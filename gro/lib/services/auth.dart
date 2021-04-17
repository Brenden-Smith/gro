import 'package:firebase_auth/firebase_auth.dart';
import '../models.dart';
import '../services.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register with email and password
  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      await DatabaseService().createUser(user.uid, email, password);
      return user;
    } catch (err) {
      print(err.toString());
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

  // Sign out
  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

}