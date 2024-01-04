import 'flutter_web_unity_platform_interface.dart';

class FlutterWebUnity {
  Future<String?> getPlatformVersion() {
    return FlutterWebUnityPlatform.instance.getPlatformVersion();
  }
}
