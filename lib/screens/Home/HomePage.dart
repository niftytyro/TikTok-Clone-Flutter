import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/Utils/FireDB.dart';
import 'package:tiktok_clone/screens/Home/Overlay.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TikToksView(),
        VideosOverlay(),
      ],
    );
  }
}

class TikToksView extends StatefulWidget {
  @override
  _TikToksViewState createState() => _TikToksViewState();
}

class _TikToksViewState extends State<TikToksView> {
  List _videos;
  int _pageIndex;
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
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        _videos = snapshot.data.docs;
        return PageView.builder(
          scrollDirection: Axis.vertical,
          onPageChanged: (int index) {
            setState(() {
              _pageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            print(_videos[index]);
            return Container();
            // _videoPlayerController = VideoPlayerController.network(_videos[index]);
          },
        );
      },
      stream: fireDB.getUploadsStream(),
    );
  }
}
