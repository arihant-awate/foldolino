import 'package:flutter/material.dart';
import 'package:foldolino/passshowplayer.dart';
import 'package:foldolino/playernamemodel.dart'; // Import the PlayerNamesModel
 // Import the next screen

class EnterPlayerNamesScreen extends StatefulWidget {
  @override
  _EnterPlayerNamesScreenState createState() => _EnterPlayerNamesScreenState();
}

class _EnterPlayerNamesScreenState extends State<EnterPlayerNamesScreen> {
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  PlayerNamesModel playerNamesModel = PlayerNamesModel(); // Create instance of model

  void _addPlayer() {
    if (controllers.length < 6) {
      setState(() {
        controllers.add(TextEditingController());
      });
    }
  }

  void _removePlayer(int index) {
    if (controllers.length > 4) {
      setState(() {
        controllers.removeAt(index);
      });
    }
  }

  bool _canContinue() {
    // Check if all player names are entered (non-empty)
    return controllers.every((controller) => controller.text.isNotEmpty);
  }

  void _continue() {
    // Get all player names from the controllers
    List<String> playerNames = controllers.map((c) => c.text).toList();

    // Set the player names in the model
    bool success = playerNamesModel.setPlayerNames(playerNames);

    if (success) {
      // Navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowPlayerNamesScreen(
            playerNames: playerNames,
          ),
        ),
      );
    } else {
      // Show alert if player names are not valid (not 4 to 6 names)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Incomplete Information"),
          content: Text("Please enter names for at least 4 players and at most 6 players."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(color: Color(0xFF2ED0C2))),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Progress Indicator
              SizedBox(
                width: screenWidth * 0.3,
                child: LinearProgressIndicator(
                  value: controllers.length <= 4 ? 0.66 : 1.0,
                  backgroundColor: Colors.grey[300],
                  color: Color(0xFF2ED0C2),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Title and Subtitle
              Text(
                "Enter Player Names",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenHeight * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Please enter the names of the players",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenHeight * 0.03,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),

              // Grid for Player Name Fields
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: controllers.length,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 4,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: PlayerNameField(
                                controller: controllers[index],
                                playerNumber: "Player ${index + 1}",
                              ),
                            ),
                            if (index >= 4)
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red, size: 30),
                                onPressed: () => _removePlayer(index),
                                tooltip: "Remove Player",
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              // Add Player Button
              if (controllers.length < 6)
                IconButton(
                  onPressed: _addPlayer,
                  icon: Icon(Icons.add_circle, color: Color(0xFF2ED0C2), size: 35),
                  tooltip: "Add Player",
                ),

              // Continue Button
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: _canContinue() ? _continue : null,  // Disable if not all names are entered
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2ED0C2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenHeight * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PlayerNameField extends StatelessWidget {
  final TextEditingController controller;
  final String playerNumber;

  const PlayerNameField({
    required this.controller,
    required this.playerNumber,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: playerNumber,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.grey,
          fontSize: screenHeight * 0.03,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xFF2ED0C2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color(0xFF2ED0C2),
            width: 2,
          ),
        ),
      ),
    );
  }
}
