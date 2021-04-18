import 'package:flutter/material.dart';
import '../services.dart';
import '../models.dart';



class Register extends StatefulWidget {
  static const routeName = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
// sets value to false
  bool _value = false;
  bool loading = false;
  String error = '';

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        height: (mediaQuery.size.height - mediaQuery.padding.top),
        padding: EdgeInsets.all(25),
        width: mediaQuery.size.width,
          child: Center(
            child: Column(
              children: [
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
                    ],
                  )
                ),

                SizedBox(height: 50),
                
                RaisedButton(
                    color: Colors.green,
                    child: Text("Create Account", style: TextStyle(color: Colors.white)),
                    onPressed: () async => submitAction(),
                  ),
              ],
            ),
          ),
        )
      );
  }

  submitAction() async {
    print('registering user in register.dart');
    if (_formKey.currentState.validate()) {
      setState(() => loading = true);
      final emailValid =
          await DatabaseService().checkEmail(_email.text);

      if (!emailValid) {
        setState(() {
          error = 'Email already used';
          loading = false;
        });
      } else {
        dynamic result = await _auth.register(
          _email.text,
          _password.text,
        );

        if (result == null) {
          setState(() {
            error = 'Please enter a valid email';
            loading = false;
          });
        } else {
          print('setting CurrentUser email');
          CurrentUser.email = _email.text;
          print('email = ' + CurrentUser.email);

          Navigator.of(context).pop();
        }
      }
    }
  }
}
