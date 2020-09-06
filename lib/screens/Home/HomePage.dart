import 'package:flutter/material.dart';
import 'package:tiktok_clone/screens/Home/Overlay.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
