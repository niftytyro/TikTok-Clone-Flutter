import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideosOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: 0.8 * constraints.maxWidth),
                  child: OverlayAbout(
                    accountID: 'akearney21',
                    caption: 'lorem ipsum about the video blah blah blah...',
                    songTitle:
                        'This song is sooooooooooooooooooooooooooo sooooooooooooooooooooooooooo loooooooooooong.',
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.userCircle,
                      color: Colors.white,
                      size: 45.0,
                    ),
                    SizedBox(height: 20.0),
                    Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 45.0,
                    ),
                    SizedBox(height: 15.0),
                    Icon(
                      FontAwesomeIcons.solidCommentDots,
                      color: Colors.white,
                      size: 45.0,
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class OverlayAbout extends StatelessWidget {
  OverlayAbout({
    @required this.accountID,
    @required this.caption,
    @required this.songTitle,
  });

  final String accountID;
  final String caption;
  final String songTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@$accountID',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15.0),
            Text(
              caption,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 15.0),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.itunesNote,
                  color: Colors.white,
                ),
                SizedBox(width: 10.0),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: 0.8 * constraints.maxWidth),
                  child: Marquee(
                    child: Text(
                      songTitle,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class Marquee extends StatefulWidget {
  Marquee({
    @required this.child,
    this.scrollDirection = Axis.horizontal,
  });
  final Widget child;
  final Axis scrollDirection;
  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      keepScrollOffset: true,
      initialScrollOffset: 0.0,
    );
    WidgetsBinding.instance.addPostFrameCallback(scroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void scroll(_) async {
    while (_controller.hasClients) {
      await Future.delayed(Duration(milliseconds: 800));
      if (_controller.hasClients)
        await _controller.animateTo(_controller.position.maxScrollExtent,
            duration: Duration(seconds: 5), curve: Curves.linear);
      await Future.delayed(Duration(milliseconds: 800));
      if (_controller.hasClients)
        await _controller.animateTo(0.0,
            duration: Duration(milliseconds: 20), curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: _controller,
          scrollDirection: widget.scrollDirection,
          child: Row(
            children: [
              widget.child,
              SizedBox(width: 1.0 * constraints.maxWidth),
            ],
          ),
        );
      },
    );
  }
}
