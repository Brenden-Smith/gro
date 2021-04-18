// Firebase stuff
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../models.dart';

import 'package:flutter/material.dart';
import '../../services.dart';
import '../../screens.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/sign-in';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  var loading = false;

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  String error = '';


  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height - mediaQuery.padding.top,
          padding: EdgeInsets.all(25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Container(
                  height: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      
                      // Email
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: "Email",
                        ),
                        validator: (value) {
                          return (value == null ? "You must enter your email" : null);
                        },
                      ),

                      // Password
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                        ),
                        validator: (value) {
                          return (value.isEmpty ? "You must enter your password" : null);
                        },
                      )
                    ]
                  )
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  child: Text("Sign in"),
                  onPressed: () => submitAction(),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  child: Text("Register"),
                  onPressed: () => Navigator.of(context).pushNamed(Register.routeName),
                ),
                Spacer(),
              ]
            )
          )
        ),
      ),
    );
  }

  submitAction() async {
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      dynamic result = await _auth
          .login(
        _email.text,
        _password.text,
      )
          .then((result) async {
        if (result != null) {
          /// perform a query to get a snapshot of the user
          QuerySnapshot userInfoSnapshot =
              await DatabaseService().getUserByEmail(_email.text);

          /// initialize user object
          final user = userInfoSnapshot.docs[0].data();

          print('retrieved user from login');
          print('email: ' + user['email']);
          print('uid: ' + user['uid']);
        } else {
          setState(() {
            error = 'Incorrect email and/or password.';
            loading = false;
          });
        }
      });
    }
  }
}