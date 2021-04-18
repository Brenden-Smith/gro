import 'package:firebase_auth/firebase_auth.dart';
import 'package:gro/screens/journal_page.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services.dart';

class OwnedPlant extends StatefulWidget {
  static const routeName = '/owned-plant';
  @override
  _OwnedPlantState createState() => _OwnedPlantState();
}

class _OwnedPlantState extends State<OwnedPlant> {
  String plantId;
  dynamic plant;

  Stream journal;

  String name;
  String commonName;
  String imageUrl;
  String uid;

  @override
  void didChangeDependencies() async {
    plantId = ModalRoute.of(context).settings.arguments as String;

    plant = await DatabaseService().getPlant(plantId);
    fetchUserJournal(uid, plantId);

    setState(() {
      name = plant.get(FieldPath(['plant_name']));
      commonName = plant.get(FieldPath(['plant_common']));
      imageUrl = plant.get(FieldPath(['image']));
    });
    super.didChangeDependencies();
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    Widget img;

    if (imageUrl == null) {
      img = CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Text((name == null) ? '' : name.substring(0, 1),
              style: TextStyle(color: Colors.white, fontSize: 40)));
    } else {
      img = CircleAvatar(radius: 50, backgroundImage: NetworkImage(imageUrl));
    }

    Widget journalList = Container(
      height: mediaQuery.size.height - mediaQuery.padding.top,
      padding: const EdgeInsets.only(bottom: 50),
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
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Container(
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
                        Text("${name}", style: TextStyle(fontSize: 25)),
                        SizedBox(height: 5),
                        Text("${commonName}",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                                fontSize: 15)),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                      width: 200,
                      height: 170,
                      padding: EdgeInsets.only(left: 15),
                      child: Column(children: <Widget>[
                        Text("Water this plant every X days"),
                        Spacer(),
                        Center(
                          child: Row(children: <Widget>[
                            ElevatedButton(
                              child: Text("Water"),
                              onPressed: () {},
                            ),
                            Spacer(),
                            ElevatedButton(
                              child: Text("Edit"),
                              onPressed: () {},
                            ),
                          ]),
                        ),
                      ])),
                  Spacer(),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: mediaQuery.size.width,
                child: Text("Journal Entries", style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JournalPage()),
          );
        },
      ),
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
        onTap: () {},
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
            Padding(
              padding: const EdgeInsets.only(right: 15),
            )
          ],
        ),
      ),
    );
  }
}
