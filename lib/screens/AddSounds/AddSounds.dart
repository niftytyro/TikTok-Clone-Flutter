import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/Utils/FireDB.dart';
import 'package:tiktok_clone/Utils/FireStorage.dart';

class AddSounds extends StatefulWidget {
  @override
  _AddSoundsState createState() => _AddSoundsState();
}

class _AddSoundsState extends State<AddSounds> {
  AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  Future<void> _playSound(Future<String> url) async {
    _player.stop();
    _player.play(await url);
  }

  void _stopSound() {
    _player.stop();
  }

  void _popScreen() {
    _stopSound();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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
              SoundsList(playSound: _playSound, stopSound: _stopSound),
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
  }) : super(key: key);

  final Function playSound;
  final Function stopSound;

  @override
  _SoundsListState createState() => _SoundsListState();
}

class _SoundsListState extends State<SoundsList> {
  List sounds = [];
  int playing = -1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                return SoundTile(
                    name: doc.data()['name'],
                    creator: doc.data()['creator'],
                    isPlaying: playing == index,
                    onTap: () {
                      if (playing == index) {
                        widget.stopSound();
                      } else {
                        widget.playSound(fireStorage.getSoundUrl(
                            path: "sounds/${doc.data()['name']}"));
                      }
                      setState(() {
                        if (playing == index) {
                          playing = -1;
                        } else {
                          playing = index;
                        }
                      });
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
    @required this.onTap,
  }) : super(key: key);

  final String name;
  final String creator;
  final bool isPlaying;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow_rounded,
              size: 30.0,
            ),
            onTap: onTap,
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
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
    );
  }
}
