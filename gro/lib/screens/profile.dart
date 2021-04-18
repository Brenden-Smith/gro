import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  String uid;

  @override
  void initState() {
    super.initState();
    // fetchUserID();
    // fetchUserData();
  }

  fetchUserID() {
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  void fetchUserData() async {
    dynamic user = await DatabaseService().getUserData(FirebaseAuth.instance.currentUser.uid);

    if (user == null) {
      setState(() {
        _email.text = "Username";
        _password.text = "Password";
      });
    } else {
      setState (() {
        _email.text = user.get(FieldPath(['email']));
        _password.text = user.get(FieldPath(['password']));
      });
    }
  }

  updateUserData(String uid, String email, String password) async {
    await DatabaseService().updateUser(uid, email, password);
    fetchUserData();
    _auth.changeEmail(email);
    _auth.changePassword(password);
  }

  deleteAccountDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Are you sure you would like to delete your account?',
        ),
        content: Text(
          'This action is permanent',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'No',
            ),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            child: Text(
              'Yes',
            ),
            onPressed: () {
              _auth.deleteUser();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height - mediaQuery.padding.top,
          width: mediaQuery.size.width,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: mediaQuery.padding.top),
              Container(
                width: mediaQuery.size.width,
                child: Text("Profile", textAlign: TextAlign.left, style: TextStyle(fontSize: 30)),
              ),
              Spacer(flex: 10),
              Form(
                child: Column(
                  children: <Widget>[

                    // Email
                    Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text("Email"),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _email,
                            validator: (val) => val.isEmpty ? "Enter your email" : null,
                          ),
                        ),
                      ],
                    ),
                    
                    
                    // Password
                    Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text("Password"),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _password,
                            obscureText: true,
                            validator: (val) => val.isEmpty ? "Enter your password" : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text("Save"),
                onPressed: () {},
              ),
              Spacer(flex: 10),
              ElevatedButton(
                child: Text("Delete Account"),
                onPressed: () {},
              ),
              SizedBox(height: 15),
              Container(
                child: Text("This application is powered by trefle.io")
              ),
            ],
          ),
        )
      )
    );
  }
}