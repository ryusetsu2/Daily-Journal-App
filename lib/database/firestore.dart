import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirestoreDatabase {
  // current login to as
  User? user = FirebaseAuth.instance.currentUser;

  //get collection of index from database
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Activity');

  //add to database
  Future<void> addPost(
    String activity,
    String instance,
    String description,
    String? embbedUrl,
  ) async {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final DocumentReference activityDoc = posts.doc(formattedDate);

    await activityDoc.set({
      'userEmail': user!.email,
      'ActivityName': activity,
      'InstanceName': instance,
      'ActivityDescription': description,
      'embbedUrl': embbedUrl,
      'Timestamp': Timestamp.now(),
    });
  }

  //read value
  Stream<QuerySnapshot<Map<String, dynamic>>> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Activity')
        .orderBy('Timestamp', descending: true)
        .snapshots();

    return postsStream;
  }

  //update value

  Future<void> updateAct(
    String formattedDate,
    String updateActivity,
    String updateInstance,
    String updateDescription,
    String updateEmbeddUrl,
    String userEmail,
  ) {
    final DocumentReference activityDoc = posts.doc(formattedDate);

    return activityDoc.update({
      'userEmail': userEmail,
      'ActivityName': updateActivity,
      'InstanceName': updateInstance,
      'ActivityDescription': updateDescription,
      'embbedUrl': updateEmbeddUrl,
      'Timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteAct(String activityID) {
    return posts.doc(activityID).delete();
  }
}
