import 'package:flutter_web_unity/src/canvas_platform_mobile.dart'
  if (dart.library.html) 'package:flutter_web_unity/src/canvas_platform_web.dart' as platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CanvasWeb extends StatefulWidget {
  const CanvasWeb({
    super.key,
    this.controller,
  });

  final CanvasWebController? controller;

  @override
  State<CanvasWeb> createState() => _CanvasWebState();
}

class _CanvasWebState extends State<CanvasWeb> {

  late platform.CanvasPlatformCtrlImpl canvasController;

  @override
  void initState() {
    super.initState();

    canvasController = platform.CanvasPlatformCtrlImpl();
    widget.controller?._setState(this);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? platform.CanvasPlatform(
      controller: canvasController,
    ) : Container();
  }

  void quit() {
    canvasController.quit();
  }
}

class CanvasWebController {
  late _CanvasWebState _state;
  void _setState(_CanvasWebState state) {
    _state = state;
  }

  Future<void> quit() async {
    _state.quit();
  }
}

abstract class CanvasPlatformCtrl {
  Future<void> quit();
}