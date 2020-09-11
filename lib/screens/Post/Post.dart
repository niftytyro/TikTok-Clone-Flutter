import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post',
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
        centerTitle: true,
        elevation: 2.0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Describe your video',
                labelStyle: TextStyle(color: Colors.grey),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              maxLines: null,
              cursorColor: Theme.of(context).accentColor,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: FlatButton(
                height: 50.0,
                onPressed: () {},
                color: Theme.of(context).accentColor,
                child: Text(
                  'Post',
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
