import 'Player.dart';

class Board {
  final int size;
  Player player;
  Player serverPlayer;
  Player? empty;
  List<List<String>>? rows;
  bool gameOver = false;

  Board(this.size, this.player, this.serverPlayer) {
    //empty player will be used to represent empty stone => '.'
    Player empty = Player('.');

    //represent board by list of lists of size: (size * size), where each empty stone is represented with empty stone, '.'
    rows = List.generate(
        size,
        (index) => List<String>.generate(size, (index) => empty.toString(),
            growable: false),
        growable: false);
  }

  void placeStone(Player player, int x, int y) {
    rows?[y - 1][x - 1] = player.toString();
  }
}
