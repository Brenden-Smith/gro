// Firebase stuff
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../models.dart';

import 'package:flutter/material.dart';
import '../../services.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  var loading = false;

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();


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
                        onChanged: (val) {
                          setState(() => _email.text = val);
                        }
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
                        onChanged: (val) {
                          setState(() => _password.text = val);
                        }
                      )
                    ]
                  )
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  child: Text("Sign in"),
                  onPressed: () {},
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  child: Text("Sign in with Google"),
                  onPressed: () {},
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  child: Text("Sign in anon"),
                  onPressed: () async {
                    dynamic result = await _auth.signInAnon();
                    if (result == null) {
                      print("Error signing in");
                    } else {
                      print("signed in");
                      print(result);
                    }
                  },
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
          print('username: ' + user['username']);
          print('email: ' + user['email']);

          print('setting current username');
          CurrentUser.username = user['username'];
          print('myusername = ' + CurrentUser.username);
        } else {
          setState(() {
            error = 'Incorrect email and/or password.';
            loading = false;
          });
        }
      });
    }
}