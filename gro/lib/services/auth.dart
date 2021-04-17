import 'package:firebase_auth/firebase_auth.dart';
import '../models.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CurrentUser _user(User user) {
    return user != null ? CurrentUser(uid: user.uid) : null;
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
}