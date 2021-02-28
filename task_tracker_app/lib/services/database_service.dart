import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(String uid, String title, String description){
    return tasks.add({
      'uid': uid,
      'title': title,
      'description': description,
      'taskid': tasks.doc().id
    });
  }

  Future getTaskList(String uid) async{
    List taskList = [];
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

  Future updateTaskData(String uid, String title, String description, String taskid) async{
    var task = tasks.where('taskid', isEqualTo: taskid);
    return task.get().then((querySnapshot) =>
      querySnapshot.docs.forEach((element)
    {
      element.reference.update({
        'title': title,
        'description': description,
        'uid': uid,
        'taskid': taskid
      });
    }));
  }

  Future deleteTaskData(String taskid) async{
    var task = tasks.where('taskid', isEqualTo: taskid);
    return task.get().then((value) => value.docs.forEach((element) {element.reference.delete();}));
  }
}