import 'package:firebase_auth/firebase_auth.dart';
import 'package:gro/screens/journal_page.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services.dart';
import '../screens.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnedPlant extends StatefulWidget {
  static const routeName = '/owned-plant';
  String rid;

  OwnedPlant({this.rid});
  @override
  _OwnedPlantState createState() => _OwnedPlantState();
}

class _OwnedPlantState extends State<OwnedPlant> {

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String plantId;
  DocumentSnapshot plant;
  int days;
  int dtw;
  Timestamp ts;

  Stream journal;

  String name;
  String commonName;
  String imageUrl;
  String uid;

  @override
  void initState() {
    super.initState();
    print(widget.rid);
    fetchUserJournal(uid, widget.rid);
    setValues(widget.rid);
    
  }

  fetchPlant() {}

  setValues(String plantId) async {
    plant = await DatabaseService().getPlant(plantId);

    setState(() {
      name = plant.get(FieldPath(['plant_name']));
      commonName = plant.get(FieldPath(['plant_common']));
      imageUrl = plant.get(FieldPath(['image']));
      ts = plant.get(FieldPath(['lastWatered']));
      dtw = plant.get(FieldPath(['daysToWater']));
      days = dtw - (DateTime.now().difference(DateTime.parse(ts.toDate().toString())).inDays);
    });
  }

  fetchUserJournal(String uid, String plantId) async {
    await DatabaseService().getUsersJournal(uid, plantId).then((results) {
      setState(() {
        journal = results;
      });
    });
  }

  fetchUserID() {
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  deletePlantDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Are you sure you would like to delete ${name}?',
        ),
        content: Text(
          'This action is permanent',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'No',
            ),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            child: Text(
              'Yes',
            ),
            onPressed: () {
              DatabaseService().deletePlant(widget.rid);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    Widget img;

    if (imageUrl == "null") {
      img = CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          child: Text((name == null) ? '' : name.substring(0, 1),
              style: TextStyle(color: Colors.white, fontSize: 40)));
    } else {
      img = CircleAvatar(radius: 50, backgroundImage: NetworkImage(imageUrl));
    }

    waterPlantSnackbar() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Yay! You watered \"${name}\"'),
        duration: const Duration(seconds: 1),
      ));
    }

    Widget journalList = Container(
      height: 400,
      width: mediaQuery.size.width,
      padding: EdgeInsets.only(bottom: 50),
      child: StreamBuilder(
          stream: journal,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error loading journal entries"));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data.docs.length == 0) {
                return Center(
                    child: Text("You do not have any journal entries"));
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot jr = snapshot.data.docs[index];
                    return JournalTile(context, jr);
                  });
            } else {
              return Text('');
            }
          }),
    );

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          "${name}",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              deletePlantDialog();
            },
          ),
        ],
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      backgroundColor: Colors.green,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 170,
                    width: 100,
                    child: Column(
                      children: <Widget>[
                        img,
                        SizedBox(height: 15),
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text("${name}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                        SizedBox(height: 5),
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text("${commonName}",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                      width: 200,
                      height: 170,
                      padding: EdgeInsets.only(left: 15),
                      child: Column(children: <Widget>[
                        Spacer(flex: 2),
                        Container(child: Text("Water this plant every ${dtw} days", textAlign: TextAlign.center)),
                        Spacer(),
                        Container(child: Text("That means you need to water it in ${days} days", textAlign: TextAlign.center)),
                        Spacer(flex: 2),
                        Center(
                          child: Row(children: <Widget>[
                            Spacer(),
                            ButtonTheme(
                              minWidth: 80,
                              height: 40,
                              child: RaisedButton(
                                onPressed: () {
                                  DatabaseService().waterPlant(plantId);
                                  waterPlantSnackbar();
                                  setState(() {
                                    ts = plant.get(FieldPath(['lastWatered']));
                                    days = dtw - (DateTime.now().difference(DateTime.parse(ts.toDate().toString())).inDays);
                                  });
                                },
                                color: Colors.green,
                                child: Text(
                                  "Water",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Spacer(),
                            // ButtonTheme(
                            //   minWidth: 80,
                            //   height: 40,
                            //   child: RaisedButton(
                            //     onPressed: () {},
                            //     color: Colors.green,
                            //     child: Text(
                            //       "Edit",
                            //       style: TextStyle(color: Colors.white),
                            //     ),
                            //   ),
                            // ),
                          ]),
                        ),
                      ])),
                  Spacer(),
                ],
              ),
              SizedBox(height: 30),
              Container(
                  width: mediaQuery.size.width,
                  child: Text(
                    "Journal Entries",
                    style: GoogleFonts.raleway(
                      fontSize: 30,
                    ),
                  )),
              SizedBox(height: 15),
              Container(
                  height: 350,
                  child: SingleChildScrollView(child: journalList)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JournalPage(rid1: widget.rid)))
                .then((value) {
              fetchUserJournal(uid, widget.rid);
            });
          }),
    );
  }

  Widget JournalTile(BuildContext context, DocumentSnapshot entry) {
    return Ink(
      padding: const EdgeInsets.only(),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[300],
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => JournalEntryView(
                      date: entry['date'],
                      title: entry['title'],
                      content: entry['content'],
                      rid1: widget.rid,
                      rid2: entry.id,)));
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 25,
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          (entry['title'].length > 15)
                              ? '${entry['title']}...'.substring(0, 15) + '...'
                              : '${entry['title']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${DateFormat.yMMMd().format(entry['date'].toDate())}',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        height: 25,
                        width: 25,
                        child: Center(
                            child: Icon(Icons.arrow_forward_ios,
                                color: Colors.grey, size: 15)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.only(bottom: 5, right: 5),
                    child: Text(
                        (entry['content'].length > 35)
                            ? '${entry['content'].substring(0, 35)}...'
                            : '${entry['content']}',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black45, fontSize: 15)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
