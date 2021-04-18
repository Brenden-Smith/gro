import 'package:flutter/material.dart';
import 'package:gro/screens/survey/plant_search.dart';
import '../../models.dart';

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
                ),
              ),
            ),
          ),
          Spacer(flex: 2),
          Container(
            child: ElevatedButton(
              onPressed: () { 
                if (_formKey.currentState.validate()) {
                  widget.entry.setDaysToWater(int.parse(_water.text));
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
