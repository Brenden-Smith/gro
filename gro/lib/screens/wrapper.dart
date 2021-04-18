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
                // if (user['isOnboarding']) {
                //   return Home();
                // } else {
                //   return Home();
                // }
                return AppTabController();
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

class AppTabController extends StatefulWidget {
  @override
  _AppTabControllerState createState() => _AppTabControllerState();
}

class _AppTabControllerState extends State<AppTabController> {

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home 1",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home 2",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home 3",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}