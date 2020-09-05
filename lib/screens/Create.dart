import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
                  child: CreateOverlay(toggleCamera: _toggleCamera),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CreateOverlay extends StatelessWidget {
  final Function toggleCamera;

  const CreateOverlay({this.toggleCamera});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OverlayTop(toggleCamera: toggleCamera),
        OverlayBottom(),
      ],
    );
  }
}

class OverlayBottom extends StatelessWidget {
  const OverlayBottom({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Stack(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      color: Color(0xEE99323B),
                      width: 10.0,
                    ),
                  ),
                  height: 100.0,
                  width: 100.0,
                  padding: EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFBD3546),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                right: 20.0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 40.0,
                        width: 40.0,
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('assets/icons/gallery_icon.png'),
                        ),
                      ),
                      Text(
                        'Upload',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OverlayTop extends StatelessWidget {
  const OverlayTop({
    Key key,
    @required this.toggleCamera,
  }) : super(key: key);

  final Function toggleCamera;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              style: TextStyle(color: Colors.white, fontSize: 13.0),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.flip_camera_android,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: toggleCamera,
        )
      ],
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
