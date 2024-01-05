import 'package:flutter_web_unity/src/unity_web_widget_controller.dart';
import 'package:flutter/material.dart';

class UnityWebWidget extends StatefulWidget {
  const UnityWebWidget({
    super.key,
    required this.data,
    this.onWidgetCreate,
    this.onUnityMessage,
    this.onUnitySceneLoaded,
    this.useCanvas = false,
  });

  final Map<String, dynamic> data;
  final Function(UnityWebWidgetController controller)? onWidgetCreate;
  final Function(String message)? onUnityMessage;
  final Function(String message)? onUnitySceneLoaded;
  final bool? useCanvas;

  @override
  State<UnityWebWidget> createState() => _UnityWebWidgetState();
}

class _UnityWebWidgetState extends State<UnityWebWidget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This Widget is Not Implemented. See Other file.'),
    );
  }
}