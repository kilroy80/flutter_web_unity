abstract class UnityWebWidgetController {

  Future<void> postMessage(String gameObject, methodName, message) {
    throw UnimplementedError('postMessage() has not been implemented.');
  }

  Future<void> postJsonMessage(
      String gameObject, String methodName, Map<String, dynamic> message) {
    throw UnimplementedError('postJsonMessage() has not been implemented.');
  }

  Future<void> quit();

  void dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}