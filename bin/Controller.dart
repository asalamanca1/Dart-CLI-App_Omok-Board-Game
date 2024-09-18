import 'Board.dart';
import 'ConsoleUI.dart';
import 'Player.dart';
import 'WebClient.dart';
import 'dart:io';
import 'dart:convert';

/// Controller sets up the game, connects to the Omok game service, and
/// handles the turn-based game loop between a human player and the server (CPU).
/// It manages the game state, user input, and the server's responses.
/// Authors: Andre Salamanca, Fernando Muñoz
void main() async {
  /// Initialize the human and CPU players.
  Player player = Player('O');
  Player serverPlayer = Player('X');

  /// Creates new Board
  Board board = Board(15, player, serverPlayer);

  /// Set up the console user interface.
  ConsoleUI consoleUI = ConsoleUI(board);

  /// Prompt the user for the server URL and establish a connection.
  String serverUrl = await consoleUI.promptServer();
  WebClient webClient = WebClient(serverUrl);

  /// Create a new game board.
  List<int?> coordinates = [null, null];
  List<int?> cpu_stones = [null, null];

  /// set first turn to human player
  Player turn = player;
  String? server;
  var strat;
  var pid;

  /// function to switch turns
  void switchTurns() {
    if (turn.toString() == player) {
      turn = serverPlayer;
    } else {
      turn = player;
    }
  }

  /// Connect to the server and retrieve information such as game strategies.
  bool isConnected = false;
  while (!isConnected) {
    webClient = WebClient(serverUrl);
    try {
      var serverInfo = await webClient.getInfo();
      serverInfo.then(isConnected = true);
    } catch (e) {
      ///keep looping if server isnt valid
    }
  }

  /// Retrieve and validate the chosen game strategy.
  bool validStrategy = false;
  while (!validStrategy) {
    strat = consoleUI.promptStrategy(serverUrl);
    try {
      pid = await webClient.getNew(strat);
      pid.then(validStrategy = true);
    } catch (e) {
      /// keep looping if strategy isnt valid
    }
  }

  consoleUI.showBoard();

  /// Enter the main game loop.
  while (!board.gameOver) {
    try {
      List<int?> coordinates = consoleUI.promptMove();
      var stones = await webClient.getPlay(
          coordinates[0]! - 1, coordinates[1]! - 1, 'O', pid);
      var cpu_stones;
      var winningRow;
      
      /// Human Player won
      if (stones.length == 10) {
        consoleUI.highlightStones(stones);
        consoleUI.showBoard();
        consoleUI.showMessage('Congratulations you won!\nGame over.');
        board.gameOver = true;

      /// CPU Player Won
      } else if (stones.length == 3) {
        cpu_stones = stones[0];
        winningRow = stones[1];
        board.placeStone(serverPlayer, cpu_stones[0]!, cpu_stones[1]!);
        consoleUI.highlightStones(winningRow);
        consoleUI.showBoard();
        consoleUI.showMessage('You lost!\nGame over.');
        board.gameOver = true;

      /// Draw
      } else if (stones.length == 1) {
        consoleUI.showMessage('Draw!'); 
        consoleUI.showBoard(); 
      
      /// No win or draw detected, game continues
      } else {
        board.placeStone(board.highlight, stones[0]!, stones[1]!);
        consoleUI.showBoard();
        board.placeStone(board.empty, stones[0]!, stones[1]!);
        board.placeStone(serverPlayer, stones[0]!, stones[1]!);
      }
    } catch (e) {
      consoleUI.displayError(e);
    }
  }
}
