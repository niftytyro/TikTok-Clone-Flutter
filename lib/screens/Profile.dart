import 'package:flutter/material.dart';
import 'package:tiktok_clone/Utils/FireAuth.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FlatButton(
        child: Text('Signout'),
        onPressed: () {
          auth.signOut();
        },
      ),
    );
  }
}
