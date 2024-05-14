// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_web_unity/flutter_web_unity_platform_interface.dart';

import 'package:web/web.dart' as web show window;

/// A web implementation of the FlutterWebUnityPlatform of the FlutterWebUnity plugin.
class FlutterWebUnityWeb extends FlutterWebUnityPlatform {
  /// Constructs a FlutterWebUnityWeb
  FlutterWebUnityWeb() {
    // ignore: undefined_prefixed_name
    // final webUrl = ui.webOnlyAssetManager.getAssetUrl(
    //   'packages/flutter_web_unity/assets/web/unity.html',
    // );
  }

  static void registerWith(Registrar registrar) {
    FlutterWebUnityPlatform.instance = FlutterWebUnityWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}
