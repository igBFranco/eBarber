import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class DataRepository {
  
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user');
  
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  
  Future<DocumentReference> addUser(User user) {
    return collection.add(user.toJson());
  }
  
  void updateUser(User user) async {
    await collection.doc(user.uid).update(user.toJson());
  }
  
  void deleteUser(User user) async {
    await collection.doc(user.uid).delete();
  }
}