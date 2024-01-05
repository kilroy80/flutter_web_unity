library flutter_web_unity;

export 'package:flutter_web_unity/src/unity_web_widget.dart'
  if (dart.library.io) 'package:flutter_web_unity/src/io/unity_web_widget_platform_io.dart'
  if (dart.library.html) 'package:flutter_web_unity/src/web/unity_web_widget_platform_web.dart';
export 'package:flutter_web_unity/src/unity_web_widget_controller.dart';

export 'package:flutter_web_unity/flutter_web_unity.dart';
export 'package:flutter_web_unity/flutter_web_unity_native.dart';
export 'package:flutter_web_unity/flutter_web_unity_method_channel.dart';
export 'package:flutter_web_unity/flutter_web_unity_platform_interface.dart';