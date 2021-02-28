import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  FToast fToast;

  List tasks = [];
  String uid = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchTaskList();
    fToast = FToast();
    fToast.init(context);
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

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Successfully updated task"),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    void editModal(String title, String description, String taskid) {
      final formKey = GlobalKey<FormState>();

      showModalBottomSheet(
          context: context, 
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30.0),
              bottom: Radius.circular(0.0),
            )
          ), 
          builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
            child:  Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(
                    'Edit your task',
                    style: TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                      fontFamily: 'Dosis'
                    ),
                  ),
                  Divider(
                    color: Colors.grey[600],
                    height: 20,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Title'),
                    validator: (val) => val.isEmpty ? "Please enter a title" : null,
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
                    validator: (val) => val.isEmpty ? "Please enter a description" : null,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 8,
                    onChanged: (val) {
                      setState(() => description = val);
                    },
                    initialValue: description,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RaisedButton(
                        color: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 15.0,
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            await dbService.updateTaskData(uid, title, description, taskid);
                            fetchTaskList();
                            tasks.forEach((element) {print(element);});
                            Navigator.pop(context);
                            return _showToast();
                            }
                          }
                        ),
                  )
                ],
              ),
            )
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(tasks[index]['title']),
                    subtitle: Text(tasks[index]['description']),
                    onTap: () => editModal(tasks[index]['title'], tasks[index]['description'], tasks[index]['taskid']),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.red[200],
                        size: 30.0,
                      ),
                      onPressed: () async {
                        await dbService.deleteTaskData(tasks[index]['taskid']);
                        fetchTaskList();
                      },
                    ),
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
