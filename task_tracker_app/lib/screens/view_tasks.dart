import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker_app/models/task_data.dart';
import 'package:task_tracker_app/screens/edit_task.dart';
import 'package:task_tracker_app/services/auth_service.dart';
import 'package:task_tracker_app/services/database_service.dart';

class ViewTasks extends StatefulWidget {
  @override
  _ViewTasksState createState() => _ViewTasksState();
}

class _ViewTasksState extends State<ViewTasks> {
  DatabaseService dbService = new DatabaseService();
  AuthService auth = new AuthService();

  List tasks = [];
  String uid = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchTaskList();
  }

  fetchUserInfo(){
    String authUid = auth.getUid();
    setState(() {
      uid = authUid;
    });
  }

  fetchTaskList() async {
    dynamic result = await DatabaseService().getTaskList(uid);
    if (result == null) {
      print('Failed to fetch tasks');
    } else {
      setState(() {
        tasks = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void editModal() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: EditTask()
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
              child: Card(
                child: ListTile(
                  title: Text(tasks[index]['title']),
                  subtitle: Text(tasks[index]['description']),
                  onTap: () => editModal(),
                ),
              ),
            );
          }
        )
      )
    );
  }
}
