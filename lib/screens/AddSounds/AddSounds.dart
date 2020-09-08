import 'package:flutter/material.dart';
import 'package:tiktok_clone/Utils/FireStorage.dart';

class AddSounds extends StatefulWidget {
  @override
  _AddSoundsState createState() => _AddSoundsState();
}

class _AddSoundsState extends State<AddSounds> {
  void _popScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              TopRow(
                popScreen: _popScreen,
              ),
              SoundsList(urlFuture: fireStorage.getSoundUrls()),
            ],
          ),
        ),
      ),
    );
  }
}

class TopRow extends StatelessWidget {
  const TopRow({
    Key key,
    this.popScreen,
  }) : super(key: key);

  final Function popScreen;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Stack(
            children: [
              ClipOval(
                child: Material(
                  child: InkWell(
                    onTap: popScreen,
                    child: SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Add a Sound',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SoundsList extends StatelessWidget {
  const SoundsList({
    Key key,
    this.urlFuture,
  }) : super(key: key);

  final Future<List> urlFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Text('asdasd'),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: urlFuture,
    );
  }
}
