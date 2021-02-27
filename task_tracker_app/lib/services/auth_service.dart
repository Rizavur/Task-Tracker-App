import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getUid () {
    User user = _auth.currentUser;
    return user.uid;
  }
  // auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // sign in anon
  signInAnonymously() async {
    UserCredential userCredential = await _auth.signInAnonymously();
    // onSignIn(userCredential.user);
    // print(userCredential.user);
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}