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
    if (loading) {
      return Loading();
    } else {
      return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 180.0, 0.0, 40.0),
              child: Text(
                "Login",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: 50.0,
                  fontFamily: 'Dosis'
                ),
              ),
            ),
            Container(
            padding: const EdgeInsets.only(top: 16.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(50.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 5.0,
                      color: Colors.greenAccent,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 150.0,
                    ),
                  ),
                ),
                FlatButton(
                    color: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result = await AuthService().signInAnonymously();
                      if (result == null) {
                        setState(() => loading = false);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                            child: Text(
                              "Sign In Anonymously",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.greenAccent
                              )
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.greenAccent,
                          )
                        ],
                      ),
                    )),
              ],
            ),
    ),
          ],
        ),
      );
    }
  }
}
