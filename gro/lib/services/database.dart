import 'package:cloud_firestore/cloud_firestore.dart';

import '../services.dart';

class DatabaseService {

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(
    String uid,
    String email,
    String password,
  ) async {
    return await users.doc(uid).set({
      "email": email,
      "password": password,
      "isOnboarding": true,
    });
  }

  // Is email in use
  Future<bool> checkEmail(String email) async {
    final res = await users.where('email', isEqualTo: email).get();
    return res.docs.isEmpty;
  }

  // Get user data
  getUserData(String uid) async {
    try {
      return await users.doc(uid).get();
    } catch (error) {
      print(error.toString());
    }
  }

  // Update doc to user collection
  Future updateUser(
    String uid,
    String email,
    String password,
  ) async {
    return await users.doc(uid).update({
      "email": email,
      "password": password,
    });
  }

  // Update onboarding
  Future<void> updateOnboarding(String uid) {
    return users.doc(uid).update({'isOnboarding': false});
  }

  // Delete user
  Future<void> deleteUser(String uid) {
    return users.doc(uid).delete().then((value) => print('User deleted')).catchError((err) => print('Failed to delete user'));
  }

  // Get user by email
  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await users.where('email', isEqualTo: email).limit(1).get().catchError((err) => print("Failed to get user by email"));
  }

}