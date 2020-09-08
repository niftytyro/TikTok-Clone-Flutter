import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/BottomNavBar.dart';
import 'package:tiktok_clone/SignInButton.dart';
import 'package:tiktok_clone/screens/Create/Create.dart';
import 'package:tiktok_clone/screens/Home/HomePage.dart';
import 'package:tiktok_clone/screens/Home/Profile.dart';
import 'package:tiktok_clone/Utils/FireAuth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  runApp(MyApp(
    cameras: cameras,
  ));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  MyApp({@required this.cameras});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // systemNavigationBarColor: Colors.transparent,
      ),
    );
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'TokTok',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routes: {
            Home.pathName: (context) => Home(),
            Create.pathName: (context) => Create(
                  cameras: cameras,
                ),
          },
          initialRoute: Home.pathName,
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  static const pathName = '/home';

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
            if (_index == 1) {
              setState(() {
                _index = 0;
              });
              Navigator.pushNamed(context, Create.pathName);
            } else if (_index == 2 && !auth.isSignedIn) {
              showSignInModalSheet(context);
            }
          }
        },
      ),
      body: _index == 0 ? HomePage() : Profile(),
    );
  }
}

void showSignInModalSheet(BuildContext context) {
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
                    constraints:
                        BoxConstraints(maxWidth: 0.6 * constraints.maxWidth),
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
