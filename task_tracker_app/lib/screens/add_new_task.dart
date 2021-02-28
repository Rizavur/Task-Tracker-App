import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker_app/services/auth_service.dart';
import 'package:task_tracker_app/services/database_service.dart';
import 'package:task_tracker_app/shared/input_decoration.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddNewTask extends StatefulWidget {
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final _formKey = GlobalKey<FormState>();
  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
          Text("Successfully added task"),
        ],
      ),
    );


    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text("Add New Task",
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.greenAccent,
                      fontFamily: 'Raleway'
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey[600],
                  height: 20,
                  thickness: 2,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: titleController,
                  validator: (val) => val.isEmpty ? "Please enter a title" : null,
                  decoration: textInputDecoration.copyWith(hintText: 'Title'),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (val) {
                    setState(() => title = val);
                  },
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  controller: descController,
                  validator: (val) => val.isEmpty ? "Please enter a description" : null,
                  decoration: textInputDecoration.copyWith(hintText: 'Description'),
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 8,
                  onChanged: (val) {
                    setState(() => description = val);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: RaisedButton(
                      onPressed: () async{
                        if (_formKey.currentState.validate()) {
                          await dbService.addTask(uid, title, description);
                          titleController.clear();
                          descController.clear();
                          if (!FocusScope.of(context).hasPrimaryFocus) {
                            FocusScope.of(context).unfocus();
                          }
                          return _showToast();
                        }
                      },
                      color: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.greenAccent
                      ),
                    )
                  ),
                )
              ],
            )
          )
        ),
      ),
    );
  }
}
