import 'package:get/get.dart';
import 'package:signalr_core/signalr_core.dart';

class XHubServices extends GetxService {
  XHubServices(this.userId) {
    // baseUrl = 'http://guesswordar.runasp.net/hubs/game?userId="$userId"';
    baseUrl = 'http://192.168.4.97:8080/hubs/game?userId="$userId"';
    connection = HubConnectionBuilder()
        .withUrl(baseUrl)
        .withAutomaticReconnect()
        .build();
  }

  final String userId;
  late String baseUrl;
  late HubConnection connection;

  Future<void> start() async {
    if (connection.state == HubConnectionState.disconnected) {
      await connection.start();
    }
  }

  @override
  void onInit() {
    // start();
    super.onInit();
  }
}
