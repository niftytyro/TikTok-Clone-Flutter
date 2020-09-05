import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/BottomNavBar.dart';
import 'package:tiktok_clone/SignInButton.dart';
import 'package:tiktok_clone/screens/Create.dart';
import 'package:tiktok_clone/screens/HomePage.dart';
import 'package:tiktok_clone/screens/Profile.dart';

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
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'TokTok',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Home(),
        );
      },
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
          if (_index != newIndex) {
            setState(() {
              _index = newIndex;
            });
            if (_index > 0) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        height: 0.5 * constraints.maxHeight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.05 * constraints.maxHeight,
                              horizontal: 0.2 * constraints.maxWidth),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 0.6 * constraints.maxWidth),
                                child: Text(
                                  'You need a TokTok account to continue.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: constraints.maxHeight * 0.1,
                                ),
                                child: SignInButton(constraints: constraints),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          }
        },
      ),
      body: _index == 0 ? HomePage() : _index == 1 ? Create() : Profile(),
    );
  }
}
