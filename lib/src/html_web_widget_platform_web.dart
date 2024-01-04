import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';

import 'dart:ui_web' as ui;
import 'dart:html' as html;

import 'package:flutter_web_unity/src/html_web_widget.dart';

@JS('createUnityNative')
external void createUnityNative(String name);

@JS('deleteUnityNative')
external void deleteUnityNative();

class HtmlWebWidgetPlatform extends StatefulWidget {
  const HtmlWebWidgetPlatform({
    super.key,
    required this.data,
    this.controller,
    this.useCanvas = false,
  });

  final Map<String, dynamic> data;
  final HtmlWebWidgetPlatformCtrlImpl? controller;
  final bool? useCanvas;

  @override
  State<HtmlWebWidgetPlatform> createState() => _HtmlWebWidgetPlatformState();
}

class _HtmlWebWidgetPlatformState extends State<HtmlWebWidgetPlatform> {

  @override
  void initState() {
    super.initState();

    final sendData = base64.encode(utf8.encode(jsonEncode(widget.data)));

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('html-element', (viewId) {

      if (widget.useCanvas == true) {
        return html.CanvasElement()
          ..id = 'unity-canvas';
        // ..style.border = 'none';
        // ..style.width = '100%'
        // ..style.height = '100%';
      } else {
        debugPrint('${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}');
        return html.IFrameElement()
          // ..id = 'unity-iframe'
          // ..src = 'http://localhost:${Uri.base.port}/unity/index.html'
          ..src = '${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}/assets/packages/flutter_web_unity/assets/unity/index.html?data=$sendData'
          ..style.border = 'none';
      }

      // c.context2D.fillStyle = "blue";
      // c.context2D.fillRect(0, 0, c.width ?? 0, c.height ?? 0);

      // final shader = gl.createShader(html.RenderingContext.VERTEX_SHADER);
      // more gl code here

      // return c;
    });

    if (widget.useCanvas == true) {
      create();
    }
    widget.controller?._setState(this);
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
    // await Future.delayed(const Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56.0,
      child: const Stack(
        children: [
          HtmlElementView(viewType: 'html-element'),
        ],
      ),
    );
  }
}

class HtmlWebWidgetPlatformCtrlImpl implements HtmlWebWidgetPlatformCtrl {
  late _HtmlWebWidgetPlatformState _state;
  void _setState(_HtmlWebWidgetPlatformState state) {
    _state = state;
  }

  @override
  Future<void> quit() async {
    _state.quitUnity();
  }
}