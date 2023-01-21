import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:nearby_connections/nearby_connections.dart';
import 'package:viral_gamification_app/providers/user_provider.dart';

import 'api/UserAPI.dart';

class Bluetooth {
  // Scale from 0 to 100, gets set by initial user setup
  static double infectionProb = 0;

  static void startAdvertising(Function setState) async {
    try {
      await Nearby().startAdvertising(
        "Advertiser",
        Strategy.P2P_POINT_TO_POINT,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          Nearby().acceptConnection(
              id,
              onPayLoadRecieved: (endpointId, payload) {
                if (payload.bytes != null && Random().nextInt(100) <= infectionProb) {
                  setState(UserState.infected);
                  UserAPI.setInfectionStatus(UserState.infected.index, DateTime.now().millisecondsSinceEpoch ~/ 1000);
                }
                Nearby().disconnectFromEndpoint(endpointId);
              },
              onPayloadTransferUpdate: (endpointId, payloadTransferUpdate) {}
          );
        },
        onConnectionResult: (String id, Status status) {},
        onDisconnected: (String id) {},
        serviceId: "com.teamexe.virality",
      );
    } catch (exception) {}
  }

  static void startDiscovering() async {
    try {
      await Nearby().startDiscovery(
        "Discoverer",
        Strategy.P2P_POINT_TO_POINT,
        onEndpointFound: (String id, String userName, String serviceId) {
          try {
            Nearby().requestConnection(
              userName,
              id,
              onConnectionInitiated: (id, info) {
                Nearby().acceptConnection(id, onPayLoadRecieved: (a, b) {});
              },
              onConnectionResult: (id, status) {
                if (status == Status.CONNECTED) {
                  Nearby().sendBytesPayload(id, Uint8List.fromList(utf8.encode("I'm infecting you")));
                }
              },
              onDisconnected: (id) {},
            );
          } catch(exception) {}
        },
        onEndpointLost: (String? id) {},
        serviceId: "com.teamexe.virality",
      );
    } catch (e) {}
  }

  static void stopAdvertising() {
    Nearby().stopAdvertising();
  }

  static void stopDiscovering() {
    Nearby().stopDiscovery();
  }
}