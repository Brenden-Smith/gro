import 'package:flutter/material.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
// sets value to false
  bool _value = false;

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        body: Container(
            height: (mediaQuery.size.height - mediaQuery.padding.top),
            width: mediaQuery.size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 300,
                        child: Icon(Icons.eco_outlined,
                          size: 150.0,
                        ),

                    ),
                    Container(
                      width:300,
                      child:Padding(
                        padding:const EdgeInsets.all(6.0),
                      child: TextFormField(
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
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter your password',
                              labelText: 'Password'
                          )
                      )
                      ),

                    ),
                    Container(
                      child: ElevatedButton(
                        child: Text("Create Account"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {},


                      )
                    )

                  ],

                )
            )
        );

  }
}
