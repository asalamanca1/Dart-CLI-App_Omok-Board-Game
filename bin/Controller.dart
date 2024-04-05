// import 'dart:html';

import 'Board.dart';
import 'ConsoleUI.dart';
import 'Player.dart';
import 'WebClient.dart';
import 'dart:io';
import 'dart:convert';

// Base URL for the Omok game service
// https://www.cs.utep.edu/cheon/cs3360/project/omok

void main() async {
  Player player = Player('O');
  Player serverPlayer = Player('X');
  Board board = Board(15, player, serverPlayer);
  ConsoleUI consoleUI = ConsoleUI(board);
  String serverUrl = await consoleUI.promptServer();
  WebClient webClient = WebClient(serverUrl);

  List<int?> coordinates = [null, null];
  List<int?> cpu_stones = [null, null];

  //set first turn to human player
  Player turn = player;
  String? server;
  var strat;
  var pid;

  //function to switch turns
  void switchTurns() {
    if (turn.toString() == player) {
      turn = serverPlayer;
    } else {
      turn = player;
    }
  }

  //connect to server
  bool isConnected = false;
  while (!isConnected) {
    // serverUrl = consoleUI.promptServer();
    webClient = WebClient(serverUrl);
    try {
      var serverInfo = await webClient.getInfo();
      serverInfo.then(isConnected = true);
    } catch (e) {
      //keep looping if server isnt valid
    }
  }

  //select server
  //get strategy
  bool validStrategy = false;
  while (!validStrategy) {
    strat = consoleUI.promptStrategy(serverUrl);
    try {
      pid = await webClient.getNew(strat);
      pid.then(validStrategy = true);
    } catch (e) {
      // Exit if we can't get server info or set a strategy
    }
  }

  //  try {
  //   var serverInfo = await webClient.getInfo();
  //   stdout.write("Server info: ${serverInfo.toString()}\n");
  //   strat = await consoleUI.promptStrategy(serverInfo);
  //   stdout.write("Strat: ${strat.toString()}\n");
  //   pid = await webClient.getNew(strat);
  //   stdout.write("PID: ${pid.toString()}\n");
  // } catch (e) {
  //   consoleUI.displayError(e);
  //   return; // Exit if we can't get server info or set a strategy
  // }

  // consoleUI.promptStrategy();

  //show board


  while (!board.gameOver) {
    //human players turn
  
    //show board after human move
    consoleUI.showBoard();
    try {
      List<int?> coordinates = consoleUI.promptMove(pid);
      consoleUI.showBoard();
      var cpu_stones =
          await webClient.getPlay(coordinates[0]!, coordinates[1]!, 'O', pid);
      cpu_stones.then(board.placeStone(serverPlayer, cpu_stones[0]!, cpu_stones[1]!));
      cpu_stones.then(consoleUI.showBoard());
      stdout.write(
          "CPU STONES X: ${cpu_stones[0].toString()} Y: ${cpu_stones[1].toString()}\n");
          
    } catch (e) {
      consoleUI.displayError(e);
    }

    stdout.write("CPU STONES X: ${cpu_stones[0].toString()}");
    stdout.write(" Y: ${cpu_stones[1].toString()}\n");
    // board.placeStone(serverPlayer, cpu_stones[0]!, cpu_stones[1]!);
    switchTurns();
    //show board after computer move
    
  }

  board.placeStone(serverPlayer, 15, 15);
  consoleUI.showBoard();
}
