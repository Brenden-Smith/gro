import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalEntryView extends StatefulWidget {

  Timestamp date;
  String title;
  String content;

  JournalEntryView({ this.date, this.title, this.content});

  @override
  _JournalEntryViewState createState() => _JournalEntryViewState();
}

class _JournalEntryViewState extends State<JournalEntryView> {
  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${DateTime.parse(widget.date.toDate().toString())}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            Container(
              height: 50,
              width: mediaQuery.size.width,
              child: Text('Title: ${widget.title}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 15),
            Container(
            width: mediaQuery.size.width,
            child: Text('${widget.content}',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20),
            ),
          ),
          ]
        )
      )
    );
  }
}