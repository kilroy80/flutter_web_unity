import 'package:flutter/material.dart';
import 'package:flutter_web_unity/src/canvas_web.dart';

class CanvasPlatform extends StatefulWidget {
  const CanvasPlatform({
    super.key,
    this.controller,
  });

  final CanvasPlatformCtrlImpl? controller;

  @override
  State<CanvasPlatform> createState() => _CanvasPlatformState();
}

class _CanvasPlatformState extends State<CanvasPlatform> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CanvasPlatformCtrlImpl implements CanvasPlatformCtrl {
  @override
  Future<void> quit() async {
  }
}