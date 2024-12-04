import 'package:flutter/material.dart';
import 'package:foldolino/multiplayercreate.dart';
import 'package:foldolino/passplayernames.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectGameModeScreen extends StatefulWidget {
  @override
  _SelectGameModeScreenState createState() => _SelectGameModeScreenState();
}

class _SelectGameModeScreenState extends State<SelectGameModeScreen> {
  String selectedLanguage = 'EN'; // Default language

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  // Load language preference from SharedPreferences
  _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language') ?? 'EN'; // Default to 'EN'
    });
  }

  // Function to get language strings based on selected language
  Map<String, String> getLanguageStrings(String languageCode) {
    Map<String, Map<String, String>> languageStrings = {
      'EN': {
        'title': 'Which mode do you want to play?',
        'subtitle': 'Please select your game mode',
        'pass_and_play': 'Pass and Play',
        'multiplayer': 'Multiplayer',
      },
      'DE': {
        'title': 'Welchen Modus möchtest du spielen?',
        'subtitle': 'Bitte wähle deinen Spielmodus',
        'pass_and_play': 'Pass and Play',
        'multiplayer': 'Mehrspieler',
      },
      'FR': {
        'title': 'Quel mode voulez-vous jouer ?',
        'subtitle': 'Veuillez sélectionner votre mode de jeu',
        'pass_and_play': 'Pass and Play',
        'multiplayer': 'Multijoueur',
      },
      'ES': {
        'title': '¿Qué modo quieres jugar?',
        'subtitle': 'Por favor selecciona tu modo de juego',
        'pass_and_play': 'Pasa y juega',
        'multiplayer': 'Multijugador',
      },
      'IT': {
        'title': 'Quale modalità vuoi giocare?',
        'subtitle': 'Per favore seleziona la modalità di gioco',
        'pass_and_play': 'Passa e gioca',
        'multiplayer': 'Multigiocatore',
      },
    };
    return languageStrings[languageCode] ?? languageStrings['EN']!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get language strings dynamically
    final languageStrings = getLanguageStrings(selectedLanguage);

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
              languageStrings['title']!,
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
              languageStrings['subtitle']!,
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
                    title: languageStrings['pass_and_play']!,
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
                    title: languageStrings['multiplayer']!,
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
