import 'package:flutter/material.dart';
import 'package:tiktok_clone/Utils/FireAuth.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({Key key, @required this.constraints}) : super(key: key);

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.only(left: 0.05 * constraints.maxWidth),
        height: 0.1 * constraints.maxHeight,
        color: Theme.of(context).accentColor,
        onPressed: () {
          auth.signIn();
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Continue with'),
            SizedBox(
              width: 0.05 * constraints.maxWidth,
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 1.0,
                  minHeight: 1.0,
                ),
                child: Image.asset('assets/icons/google_logo.png'),
              ),
            ),
          ],
        ));
  }
}
