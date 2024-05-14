import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_web_unity/src/help/events.dart';
import 'package:flutter_web_unity/src/help/misc.dart';
import 'package:flutter_web_unity/src/help/types.dart';
import 'package:flutter_web_unity/src/unity_web_widget_controller.dart';
import 'package:flutter_web_unity/src/web/unity_web_widget_platform_web.dart';
import 'package:stream_transform/stream_transform.dart';

import 'dart:html' as html;
import 'package:web/web.dart' as web;

class UnityWebEvent {
  UnityWebEvent({
    required this.name,
    this.data,
  });
  final String name;
  final dynamic data;
}

class UnityWebWidgetControllerWebImpl implements UnityWebWidgetController {

  final WebUnityWidgetState _unityWidgetState;

  static Registrar? webRegistrar;

  late web.MessageEvent _unityFlutterBiding;
  late web.MessageEvent _unityFlutterBidingFn;

  bool unityReady = false;
  bool unityPause = true;

  MethodChannel? _channel;

  /// used for cancel the subscription
  StreamSubscription? _onUnityMessageSub;
  StreamSubscription? _onUnitySceneLoadedSub;
  StreamSubscription? _onUnityUnloadedSub;

  // The controller we need to broadcast the different events coming
  // from handleMethodCall.
  //
  // It is a `broadcast` because multiple controllers will connect to
  // different stream views of this Controller.
  final StreamController<UnityEvent> _unityStreamController =
    StreamController<UnityEvent>.broadcast();

  // Returns a filtered view of the events in the _controller, by unityId.
  Stream<UnityEvent> get _events => _unityStreamController.stream;

  UnityWebWidgetControllerWebImpl._(this._unityWidgetState) {
    _channel = ensureChannelInitialized();
    _connectStreams();
    _registerEvents();
  }

  /// Accesses the MethodChannel associated to the passed unityId.
  MethodChannel get channel {
    MethodChannel? channel = _channel;
    if (channel == null) {
      throw UnknownUnityIDError(0);
    }
    return channel;
  }

  // /// Initialize [UnityWidgetController] with [id]
  // /// Mainly for internal use when instantiating a [UnityWidgetController] passed
  // /// in [UnityWidget.onUnityCreated] callback.
  static Future<UnityWebWidgetControllerWebImpl> init(
      int id, WebUnityWidgetState unityWidgetState) async {
    return UnityWebWidgetControllerWebImpl._(
      unityWidgetState,
    );
  }

  /// Method required for web initialization
  static void registerWith(Registrar registrar) {
    webRegistrar = registrar;
  }

  MethodChannel ensureChannelInitialized() {
    MethodChannel? channel = _channel;
    if (channel == null) {
      channel = MethodChannel(
        'kinosoft_flutter_web_unity/unity_view',
        const StandardMethodCodec(),
        webRegistrar,
      );

      channel.setMethodCallHandler(_handleMessages);
      _channel = channel;
    }
    return channel;
  }

  _registerEvents() {
    if (kIsWeb) {

      web.window.addEventListener('message', (event) {
        final raw = (event as web.MessageEvent).data.toString();
        // ignore: unnecessary_null_comparison
        if (raw == '' || raw == null) return;
        if (raw == 'unityReady') {
          unityReady = true;
          unityPause = false;

          _unityStreamController.add(UnityCreatedEvent(0, {}));
          return;
        }

        _processEvents(UnityWebEvent(
          // name: event.data['name'],
          // data: event.data['data'],
          name: event.type,
          data: event.data,
        ));
      } as web.EventListener?);
    }
  }

  void _connectStreams() {
    if (_unityWidgetState.widget.onUnityMessage != null) {
      _onUnityMessageSub = _events.whereType<UnityMessageEvent>().listen(
              (UnityMessageEvent e) =>
              _unityWidgetState.widget.onUnityMessage?.call(e.value));
    }

    if (_unityWidgetState.widget.onUnitySceneLoaded != null) {
      _onUnitySceneLoadedSub = _events
          .whereType<UnitySceneLoadedEvent>()
          .listen((UnitySceneLoadedEvent e) =>
          _unityWidgetState.widget.onUnitySceneLoaded?.call(e.value.toString()));
    }

    // if (_unityWidgetState.widget.onUnityUnloaded != null) {
    //   _onUnityUnloadedSub = _events
    //       .whereType<UnityLoadedEvent>()
    //       .listen((_) => _unityWidgetState.widget.onUnityUnloaded!());
    // }
  }

  void _processEvents(UnityWebEvent e) {
    switch (e.name) {
      case 'onUnityMessage':
        _unityStreamController.add(UnityMessageEvent(0, e.data));
        break;
      case 'onUnitySceneLoaded':
        _unityStreamController
            .add(UnitySceneLoadedEvent(0, SceneLoaded.fromMap(e.data)));
        break;
    }
  }

  Future<dynamic> _handleMessages(MethodCall call) {
    switch (call.method) {
      case "unity#waitForUnity":
        return Future.value(null);
      case "unity#dispose":
        dispose();
        return Future.value(null);
      case "unity#postMessage":
        messageUnity(
          gameObject: call.arguments['gameObject'],
          methodName: call.arguments['methodName'],
          message: call.arguments['message'],
        );
        return Future.value(null);
      case "unity#resumePlayer":
        callUnityFn(fnName: 'resume');
        return Future.value(null);
      case "unity#pausePlayer":
        callUnityFn(fnName: 'pause');
        return Future.value(null);
      case "unity#unloadPlayer":
        callUnityFn(fnName: 'unload');
        return Future.value(null);
      case "unity#quitPlayer":
        callUnityFn(fnName: 'quit');
        return Future.value(null);
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
  }

  void callUnityFn({required String fnName}) {
    if (kIsWeb) {
      // _unityFlutterBidingFn = html.MessageEvent(
      //   'unityFlutterBidingFnCal',
      //   data: fnName,
      // );
      _unityFlutterBidingFn = web.MessageEvent(
        'unityFlutterBidingFnCal',
          web.MessageEventInit(
            data: fnName.toJS,
          ),
      );
      web.window.dispatchEvent(_unityFlutterBidingFn);
    }
  }

  void messageUnity({
    required String gameObject,
    required String methodName,
    required String message,
  }) {
    if (kIsWeb) {
      _unityFlutterBiding = web.MessageEvent(
        'unityFlutterBiding',
        // data: json.encode({
        //   'gameObject': gameObject,
        //   'methodName': methodName,
        //   'message': message,
        // }),
        web.MessageEventInit(
          data: json.encode({
            'gameObject': gameObject,
            'methodName': methodName,
            'message': message,
          }).toJS
        ),
      );
      web.window.dispatchEvent(_unityFlutterBiding);
      postProcess();
    }
  }

  /// This method makes sure Unity has been refreshed and is ready to receive further messages.
  void postProcess() {
    web.Element? frame = web.document
        .querySelector('flt-platform-view')
        ?.querySelector('iframe');

    if (frame != null) {
      (frame as web.HTMLIFrameElement).focus();
    }
  }

  @override
  Future<void> postMessage(String gameObject, methodName, message) async {
    messageUnity(
      gameObject: gameObject,
      methodName: methodName,
      message: message,
    );
  }

  @override
  Future<void> postJsonMessage(
      String gameObject, String methodName, Map<String, dynamic> message) async {
    messageUnity(
      gameObject: gameObject,
      methodName: methodName,
      message: json.encode(message),
    );
  }

  @override
  Future<void> quit() async {
  }

  /// cancel the subscriptions when dispose called
  void _cancelSubscriptions() {
    _onUnityMessageSub?.cancel();
    _onUnitySceneLoadedSub?.cancel();
    _onUnityUnloadedSub?.cancel();

    _onUnityMessageSub = null;
    _onUnitySceneLoadedSub = null;
    _onUnityUnloadedSub = null;
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    if (kIsWeb) {
      web.window.removeEventListener('message', (_) {} as web.EventListener?);
      web.window.removeEventListener('unityFlutterBiding', (event) {} as web.EventListener?);
      web.window.removeEventListener('unityFlutterBidingFnCal', (event) {} as web.EventListener?);
    }
  }
}