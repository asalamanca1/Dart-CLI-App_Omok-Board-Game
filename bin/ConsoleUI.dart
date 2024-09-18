import 'dart:io';
import 'Board.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Default URL for the Omok game service
const String defaultUrl = "https://www.cs.utep.edu/cheon/cs3360/project/omok/";

/// The ConsoleUI manages the user interface of the game
/// by handling the user input and displaying the game
/// state and messages.
/// 
/// Authors: Andre Salamanca, Fernando Muñoz
class ConsoleUI {
  /// A list to store the last move's coordinates.
  List<int?> coordinates = [null, null];

  /// The URL of the Omok game service.
  dynamic url;

  /// Flag to check if the input is valid.
  bool validInput = false;

  /// Flag to check if the selected strategy is 'smart'
  bool smartStrategy = false;

  /// Instance of board
  Board board;

  /// the x and y coordinates of the last move
  int x = 0;
  int y = 0;

  //constructor
  ConsoleUI(this.board) {}

  /// Displays a message with a parameter of any type, that param is then converted to string and printed
  void showMessage(var message) {
    stdout.write(message.toString());
  }

  /// Prompts the user to enter the server URL.
  ///
  /// Returns the entered URL or the [defaultUrl] if none is entered.
  String promptServer() {
    stdout.write('Enter the server URL [default: $defaultUrl ]: ');
    String? inputUrl = stdin.readLineSync();

    // If the user just presses Enter, use the default URL
    return inputUrl?.isEmpty ?? true ? defaultUrl : inputUrl!;
  }

  //function to prompt user for game strateg
  int promptStrategy(serverInfo) {
    
    validInput = false;
    while (!validInput) {
      showMessage('Select the server strategy: 1. Smart  2.Random\n');

      dynamic line = stdin.readLineSync();
      try {
        //parse game strategy selection into an integer, default to 1 if input is null
        int selection = int.parse(line ?? '1');
        if (selection == 1) {
          //set game strategy to smart
          smartStrategy = true;
          //set validInput to true to exit the loop
          setValidInput(true);
          return 1;
        } else if (selection == 2) {
          //set game strategy to random
          smartStrategy = false;
          //set validInput to true to exit the loop
          setValidInput(true);
          return 2;
        }
        //a different number besides 1 or 2 was inputted
        else {
          //keep looping until we get valid input
          showMessage("Invalid selection. Please enter '1' or '2'.\n");
          //stdout.write("Invalid selection. Please enter '1' or '2'.\n");
        }
      }
      //if any character was inputted that is not an integer, show error message and keep looping until we get valid input
      on FormatException {
        showMessage("Invalid input. Please enter '1' or '2'.\n");
      }
    }
    validInput = false;
    return 0;
  }

  /// Sets the [validInput] flag to [move].
  void setValidInput(bool move) {
    validInput = move;
  }

  /// Displays an error message to the console.
  void displayError(dynamic error) {
    print('Error: $error');
  }


  /// Prompts the user to select a game strategy.
  ///
  /// Uses the information from [serverInfo] to validate the choice.
  /// Returns `1` for the smart strategy, `2` for random, or `0` if the input is invalid.
  List<int?> promptMove() {
    validInput = false;
    //prompt user for move while input isnt valid
    while (!validInput) {
      showMessage(
          'Player: O, Server: X (and *)\nEnter x and y (1-15), e.g., 8 10\n');
      dynamic move = stdin.readLineSync();
      /// check that input is not null

      if (move != null) {
        ///turn input into a list by splitting it with ' '
        move = move.trim().split(' ');

        try {
          ///parse coordinates into integers
          x = int.parse(move[0]);
          y = int.parse(move[1]);
          x + 1;
          y + 1;
          ///check that coordinates are within range
          if (x > 0 && x < 16 && y > 0 && y < 16) {
            ///check that intersection is empty
            if (board.rows![y - 1][x - 1] == '.') {
              board.placeStone(board.player, x, y);
              ///spread parsed move onto coordinates attribute
              validInput = true;
              coordinates = [x, y];
              return coordinates;
            }
            ///if intersection is not empty, print error message
            else {
              showMessage("Not Empty!.\n");
            }
          }
          ///if coordinates are not within range, print error message
          else {
            showMessage("Invalid index!.\n");
          }
        }
        ///if any character was inputted that is not an integer, show error message and keep looping until we get valid input
        on FormatException {
          showMessage("Invalid input, you must input INTEGERS only.\n");
        }
      }
      ///if input is null, show error message
      else {
        showMessage('Invalid input! Please try again.\n');
      }
    }
    return coordinates;
  }

  /// Displays the current state of the game board to the console.
  void showBoard() {
    var indexes = List<int>.generate(board.size, (i) => (i + 1) % 10).join(' ');
    stdout.writeln('  x $indexes');
    stdout.writeln('y -------------------------------');
    int y = 1;
    for (var row in board.rows!) {
      var line = row.join(' ');
      stdout.writeln('${y % 10} | $line');
      y++;
    }
  }

  /// Highlights the stones in the winning row on the board.
  ///
  /// The [winningRow] parameter is expected to be a list of integer pairs
  /// representing the coordinates of the stones in the winning sequence.
  void highlightStones(var winningRow) {
    for (int i = 0; i < 10; i += 2) {
      board.placeStone(
          board.highlight, winningRow[i] + 1, winningRow[i + 1] + 1);
    }
  }

  void showDraw() {

  }
}
