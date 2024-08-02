// ignore_for_file: use_build_context_synchronously

import 'package:easy_home/services/cloud/user_service.dart';
import 'package:easy_home/services/model/property_model.dart';
import 'package:easy_home/services/model/user_model.dart';
import 'package:easy_home/views/property/owner_property_details_view.dart';
import 'package:easy_home/views/user/edit_profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserDatailsView extends StatefulWidget {
  final String userId;
  const UserDatailsView({super.key, required this.userId});

  @override
  UserDatailsViewState createState() => UserDatailsViewState();
}

class UserDatailsViewState extends State<UserDatailsView> {
  late Future<UserModel> _userProfile;
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final UserService _user = UserService();
  late bool isFollowing;
  
  Future<void> _toggleFollow(String currentUserId, String targetUserId) async {
    await _user.followUnfollowUser(
      currentUserId: currentUserId,
      targetUserId: targetUserId,
      isFollowing: isFollowing,
    );
    var newStatus = await _checkIfFollowing(currentUserId, targetUserId);
    setState(() {
      isFollowing = newStatus;
    });
  }

  Future<bool> _checkIfFollowing(
      String currentUserId, String targetUserId) async {
    bool isFollowing = await _user.checkFollowStatus(
        currentUserId: currentUserId, targetUserId: targetUserId);

    return isFollowing;
  }

  @override
  void initState() {
    super.initState();
    _userProfile = _getUserProfile();
  }

  Future<UserModel> _getUserProfile() async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    return UserModel.fromJson(doc.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePage()),
                );
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(
              width: 20,
            ),
            FutureBuilder<bool>(
              future: _checkIfFollowing(userId, widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error);
                } else if (snapshot.hasData) {
                  isFollowing = snapshot.data!;
                  return ElevatedButton(
                    onPressed: () async {
                      await _toggleFollow(userId, widget.userId);
                    },
                    child: isFollowing
                        ? const Text("UnFollow")
                        : const Text("Follow"),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }

  Widget _buildAllProperties() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('properties')
          .where('ownerId', isEqualTo: widget.userId)
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
}
