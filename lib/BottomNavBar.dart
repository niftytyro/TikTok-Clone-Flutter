import 'package:flutter/material.dart';

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

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _index = 0;

  void _setIndex(index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: _index == 0 ? Colors.black : Colors.white,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: BottomNavBarItemIcon(
              index: 0,
              selectedIndex: _index,
              icon: Icon(
                Icons.home,
                color: Colors.black,
                size: 25.0,
              ),
              selectedIcon: Column(
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: 25.0,
                    height: 2.0,
                    color: _index == 0 ? Colors.white : Colors.black,
                  ),
                ],
              ),
            ),
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
              icon: SizedBox(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: _index == 0
                      ? Image.asset('assets/icons/create_light.png')
                      : Image.asset('assets/icons/create_dark.png'),
                ),
                height: 25.0,
              ),
              selectedIcon: SizedBox(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Image.asset('assets/icons/create_dark.png'),
                ),
                height: 28.0,
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
                size: 28.0,
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
                size: 28.0,
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
    );
  }
}
