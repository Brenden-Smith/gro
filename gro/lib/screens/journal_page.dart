import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _journalController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          title: Container(
            child: Row(
              children: <Widget>[
                Icon(Icons.date_range),
                Text('   ${DateFormat.yMMMd().format(DateTime.now())}'),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        ),
        key: _formKey,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
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
                    color: Colors.green,
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
                    color: Colors.green,
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
        ));
  }
}
