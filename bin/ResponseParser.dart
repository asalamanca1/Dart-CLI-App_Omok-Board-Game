import 'package:http/http.dart' as http;
import 'dart:convert';

//This class is meant to parse json response objects from server urls into strings

class ResponseParser {
  dynamic response;
  String? info;

  ResponseParser();

  // String parseInfo(dynamic response){
  //   return json.decode(response.body);
  // }

  Map<String, dynamic> parseInfo(String responseBody) {
    return json.decode(responseBody);
  }

  String parseNew() {
    // TODO: implement parseNew
    return '';
  }

  String parsePlay() {
    // TODO: implement parsePlay
    return '';
  }
}
