import 'package:flutter/material.dart';
import 'package:foldolino/gamecanvas.dart';
import 'package:foldolino/optionsscreen.dart'; // Import the GameCanvasScreen
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class ShowPlayerNamesScreen extends StatefulWidget {
  final List<String> playerNames;

  const ShowPlayerNamesScreen({required this.playerNames});

  @override
  _ShowPlayerNamesScreenState createState() => _ShowPlayerNamesScreenState();
}

class _ShowPlayerNamesScreenState extends State<ShowPlayerNamesScreen> {
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
        'title': 'Ready to Play?',
        'subtitle': 'Here are your players',
        'play': 'Play',
        'settings': 'Settings',
      },
      'DE': {
        'title': 'Bereit zu spielen?',
        'subtitle': 'Hier sind deine Spieler',
        'play': 'Spielen',
        'settings': 'Einstellungen',
      },
      'FR': {
        'title': 'Prêt à jouer?',
        'subtitle': 'Voici vos joueurs',
        'play': 'Jouer',
        'settings': 'Paramètres',
      },
      'ES': {
        'title': '¿Listo para jugar?',
        'subtitle': 'Aquí están tus jugadores',
        'play': 'Jugar',
        'settings': 'Configuraciones',
      },
      'IT': {
        'title': 'Pronto a giocare?',
        'subtitle': 'Ecco i tuoi giocatori',
        'play': 'Gioca',
        'settings': 'Impostazioni',
      },
    };
    return languageStrings[languageCode] ?? languageStrings['EN']!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Indicator at the top with full width
            SizedBox(
              width: 200, // Fixed width for consistency
              child: LinearProgressIndicator(
                value: 1.0, // Shows 100% progress
                backgroundColor: Colors.grey[300],
                color: Color(0xFF2ED0C2), // Blue theme color
              ),
            ),
            SizedBox(height: 10), // Reduced space below the progress indicator

            // Title Text
            Text(
              languageStrings['title']!,
              style: TextStyle(
                fontFamily: 'Poppins', // Poppins font
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10), // Increased space after title text

            // Subtitle Text
            Text(
              languageStrings['subtitle']!,
              style: TextStyle(
                fontFamily: 'Poppins', // Poppins font
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Increased space before displaying player names

            // Single Row for Player Icons and Names
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row
              children: [
                for (var playerName in widget.playerNames)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0), // Reduced space between players
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFF2ED0C2), // Blue theme color
                          radius: 32, // Reduced avatar size
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32, // Reduced icon size
                          ),
                        ),
                        SizedBox(height: 4), // Reduced space between icon and text
                        Text(
                          playerName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12, // Reduced font size for player names
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20), // Increased space before the Play button

            // Play Button
            ElevatedButton(
              onPressed: () {
                // Navigate to GameCanvasScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameCanvasScreen(numberOfPlayers: widget.playerNames.length, hatSelected: true, playerNames: widget.playerNames),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2ED0C2), // Blue theme color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text(
                languageStrings['play']!,
                style: TextStyle(
                  fontFamily: 'Poppins', // Poppins font
                  fontSize: 14, // Reduced font size for the button text
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20), // Further reduced space at the bottom for better padding
          ],
        ),
      ),

      // Settings Gear Icon (Bottom Right)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pass the number of players to the settings screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(numberOfPlayers: widget.playerNames.length, playerNames: widget.playerNames),
            ),
          );
        },
        backgroundColor: Colors.black, // Black color for the settings icon
        child: Icon(
          Icons.settings, // Settings gear icon
          color: Colors.white,
        ),
      ),
    );
  }
}
