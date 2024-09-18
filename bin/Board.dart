import 'Player.dart';

/// Represents a player in the game, identified by their stone type.
///
/// Each player in the game is associated with a specific type of stone,
/// which is used to mark their moves on the game board. This class
/// encapsulates the stone type and provides a simple interface for
/// representing and using player stones within the game.
/// 
/// Author: Andre Salamanca
class Board {
  /// Final size of the Board
  final int size;
  Player player;
  Player serverPlayer;
  Player empty = Player('.');
  Player highlight = Player('*');
  List<List<String>>? rows;
  bool gameOver = false;

  /// Constructs a [Board] with a given [size], [player], and [serverPlayer].
  Board(this.size, this.player, this.serverPlayer) {
    /// empty player will be used to represent empty stone => '.'
    Player empty = Player('.');

    gameOver=false;
    /// represent board by list of lists of size: (size * size), where each empty stone is represented with empty stone, '.'
    rows = List.generate(
        size,
        (index) => List<String>.generate(size, (index) => empty.toString(),
            growable: false),
        growable: false);
  }

  /// Places a stone for [player] at the specified [x] and [y] coordinates.
  void placeStone(Player player, int x, int y) {
    rows?[y - 1][x - 1] = player.toString();
  }
}
