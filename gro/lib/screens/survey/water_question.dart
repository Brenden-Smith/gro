import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models.dart';
import '../../services.dart';

class WaterQuestion extends StatefulWidget {
  static const routeName = '/water-question';
  PlantEntry entry;

  WaterQuestion({ this.entry });
  @override
  _WaterQuestionState createState() => _WaterQuestionState();
}

class _WaterQuestionState extends State<WaterQuestion> {

  TextEditingController _water = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String uid;
  String email;

  @override
  void initState() {
    super.initState();
    fetchUserID();
    fetchUserData();
  }

  fetchUserID() {
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  fetchUserData() async {
    dynamic user = await DatabaseService().getUserData(FirebaseAuth.instance.currentUser.uid);
    if (user==null) {
      setState(() {
        email = "Email";
      });
    } else {
      setState(() {
        email = user.get(FieldPath(['email']));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final pageBody = Container(
      height: (mediaQuery.size.height - mediaQuery.padding.top),
      width: mediaQuery.size.width,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              "How often do you want to water your plant?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          Spacer(),
          Container(
            height: 50,
            child: Form(
              key: _formKey,
              child: Container(
                height: 50,
                child: TextFormField(
                  controller: _water,
                  decoration: InputDecoration(
                    hintText: "Days",
                  ),
                  validator: (val) => val.isEmpty ? 'This field is required' : null,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                ),
              ),
            ),
          ),
          Spacer(flex: 2),
          Container(
            child: ElevatedButton(
              onPressed: () async { 
                if (_formKey.currentState.validate()) {
                  widget.entry.setDaysToWater(int.parse(_water.text));
                  DatabaseService()
                      .createPlantEntry(
                        DateTime.now().toString(),
                        uid,
                        email,
                        widget.entry,
                        DateTime.now(),
                      )
                      .whenComplete(() => print('Added to Firestore'));

                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: Text('Next'),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: pageBody,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
      ),
    );
  }
}
