import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/screens/Create/CreateOverlay.dart';
import 'package:video_player/video_player.dart';

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

  ImagePicker _imagePicker;
  File _tempVideoFile;
  bool _isRecorded = false;

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
    PickedFile _video =
        await _imagePicker.getVideo(source: ImageSource.gallery);
    _tempVideoFile = File(_video.path);
    setState(() {
      _isRecorded = true;
    });
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecorded = false;
    });
    if (!_controller.value.isInitialized) {
      return null;
    }
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      final extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}';
      await Directory(dirPath).create(recursive: true);
      String tempVideoPath = '$dirPath/${DateTime.now().toString()}.mp4';
      _tempVideoFile = File(tempVideoPath);
      try {
        await _controller.startVideoRecording(tempVideoPath);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    setState(() {
      _isRecorded = true;
    });
    try {
      await _controller.stopVideoRecording();
    } catch (e) {
      print(e);
    }
  }

  void _clearRecordedVideo() {
    setState(() {
      _isRecorded = false;
    });
    _tempVideoFile.deleteSync(recursive: true);
  }

  void _saveRecordedVideo() async {
    setState(() {
      _isRecorded = false;
    });
    _tempVideoFile.copySync(await _getSaveFilePath());
  }

  Future<String> _getSaveFilePath() async {
    final extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}/../../../../TokTok';
    await Directory(dirPath).create(recursive: true);
    return '$dirPath/${DateTime.now().toString()}.mp4';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            child: Stack(
              children: [
                _isRecorded
                    ? VideoPreview(previewFile: _tempVideoFile)
                    : Camera(
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
                    clearRecording: _clearRecordedVideo,
                    saveRecording: _saveRecordedVideo,
                    isRecorded: _isRecorded,
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

class VideoPreview extends StatefulWidget {
  VideoPreview({this.previewFile});

  final File previewFile;

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  VideoPlayerController _controller;
  Future<void> _initializePlayerController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.previewFile);

    _initializePlayerController = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _controller.play();
          _controller.setLooping(true);
          return VideoPlayer(_controller);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      future: _initializePlayerController,
    );
  }
}
