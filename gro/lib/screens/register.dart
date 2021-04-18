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
        width: mediaQuery.size.width,
          child: Column(
            children: [
              Container(
                height: 300,
                  child: Icon(Icons.eco_outlined,
                    size: 150.0,
                  ),

              ),
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
                          )
                        )
                      ),

                    ),
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
                          )
                        )
                      ),
                    ),
                  ],
                )
              ),

              SizedBox(height: 15),
              
              Container(
                child: ElevatedButton(
                  child: Text("Create Account"),
                  onPressed: () async {
                    submitAction();
                  },
                )
              )
            ],
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
