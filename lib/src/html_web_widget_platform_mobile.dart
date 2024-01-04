import 'package:flutter/material.dart';
import 'package:flutter_web_unity/src/html_web_widget.dart';

class HtmlWebWidgetPlatform extends StatefulWidget {
  const HtmlWebWidgetPlatform({
    super.key,
    required this.data,
    this.controller,
  });

  final Map<String, dynamic> data;
  final HtmlWebWidgetPlatformCtrlImpl? controller;

  @override
  State<HtmlWebWidgetPlatform> createState() => _HtmlWebWidgetPlatformState();
}

class _HtmlWebWidgetPlatformState extends State<HtmlWebWidgetPlatform> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HtmlWebWidgetPlatformCtrlImpl implements HtmlWebWidgetPlatformCtrl {
  @override
  Future<void> quit() async {
  }
}