import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_web_unity_method_channel.dart';

abstract class FlutterWebUnityPlatform extends PlatformInterface {
  /// Constructs a FlutterWebUnityPlatform.
  FlutterWebUnityPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWebUnityPlatform _instance = MethodChannelFlutterWebUnity();

  /// The default instance of [FlutterWebUnityPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWebUnity].
  static FlutterWebUnityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWebUnityPlatform] when
  /// they register themselves.
  static set instance(FlutterWebUnityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
