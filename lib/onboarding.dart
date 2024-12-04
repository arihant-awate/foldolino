import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:foldolino/gamemode.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FoldolinoOnboardingScreen extends StatefulWidget {
  @override
  _FoldolinoOnboardingScreenState createState() =>
      _FoldolinoOnboardingScreenState();
}

class _FoldolinoOnboardingScreenState extends State<FoldolinoOnboardingScreen> {
  final PageController _controller = PageController();

  // Define strings for multiple languages
  Map<String, Map<String, String>> languageStrings = {
    'EN': {
      'create_together': 'Create Together',
      'explore_creativity': 'Explore Creativity',
      'play_discover': 'Play & Discover',
      'change_language': 'CHANGE LANGUAGE',
      'play_foldolino': 'PLAY FOLDOLINO',
      'select_language': 'Select Language',
      'cancel': 'CANCEL',
      'description_1': 'Draw different parts with friends and combine them into unique characters.',
      'description_2': 'Unleash your imagination with every stroke and share it with the world.',
      'description_3': 'Pass the screen, add your piece, and watch art come to life, part by part.'
    },
    'DE': {
      'create_together': 'Gemeinsam Erstellen',
      'explore_creativity': 'Kreativität Entfalten',
      'play_discover': 'Spielen & Entdecken',
      'change_language': 'SPRACHE ÄNDERN',
      'play_foldolino': 'SPIELE FOLDOLINO',
      'select_language': 'Sprache Auswählen',
      'cancel': 'ABBRECHEN',
      'description_1': 'Zeichne verschiedene Teile mit Freunden und kombiniere sie zu einzigartigen Charakteren.',
      'description_2': 'Entfalte deine Kreativität mit jedem Strich und teile es mit der Welt.',
      'description_3': 'Gib das Handy weiter, füge dein Teil hinzu und sieh zu, wie die Kunst Teil für Teil lebendig wird.'
    },
    'FR': {
      'create_together': 'Créer Ensemble',
      'explore_creativity': 'Explorer la Créativité',
      'play_discover': 'Jouer & Découvrir',
      'change_language': 'CHANGER DE LANGUE',
      'play_foldolino': 'JOUER À FOLDOLINO',
      'select_language': 'Sélectionner la Langue',
      'cancel': 'ANNULER',
      'description_1': 'Dessinez différentes parties avec des amis et combinez-les pour créer des personnages uniques.',
      'description_2': 'Libérez votre imagination à chaque coup de pinceau et partagez-la avec le monde.',
      'description_3': 'Passez l’écran, ajoutez votre pièce et regardez l’art prendre vie, pièce par pièce.'
    },
    'ES': {
      'create_together': 'Crear Juntos',
      'explore_creativity': 'Explorar la Creatividad',
      'play_discover': 'Jugar & Descubrir',
      'change_language': 'CAMBIAR IDIOMA',
      'play_foldolino': 'JUGAR A FOLDOLINO',
      'select_language': 'Seleccionar Idioma',
      'cancel': 'CANCELAR',
      'description_1': 'Dibuja diferentes partes con tus amigos y combínalas para crear personajes únicos.',
      'description_2': 'Desata tu imaginación con cada trazo y compártelo con el mundo.',
      'description_3': 'Pasa la pantalla, añade tu parte y mira cómo el arte cobra vida, parte por parte.'
    },
    'IT': {
      'create_together': 'Creare Insieme',
      'explore_creativity': 'Esplorare la Creatività',
      'play_discover': 'Gioca & Scopri',
      'change_language': 'CAMBIA LINGUA',
      'play_foldolino': 'GIOCA A FOLDOLINO',
      'select_language': 'Seleziona Lingua',
      'cancel': 'ANNULLA',
      'description_1': 'Disegna diverse parti con gli amici e combinatele per creare personaggi unici.',
      'description_2': 'Libera la tua immaginazione con ogni tratto e condividilo con il mondo.',
      'description_3': 'Passa lo schermo, aggiungi il tuo pezzo e guarda l\'arte prendere vita, pezzo dopo pezzo.'
    },
  };

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

  // Save the selected language to SharedPreferences
  _saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft
      ]);
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: PageView.builder(
              controller: _controller,
              itemCount: 3, // Number of onboarding pages
              itemBuilder: (context, index) {
                return _buildLandscapeContent(index, screenWidth, screenHeight);
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3, // Number of onboarding pages
                  effect: ExpandingDotsEffect(
                    activeDotColor: Color(0xFF2ED0C2),
                    dotColor: Color(0xFFD1ECE9),
                    dotHeight: screenHeight * 0.02,
                    dotWidth: screenHeight * 0.02,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectGameModeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2ED0C2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.035,
                        ),
                      ),
                      child: Text(
                        languageStrings[selectedLanguage]!['play_foldolino']!, // Dynamic text
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: screenHeight * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    TextButton(
                      onPressed: _showLanguageDialog,
                      child: Text(
                        languageStrings[selectedLanguage]!['change_language']!, // Dynamic text
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF2ED0C2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show language selection dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            languageStrings[selectedLanguage]!['select_language']!, // Dynamic text
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 18, // Adjusted font size for better visibility
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languageStrings.keys.map((lang) {
                return ListTile(
                  title: Text(
                    _getLanguageName(lang), // Language name with dynamic text
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: () {
                    _saveLanguagePreference(lang);
                    Navigator.pop(context);
                    setState(() {
                      selectedLanguage = lang;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                languageStrings[selectedLanguage]!['cancel']!, // Dynamic text
                style: TextStyle(
                  color: Colors.white, // White text for the cancel button
                  fontSize: 16, // Adjusted font size for better visibility
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper function to get language name in a readable format
  String _getLanguageName(String lang) {
    switch (lang) {
      case 'EN':
        return 'English (EN)';
      case 'DE':
        return 'Deutsch (DE)';
      case 'FR':
        return 'Français (FR)';
      case 'ES':
        return 'Español (ES)';
      case 'IT':
        return 'Italiano (IT)';
      default:
        return lang;
    }
  }

  Widget _buildLandscapeContent(int index, double screenWidth, double screenHeight) {
    List<String> titles = [
      'create_together',
      'explore_creativity',
      'play_discover'
    ];
    List<String> descriptions = [
      languageStrings[selectedLanguage]!['description_1']!,
      languageStrings[selectedLanguage]!['description_2']!,
      languageStrings[selectedLanguage]!['description_3']!
    ];

    final textWidth = screenWidth * 0.5;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              'assets/images/onboard${index + 1}.png', // Image dynamically loaded based on the index
              width: screenWidth * 0.4,
              height: screenHeight * 0.7,
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageStrings[selectedLanguage]![titles[index]]!, // Dynamic title
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenHeight * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2ED0C2),
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  width: textWidth,
                  child: Text(
                    descriptions[index], // Dynamic description
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: screenHeight * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
