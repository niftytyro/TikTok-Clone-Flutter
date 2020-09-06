import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/screens/Create/CreateOverlay.dart';

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
  PickedFile _video;
  ImagePicker _imagePicker;

  @override
  void initState() {
    Permission.storage.status.then((status) {
      if (!status.isGranted) {
        Permission.storage.request();
      }
    });
    super.initState();
    _initCamera(widget.cameras.last);
    _imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initCamera(CameraDescription description) async {
    _controller = CameraController(description, ResolutionPreset.high);
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

  void _pickFromGallery() async {
    _video = await _imagePicker.getVideo(source: ImageSource.gallery);
  }

  Future<void> _startRecording() async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      final extDir = await getExternalStorageDirectory();
      final String dirPath = '${extDir.path}/../../../../TokTok';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${DateTime.now().toString()}.mp4';

      try {
        await _controller.startVideoRecording(filePath);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    try {
      await _controller.stopVideoRecording();
    } catch (e) {
      print(e);
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
                  child: CreateOverlay(
                    toggleCamera: _toggleCamera,
                    pickFromGallery: _pickFromGallery,
                    startRecording: _startRecording,
                    stopRecording: _stopRecording,
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
