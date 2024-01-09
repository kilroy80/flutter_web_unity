import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_interop';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_web_unity/src/unity_web_widget_controller.dart';
import 'package:flutter_web_unity/src/web/unity_web_widget_controller_web_impl.dart';

@JS('createUnityNative')
external void createUnityNative(String name);

@JS('deleteUnityNative')
external void deleteUnityNative();

typedef WebUnityWidgetState = _UnityWebWidgetState;

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

  late UnityWebWidgetController controller;

  @override
  void initState() {
    super.initState();

    final encodeData = base64.encode(utf8.encode(jsonEncode(widget.data)));

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('html-element', (viewId) {

      if (widget.useCanvas == true) {
        return html.CanvasElement()
          ..id = 'unity-canvas';
        // ..style.border = 'none';
        // ..style.width = '100%'
        // ..style.height = '100%';
      } else {
        // debugPrint('${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}');
        return html.IFrameElement()
          // ..id = 'unity-iframe'
          ..src = '${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}/assets/packages/flutter_web_unity/assets/unity/index.html?data=$encodeData'
          ..style.border = 'none';
      }
    });

    initController();

    if (widget.useCanvas == true) {
      create();
    }
  }

  Future<void> initController() async {
    controller = await UnityWebWidgetControllerWebImpl.init(0, this);
    widget.onWidgetCreate?.call(controller);
  }

  Future<void> create() async {
    if (!mounted) return;
    await Future.delayed(Duration.zero);
    createUnityNative('unity-canvas');
  }

  @override
  void dispose() {
    // quitUnity();
    super.dispose();
  }

  Future<void> quitUnity() async {
    if (!mounted) return;

    if (widget.useCanvas == true) {
      try {
        deleteUnityNative();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Stack(
        children: [
          HtmlElementView(viewType: 'html-element'),
        ],
      ),
    );
  }
}