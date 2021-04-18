import 'package:flutter/material.dart';
import '../../models.dart';
import 'name_question.dart';

class PlantDesc extends StatefulWidget {
  static const routeName = '/plant-desc';
  bool isSurvey;

  Plant plant;

  PlantDesc({ this.plant, this.isSurvey });

  @override
  _PlantDescState createState() => _PlantDescState();
}

class _PlantDescState extends State<PlantDesc> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: <Widget>[
              CircleAvatar(backgroundImage: NetworkImage(widget.plant.image), radius: 80),
              SizedBox(height: 15),
              Text("${widget.plant.name}", style: TextStyle(fontSize: 30)),
              SizedBox(height: 5),
              Text("${widget.plant.scientificName}", style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic, fontSize: 20)),
              Spacer(),

              widget.isSurvey ? ElevatedButton(
                child: Text("Confirm"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NameQuestion(entry: PlantEntry(plant: widget.plant))),
                  );
                },
              ) :
              Container(),
            ],
          ),
        ),
      )
    );
  }
}
