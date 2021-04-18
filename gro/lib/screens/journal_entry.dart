import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services.dart';

class JournalEntryView extends StatefulWidget {
  Timestamp date;
  String title;
  String content;
  String rid1;
  String rid2;

  JournalEntryView({this.date, this.title, this.content, this.rid1, this.rid2});

  @override
  _JournalEntryViewState createState() => _JournalEntryViewState();
}

class _JournalEntryViewState extends State<JournalEntryView> {

  deleteEntryDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Are you sure you would like to delete this journal entry?',
        ),
        content: Text(
          'This action is permanent',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'No',
            ),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            child: Text(
              'Yes',
            ),
            onPressed: () {
              DatabaseService().deleteJournalEntry(widget.rid1, widget.rid2);
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green,
          title: Container(
            child: Row(
              children: <Widget>[
                Icon(Icons.date_range),
                SizedBox(width: 7),
                Text("${DateFormat.yMMMd().format(DateTime.parse(widget.date.toDate().toString()))}"),
              ],
            )
          ),
          actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              deleteEntryDialog();
            },
          ),
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
          padding: EdgeInsets.all(15),
          height: mediaQuery.size.height - mediaQuery.padding.top,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: 15),
              Container(
                height: 50,
                width: mediaQuery.size.width,
                child: Text(
                  '  ${widget.title}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: mediaQuery.size.width,
                child: Text(
                  '   ${widget.content}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
              ),
        ]))));
  }
}
