import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'ResponseParser.dart';
import 'dart:io';
import 'Board.dart';

// DART NOTES: as to type cast is: true if the object has the specified type;
// similar to instanceof of Java is!: False if the object has the specified type
// Use ?: to assign a value based on a Boolean expression Consider using ?? if
// the Boolean expression tests for null cascade notation: Allows to make a
// sequence of operations on the same object. Conditional spread(?...): spread
// only if the collection is not null. addressLetter(name,  {street, number,
// city = 'El Paso', state = 'TX', zip})  ==>named parameters inside {}
// addressLetter('CS', street: 'West University Ave.', number: 500, city: 'El
// Paso', state: 'TX', zip: '79968’); a closure is a function object that has
// access to variables in its lexical scope, even when the function is used
// outside of its original scope. Higher-order functions: functions that take
// functions as arguments, return a function as the result, or do both. Call
// synchronously with the await keyword Call asynchronously with 'then' and
// later consume the Future object. Isolate: worker process (similar to thread)
// but does not share memory with the process that spawned it -- it is isolated
// and has its own memory heap. Generators are functions that are used to
// generate values in a collection in a lazy fashion. AKA CONSTRUCTORS FOR
// ATTRIBUTES, Synchronous: syntactic sugar for producing iterables AKA lists,
// sets asynchronous generators: Return a Stream (from dart:async) providing a
// sequence of events, either data or error events This class is meant to
// connect to the different url servers: /info, /new, and /play
class WebClient {
  String baseUrl;
  // List <int?> cpu_stones = [null, null];

  ResponseParser responseParser = new ResponseParser();

  WebClient(this.baseUrl);

  Future<dynamic> getInfo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/info'));
      _checkAndThrowIfNotSuccessful(response);
      return responseParser.parseInfo(response.body);
    } catch (e) {
      throw Exception('Failed to get info: $e');
    }
  }

  Future<dynamic> getNew(int strategy) async {
    //smart strategy
    if (strategy == 1) {
      var newGameSmart = "new/index.php?strategy=Smart";
      var uri = Uri.parse(baseUrl + newGameSmart);
      var response = await http.get(uri);
      var info = json.decode(response.body);

      var pid = info['pid'];
      stdout.write("PID: " + pid + "\n");
      return //random strategy
          pid;
    } else {
      var newGameRandom = "new/index.php?strategy=Random";
      var uri = Uri.parse(baseUrl + newGameRandom);
      var response = await http.get(uri);
      var info = json.decode(response.body);
      var pid = info['pid'];
      return pid;
    }
  }

  Future<dynamic> getPlay(int x, int y, String playerSymbol, String pid) async {
    try {
      var move = "play/?pid=$pid&x=$x&y=$y";
      var uri = Uri.parse(baseUrl + move);
      var response = await http.get(uri);
      _checkAndThrowIfNotSuccessful(
          response); // This should be before trying to parse the body
      var info = json.decode(response.body);
      if (info != null && info.containsKey('move')) {
        // Check if 'move' key exists
        var cpu_move = info['move'];
        var cpu_x = cpu_move['x'];
        var cpu_y = cpu_move['y'];
        List<int?> cpu_stones = [cpu_x, cpu_y];
        return cpu_stones; // Correctly return the list of integers
      } else {
        throw Exception('Move data not found in response');
      }
    } catch (e) {
      throw Exception('Failed to make a play: $e');
    }
  }

  // void set_CPU_Stones(int x, int y) {   cpu_stones[0] = x;   cpu_stones[1] = y;
  // }    List <int?> get_CPU_Stones() {     return cpu_stones;    }

  void _checkAndThrowIfNotSuccessful(http.Response response) {
    if (response.statusCode != 200) {
      throw http.ClientException(
          'Non-successful response: ${response.statusCode}',
          response.request?.url);
    }
  }
}
