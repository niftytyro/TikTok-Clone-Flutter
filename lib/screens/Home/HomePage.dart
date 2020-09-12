import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/Utils/FireDB.dart';
import 'package:tiktok_clone/Utils/FireStorage.dart';
import 'package:tiktok_clone/screens/Home/Overlay.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.videoPlayerController,
    this.initVideoPlayerController,
    this.setVideoPlayerController,
    this.startPlaying,
  });

  final VideoPlayerController videoPlayerController;
  final Future initVideoPlayerController;
  final Function setVideoPlayerController;
  final Function startPlaying;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _videos;
  int _pageIndex = 0;
  bool _liked = false;

  void _setIndex(int index) {
    setState(() {
      _pageIndex = index;
      _liked = false;
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
                videoPlayerController: widget.videoPlayerController,
                setVideoPlayerController: widget.setVideoPlayerController,
                startPlaying: widget.startPlaying,
                initVideoPlayerController: widget.initVideoPlayerController,
              ),
              VideosOverlay(
                username:
                    fireDB.getUsername(_videos[_pageIndex].data()['creator']),
                description: _videos[_pageIndex].data()['description'],
                likes: _videos[_pageIndex].data()['likes'],
                liked: _liked,
                addLike: () {
                  fireDB.addLike(_videos[_pageIndex].id,
                      _videos[_pageIndex].data()['likes'] + 1);
                  setState(() {
                    _liked = true;
                  });
                },
              ),
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
  TikToksView({
    this.setIndex,
    this.videos,
    this.initVideoPlayerController,
    this.videoPlayerController,
    this.setVideoPlayerController,
    this.startPlaying,
  });

  final Function setIndex;
  final List videos;
  VideoPlayerController videoPlayerController;
  Future initVideoPlayerController;
  final Function setVideoPlayerController;
  final Function startPlaying;

  @override
  _TikToksViewState createState() => _TikToksViewState();
}

class _TikToksViewState extends State<TikToksView> {
  PageController _pageController;

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
    return GestureDetector(
      onTap: widget.startPlaying,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        onPageChanged: widget.setIndex,
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                widget.videoPlayerController =
                    widget.setVideoPlayerController(snapshot.data);
                widget.initVideoPlayerController =
                    widget.videoPlayerController.initialize();
                return FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      widget.startPlaying();
                      return VideoPlayer(widget.videoPlayerController);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                  future: widget.initVideoPlayerController,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
            future: fireStorage.getDownloadUrl(path: widget.videos[index]),
          );
        },
      ),
    );
  }
}
