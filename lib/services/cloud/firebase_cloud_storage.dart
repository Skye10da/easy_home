import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud_user.dart';
import '/services/cloud/cloud_storage_costants.dart';
import '/services/cloud/coud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection("easyhome");

  void createUser({required String userId}) async {
    await notes.add(
      {
        userIdFieldName: userId,
        firstNameFieldName: '',
      },
    );
  }

  Future<void> updateUser({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({firstNameFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteUser({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<Iterable<CloudUser>> getUser({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            userIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudUser(
                  documentId: doc.id,
                  userId: doc.data()[userIdFieldName].toString(),
                  firstName: doc.data()[firstNameFieldName].toString(),
                  lastName: doc.data()[lastNameFieldName].toString(),
                  bio: doc.data()[firstNameFieldName].toString(),
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
  }

  Stream<Iterable<CloudUser>> allUser({required String owerUserId}) {
    return notes.snapshots().map((event) => event.docs
        .map((doc) => CloudUser.fromSnapshot(doc))
        .where((note) => note.userId == owerUserId));
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
