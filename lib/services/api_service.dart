import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://guesswordar.runasp.net/api/games';

  static Future<Map<String, dynamic>> createGame() async {
    final res = await http.post(Uri.parse(baseUrl));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to create game: ${res.body}');
    }
  }

  static Future<Map<String, dynamic>> joinGame(
    String gameKey,
    String clientId,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/join'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'gameKey': gameKey, 'clientId': clientId}),
    );
    return jsonDecode(res.body);
  }

  static Future<void> submitSecret(
    String gameKey,
    String clientId,
    String secret,
  ) async {
    await http.post(
      Uri.parse('$baseUrl/secret'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'gameKey': gameKey,
        'clientId': clientId,
        'secret': secret,
      }),
    );
  }

  static Future<void> submitGuess(
    String gameKey,
    String clientId,
    String guess,
  ) async {
    await http.post(
      Uri.parse('$baseUrl/guess'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'gameKey': gameKey,
        'clientId': clientId,
        'guess': guess,
      }),
    );
  }
}
