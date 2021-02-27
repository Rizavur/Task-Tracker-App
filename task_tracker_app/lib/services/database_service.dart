import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(String uid, String title, String description){
    return tasks.add({
      'uid': uid,
      'title': title,
      'description': description
    });
  }
}