import 'package:flutter/material.dart';
import 'package:task_tracker_app/services/auth_service.dart';

import 'loading.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Container(
      padding: const EdgeInsets.only(top: 16.0),
      alignment: Alignment.center,
      child: RaisedButton(
          color: Colors.greenAccent[200],
          onPressed: () async {
            setState(() => loading = true);
            dynamic result = await AuthService().signInAnonymously();
            if (result == null) {
              setState(() => loading = false);
            }
          },
          child: Text("Anon Sign in")),
    );
  }
}
