import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Function(User) onSignIn;
  SignIn({@required this.onSignIn});

  signInAnonymously() async {
    UserCredential userCredential = await _auth.signInAnonymously();
    onSignIn(userCredential.user);
    print(userCredential.user);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      alignment: Alignment.center,
      child: RaisedButton(
          color: Colors.greenAccent[200],
          onPressed: () async {
            signInAnonymously();
          },
          child: Text("Anon Sign in")),
    );
  }
}
