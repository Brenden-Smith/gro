import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gro/screens/owned_plants.dart';
import 'package:gro/screens/survey/name_question.dart';
import '../screens.dart';
import '../services.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid;

  Stream plants;

  fetchUserID() {
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  fetchUserPlants() async {
    await DatabaseService().getUsersPlants(uid).then((results) {
      setState(() {
        plants = results;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserID();
    fetchUserPlants();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final appBar = new AppBar(
      backgroundColor: Colors.green,
      title: Text(
        "My Plants",
      ),
      elevation: 0,
    );

    final plantList = Container(
      height: (mediaQuery.size.height - mediaQuery.padding.top - appBar.preferredSize.height - 50),
      child: StreamBuilder(
          stream: plants,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.docs.length == 0) {
                return Center(child: Text("You do not have any plants."));
              }
              return GridView.builder(
                  padding: EdgeInsets.all(30),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                  ),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext txt, index) {
                    Widget img;
                    DocumentSnapshot plant = snapshot.data.docs[index];

                    if (plant['image'] == "null") {
                      img = CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Text(plant['plant_name'].substring(0, 1),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 40)));
                    } else {
                      img = CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(plant['image']));
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OwnedPlant(rid: plant.id)));
                      },
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
                            Text("${plant['plant_name']}",
                                style: GoogleFonts.openSans()),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Text('');
            }
          }),
    );

    return Scaffold(
        backgroundColor: Colors.green,
        appBar: appBar,
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
                  plantList,
                ]
              )
            )
          )
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PlantSearch(isSurvey: true)));
            }));
  }
}
