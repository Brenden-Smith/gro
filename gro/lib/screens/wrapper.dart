import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services.dart';
import '../screens.dart';
import '../models.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(snapshot.data.uid).snapshots(),
            builder: (ctx, ss) {
              if (ss.hasData && ss.data != null) {
                final userDoc = ss.data;
                final user = userDoc.data();
                if (user == null) {
                  return SignIn();
                }
                if (user['isOnboarding']) {
                  return Home();
                } else {
                  return Home();
                }
              }
              return CircularProgressIndicator();
            },
          );
        }
        return SignIn();
      }
    );
  }
}