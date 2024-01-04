import 'package:flutter_web_unity/src/html_web_widget_platform_mobile.dart'
  if (dart.library.html) 'package:flutter_web_unity/src/html_web_widget_platform_web.dart' as platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HtmlWebWidget extends StatefulWidget {
  const HtmlWebWidget({
    super.key,
    required this.data,
    this.controller,
  });

  final Map<String, dynamic> data;
  final HtmlWebWidgetController? controller;

  @override
  State<HtmlWebWidget> createState() => _HtmlWebWidgetState();
}

class _HtmlWebWidgetState extends State<HtmlWebWidget> {

  late platform.HtmlWebWidgetPlatformCtrlImpl canvasController;

  @override
  void initState() {
    super.initState();

    canvasController = platform.HtmlWebWidgetPlatformCtrlImpl();
    widget.controller?._setState(this);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? platform.HtmlWebWidgetPlatform(
      data: widget.data,
      controller: canvasController,
    ) : Container();
  }

  void quit() {
    canvasController.quit();
  }
}

class HtmlWebWidgetController {
  late _HtmlWebWidgetState _state;
  void _setState(_HtmlWebWidgetState state) {
    _state = state;
  }

  Future<void> quit() async {
    _state.quit();
  }
}

abstract class HtmlWebWidgetPlatformCtrl {
  Future<void> quit();
}