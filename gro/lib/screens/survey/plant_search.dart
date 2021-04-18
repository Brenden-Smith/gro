// API from https://trefle.io/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models.dart';
import '../../screens.dart';



class PlantSearch extends StatefulWidget {
  static const routeName = '/plant-search';
  @override
  _PlantSearchState createState() => _PlantSearchState();
}

class _PlantSearchState extends State<PlantSearch> {

  Future<List<Plant>> queryResults;

  @override
    void initState() {
      super.initState();
      queryResults = _searchPlant("rose");
    }

  Future<List<Plant>> _searchPlant(String q) async {

    // If query is empty
    if (q=="") {
      List<Plant> empty = [];
      return empty;
    }

    // API queries
    final Map<String, String> query = {
      'token' : 'e4MKtEkxTyNFuwO3P5jQB5WIPlan2Tx0s3tKs0NFXSU',
      'q' : q,
    };

    // Get info from API
    final response = await http.get(Uri.https("trefle.io", "/api/v1/plants/search", query));

    // If response code is 200
    if (response.statusCode == 200) {
      final output = new List<Plant>.from(json.decode(response.body)['data'].map((data) => Plant.fromJson(data)));
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
    
    final buildResults = Container(
      child: FutureBuilder<List<Plant>>(
        future: queryResults,
        builder: (conext, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: EdgeInsets.all(30),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
              ),
              itemBuilder: (context, index) {
                return PlantCard(context, snapshot.data[index]);
              }
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
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
      body: buildResults,
    );
  }

  Widget PlantCard(BuildContext context, Plant plant) {
    
    Widget img;

    if (plant.image=="null") {
      img = CircleAvatar(radius: 20, backgroundColor: Colors.grey, child: Text(plant.name.substring(0, 1), style: TextStyle(color: Colors.white, fontSize: 40)));
    } else {
      img = CircleAvatar(radius: 20, backgroundImage: NetworkImage(plant.image));
    }
    return new Container(
      // decoration: BoxDecoration(
      //   shape: BoxShape.rectangle,
      //   border: Border(
      //     top: BorderSide(
      //       width: 1,
      //       color: Colors.grey[300],
      //     ),
      //     bottom: BorderSide(
      //       width: 1,
      //       color: Colors.grey[300],
      //     ),
      //     left: BorderSide(
      //       width: 1,
      //       color: Colors.grey[300],
      //     ),
      //     right: BorderSide(
      //       width: 1,
      //       color: Colors.grey[300],
      //     ),
      //   ),
      //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.5),
      //       spreadRadius: 1,
      //       blurRadius: 3,
      //       offset: Offset(0, 5), // changes position of shadow
      //     ),
      //   ],
      // ),
      child: InkWell(
        onTap: () {},
        child: Ink(
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
        )  
      )
    );
  }
}
