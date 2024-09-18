/// Represents a player in the game, identified by their stone type.
///
/// Each player in the game is associated with a specific type of stone,
/// which is used to mark their moves on the game board. This class
/// encapsulates the stone type and provides a simple interface for
/// representing and using player stones within the game.
/// 
/// Author: Andre Salamanca
class Player {

  /// The type of stone used by the player, represented as a [String].
  final String stone;

  /// Constructs a [Player] with the specified [stone].
  Player(this.stone);

  /// Returns a string representation of the player's stone.
  ///
  /// This method overrides the [toString] method to return the [stone]
  /// property, allowing the player's stone type to be easily printed
  /// and displayed.
  @override
  String toString() => stone;
}
