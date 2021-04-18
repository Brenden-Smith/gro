// API from https://trefle.io/

import 'package:flutter/material.dart';
import 'package:gro/screens/survey/plant_description.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models.dart';

class PlantSearch extends StatefulWidget {
  static const routeName = '/plant_search';
  bool isSurvey;

  PlantSearch({ this.isSurvey });

  @override
  _PlantSearchState createState() => _PlantSearchState();
}

class _PlantSearchState extends State<PlantSearch> {
  Stream<List<Plant>> queryResults;
  TextEditingController _query = TextEditingController();

  String searchString;

  @override
  void initState() {
    super.initState();
    queryResults = _searchPlant("");
  }

  Stream<List<Plant>> _searchPlant(String q) async* {

    if (q=="") {
      return;
    }

    // API queries
    final Map<String, String> query = {
      'token': 'e4MKtEkxTyNFuwO3P5jQB5WIPlan2Tx0s3tKs0NFXSU',
      'q': q,
    };

    // Get info from API
    final response = await http.get(Uri.https("trefle.io", "/api/v1/plants/search", query));

    // If response code is 200
    print(response.statusCode);
    if (response.statusCode == 200) {
      final output = new List<Plant>.from(json
          .decode(response.body)['data']
          .map((data) => Plant.fromJson(data)));
      output.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      yield output;
    } else {
      throw Exception("Failed to search");
    }
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    Widget _build(List<Plant> data) {
      return GridView.builder(
        padding: EdgeInsets.all(30),
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
        ),
        itemBuilder: (context, index) {
          return PlantCard(context, data[index]);
        });
    }

    final buildResults = Container(
      height: (mediaQuery.size.height - mediaQuery.padding.top - 125),
      child: StreamBuilder<List<Plant>>(
        stream: queryResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            if (snapshot.data.length!=0) {
              return _build(snapshot.data);
            } else {
              return Center(child: Text("There are no items that match your search"));
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: Text("Enter a search query in the search bar"));
        }          
      )
    );

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Compendium",
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 75,
                  padding: EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                  child: TextField(
                    controller: _query,
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search",
                    ),
                    onSubmitted: (text) {
                      print("submitted!");
                      queryResults = _searchPlant(text);
                      setState(() {});
                    }
                  ),
                ),
                buildResults,
              ]
            )
          )
        ),
      )
    );
  }

  Widget PlantCard(BuildContext context, Plant plant) {
    Widget img;

    if (plant.image == "null") {
      img = CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Text(plant.name.substring(0, 1),
              style: TextStyle(color: Colors.white, fontSize: 40)));
    } else {
      img =
          CircleAvatar(radius: 20, backgroundImage: NetworkImage(plant.image));
    }

    return new InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlantDesc(plant: plant, isSurvey: widget.isSurvey))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: img,
          ),
          SizedBox(height: 15),
          Text("${plant.name}"),
        ],
      ),
    );
}
}
