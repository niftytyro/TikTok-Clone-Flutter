import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'TokTok',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
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

  void _setIndex(index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: _index == 0 ? Colors.black : Colors.white,
        ),
        child: BottomNavigationBar(
          elevation: 0.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: BottomNavBarItemIcon(
                  index: 0,
                  selectedIndex: _index,
                  icon: Icon(
                    Icons.home,
                    color: _index == 0 ? Colors.white : Colors.black,
                    size: 25.0,
                  ),
                  selectedIcon: Column(
                    children: [
                      Icon(
                        Icons.home,
                        color: _index == 0 ? Colors.white : Colors.black,
                        size: 25.0,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        width: 25.0,
                        height: 2.0,
                        color: _index == 0 ? Colors.white : Colors.black,
                      ),
                    ],
                  )),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: BottomNavBarItemIcon(
                index: 1,
                selectedIndex: _index,
                icon: Icon(
                  Icons.search_rounded,
                  color: _index == 0 ? Colors.white : Colors.black,
                  size: 25.0,
                ),
                selectedIcon: Icon(
                  Icons.search,
                  color: _index == 0 ? Colors.white : Colors.black,
                  size: 28.0,
                ),
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: BottomNavBarItemIcon(
                index: 2,
                selectedIndex: _index,
                icon: Icon(
                  Icons.add,
                  color: _index == 0 ? Colors.white : Colors.black,
                  size: 25.0,
                ),
                selectedIcon: Icon(
                  Icons.add,
                  color: _index == 0 ? Colors.white : Colors.black,
                  size: 25.0,
                ),
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: BottomNavBarItemIcon(
                index: 3,
                selectedIndex: _index,
                icon: Icon(
                  Icons.message_outlined,
                  color: _index == 0 ? Colors.white : Colors.black,
                  size: 25.0,
                ),
                selectedIcon: Icon(
                  Icons.message,
                  color: _index == 0 ? Colors.white : Colors.black,
                  size: 25.0,
                ),
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: BottomNavBarItemIcon(
                index: 4,
                selectedIndex: _index,
                icon: Icon(
                  Icons.person_outline,
                  color: _index == 0 ? Colors.white : Colors.black,
                  size: 25.0,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  color: _index == 0 ? Colors.white : Colors.black,
                  size: 25.0,
                ),
              ),
              title: Text(''),
            ),
          ],
          currentIndex: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _setIndex,
        ),
      ),
      body: Center(),
    );
  }
}

class BottomNavBarItemIcon extends StatelessWidget {
  const BottomNavBarItemIcon({
    Key key,
    @required this.index,
    @required this.selectedIndex,
    @required this.icon,
    @required this.selectedIcon,
  }) : super(key: key);

  final int index;
  final int selectedIndex;
  final Widget icon;
  final Widget selectedIcon;

  @override
  Widget build(BuildContext context) {
    return selectedIndex == index ? selectedIcon : icon;
  }
}
