import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';
import '../services.dart';

class JournalPage extends StatefulWidget {
  String rid1;

  JournalPage({this.rid1});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _journalController = TextEditingController();

  String uid;
  String email;

  @override
  void initState() {
    super.initState();
    print(widget.rid1);
    fetchUserID();
    fetchUserData();
  }

  fetchUserID() {
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  fetchUserData() async {
    dynamic user = await DatabaseService()
        .getUserData(FirebaseAuth.instance.currentUser.uid);
    if (user == null) {
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
    return Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: Container(
            child: Row(
              children: <Widget>[
                Icon(Icons.date_range),
                SizedBox(width: 7),
                Text('${DateFormat.yMMMd().format(DateTime.now())}'),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  JournalEntry entry = new JournalEntry(
                      title: _titleController.text,
                      content: _journalController.text);
                  DatabaseService()
                      .createJournalEntry(
                        widget.rid1,
                        DateTime.now().toString(),
                        uid,
                        email,
                        entry,
                        DateTime.now(),
                      )
                      .whenComplete(() => print('Added to Firestore'));

                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          height: mediaQuery.size.height - mediaQuery.padding.top,
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please create a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Journal',
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                    ),
                    controller: _journalController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please create a write something in the journal';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
