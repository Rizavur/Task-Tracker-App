import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker_app/screens/sign_in.dart';

import 'home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User user;
  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return SignIn(onSignIn: (userCred) => onRefresh(userCred),);
    } else {
      return Home();
    }
  }
}
