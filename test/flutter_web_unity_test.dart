import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_unity/flutter_web_unity.dart';
import 'package:flutter_web_unity/flutter_web_unity_native.dart';
import 'package:flutter_web_unity/flutter_web_unity_platform_interface.dart';
import 'package:flutter_web_unity/flutter_web_unity_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterWebUnityPlatform
    with MockPlatformInterfaceMixin
    implements FlutterWebUnityPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterWebUnityPlatform initialPlatform = FlutterWebUnityPlatform.instance;

  test('$MethodChannelFlutterWebUnity is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterWebUnity>());
  });

  test('getPlatformVersion', () async {
    FlutterWebUnity flutterWebUnityPlugin = FlutterWebUnity();
    MockFlutterWebUnityPlatform fakePlatform = MockFlutterWebUnityPlatform();
    FlutterWebUnityPlatform.instance = fakePlatform;

    expect(await flutterWebUnityPlugin.getPlatformVersion(), '42');
  });
}
