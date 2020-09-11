import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/Utils/FireDB.dart';
import 'package:tiktok_clone/Utils/FireStorage.dart';
import 'package:tiktok_clone/screens/Home/Overlay.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _videos;
  int _pageIndex;

  void _setIndex(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _videos = snapshot.data.docs;
          if (_videos.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              TikToksView(
                setIndex: _setIndex,
                videos: _videos.map((documentSnapshot) {
                  return documentSnapshot.data()['path'];
                }).toList(),
              ),
              VideosOverlay(),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      stream: fireDB.getUploadsStream(),
    );
  }
}

class TikToksView extends StatefulWidget {
  TikToksView({this.setIndex, this.videos});

  final Function setIndex;
  final List videos;

  @override
  _TikToksViewState createState() => _TikToksViewState();
}

class _TikToksViewState extends State<TikToksView> {
  PageController _pageController;
  VideoPlayerController _videoPlayerController;
  Future initVideoPlayerController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      onPageChanged: widget.setIndex,
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              try {
                _videoPlayerController.dispose();
              } catch (e) {
                print(e);
              }
              _videoPlayerController =
                  VideoPlayerController.network(snapshot.data);
              initVideoPlayerController = _videoPlayerController.initialize();
              return FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    _videoPlayerController.play();
                    _videoPlayerController.setLooping(true);
                    return VideoPlayer(_videoPlayerController);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                future: initVideoPlayerController,
              );
            } else {
              return Container(child: CircularProgressIndicator());
            }
          },
          future: fireStorage.getDownloadUrl(path: widget.videos[index]),
        );
      },
    );
  }
}
