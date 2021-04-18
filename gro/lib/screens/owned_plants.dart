import 'package:flutter/material.dart';

class OwnedPlant extends StatefulWidget {
  @override
  _OwnedPlantState createState() => _OwnedPlantState();
}

class _OwnedPlantState extends State<OwnedPlant> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final pageBody = Container(
      height: (mediaQuery.size.height - mediaQuery.padding.top),
      width: mediaQuery.size.width,
      padding: const EdgeInsets.all(80),
      child: Container(
        height: 100.0,
        child: Container(
          child: ListView(
            children: <Widget>[Text("Hello"), Text("HElo")],
          ),
        ),
      ),
    );

    return Scaffold(
      body: pageBody,
    );
  }
}
