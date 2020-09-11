import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatelessWidget {
  final CameraController controller;
  final Future<void> future;

  Camera({@required this.controller, @required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return CameraPreview(controller);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Some error ocurred. Share Screenshot on me@udasitharani.dev '),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
        future: future);
  }
}
