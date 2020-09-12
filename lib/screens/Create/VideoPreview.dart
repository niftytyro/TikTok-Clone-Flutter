import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatelessWidget {
  VideoPreview({this.controller, this.future});

  final VideoPlayerController controller;
  final Future<void> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          controller.play();
          controller.setLooping(true);
          return Center(child: VideoPlayer(controller));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      future: future,
    );
  }
}
