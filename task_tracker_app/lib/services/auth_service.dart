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
    return await _auth.signInAnonymously();
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