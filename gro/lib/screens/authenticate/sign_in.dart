import 'package:flutter/material.dart';
import '../../services.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {



  @override
  Widget build(BuildContext context) {

    final AuthService _auth = AuthService();

    final mediaQuery = MediaQuery.of(context);

    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();

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
}