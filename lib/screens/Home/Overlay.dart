import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideosOverlay extends StatelessWidget {
  VideosOverlay({
    this.description = '',
    this.username,
    this.likes = 0,
    this.addLike,
    this.liked,
  });

  final String description;
  final Future<String> username;
  final int likes;
  final bool liked;
  final Function addLike;

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
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      return OverlayAbout(
                        username: snapshot.data,
                        caption: description,
                      );
                    },
                    future: username,
                    initialData: '',
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
                    GestureDetector(
                      onTap: addLike,
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: liked ? Colors.red : Colors.white,
                            size: 45.0,
                          ),
                          Text(
                            '$likes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
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
    @required this.username,
    @required this.caption,
  });

  final String username;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$username',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15.0),
            Text(
              caption,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 15.0),
          ],
        );
      },
    );
  }
}
