import 'package:http/http.dart' as http;
import 'dart:convert';

/// Response parser parses the JSON response from the game service
/// URL. 
/// 
/// Author: Andre Salamanca
class ResponseParser {
  /// The raw response from the server. 
  dynamic response;

  /// Extracted information from the response. 
  String? info;

  /// Constructs a `ResponseParser`.
  ResponseParser();

  /// Parses a given JSON [responseBody] and returns a map.
  Map<String, dynamic> parseInfo(String responseBody) {
    return json.decode(responseBody);
  }

}
