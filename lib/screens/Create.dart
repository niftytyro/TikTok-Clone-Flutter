import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Create extends StatefulWidget {
  static const pathName = '/create';
  final List<CameraDescription> cameras;

  Create({@required this.cameras});

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  CameraController _controller;
  Future<void> _initializedControllerFuture;

  @override
  void initState() {
    super.initState();
    _initCamera(widget.cameras.last);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initCamera(CameraDescription description) async {
    _controller = CameraController(description, ResolutionPreset.medium);
    _initializedControllerFuture = _controller.initialize();
    setState(() {});
  }

  void _toggleCamera() {
    final lensDirection = _controller.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = widget.cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else if (lensDirection == CameraLensDirection.back) {
      newDescription = widget.cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }
    if (newDescription != null) {
      _initCamera(newDescription);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            child: Stack(
              children: [
                Camera(
                  controller: _controller,
                  future: _initializedControllerFuture,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0.05 * constraints.maxHeight,
                    horizontal: 0.05 * constraints.maxWidth,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.music_note_outlined,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              Text(
                                'Add a sound',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.flip_camera_android,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: _toggleCamera,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Camera extends StatefulWidget {
  final CameraController controller;
  final Future<void> future;

  Camera({@required this.controller, @required this.future});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return CameraPreview(widget.controller);
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
        future: widget.future);
  }
}
