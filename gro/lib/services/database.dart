import 'package:cloud_firestore/cloud_firestore.dart';

import '../services.dart';
import '../models.dart';

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

  // PLANT ENTRIES
  final CollectionReference plants = FirebaseFirestore.instance.collection('plant-entries');

  // Create plant entry
  Future<void> createPlantEntry(String rid, String uid, String email, PlantEntry entry, DateTime date) async {
    return await plants.doc(rid).set({
      'uid': uid,
      'email': email,
      'date': date,
      'image': entry.plant.image,
      'plant_name': entry.name,
      'plant_common': entry.plant.name,
      'plant_science': entry.plant.scientificName,
      'daysToWater': entry.daysToWater,
      'lastWatered': DateTime.now(),
    });
  }

  // Water plant
  Future<void> waterPlant(String rid) {
    return plants.doc(rid).set({'lastWatered': Timestamp.now()}).then((_) => print("Watered plant!"));
  }

  // Delete plant
  Future<void> deletePlant(String rid) {
    return plants.doc(rid).delete().then((value) => print("Entry deleted")).catchError((err) => print("Faiiled to delete entry"));
  }
  
  // Get user's plants
  Future<Stream<QuerySnapshot>> getUsersPlants(String uid) async {
    return plants.where('uid', isEqualTo: uid).snapshots();
  }

  getPlant(String rid) async {
    try {
      return await plants.doc(rid).get();
    } catch (err) {
      print(err.toString());
    }
  }

  // Create journal entry
  Future<void> createJournalEntry(String rid1, String rid2, String uid, String email, JournalEntry entry, DateTime date) async {
    return await plants.doc(rid1).collection('journal').doc(rid2).set({
      'uid': uid,
      'email': email,
      'date': date,
      'title': entry.title,
      'content': entry.content,
    });
  }

  // Delete journal entry
  Future<void> deleteJournalEntry(String rid1, String rid2) {
    return plants.doc(rid1).collection('journal').doc(rid2).delete().then((value) => print("Entry deleted")).catchError((err) => print("Faiiled to delete entry"));
  }

  // Get user's journal
  Future<Stream<QuerySnapshot>> getUsersJournal(String uid, String rid) async {
    return plants.doc(rid).collection('journal').where('uid', isEqualTo: uid).snapshots();
  }

  getJournal(String rid1, String rid2) async {
    try {
      return await plants.doc(rid1).collection('journal').doc(rid2).get();
    } catch (err) {
      print(err.toString());
    }
  }

}