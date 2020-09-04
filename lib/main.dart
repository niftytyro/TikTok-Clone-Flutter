import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/BottomNavBar.dart';
import 'package:tiktok_clone/Utils/FireAuth.dart';
import 'package:tiktok_clone/screens/HomePage.dart';
import 'package:tiktok_clone/screens/SignIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     systemNavigationBarColor: Colors.transparent,
    //   ),
    // );
    return MaterialApp(
      title: 'TokTok',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: auth.isSignedIn ? Home() : SignIn(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _index == 0 ? Colors.black : Colors.white,
      bottomNavigationBar: BottomNavBar(
        index: _index,
        setIndex: (int newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
      ),
      body: HomePage(),
    );
  }
}
