import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String address;
  final Map<String, String> location; // {country, state, city}
  final List<String> photos;
  final String ownerId;
  final List<String> amenities;
  final List<String> utilities;
  final String type;
  final int views;
  final Timestamp createdAt;

  PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.location,
    required this.photos,
    required this.ownerId,
    required this.amenities,
    required this.utilities,
    required this.type,
    required this.views,
    required this.createdAt,
  });

  // Factory constructor to create a PropertyModel from a Firestore document
  factory PropertyModel.fromJson(Map<String, dynamic> json, String id) {
    return PropertyModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      address: json['address'] ?? '',
      location: {
        'country': json['location']['country'] ?? '',
        'state': json['location']['state'] ?? '',
        'city': json['location']['city'] ?? '',
      },
      photos: List<String>.from(json['photos'] ?? []),
      ownerId: json['ownerId'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      utilities: List<String>.from(json['utilities'] ?? []),
      type: json['type'] ?? '',
      views: json['views'] ?? 0,
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  // Method to convert a PropertyModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'address': address,
      'location': location,
      'photos': photos,
      'ownerId': ownerId,
      'amenities': amenities,
      'utilities': utilities,
      'type': type,
      'views': views,
      'createdAt': createdAt,
    };
  }
}
