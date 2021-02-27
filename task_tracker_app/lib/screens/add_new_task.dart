import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker_app/services/auth_service.dart';
import 'package:task_tracker_app/services/database_service.dart';
import 'package:task_tracker_app/shared/input_decoration.dart';

class AddNewTask extends StatefulWidget {
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final _formKey = GlobalKey<FormState>();

  String uid = '';
  String title = '';
  String description = '';
  DatabaseService dbService = new DatabaseService();
  AuthService auth = new AuthService();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    uid = auth.getUid();
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Add New Tasks",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.amber,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: titleController,
                decoration: textInputDecoration.copyWith(hintText: 'Title'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (val) {
                  setState(() => title = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: descController,
                decoration: textInputDecoration.copyWith(hintText: 'Description'),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 8,
                onChanged: (val) {
                  setState(() => description = val);
                },

              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FlatButton(
                    onPressed: () {
                      dbService.addTask(uid, title, description);
                      titleController.clear();
                      descController.clear();
                    },
                    color: Colors.black,
                    textColor: Colors.amber,
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                    child: Text(
                    "Done",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  )

                ),
              )
            ],
          )
        )
      ),
    );
  }
}
