import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_web_unity_platform_interface.dart';

/// An implementation of [FlutterWebUnityPlatform] that uses method channels.
class MethodChannelFlutterWebUnity extends FlutterWebUnityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_web_unity');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
