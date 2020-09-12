import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiktok_clone/Utils/FireAuth.dart';
import 'package:tiktok_clone/Utils/FireDB.dart';
import 'package:tiktok_clone/Utils/FireStorage.dart';
import 'package:tiktok_clone/main.dart';

class Post extends StatefulWidget {
  Post({
    @required this.file,
  });

  final File file;

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  TextEditingController _textEditingController;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10.0),
              TextField(
                controller: _textEditingController,
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
                  onPressed: () async {
                    List path_timestamp = await fireStorage.uploadFile(
                        widget.file, auth.getDocID);
                    print(_textEditingController.value.text);
                    if (auth.isSignedIn) {
                      fireDB.addPost(
                        creator: auth.getDocID,
                        path: path_timestamp.first,
                        description: _textEditingController.value.text,
                        timestamp: path_timestamp.last,
                      );
                    }
                    Navigator.pushReplacementNamed(context, Home.pathName);
                  },
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
      ),
    );
  }
}
