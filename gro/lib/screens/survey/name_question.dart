import 'package:flutter/material.dart';
import 'package:gro/screens/survey/water_question.dart';
import '../../models.dart';

class NameQuestion extends StatefulWidget {
  static const routeName = '/name-question';
  PlantEntry entry;

  NameQuestion({ this.entry });

  @override
  _NameQuestionState createState() => _NameQuestionState();
}

class _NameQuestionState extends State<NameQuestion> {

  TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pageBody = Container(
      height: (mediaQuery.size.height - mediaQuery.padding.top),
      width: mediaQuery.size.width,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              "What do you want to name your plant?",
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
                  controller: _name,
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                  validator: (val) => val.isEmpty ? 'This field is required' : null,
                ),
              ),
            ),
          ),
          Spacer(flex: 2),
          Container(
            child: ElevatedButton(
              onPressed: () { 
                if (_formKey.currentState.validate()) {
                  widget.entry.setName(_name.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WaterQuestion(entry: widget.entry)),
                    );
                }
              },
              child: Text('Next'),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.green,
      body: pageBody,
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),

    );
  }
}
