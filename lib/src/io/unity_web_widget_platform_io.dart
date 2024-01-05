import 'package:flutter/material.dart';
import 'package:flutter_web_unity/src/unity_web_widget_controller.dart';

class UnityWebWidget extends StatefulWidget {
  const UnityWebWidget({
    super.key,
    required this.data,
    this.onWidgetCreate,
  });

  final Map<String, dynamic> data;
  final Function(UnityWebWidgetController controller)? onWidgetCreate;

  @override
  State<UnityWebWidget> createState() => _UnityWebWidgetState();
}

class _UnityWebWidgetState extends State<UnityWebWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Android / iOS not supported by the web unity plugin'),
    );
  }
}