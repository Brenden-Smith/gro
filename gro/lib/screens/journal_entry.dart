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
        title: Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.date_range),
              SizedBox(width: 7),
              Text("${DateFormat.yMMMd().format(DateTime.parse(widget.date.toDate().toString()))}"),
            ],
          ),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      backgroundColor: Colors.green,
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
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              Container(
                height: 50,
                width: mediaQuery.size.width,
                child: Text('${widget.title}',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
      )
    );
  }
}