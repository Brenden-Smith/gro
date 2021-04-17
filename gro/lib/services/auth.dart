import 'package:firebase_auth/firebase_auth.dart';
import '../models.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CurrentUser _user(User user) {
    return user != null ? CurrentUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<CurrentUser> get user {
    return _auth.authStateChanges().map(_user);
  }

  // Anonymous signin
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _user(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (err) {
      print(err.toString());
    }
  }
}