import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

class BottomNavBar extends StatelessWidget {
  final int index;
  final Function setIndex;

  BottomNavBar({@required this.index, @required this.setIndex});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: index == 0 ? Colors.black : Colors.white,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: BottomNavBarItemIcon(
              index: 0,
              selectedIndex: index,
              icon: Icon(
                Icons.home_outlined,
                color: Colors.black,
                size: 35.0,
              ),
              selectedIcon: Icon(
                Icons.home,
                color: Colors.white,
                size: 35.0,
              ),
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: BottomNavBarItemIcon(
              index: 2,
              selectedIndex: index,
              icon: SizedBox(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 25.0,
                      minWidth: 25.0,
                    ),
                    child: index == 0
                        ? Image.asset('assets/icons/create_light.png')
                        : Image.asset('assets/icons/create_dark.png'),
                  ),
                ),
                height: 28.0,
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
              index: 4,
              selectedIndex: index,
              icon: Icon(
                FontAwesomeIcons.user,
                color: index == 0 ? Colors.white : Colors.black,
                size: 25.0,
              ),
              selectedIcon: Icon(
                FontAwesomeIcons.userAlt,
                color: index == 0 ? Colors.white : Colors.black,
                size: 28.0,
              ),
            ),
            title: Text(''),
          ),
        ],
        currentIndex: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: setIndex,
      ),
    );
  }
}
