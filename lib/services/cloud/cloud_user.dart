// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '/services/cloud/cloud_storage_costants.dart';

@immutable
class CloudUser {
  final String documentId;
  final String userId;
  final String firstName;
  final String lastName;
  final String bio;

  const CloudUser({
    required this.documentId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.bio,
  });

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = snapshot.data()[userIdFieldName],
        documentId = snapshot.id,
        firstName = snapshot.data()[firstNameFieldName],
        lastName = snapshot.data()[lastNameFieldName],
        bio = snapshot.data()[bioFieldName];

}
