// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_home/services/cloud/firestore_service.dart';
import 'package:easy_home/services/model/property_model.dart';
import 'package:easy_home/utilities/ui/flushbar_notifications.dart';
import 'package:easy_home/utilities/ui/responsive_container.dart';
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:easy_home/views/property/edit_property_view.dart';
import 'package:easy_home/views/property/fullscreen_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class OwnerPropertyDetailsPage extends StatefulWidget {
  final String propertyId;

  const OwnerPropertyDetailsPage({super.key, required this.propertyId});

  @override
  State<OwnerPropertyDetailsPage> createState() =>
      _OwnerPropertyDetailsPageState();
}

class _OwnerPropertyDetailsPageState extends State<OwnerPropertyDetailsPage> {
  final FirestoreService _firestore = FirestoreService.instance;
  late final size = Screen(MediaQuery.of(context).size);

  Future<PropertyModel?> _getProperty() async {
    return await _firestore.getProperty(propertyId: widget.propertyId);
  }

  Future<void> _deleteProperty(BuildContext context, bool confirm) async {
    if (confirm == true) {
      try {
        var response =
            await _firestore.deleteProperty(propertyId: widget.propertyId);
        if (response == "Success") {
          showSuccessNotification(context, "Property added successfully!");
          Future.delayed(
              const Duration(
                seconds: 1,
              ), () {
            Navigator.of(context).pop();
          });
        }
        Future.delayed(
            const Duration(
              seconds: 1,
            ), () {
          Navigator.of(context).pop();
        });
      } catch (e) {
        showErrorNotification(context, 'Error deleting property');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Property'),
                  content: const Text(
                      'Are you sure you want to delete this property?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              _deleteProperty(context, confirm);
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditPropertyPage(propertyId: widget.propertyId),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined))
        ],
      ),
      body: FutureBuilder<PropertyModel?>(
        future: _getProperty(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var property = snapshot.data;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Photo carousel
                SizedBox(
                  height: 300.0,
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
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        );
                      },
                      itemCount: property!.photos.length,
                      pagination: const SwiperPagination(),
                      control: const SwiperControl(),
                      layout: SwiperLayout.DEFAULT),
                ),
                const SizedBox(height: 16.0),
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
                      Text(
                        '#${property.price}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text('Views: ${property.views}'),
                      const SizedBox(height: 8.0),
                      ResponsiveContainer(
                        maxWidth: size.wp(80),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(),
                          ),
                          child: Align(
                            child: Text(
                              'Description: ${property.description}',
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ResponsiveContainer(
                        maxWidth: size.wp(80),
                        height: size.hp(10),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(),
                          ),
                          child: Align(
                            child: Text(
                              'Location: ${property.location}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
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
}
