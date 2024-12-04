import 'package:flutter/material.dart';
import 'package:foldolino/createroom.dart';
import 'package:foldolino/passplayernames.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class MultiplayerCreateScreen extends StatefulWidget {
  @override
  _MultiplayerCreateScreenState createState() => _MultiplayerCreateScreenState();
}

class _MultiplayerCreateScreenState extends State<MultiplayerCreateScreen> {
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
        'create_room': 'Create a Room',
        'join_room': 'Join a Room',
      },
      'DE': {
        'title': 'Welchen Modus möchtest du spielen?',
        'subtitle': 'Bitte wähle deinen Spielmodus',
        'create_room': 'Raum erstellen',
        'join_room': 'Raum beitreten',
      },
      'FR': {
        'title': 'Quel mode voulez-vous jouer ?',
        'subtitle': 'Veuillez sélectionner votre mode de jeu',
        'create_room': 'Créer une salle',
        'join_room': 'Rejoindre une salle',
      },
      'ES': {
        'title': '¿Qué modo quieres jugar?',
        'subtitle': 'Por favor selecciona tu modo de juego',
        'create_room': 'Crear una sala',
        'join_room': 'Unirse a una sala',
      },
      'IT': {
        'title': 'Quale modalità vuoi giocare?',
        'subtitle': 'Per favore seleziona la modalità di gioco',
        'create_room': 'Crea una stanza',
        'join_room': 'Unisciti a una stanza',
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Indicator at the top
            SizedBox(
              width: screenWidth * 0.3,
              child: LinearProgressIndicator(
                value: 0.60,
                backgroundColor: Colors.grey[300],
                color: Color(0xFF2ED0C2),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Title Text
            Text(
              languageStrings['title']!,
              style: TextStyle(
                fontFamily: 'Poppins',
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
                fontFamily: 'Poppins',
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
                  // "Create a Room" Button
                  GameModeOption(
                    title: languageStrings['create_room']!,
                    color: Color(0xFF2ED0C2),
                    icon: Icons.create_new_folder,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => CreateRoom(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),

                  // "Join a Room" Button
                  GameModeOption(
                    title: languageStrings['join_room']!,
                    color: Color(0xFF2ED0C2),
                    icon: Icons.group_add,
                    onTap: () {
                      // Handle Join Room mode selection
                      print("Join a Room selected");
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
        height: screenHeight * 0.5,
        width: screenWidth * 0.3,
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
              radius: screenHeight * 0.08,
              child: Icon(
                icon,
                color: Colors.white,
                size: screenHeight * 0.07,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: screenHeight * 0.05,
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
