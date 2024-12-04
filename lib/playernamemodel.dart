import 'dart:collection';

class PlayerNamesModel {
  // List to store player names
  List<String> _playerNames = [];

  // Singleton instance
  static final PlayerNamesModel _instance = PlayerNamesModel._internal();

  factory PlayerNamesModel() {
    return _instance;
  }

  PlayerNamesModel._internal();

  // Getter to access player names
  List<String> get playerNames {
    print("Returning player names: $_playerNames"); // Debugging: check names when accessed
    return List.unmodifiable(_playerNames);
  }

  // Method to set player names, ensuring it is between 4 and 6
  bool setPlayerNames(List<String> names) {
    if (names.length >= 4 && names.length <= 6) {
      _playerNames = List.from(names); // Store a copy of the names list
      print("Player names set: $_playerNames"); // Debugging: print player names when set
      return true;
    }
    print("Failed to set player names. The list size is: ${names.length}"); // Debugging: failed case
    return false; // Return false if names count is not between 4 and 6
  }

  // Method to get a player's name by index (1-based)
  String? getPlayerName(int index) {
    if (index > 0 && index <= _playerNames.length) {
      return _playerNames[index - 1];
    }
    return null; // Return null if index is out of range
  }

  // Method to reset the player names list
  void resetPlayerNames() {
    _playerNames.clear();
  }

  // New method to return all player names
  List<String> getAllPlayerNames() {
    print("Fetching all player names: $_playerNames"); // Debugging: print player names when fetched
    return List.unmodifiable(_playerNames); // Return a copy of the list of player names
  }
}
