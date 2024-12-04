import 'package:flutter/material.dart';
import 'package:foldolino/passshowplayer.dart';
import 'package:foldolino/playernamemodel.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

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
        'title': 'Enter Player Names',
        'subtitle': 'Please enter the names of the players',
        'player_name': 'Player',
        'incomplete_info': 'Incomplete Information',
        'incomplete_info_message': 'Please enter names for at least 4 players and at most 6 players.',
        'continue': 'Continue',
        'add_player': 'Add Player',
        'remove_player': 'Remove Player',
      },
      'DE': {
        'title': 'Gib die Spielernamen ein',
        'subtitle': 'Bitte gib die Namen der Spieler ein',
        'player_name': 'Spieler',
        'incomplete_info': 'Unvollständige Informationen',
        'incomplete_info_message': 'Bitte gib Namen für mindestens 4 Spieler und höchstens 6 Spieler ein.',
        'continue': 'Weiter',
        'add_player': 'Spieler hinzufügen',
        'remove_player': 'Spieler entfernen',
      },
      'FR': {
        'title': 'Entrez les noms des joueurs',
        'subtitle': 'Veuillez entrer les noms des joueurs',
        'player_name': 'Joueur',
        'incomplete_info': 'Informations incomplètes',
        'incomplete_info_message': 'Veuillez entrer les noms pour au moins 4 joueurs et au plus 6 joueurs.',
        'continue': 'Continuer',
        'add_player': 'Ajouter un joueur',
        'remove_player': 'Supprimer un joueur',
      },
      'ES': {
        'title': 'Ingrese los nombres de los jugadores',
        'subtitle': 'Por favor ingrese los nombres de los jugadores',
        'player_name': 'Jugador',
        'incomplete_info': 'Información incompleta',
        'incomplete_info_message': 'Por favor ingrese nombres para al menos 4 jugadores y como máximo 6 jugadores.',
        'continue': 'Continuar',
        'add_player': 'Agregar jugador',
        'remove_player': 'Eliminar jugador',
      },
      'IT': {
        'title': 'Inserisci i nomi dei giocatori',
        'subtitle': 'Si prega di inserire i nomi dei giocatori',
        'player_name': 'Giocatore',
        'incomplete_info': 'Informazioni incomplete',
        'incomplete_info_message': 'Si prega di inserire i nomi per almeno 4 giocatori e al massimo 6 giocatori.',
        'continue': 'Continua',
        'add_player': 'Aggiungi giocatore',
        'remove_player': 'Rimuovi giocatore',
      },
    };
    return languageStrings[languageCode] ?? languageStrings['EN']!;
  }

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
    return controllers.every((controller) => controller.text.isNotEmpty);
  }

  void _continue() {
    List<String> playerNames = controllers.map((c) => c.text).toList();

    bool success = playerNamesModel.setPlayerNames(playerNames);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowPlayerNamesScreen(
            playerNames: playerNames,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(getLanguageStrings(selectedLanguage)['incomplete_info']!),
          content: Text(getLanguageStrings(selectedLanguage)['incomplete_info_message']!),
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
                languageStrings['title']!,
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
                languageStrings['subtitle']!,
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
                                playerNumber: "${languageStrings['player_name']} ${index + 1}",
                              ),
                            ),
                            if (index >= 4)
                              IconButton(
                                icon: Icon(Icons.remove_circle, color: Colors.red, size: 30),
                                onPressed: () => _removePlayer(index),
                                tooltip: languageStrings['remove_player']!,
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
                  tooltip: languageStrings['add_player']!,
                ),

              // Continue Button
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: _canContinue() ? _continue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2ED0C2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
                ),
                child: Text(
                  languageStrings['continue']!,
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
