import 'package:flutter/material.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageList = [
    PageModel(
      color: Color(0xFF4527A0),
      heroImagePath: 'assets/images/plant1.jfif',
      title: Text(
        "Welcome to Gro!",
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      body: Text(""),
      iconImagePath: 'assets/images/plant1.jfif',
    ),
    PageModel(
      color: Color(0xFF512DA8),
      heroImagePath: 'assets/images/plant2.png',
      title: Text(
        "Purpose",
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      body: Text(
        "This app is used to take care of your plants!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      iconImagePath: 'assets/images/plant1.jfif',
    ),
    PageModel(
      color: Color(0xFF5E35B1),
      heroImagePath: 'assets/images/plant3.png',
      title: Text(
        "Give and Take",
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      body: Text(
        "Give nutrients for your plant and watch your plant grow!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      iconImagePath: 'assets/images/plant1.jfif',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        onDoneButtonPressed: () => Navigator.of(context).pushNamed('home.dart'),
        onSkipButtonPressed: () => Navigator.of(context).pushNamed('home.dart'),
        pageList: pageList,
      ),
    );
  }
}
