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
              children: <Widget>[
                SizedBox(height: mediaQuery.padding.top),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Center(child: CircleAvatar(radius: 80, backgroundColor: Colors.green)),
                    Center(child: Icon(Icons.eco, color: Colors.white, size: 80)),
                  ],
                ),
                SizedBox(height: 15),
                Text("Gro", style: TextStyle(fontSize: 40)),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      
                      // Email
                      Container(
                        width:300,
                        child:Padding(
                          padding:const EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: _email,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter your email',
                              labelText: 'Email'
                            ),
                            validator: (val) => val.isEmpty ? "This field is required" : null,
                          )
                        ),
                      ),
                      SizedBox(height: 5),

                      // Password
                      Container(
                        width:300,
                        child:Padding(
                          padding:const EdgeInsets.all(6.0),

                        child: TextFormField(
                          controller: _password,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your password',
                                labelText: 'Password'
                            ),
                            validator: (val) => val.isEmpty ? "This field is required" : null,
                          )
                        ),
                      ),
                    ]
                  )
                ),
                SizedBox(height: 50),
                RaisedButton(
                  color: Colors.green,
                  child: Text("Sign in", style: TextStyle(color: Colors.white)),
                  onPressed: () => submitAction(),
                ),
                SizedBox(height: 5),
                RaisedButton(
                  color: Colors.green,
                  child: Text("Register", style: TextStyle(color: Colors.white)),
                  onPressed: () => Navigator.of(context).pushNamed(Register.routeName),
                ),
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