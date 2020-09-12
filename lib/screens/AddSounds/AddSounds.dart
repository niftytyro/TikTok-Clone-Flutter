import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiktok_clone/Utils/FireDB.dart';
import 'package:tiktok_clone/Utils/FireStorage.dart';

class AddSounds extends StatefulWidget {
  AddSounds({@required this.tempFile});

  final File tempFile;

  @override
  _AddSoundsState createState() => _AddSoundsState();
}

class _AddSoundsState extends State<AddSounds> {
  AudioPlayer _player;
  File _newFile;
  FlutterFFmpeg _fFmpeg;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _fFmpeg = FlutterFFmpeg();
    _newFile = widget.tempFile;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound(Future<String> url) async {
    try {
      await _player.stop();
    } catch (e) {
      print(e);
    }
    _player.play(await url);
  }

  void _stopSound() {
    _player.stop();
  }

  void _popScreen() {
    _stopSound();
    Navigator.pop(context, _newFile);
  }

  void _replaceSound({Future<String> downloadURL}) async {
    print('DOWNLOAD FUCKING URL');
    print(downloadURL);
    if (widget.tempFile != null) {
      final extDir = await getExternalStorageDirectory();
      final String dirPath = '${extDir.path}';
      await Directory(dirPath).create(recursive: true);
      DateTime now = DateTime.now();
      String filename = now.day.toString() +
          '.' +
          now.hour.toString() +
          '.' +
          now.minute.toString() +
          '.' +
          now.second.toString();
      String _newFilePath = '$dirPath/$filename.mp4';
      String url = await downloadURL;
      await _fFmpeg.executeWithArguments([
        '-i',
        widget.tempFile.path,
        '-i',
        url,
        '-map',
        '0:v:0',
        '-map',
        '1:a:0',
        '-shortest',
        _newFilePath
      ]);
      _newFile = File(_newFilePath);
      _popScreen();
    }
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
              SizedBox(height: 20.0),
              SoundsList(
                  playSound: _playSound,
                  stopSound: _stopSound,
                  replaceSound: _replaceSound),
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

class SoundsList extends StatefulWidget {
  const SoundsList({
    Key key,
    this.playSound,
    this.stopSound,
    this.replaceSound,
  }) : super(key: key);

  final Function playSound;
  final Function stopSound;
  final Function replaceSound;

  @override
  _SoundsListState createState() => _SoundsListState();
}

class _SoundsListState extends State<SoundsList> {
  List sounds = [];
  int playing = -1;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return _isEditing
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  sounds = snapshot.data.docs;
                  return ListView(
                    children: sounds.asMap().entries.map((entry) {
                      var doc = entry.value;
                      int index = entry.key;
                      Future<String> downloadURL = fireStorage.getDownloadUrl(
                          path: "sounds/${doc.data()['name']}");
                      return SoundTile(
                          name: doc.data()['name'],
                          creator: doc.data()['creator'],
                          isPlaying: playing == index,
                          onPlay: () {
                            if (playing == index) {
                              widget.stopSound();
                            } else {
                              widget.playSound(downloadURL);
                            }
                            setState(() {
                              if (playing == index) {
                                playing = -1;
                              } else {
                                playing = index;
                              }
                            });
                          },
                          onSelect: () async {
                            setState(() {
                              _isEditing = true;
                            });
                            widget.replaceSound(downloadURL: downloadURL);
                          });
                    }).toList(),
                  );
                }
              },
              stream: fireDB.getSoundsStream(),
            ),
          );
  }
}

class SoundTile extends StatelessWidget {
  const SoundTile({
    Key key,
    @required this.name,
    @required this.creator,
    @required this.isPlaying,
    @required this.onPlay,
    @required this.onSelect,
  }) : super(key: key);

  final String name;
  final String creator;
  final bool isPlaying;
  final Function onPlay;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            GestureDetector(
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                size: 30.0,
              ),
              onTap: onPlay,
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.substring(0, name.lastIndexOf('.')),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.0),
                ),
                SizedBox(height: 5.0),
                Text(
                  creator,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
