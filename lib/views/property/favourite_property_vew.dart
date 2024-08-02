// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:easy_home/services/cloud/firestore_service.dart';
import 'package:easy_home/services/model/property_model.dart';
import 'package:easy_home/utilities/ui/flushbar_notifications.dart';
import 'package:easy_home/views/property/favourite_property.dart';
import 'package:easy_home/views/property/property_detail_view.dart';

class FavoritePropertiesPage extends StatefulWidget {
  const FavoritePropertiesPage({super.key});

  @override
  FavoritePropertiesPageState createState() => FavoritePropertiesPageState();
}

class FavoritePropertiesPageState extends State<FavoritePropertiesPage> {
  final FirestoreService _firestoreService = FirestoreService.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  late Future<List<PropertyModel>> _favoriteProperties;

  @override
  void initState() {
    super.initState();
    _favoriteProperties = _getFavoriteProperties();
  }

  Future<List<PropertyModel>> _getFavoriteProperties() async {
    return await _firestoreService.getFavoriteProperties(userId);
  }

  Future<void> _removeFromFavorites(String propertyId) async {
    await _firestoreService.toggleFavoriteProperty(userId, propertyId);
    setState(() {
      _favoriteProperties = _getFavoriteProperties();
    });
    showSuccessNotification(
      context,
      'Property removed from favorites',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Properties'),
      ),
      body: FutureBuilder<List<PropertyModel>>(
        future: _favoriteProperties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            var properties = snapshot.data!;
            if (properties.isEmpty) {
              return const Center(
                child: Text('No favorite properties found.'),
              );
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  var property = properties[index];
                  return Stack(
                    children: [
                      PropertyItem(
                        property: property,
                        onPropertyTapped: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PropertyDetailsPage(propertyId: property.id),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _removeFromFavorites(property.id);
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          }
          return const Center(child: Text('No favorite properties found.'));
        },
      ),
    );
  }
}
