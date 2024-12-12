import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

/// Some facilities to use ports
class PortFacilities {

  /// Obtain a [ReceivePort] with name [portName]
  /// Ensure the binding with [portName]
  /// Existing [port] and [subscriptionToClose] are closed
  /// After the call subscription must be set to null
  /// port = await _initializePort(port, portName, subscription);
  /// subscription = null;
  static Future<ReceivePort> initializePort(ReceivePort? port, String portName,
      StreamSubscription<dynamic>? subscriptionToClose) async {
    var newPort = ReceivePort();
    IsolateNameServer.removePortNameMapping(portName);
    if (IsolateNameServer.registerPortWithName(newPort.sendPort, portName)) {
      await subscriptionToClose?.cancel();
      port?.close();
      return newPort;
    } else {
      throw TypeError();
    }
  }

  /// Same as [initializePort], but simpler
  /// Use it for local defined ports
  /// which are closed on dispose just after susbscription cancel
  static bool reRegisterPortWithName(SendPort sendPort, String portName) {
    IsolateNameServer.removePortNameMapping(portName);
    return (IsolateNameServer.registerPortWithName(sendPort, portName));
  }
}