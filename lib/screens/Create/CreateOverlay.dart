import 'package:flutter/material.dart';

class CreateOverlay extends StatefulWidget {
  final Function toggleCamera;
  final Function pickFromGallery;
  final Function startRecording;
  final Function stopRecording;
  final Function clearRecording;
  final Function saveRecording;
  final bool isRecorded;

  const CreateOverlay({
    this.toggleCamera,
    this.pickFromGallery,
    this.startRecording,
    this.stopRecording,
    this.clearRecording,
    this.saveRecording,
    this.isRecorded,
  });

  @override
  _CreateOverlayState createState() => _CreateOverlayState();
}

class _CreateOverlayState extends State<CreateOverlay> {
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _isRecording
            ? VideoLengthBar()
            : OverlayTop(toggleCamera: widget.toggleCamera),
        OverlayBottom(
          pickFromGallery: widget.pickFromGallery,
          startRecording: (PointerDownEvent downEvent) {
            setState(() {
              _isRecording = true;
            });
            widget.startRecording();
            Future.delayed(Duration(seconds: 15), () {
              setState(() {
                _isRecording = false;
              });
              widget.stopRecording();
            });
          },
          stopRecording: (PointerUpEvent upEvent) {
            setState(() {
              _isRecording = false;
            });
            widget.stopRecording();
          },
          clearRecorded: () {
            widget.clearRecording();
          },
          saveRecorded: () {
            widget.saveRecording();
          },
          isRecording: _isRecording,
          isRecorded: widget.isRecorded,
        ),
      ],
    );
  }
}

class VideoLengthBar extends StatefulWidget {
  @override
  _VideoLengthBarState createState() => _VideoLengthBarState();
}

class _VideoLengthBarState extends State<VideoLengthBar> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(5.0),
        ),
        width: MediaQuery.of(context).size.width,
        height: 8.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 0.0,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 15),
            builder: (context, value, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  color: Colors.blue[400],
                ),
              );
            },
          ),
        ),
      ),
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

class OverlayBottom extends StatefulWidget {
  const OverlayBottom({
    Key key,
    this.pickFromGallery,
    this.startRecording,
    this.stopRecording,
    this.clearRecorded,
    this.saveRecorded,
    this.isRecording,
    this.isRecorded,
  }) : super(key: key);

  final Function pickFromGallery;
  final Function startRecording;
  final Function stopRecording;
  final Function clearRecorded;
  final Function saveRecorded;
  final bool isRecording;
  final bool isRecorded;

  @override
  _OverlayBottomState createState() => _OverlayBottomState();
}

class _OverlayBottomState extends State<OverlayBottom> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Stack(
            children: [
              if (widget.isRecorded)
                Positioned.fill(
                  left: 20.0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: widget.clearRecorded,
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(Icons.backspace, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              Center(
                child: Listener(
                  onPointerDown: widget.startRecording,
                  onPointerUp: widget.stopRecording,
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 10.0,
                          color: widget.isRecording
                              ? Color(0xFFBB323B)
                              : Color(0xEE99323B)),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Opacity(
                      opacity: widget.isRecording ? 0.0 : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        padding: EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFBD3546),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                right: 20.0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: widget.isRecorded
                        ? widget.saveRecorded
                        : widget.pickFromGallery,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 40.0,
                          width: 40.0,
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: widget.isRecorded
                                ? Color(0xFFBD3546)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                                widget.isRecorded ? 50.0 : 2.0),
                          ),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: widget.isRecorded
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : Image.asset('assets/icons/gallery_icon.png'),
                          ),
                        ),
                        if (!widget.isRecorded)
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
