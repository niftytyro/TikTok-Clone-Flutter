import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/screens/Create/Camera.dart';
import 'package:tiktok_clone/screens/Create/CreateOverlay.dart';
import 'package:tiktok_clone/screens/Create/VideoPreview.dart';
import 'package:video_player/video_player.dart';

class Create extends StatefulWidget {
  static const pathName = '/create';
  final List<CameraDescription> cameras;

  Create({@required this.cameras});

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  CameraController _cameraController;
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeCameraControllerFuture;
  Future<void> _initializeVideoControllerFuture;
  ImagePicker _imagePicker;
  File _tempVideoFile;
  String _tempVideoPath;
  bool _isRecorded = false;

  @override
  void initState() {
    super.initState();
    requestPermission();
    _initCamera(widget.cameras.firstWhere((description) =>
        description.lensDirection == CameraLensDirection.back));
    _imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _disposeVideoPreviewController();
    super.dispose();
  }

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    return status.isGranted;
  }

  Future<void> _initCamera(CameraDescription description) async {
    _cameraController = CameraController(description, ResolutionPreset.high);
    _initializeCameraControllerFuture = _cameraController.initialize();
    setState(() {});
  }

  void _toggleCamera() {
    final lensDirection = _cameraController.description.lensDirection;
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
    setVideoPreviewController();
    setState(() {
      _isRecorded = true;
    });
  }

  Future<void> _startRecording() async {
    if (_isRecorded) {
      _clearRecordedVideo();
    }
    setState(() {
      _isRecorded = false;
    });
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    bool granted = await requestPermission();
    if (granted) {
      final extDir = await getExternalStorageDirectory();
      final String dirPath = '${extDir.path}';
      await Directory(dirPath).create(recursive: true);
      DateTime now = DateTime.now();
      String filename = now.day.toString() +
          '.' +
          now.hour.toString() +
          '.' +
          now.minute.toString() +
          '.' +
          now.second.toString();
      _tempVideoPath = '$dirPath/$filename.mp4';
      try {
        await _cameraController.startVideoRecording(_tempVideoPath);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      return null;
    }
    try {
      await _cameraController.stopVideoRecording();
      _tempVideoFile = File(_tempVideoPath);
    } catch (e) {
      print(e);
    }
    setVideoPreviewController();
    setState(() {
      _isRecorded = true;
    });
  }

  void _clearRecordedVideo() {
    setState(() {
      _isRecorded = false;
    });
    _tempVideoFile.deleteSync(recursive: true);
    _disposeVideoPreviewController();
  }

  void _saveRecordedVideo() async {
    setState(() {
      _isRecorded = false;
    });
    _tempVideoFile.copySync(await _getSaveFilePath());
    _clearRecordedVideo();
    _disposeVideoPreviewController();
  }

  void _disposeVideoPreviewController() {
    try {
      setState(() {
        _videoPlayerController.dispose();
        _videoPlayerController = null;
      });
    } catch (e) {
      print(e);
    }
  }

  void setVideoPreviewController() {
    setState(() {
      _videoPlayerController = VideoPlayerController.file(_tempVideoFile);
      _initializeVideoControllerFuture = _videoPlayerController.initialize();
    });
  }

  Future<String> _getSaveFilePath() async {
    final extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}/../../../../TokTok';
    await Directory(dirPath).create(recursive: true);
    DateTime now = DateTime.now();
    String filename = now.day.toString() +
        '.' +
        now.hour.toString() +
        '.' +
        now.minute.toString() +
        '.' +
        now.second.toString();
    return '$dirPath/$filename.mp4';
  }

  void _setTempVideoFile(File newFile) {
    if (newFile != null) {
      _clearRecordedVideo();
      setState(() {
        _tempVideoFile = newFile;
        _tempVideoPath = _tempVideoFile.path;
        _isRecorded = true;
      });
      setVideoPreviewController();
    }
  }

  void _pauseVideoPlayer() {
    try {
      _videoPlayerController.pause();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          print('_isRecorded');
          print(_isRecorded);
          return Container(
            child: Stack(
              children: [
                _isRecorded
                    ? VideoPreview(
                        controller: _videoPlayerController,
                        future: _initializeVideoControllerFuture,
                      )
                    : Camera(
                        controller: _cameraController,
                        future: _initializeCameraControllerFuture,
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
                    setTempVideoFile: _setTempVideoFile,
                    pauseVideoPlayer: _pauseVideoPlayer,
                    isRecorded: _isRecorded,
                    videoFile: _tempVideoFile,
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
