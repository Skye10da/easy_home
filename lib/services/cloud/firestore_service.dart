import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_home/services/cloud/user_service.dart';
import 'package:easy_home/services/model/property_model.dart';
import 'package:easy_home/services/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  FirestoreService._privateConstructor();

  // Singleton instance
  static final FirestoreService instance =
      FirestoreService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late String propertyId;
  Future<void> createUser({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _db.collection('users').doc(userId).set(userData);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user: $e');
      }
    }
  }

  Future<void> incrementPropertyViewCount(String propertyId) async {
    DocumentReference propertyRef =
        _db.collection('properties').doc(propertyId);

    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(propertyRef);

      if (!snapshot.exists) {
        throw Exception("Property does not exist!");
      }

      int newViews = (snapshot.data() as Map<String, dynamic>)['views'] + 1;
      transaction.update(propertyRef, {'views': newViews});
    });
  }

  Future<void> addProperty({
    required Map<String, dynamic> propertyData,
  }) async {
    try {
      propertyData['id'] = propertyId;
      print(propertyId);
      await _db.collection('properties').doc(propertyId).set(propertyData);
      print("here");
      // Fetch user data
      // String userId = propertyData['userId'];
      // DocumentSnapshot userDoc =
      //     await _db.collection('users').doc(userId).get();
      // UserModel user =
      //     UserModel.fromJson(userDoc.data() as Map<String, dynamic>);

      // // Notify followers
      // for (String followerId in user.followers) {
      //   await UserService().sendNotification(
      //     userId: followerId,
      //     title: 'New Property Posted',
      //     message:
      //         '${user.firstName} ${user.lastName} has posted a new property.',
      //   );
      // }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding property: $e');
      }
    }
  }

  Future<UserModel?> getUser({required String userId}) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user: $e');
      }
    }
    return null;
  }

  Future<List<PropertyModel>> getUserProperties(
      {required String userId}) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('properties')
          .where('ownerId', isEqualTo: userId)
          .get();
      return querySnapshot.docs
          .map((doc) => PropertyModel.fromJson(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user properties: $e');
      }
      rethrow;
    }
  }

  Future<List<PropertyModel>> getAllProperties() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('properties').get();
      return querySnapshot.docs
          .map((doc) => PropertyModel.fromJson(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all properties: $e');
      }
      rethrow;
    }
  }

  Future<PropertyModel?> getProperty({required String propertyId}) async {
    try {
      DocumentSnapshot doc =
          await _db.collection('properties').doc(propertyId).get();
      if (doc.exists) {
        return PropertyModel.fromJson(
            doc.data() as Map<String, dynamic>, propertyId);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting property: $e');
      }
    }
    return null;
  }

  Future<void> updateUser({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _db.collection('users').doc(userId).update(userData);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user: $e');
      }
    }
  }

  Future<String> updateProperty({
    required String propertyId,
    required Map<String, dynamic> propertyData,
  }) async {
    try {
      await _db.collection('properties').doc(propertyId).update(propertyData);
      return "Success";
    } catch (e) {
      return 'Error updating property: $e';
    }
  }

  Future<String> deleteUser({
    required String userId,
  }) async {
    try {
      await _db.collection('users').doc(userId).delete();
      return "Success";
    } catch (e) {
      return 'Error deleting user: $e';
    }
  }

  // Future<void> deleteProperty({
  //   required String propertyId,
  // }) async {
  //   try {
  //     await _db.collection('properties').doc(propertyId).delete();
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error deleting property: $e');
  //     }
  //   }
  // }

  // Method to delete property along with its images
  Future<String> deleteProperty({required String propertyId}) async {
    try {
      // Fetch property data
      var propertyData = await getProperty(propertyId: propertyId);
      List<String> imageUrls = List<String>.from(propertyData!.photos);

      // Delete images from storage
      for (String imageUrl in imageUrls) {
        await _deleteImage(imageUrl);
      }

      // Delete property document
      await _db.collection('properties').doc(propertyId).delete();
      return "Success";
    } catch (e) {
      return "'Error deleting property: $e'";
    }
  }

  // Helper method to delete an image from storage
  Future<void> _deleteImage(String imageUrl) async {
    try {
      // Extract the file name from the URL
      var fileName = imageUrl.split('/').last.split('?').first;
      var ref = _storage.ref().child('property_images/$fileName');
      await ref.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting image: $e');
      }
    }
  }

  Future<QuerySnapshot> searchUsers({
    required String field,
    required String value,
  }) async {
    try {
      return await _db.collection('users').where(field, isEqualTo: value).get();
    } catch (e) {
      if (kDebugMode) {
        print('Error searching users: $e');
      }
      rethrow;
    }
  }

  Future<QuerySnapshot> searchProperties({
    required String query,
    required String value,
  }) async {
    try {
      return await _db
          .collection('properties')
          .where(query, isEqualTo: value)
          .get();
    } catch (e) {
      if (kDebugMode) {
        print('Error searching properties: $e');
      }
      rethrow;
    }
  }

  Stream<List<PropertyModel>> getProperties({required String orderBy}) {
    try {
      var properties = _db
          .collection('properties')
          .orderBy(orderBy, descending: true)
          .limit(10)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => PropertyModel.fromJson(doc.data(), doc.id))
              .toList());
      return properties;
    } catch (_) {
      // print(e);
      rethrow;
    }
  }

  Future<void> toggleFavoriteProperty(String userId, String propertyId) async {
    try {
      DocumentReference userRef = _db.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        List<String> favorites =
            List<String>.from(userSnapshot['favorites'] ?? []);
        if (favorites.contains(propertyId)) {
          favorites.remove(propertyId);
        } else {
          favorites.add(propertyId);
        }

        await userRef.update({'favorites': favorites});
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<List<PropertyModel>> getFavoriteProperties(String userId) async {
    DocumentSnapshot userSnapshot =
        await _db.collection('users').doc(userId).get();
    List<String> favoriteIds =
        List<String>.from(userSnapshot['favorites'] ?? []);

    if (favoriteIds.isEmpty) {
      return [];
    }

    QuerySnapshot propertySnapshot = await _db
        .collection('properties')
        .where(FieldPath.documentId, whereIn: favoriteIds)
        .get();

    return propertySnapshot.docs
        .map((doc) =>
            PropertyModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<String> uploadProfilePicture({
    required File file,
    required String docId,
  }) async {
    try {
      String fileName = basename(file.path);
      Reference storageRef =
          _storage.ref().child('profile_pictures/$docId/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (_) {
      // print('Error uploading profile picture: $e');
      rethrow;
    }
  }

  Future<List<String>> uploadImages({required List<XFile> images}) async {
    try {
      final List<String> imageUrls = [];
      propertyId = const Uuid().v4();
      for (var image in images) {
        final ref = FirebaseStorage.instance
            .ref()
            .child("property_images/$propertyId/${const Uuid().v4()}.jpg");
        await ref.putFile(File(image.path));
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
      return imageUrls;
    } on Exception catch (_) {
      // print('error $e');
      rethrow;
    }
  }
}
