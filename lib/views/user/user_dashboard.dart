// ignore_for_file: use_build_context_synchronously

import 'package:easy_home/constant/routes.dart';
import 'package:easy_home/enum/menu_action.dart';
import 'package:easy_home/services/auth/auth_service.dart';
import 'package:easy_home/services/cloud/firestore_service.dart';
import 'package:easy_home/services/model/property_model.dart';
import 'package:easy_home/services/model/user_model.dart';
import 'package:easy_home/utilities/dialogs/confirmation_dialog.dart';
import 'package:easy_home/views/property/owner_property_details_view.dart';
import 'package:easy_home/views/user/edit_profile_view.dart';
import 'package:easy_home/views/user/notification_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  late Future<int> _totalProperties;
  late Future<int> _totalViews;
  final FirestoreService _firestoreService = FirestoreService.instance;
  late Future<UserModel> _userProfile;
  late Future<List<_DailyPerformance>> _dailyPerformance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _totalProperties = _getTotalProperties();
    _totalViews = _getTotalViews();
    _userProfile = _getUserProfile();
    _dailyPerformance = _getDailyPerformance();
  }

  Future<int> _getTotalProperties() async {
    var snapshot = await _firestoreService.getUserProperties(userId: userId);
    return snapshot.length;
  }

  Future<int> _getTotalViews() async {
    var res = await _firestoreService.getUserProperties(userId: userId);
    int totalViews = 0;
    for (var doc in res) {
      totalViews += doc.views;
    }
    return totalViews;
  }

  Future<UserModel> _getUserProfile() async {
    var doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return UserModel.fromJson(doc.data()!);
  }

  Future<List<_DailyPerformance>> _getDailyPerformance() async {
    var snapshot = await _firestoreService.getUserProperties(userId: userId);

    Map<String, _DailyPerformance> performanceMap = {};

    for (var doc in snapshot) {
      // var property = doc.id;
      String date = doc.createdAt.toDate().toString().split(' ')[0];

      if (!performanceMap.containsKey(date)) {
        performanceMap[date] =
            _DailyPerformance(date: date, views: 0, properties: 0);
      }

      performanceMap[date]!.views += doc.views;
      performanceMap[date]!.properties += 1;
    }

    return performanceMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_active),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  var response = await confirmationDialog(
                      context: context, title: "Log out");
                  if (response) {
                    await AuthService.firebase().signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      welcomeRoute,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text("Log out"),
                )
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder<UserModel>(
                future: _userProfile,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var user = snapshot.data!;
                  return Center(
                    child: _buildUserProfile(user),
                  );
                },
              ),
              const SizedBox(height: 32.0),
              const Text(
                'Metrics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              _buildMetrics(),
              const SizedBox(height: 32.0),
              const Text(
                'Daily Performance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              _buildDailyPerformanceChart(),
              const SizedBox(height: 32.0),
              const Text(
                'All Properties',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              _buildAllProperties(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(UserModel user) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 100,
          backgroundImage: CachedNetworkImageProvider(user.profilePicture),
        ),
        const SizedBox(height: 16.0),
        Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Text('Phone: ${user.phoneNo}'),
        const SizedBox(height: 8.0),
        Text('Bio: ${user.bio}'),
        const SizedBox(height: 16.0),
        ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Edit Profile'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()),
            );
          },
        ),
        // const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildMetrics() {
    return Row(
      children: <Widget>[
        _buildDashboardCard(
          title: 'Total Properties',
          futureValue: _totalProperties,
          icon: FontAwesomeIcons.building,
          color: Colors.orange,
        ),
        const SizedBox(width: 16.0),
        _buildDashboardCard(
          title: 'Total Views',
          futureValue: _totalViews,
          icon: FontAwesomeIcons.eye,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required Future<int> futureValue,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<int>(
            future: futureValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(icon, color: color, size: 40.0),
                        const SizedBox(width: 16.0),
                        Text(
                          snapshot.data.toString(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAllProperties() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('properties')
          .where('ownerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var properties = snapshot.data!.docs.map((doc) {
          var property = PropertyModel.fromJson(
              doc.data() as Map<String, dynamic>, doc.id);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OwnerPropertyDetailsPage(propertyId: property.id),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: const EdgeInsets.all(8),
              borderOnForeground: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: property.photos[0],
                      fit: BoxFit.fill,
                      width: double.infinity,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text('#${property.price}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: properties,
        );
      },
    );
  }

  Widget _buildDailyPerformanceChart() {
    return FutureBuilder<List<_DailyPerformance>>(
      future: _dailyPerformance,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var data = snapshot.data!;
        return SizedBox(
          height: 200.0,
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(),
            series: <CartesianSeries>[
              ColumnSeries<_DailyPerformance, String>(
                dataSource: data,
                xValueMapper: (_DailyPerformance performance, _) =>
                    performance.date,
                yValueMapper: (_DailyPerformance performance, _) =>
                    performance.views,
                name: 'Views',
                color: Colors.blue,
              ),
              ColumnSeries<_DailyPerformance, String>(
                dataSource: data,
                xValueMapper: (_DailyPerformance performance, _) =>
                    performance.date,
                yValueMapper: (_DailyPerformance performance, _) =>
                    performance.properties,
                name: 'Properties',
                color: Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DailyPerformance {
  final String date;
  int views;
  int properties;

  _DailyPerformance({
    required this.date,
    required this.views,
    required this.properties,
  });
}
