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

  Future getTaskList(String uid) async{
    List taskList = [];
    print(uid);
    try {
      await tasks.where('uid', isEqualTo: uid).get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          taskList.add(element.data());
        });
      });
      return taskList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}