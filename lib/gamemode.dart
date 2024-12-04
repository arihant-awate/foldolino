import 'package:flutter/material.dart';
import 'package:foldolino/multiplayercreate.dart';
import 'package:foldolino/passplayernames.dart';

class SelectGameModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white, // Set AppBar background color to white
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Indicator at the top
            SizedBox(
              width: screenWidth * 0.3, // Dynamic width for progress bar
              child: LinearProgressIndicator(
                value: 0.33, // Shows 1/3 progress
                backgroundColor: Colors.grey[300],
                color: Color(0xFF2ED0C2), // Theme color
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Space below the progress indicator

            // Title Text
            Text(
              "Which mode do you want to play?",
              style: TextStyle(
                fontFamily: 'Poppins', // Poppins font
                fontSize: screenHeight * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),

            // Subtitle Text
            Text(
              "Please select your game mode",
              style: TextStyle(
                fontFamily: 'Poppins', // Poppins font
                fontSize: screenHeight * 0.04,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.05), // Space before the buttons

            // Row for Game Modes
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // "Pass and Play" Button
                  GameModeOption(
                    title: "Pass and Play",
                    color: Color(0xFF2ED0C2), // Theme color
                    icon: Icons.group,
                    onTap: () {
                      // Navigate to EnterPlayerNamesScreen with no animation
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => EnterPlayerNamesScreen(),
                          transitionDuration: Duration.zero, // No animation
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),

                  // "Multiplayer" Button
                  GameModeOption(
                    title: "Multiplayer",
                    color: Color(0xFF2ED0C2), // Theme color
                    icon: Icons.online_prediction,
                    onTap: () {
                      // Handle Multiplayer mode selection
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => MultiplayerCreateScreen(),
                          transitionDuration: Duration.zero, // No animation
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameModeOption extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const GameModeOption({
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.5, // Adjust height dynamically
        width: screenWidth * 0.3, // Adjust width dynamically
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 1.5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: screenHeight * 0.08, // Adjust radius dynamically
              child: Icon(
                icon,
                color: Colors.white,
                size: screenHeight * 0.07, // Adjust icon size dynamically
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins', // Poppins font
                color: Colors.black,
                fontSize: screenHeight * 0.05, // Adjust font size dynamically
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
