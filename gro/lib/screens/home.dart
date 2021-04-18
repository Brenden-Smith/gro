import 'package:flutter/material.dart';
import 'package:gro/screens/name_question.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List plants = [1,2,3,4];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final plantList = SingleChildScrollView(
      child: Container(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
          ),
          itemCount: 4,
          shrinkWrap: true,
          itemBuilder: (BuildContext txt, index) {
            return InkWell(
              onTap: () {},
              child: Ink(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      )
                    ),
                    SizedBox(height: 15),
                    Text("Plant $index"),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );

    final pageBody = Container(
      height: (mediaQuery.size.height - mediaQuery.padding.top),
      width: mediaQuery.size.width,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          SizedBox(height: mediaQuery.padding.top),
          Container(
            width: mediaQuery.size.width,
            child: Text("My Plants", textAlign: TextAlign.left, style: TextStyle(fontSize: 30)),
          ),
          Expanded(child: plantList),
        ]
      )
    );

    return Scaffold(
        body: pageBody,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NameQuestion()),
              );
            }));
  }
}
