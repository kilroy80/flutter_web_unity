import 'package:flutter/material.dart';
import 'package:flutter_web_unity/src/html_web_widget_controller.dart';

class HtmlWebWidget extends StatefulWidget {
  const HtmlWebWidget({
    super.key,
    required this.data,
    this.onWidgetCreate,
  });

  final Map<String, dynamic> data;
  final Function(HtmlWebWidgetController controller)? onWidgetCreate;

  @override
  State<HtmlWebWidget> createState() => _HtmlWebWidgetState();
}

class _HtmlWebWidgetState extends State<HtmlWebWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('not yet supported by the web unity plugin'),
    );
  }
}