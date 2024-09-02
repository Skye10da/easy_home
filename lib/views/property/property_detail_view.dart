import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_home/constant/routes.dart';
import 'package:easy_home/services/cloud/firestore_service.dart';
import 'package:easy_home/services/cloud/user_service.dart';
import 'package:easy_home/services/model/property_model.dart';
import 'package:easy_home/services/model/user_model.dart';
import 'package:easy_home/utilities/ui/flushbar_notifications.dart';
import 'package:easy_home/utilities/ui/responsive_container.dart';
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:easy_home/views/property/fullscreen_image.dart';
import 'package:easy_home/views/user/user_datails_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PropertyDetailsPage extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsPage({super.key, required this.propertyId});

  @override
  State<PropertyDetailsPage> createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  final FirestoreService _firestore = FirestoreService.instance;
  final UserService _user = UserService();
  late final size = Screen(MediaQuery.of(context).size);

  Future<PropertyModel?> _getPropertyDetails() async {
    return await _firestore.getProperty(propertyId: widget.propertyId);
  }

  final String userId = FirebaseAuth.instance.currentUser!.uid;
  late Future<PropertyModel?> _property;
  late Future<bool> _isFavorite;
  late bool isFollowing;

  Future<void> _toggleFavorite() async {
    await _firestore.toggleFavoriteProperty(userId, widget.propertyId);
    setState(() {
      _isFavorite = _checkIfFavorite();
    });
  }

  Future<bool> _checkIfFavorite() async {
    var userDoc = await _firestore.getUser(userId: userId);
    List<String> favorites = userDoc!.favorites;
    return favorites.contains(widget.propertyId);
  }

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
    _property = _getPropertyDetails();
    _isFavorite = _checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Property Details'),
      // ),
      body: FutureBuilder<PropertyModel?>(
        future: _property,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var property = snapshot.data;
          if (userId != property!.ownerId) {
            _firestore.incrementPropertyViewCount(widget.propertyId);
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Photo carousel
                SizedBox(
                  height: size.hp(45),
                  child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageView(
                                  imageUrls: property.photos,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: property.photos[index],
                            fit: BoxFit.fill,
                            width: double.infinity,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        );
                      },
                      itemCount: property.photos.length,
                      pagination: const SwiperPagination(),
                      control: const SwiperControl(),
                      layout: SwiperLayout.DEFAULT),
                ),
                SizedBox(
                  height: 50.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FutureBuilder<bool>(
                        future: _isFavorite,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator.adaptive();
                          } else if (snapshot.hasError) {
                            return const Icon(Icons.error);
                          } else if (snapshot.hasData) {
                            bool isFavorite = snapshot.data!;
                            return IconButton(
                              iconSize: 50,
                              isSelected: isFavorite,
                              icon: const Icon(
                                Icons.favorite_border,
                              ),
                              selectedIcon: const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: _toggleFavorite,
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        property.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ResponsiveContainer(
                        maxWidth: size.wp(80),
                        wrapHeight: true,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                          child: Text(
                            'Price: #${property.price} / year',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ResponsiveContainer(
                        maxWidth: size.wp(80),
                        wrapHeight: true,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(),
                          ),
                          child: Text(
                            'Description: ${property.description}',
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ResponsiveContainer(
                        maxWidth: size.wp(80),
                        wrapHeight: true,
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(),
                          ),
                          child: Text(
                            'Location: ${property.location.values}',
                          ),
                        ),
                      ),
                      ResponsiveContainer(
                        maxWidth: size.wp(80),
                        wrapHeight: true,
                        child: Column(
                          children: [
                            const Text(
                              'Amenities',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            _buildAmenities(property.amenities),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ResponsiveContainer(
                        maxWidth: size.wp(80),
                        wrapHeight: true,
                        child: Column(
                          children: [
                            const Text(
                              'Utilities',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            _buildUtilities(property.utilities),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100.0),
                      const Text(
                        'Owner Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder<UserModel?>(
                        future: _firestore.getUser(userId: property.ownerId),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          var user = userSnapshot.data!;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (userId == user.id) {
                                      Navigator.popAndPushNamed(
                                          context, userDashboardRoute);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserDatailsView(
                                            userId: user.id,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundImage: CachedNetworkImageProvider(
                                      user.profilePicture,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "${user.firstName} ${user.lastName}",
                                  ),
                                  subtitle: Text(
                                    'Phone: ${user.phoneNo}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      FutureBuilder<bool>(
                                        future: _checkIfFollowing(
                                          userId,
                                          property.ownerId,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator
                                                  .adaptive(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Icon(Icons.error);
                                          } else if (snapshot.hasData) {
                                            isFollowing = snapshot.data!;
                                            return ElevatedButton(
                                              onPressed: () async {
                                                if (userId ==
                                                    property.ownerId) {
                                                  showErrorNotification(
                                                    context,
                                                    "You cannot follow yourself",
                                                  );
                                                } else {
                                                  await _toggleFollow(
                                                      userId, property.ownerId);
                                                }
                                              },
                                              child: isFollowing
                                                  ? const Text("UnFollow")
                                                  : const Text("Follow"),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.call),
                                        onPressed: () {
                                          launchUrlString(
                                              'tel:${user.phoneNo}');
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            FontAwesomeIcons.whatsapp),
                                        onPressed: () {
                                          launchUrlString(
                                              'https://wa.me/${user.phoneNo}');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Related Properties',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildRelatedProperties(property.type),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmenities(List<String> amenities) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: amenities.map((amenity) {
        var icon = _getAmenityIcon(amenity);
        return Chip(
          avatar: Icon(icon),
          label: Text(amenity),
        );
      }).toList(),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity) {
      case 'Pool':
        return Icons.pool;
      case 'Gym':
        return Icons.fitness_center;
      case 'Parking':
        return Icons.local_parking;
      case 'WiFi':
        return Icons.wifi;
      case 'Air Conditioning':
        return Icons.ac_unit;
      case 'Heating':
        return Icons.whatshot;
      case 'Balcony':
        return Icons.balcony;
      case 'Garden':
        return Icons.grass;
      case 'Elevator':
        return Icons.elevator;
      case 'Security':
        return Icons.security;
      case 'Laundry':
        return Icons.local_laundry_service;
      case 'Fireplace':
        return Icons.local_fire_department;
      case 'Sauna':
        return Icons.spa;
      case 'Jacuzzi':
        return Icons.hot_tub;
      default:
        return Icons.help_outline; // Default icon for unknown amenities
    }
  }

  IconData _getUtilityIcon(String utility) {
    switch (utility) {
      case 'Electricity':
        return Icons.electrical_services;
      case 'Water':
        return Icons.water;
      case 'Gas':
        return Icons.local_gas_station;
      case 'Internet':
        return Icons.router;
      case 'Trash Collection':
        return Icons.delete;
      case 'Sewage':
        return Icons.waves;
      case 'Cable TV':
        return Icons.tv;
      case 'Telephone':
        return Icons.phone;
      default:
        return Icons.help_outline; // Default icon for unknown utilities
    }
  }

  Widget _buildUtilities(List<String> utilities) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: utilities.map((utility) {
        var icon = _getUtilityIcon(utility);
        return Chip(
          avatar: Icon(icon),
          label: Text(utility),
        );
      }).toList(),
    );
  }

  Widget _buildRelatedProperties(String propertyType) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('properties')
          .where('type', isEqualTo: propertyType)
          .limit(5)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var relatedProperties = snapshot.data!.docs;

        return Column(
          children: relatedProperties.map((doc) {
            var property = doc.data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                title: Text(property['title']),
                subtitle: Text(
                    '${property['location']['city']}, ${property['location']['state']}, ${property['location']['country']}'),
                trailing: Text('\$${property['price']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PropertyDetailsPage(propertyId: doc.id),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
