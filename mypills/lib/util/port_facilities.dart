import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

class PortFacilities {

  // Use it for local defined ports
  // which are closed on dispose just after susbscription cancel
  static bool reRegisterPortWithName(SendPort sendPort, String portName) {
    IsolateNameServer.removePortNameMapping(portName);
    return (IsolateNameServer.registerPortWithName(sendPort, portName));
  }

  // after the call subscription must be set to null
  // port = await _initializePort(port, portName, subscription);
  // subscription = null;
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
}