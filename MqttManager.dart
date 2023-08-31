import 'dart:math';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttManager {
  MqttServerClient client = MqttServerClient.withPort(
    'mqtt-broker',
    Random().nextInt(100).toString(),
    1889,
  );

  void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  void onDisconnected() {
    print('MQTT_LOGS:: Disconnected');
    connect();
  }

  void onSubscribed(String topic) {
    print('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('MQTT_LOGS:: Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTT_LOGS:: Ping response client callback invoked');
  }

  Future<MqttServerClient> connect() async {
    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    //client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 60;
    final connMessage = MqttConnectMessage()
        .withWillTopic('willTopic')
        .withWillMessage('willMessage')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('MQTT_LOGS:: Client connecting....');

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      //print('Exception: $e');
      client.disconnect();
    }

    return client;
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
}
