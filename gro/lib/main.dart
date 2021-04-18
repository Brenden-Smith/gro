import 'package:flutter/material.dart';

// Firebase stuff
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Files
import 'screens.dart';
import 'services.dart';
import 'models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Gro());
}

class Gro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gro',
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
      routes: {
        Home.routeName: (ctx) => Home(),
        NameQuestion.routeName: (ctx) => NameQuestion(),
        OwnedPlant.routeName: (ctx) => OwnedPlant(),
        PlantSearch.routeName: (ctx) => PlantSearch(),
        PlantDesc.routeName: (ctx) => PlantDesc(),
        Register.routeName: (ctx) => Register(),
        SignIn.routeName: (ctx) => SignIn(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => SignIn());
      },
    );
  }
}

