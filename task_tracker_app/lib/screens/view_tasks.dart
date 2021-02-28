import 'package:flutter/material.dart';
import 'package:task_tracker_app/services/auth_service.dart';
import 'package:task_tracker_app/services/database_service.dart';
import 'package:task_tracker_app/shared/input_decoration.dart';

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
    void editModal(String title, String description, String taskid) {
      final formKey = GlobalKey<FormState>();

      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child:  Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Edit your task',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Title'),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (val) {
                    setState(() => title = val);
                  },
                  initialValue: title,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Description'),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 8,
                  onChanged: (val) {
                    setState(() => description = val);
                  },
                  initialValue: description,
                ),
                RaisedButton(
                    color: Colors.black,
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await dbService.updateTaskData(uid, title, description, taskid);
                      fetchTaskList();
                      tasks.forEach((element) {print(element);});
                      Navigator.pop(context);
                    })
              ],
            ),
          )
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
                  onTap: () => editModal(tasks[index]['title'], tasks[index]['description'], tasks[index]['taskid']),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      await dbService.deleteTaskData(tasks[index]['taskid']);
                      fetchTaskList();
                    },
                  ),
                ),
              ),
            );
          }
        )
      )
    );
  }
}
