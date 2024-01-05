import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_interop';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_web_unity/src/html_web_widget_controller.dart';
import 'package:flutter_web_unity/src/web/html_web_widget_controller_web_impl.dart';

@JS('createUnityNative')
external void createUnityNative(String name);

@JS('deleteUnityNative')
external void deleteUnityNative();

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

    controller = HtmlWebWidgetControllerWebImpl();
    widget.onWidgetCreate?.call(controller);

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
          // ..src = 'http://localhost:${Uri.base.port}/unity/index.html'
          ..src = '${Uri.base.scheme}://${Uri.base.host}:${Uri.base.port}/assets/packages/flutter_web_unity/assets/unity/index.html?data=$encodeData'
          ..style.border = 'none';
      }
    });

    if (widget.useCanvas == true) {
      create();
    }
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