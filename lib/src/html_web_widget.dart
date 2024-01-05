import 'package:flutter_web_unity/src/html_web_widget_controller.dart';
import 'package:flutter/material.dart';

class HtmlWebWidget extends StatefulWidget {
  const HtmlWebWidget({
    super.key,
    required this.data,
    this.onWidgetCreate,
    this.useCanvas = false,
  });

  final Map<String, dynamic> data;
  final Function(HtmlWebWidgetController controller)? onWidgetCreate;
  final bool? useCanvas;

  @override
  State<HtmlWebWidget> createState() => _HtmlWebWidgetState();
}

class _HtmlWebWidgetState extends State<HtmlWebWidget> {

  late HtmlWebWidgetController controller;

  @override
  void initState() {
    super.initState();
    widget.onWidgetCreate?.call(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}