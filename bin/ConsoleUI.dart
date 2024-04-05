import 'dart:io';
import 'Board.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String defaultUrl = "https://www.cs.utep.edu/cheon/cs3360/project/omok/";

//DART NOTES:
//as to type cast
//is: true if the object has the specified type; similar to instanceof of Java
//is!: False if the object has the specified type
//Use ?: to assign a value based on a Boolean expression
//Consider using ?? if the Boolean expression tests for null
//cascade notation: Allows to make a sequence of operations on the same object.
//Conditional spread(?...): spread only if the collection is not null.

//addressLetter(name,  {street, number, city = 'El Paso', state = 'TX', zip})  ==>named parameters inside {}
//addressLetter('CS', street: 'West University Ave.', number: 500, city: 'El Paso', state: 'TX', zip: '79968’);

//a closure is a function object that has access to variables in its lexical scope, even when the function is used outside of its original scope.

//Higher-order functions: functions that take functions as arguments, return a function as the result, or do both.

//Call synchronously with the await keyword

//Call asynchronously with 'then' and later consume the Future object.

//Isolate: worker process (similar to thread) but does not share memory with the process that spawned it -- it is isolated and has its own memory heap.

//Generators are functions that are used to generate values in a collection in a lazy fashion. AKA CONSTRUCTORS FOR ATTRIBUTES, Synchronous: syntactic sugar for producing iterables AKA lists, sets

//asynchronous generators: Return a Stream (from dart:async) providing a sequence of events, either data or error events

class ConsoleUI {
  //attributes
  List<int?> coordinates = [null, null];
  dynamic url;
  bool validInput = false;
  bool smartStrategy = false;
  Board board;
  int x = 0;
  int y = 0;

  //constructor
  ConsoleUI(this.board) {}

  //function to show message with a parameter of any type, that param is then converted to string and printed
  void showMessage(var message) {
    stdout.write(message.toString());
  }

  //function to prompt user for server url
  // void promptServer(){
  //   //prompt user to input url
  //   showMessage('Enter the server URL [default: $defaultUrl ]\n');
  //   //stdout.write('Enter the server URL [default: $defaultUrl ]\n');

  //   //take input url as string
  //   // url = stdin.readLineSync();

  //   // //if input url is null, assign it to the default url
  //   // url = url ?? defaultUrl;
  // }

  // Function to prompt user for server URL and return it
  String promptServer() {
    stdout.write('Enter the server URL [default: $defaultUrl ]: ');
    String? inputUrl = stdin.readLineSync();

    // If the user just presses Enter, use the default URL
    return inputUrl?.isEmpty ?? true ? defaultUrl : inputUrl!;
  }

//function to prompt user for game strateg
  int promptStrategy(serverInfo) {
    stdout.write("84");
    validInput = false;
    while (!validInput) {
      showMessage('Select the server strategy: 1. Smart  2.Random\n');
      //stdout.write("Select the server strategy: 1. Smart  2.Random\n");

      dynamic line = stdin.readLineSync();
      try {
        //parse game strategy selection into an integer, default to 1 if input is null
        int selection = int.parse(line ?? '1');

        //selection = int.parse(selection.toString());

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

  void setValidInput(bool move) {
    validInput = move;
  }

  void displayError(dynamic error) {
    print('Error: $error');
  }

  List<int?> promptMove(var pid) {
    validInput = false;
    //prompt user for move while input isnt valid
    while (!validInput) {
      showMessage(
          'Player: O, Server: X (and *)\nEnter x and y (1-15), e.g., 8 10\n');
      dynamic move = stdin.readLineSync();
      //check that input is not null
      // List<String> moves = move!.split(RegExp(r'[,\s]+'));
      if (move != null) {
        //turn input into a list by splitting it with ' '
        move = move.trim().split(' ');

        try {
          //parse coordinates into integers
          x = int.parse(move[0]);
          y = int.parse(move[1]);
          //check that coordinates are within range
          if (x > 0 && x < 16 && y > 0 && y < 16) {
            //check that intersection is empty
            if (board.rows![y - 1][x - 1] == '.') {
              board.placeStone(board.player, x, y);
              //spread parsed move onto coordinates attribute

              validInput = true;
              coordinates = [x, y];
              return coordinates;
            }
            //if intersection is not empty, print error message
            else {
              showMessage("Not Empty!.\n");
            }
          }
          //if coordinates are not within range, print error message
          else {
            showMessage("Invalid index!.\n");
          }
        }
        //if any character was inputted that is not an integer, show error message and keep looping until we get valid input
        on FormatException {
          showMessage("Invalid input, you must input INTEGERS only.\n");
        }
      }
      //if input is null, show error message
      else {
        showMessage('Invalid input! Please try again.\n');
      }
    }
    return coordinates;
  }

  void showBoard() {
    var indexes = List<int>.generate(board.size, (i) => (i + 1) % 10).join(' ');
    stdout.writeln('  x $indexes');

    stdout.writeln('y -------------------------------');

    int y = 0;
    for (var row in board.rows!) {
      var line = row.join(' ');

      stdout.writeln('${y % 10} | $line');
      y++;
    }
  }

  //TODO implement
}
