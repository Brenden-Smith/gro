import 'package:flutter/material.dart';
import 'package:gro/screens/survey/plant_search.dart';

class WaterQuestion extends StatefulWidget {
  @override
  _WaterQuestionState createState() => _WaterQuestionState();
}

class _WaterQuestionState extends State<WaterQuestion> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pageBody = Container(
      height: (mediaQuery.size.height - mediaQuery.padding.top),
      width: mediaQuery.size.width,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Text(
            "How often do you want to water your plant?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
          SizedBox(
            height: 180,
          ),
          Center(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Input Here",
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.blue,
              onSurface: Colors.red,
            ),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PlantSearch())),
            child: Text('Next'),
          )
        ],
      ),
    );

    return Scaffold(
      body: pageBody,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
