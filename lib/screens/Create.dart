import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Create extends StatelessWidget {
  static const pathName = '/create';
  final List<CameraDescription> cameras;

  Create({@required this.cameras});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: Stack(
            children: [
              Camera(
                camera: cameras.first,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.05 * constraints.maxHeight,
                  horizontal: 0.05 * constraints.maxWidth,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Camera extends StatefulWidget {
  final CameraDescription camera;

  Camera({@required this.camera});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController _controller;
  Future<void> _initializedControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializedControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
                'Some error ocurred. Share Screenshot on me@udasitharani.dev '),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
      future: _initializedControllerFuture,
    );
  }
}
