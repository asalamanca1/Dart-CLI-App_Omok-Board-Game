import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'ResponseParser.dart';
import 'dart:io';

///
/// WebClient provides methods to interact with the game's backend web service.
/// It supports fetching game information, starting new games, and making moves within a game.
///
/// Authors: Andre Salamanca, Fernando Muñoz
class WebClient {
  /// The base URL of the game's web service.
  String baseUrl;

  /// An instance of [ResponseParser] to handle parsing of responses from the web service.
  ResponseParser responseParser = new ResponseParser();

  /// Constructs a [WebClient] with the given [baseUrl].
  WebClient(this.baseUrl);

  /// Fetches game information from the web service.
  ///
  /// Sends a GET request to the `${baseUrl}/info` endpoint and parses the response.
  ///
  /// Returns:
  /// A dynamic object containing the parsed game information.
  ///
  /// Throws:
  /// An [Exception] if the request fails or the response cannot be parsed.
  Future<dynamic> getInfo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/info'));
      _checkAndThrowIfNotSuccessful(response);
      return responseParser.parseInfo(response.body);
    } catch (e) {
      throw Exception('Failed to get info: $e');
    }
  }

  /// Starts a new game with the specified strategy.
  ///
  /// Parameters:
  /// - [strategy]: The game strategy to use. `1` for smart strategy, `2` for random.
  ///
  /// Returns:
  /// The game session ID (`pid`) as a [String].
  ///
  /// Throws:
  /// An [Exception] if the request fails.
  Future<dynamic> getNew(int strategy) async {
    /// smart strategy
    if (strategy == 1) {
      var newGameSmart = "new/index.php?strategy=Smart";
      var uri = Uri.parse(baseUrl + newGameSmart);
      var response = await http.get(uri);
      var info = json.decode(response.body);

      var pid = info['pid'];
     
      return /// random strategy
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

  /// Sends a move to the web service and gets the game's current state.
  ///
  /// Parameters:
  /// - [x]: The x-coordinate of the move.
  /// - [y]: The y-coordinate of the move.
  /// - [playerSymbol]: The symbol of the player making the move.
  /// - [pid]: The game session ID.
  ///
  /// Returns:
  /// A dynamic object containing the response from the web service, which may include
  /// the current game state, any winning conditions, and the next move if applicable.
  ///
  /// Throws:
  /// An [Exception] if the request fails or the response cannot be parsed.
  Future<dynamic> getPlay(int x, int y, String playerSymbol, String pid) async {
    try {
      var move = "play/?pid=$pid&x=$x&y=$y";
      var uri = Uri.parse(baseUrl + move);
      var response = await http.get(uri);
      /// This should be before trying to parse the body
      _checkAndThrowIfNotSuccessful(
          response); 
      var info = json.decode(response.body);

      
      if (info != null) {
        /// if we dont have a 'move', it means the human player won
        if (!info.containsKey('move')) {
          /// human player won
          var ack_move = info['ack_move'];
          var x = ack_move['x'];
          var y = ack_move['y'];
          var winningRow = ack_move['row'];
          /// return list length of 10
          return winningRow;
        }
        var cpu_move = info['move'];
        /// cpu player won
        /// if row is not empty, return winning row and cpu stones, length of 3
        if (!cpu_move['row'].isEmpty) {
          /// cpu player won
          var cpu_x = cpu_move['x'];
          var cpu_y = cpu_move['y'];
          List<int?> cpu_stones = [cpu_x + 1, cpu_y + 1];
          var winningRow = cpu_move['row'];
          List<dynamic> stones = [cpu_stones, winningRow, true];
          return stones;
        }
        if (cpu_move['isDraw'] == true) {
          List<dynamic> stones = [true]; // Tie
          return stones; 
        } else {
          /// else row is empty, return cpu stones, length of 2
          /// if we have both, it means no one has won yet
          var cpu_x = cpu_move['x'];
          var cpu_y = cpu_move['y'];
          List<int?> cpu_stones = [cpu_x + 1, cpu_y + 1];
          return cpu_stones;
        }
      }
    } catch (e) {
      throw Exception('Failed to make a play: $e');
    }
  }

  /// Checks if the HTTP response was successful and throws an exception if not.
  void _checkAndThrowIfNotSuccessful(http.Response response) {
    if (response.statusCode != 200) {
      throw http.ClientException(
          'Non-successful response: ${response.statusCode}',
          response.request?.url);
    }
  }
}
