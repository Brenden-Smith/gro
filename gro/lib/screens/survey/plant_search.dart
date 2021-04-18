// API from https://trefle.io/

import 'package:flutter/material.dart';
import 'package:gro/screens/survey/plant_description.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models.dart';

class PlantSearch extends StatefulWidget {
  static const routeName = '/plant_search';
  @override
  _PlantSearchState createState() => _PlantSearchState();
}

class _PlantSearchState extends State<PlantSearch> {
  Future<List<Plant>> queryResults;
  TextEditingController _query = TextEditingController();

  @override
  void initState() {
    super.initState();
    queryResults = _searchPlant("rose");
  }

  Future<List<Plant>> _searchPlant(String q) async {
    // If query is empty
    if (q == "") {
      List<Plant> empty = [];
      return empty;
    }

    // API queries
    final Map<String, String> query = {
      'token': 'e4MKtEkxTyNFuwO3P5jQB5WIPlan2Tx0s3tKs0NFXSU',
      'q': q,
    };

    // Get info from API
    final response =
        await http.get(Uri.https("trefle.io", "/api/v1/plants/search", query));

    // If response code is 200
    if (response.statusCode == 200) {
      final output = new List<Plant>.from(json
          .decode(response.body)['data']
          .map((data) => Plant.fromJson(data)));
      output.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      return output;
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
      height: (mediaQuery.size.height - mediaQuery.padding.top),
      child: FutureBuilder<List<Plant>>(
        future: queryResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return _build(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return _build(snapshot.data);
        }       
      )
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Search", textAlign: TextAlign.center),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15, right: 30, left: 30, bottom: 15),
                child: TextField(
                  controller: _query,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search",
                  ),
                  onSubmitted: (text) async {
                    print("submitted!");
                    await _searchPlant(text);
                    setState(() {});
                  }
                ),
              ),
              buildResults,
            ]
          )
        )
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
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlantDesc(plant: plant))),
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
