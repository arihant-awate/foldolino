import 'package:flutter/material.dart';
import 'package:foldolino/passshowplayer.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:foldolino/gamecanvas.dart';

class SettingsScreen extends StatefulWidget {
  final int numberOfPlayers; // Pass the number of players
  final List<String> playerNames;
  const SettingsScreen({required this.numberOfPlayers, required this.playerNames});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool hatSelected = true;
  bool headSelected = false;
  bool upperBodySelected = false;
  bool lowerBodySelected = false;
  bool feetSelected = false;
  bool undergroundSelected = false;
  String selectedLanguage = 'EN'; // Default language

  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();

    // Automatically select the first and last option based on the number of players
    if (widget.numberOfPlayers == 6) {
      hatSelected = true; // First option (Hat) selected
      undergroundSelected = true; // Last option (Underground) selected
    }

    if (widget.numberOfPlayers == 5) {
      headSelected = true;
    }

    if (widget.numberOfPlayers == 4) {
      hatSelected = false;
      undergroundSelected = false;
    }
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
    // Get language strings dynamically
    final languageStrings = getLanguageStrings(selectedLanguage);

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          languageStrings['select_parts']!,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(  // Make the entire body scrollable
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              OptionTile(
                icon: Icons.headphones, // Hat icon
                label: languageStrings['hat']!,
                value: hatSelected,
                onChanged: getOnChanged(0), // Pass the correct onChanged callback
                isCheckbox: widget.numberOfPlayers != 6, // Only show checkbox if not 6 players
                isCross: widget.numberOfPlayers == 4, // Show red cross for 4 players
              ),
              OptionTile(
                icon: Icons.face_5_rounded, // Head icon
                label: languageStrings['head']!,
                value: headSelected,
                onChanged: getOnChanged(1), // Pass the correct onChanged callback
                isCheckbox: false, // Remove checkbox for Head
                isCross: false, // No cross icon
              ),
              OptionTile(
                icon: Icons.person, // Upper body icon
                label: languageStrings['upper_body']!,
                value: upperBodySelected,
                onChanged: getOnChanged(2), // Pass the correct onChanged callback
                isCheckbox: false, // No checkbox
                isCross: false, // No cross icon
              ),
              OptionTile(
                icon: Icons.person_2_outlined, // Lower body icon
                label: languageStrings['lower_body']!,
                value: lowerBodySelected,
                onChanged: getOnChanged(3), // Pass the correct onChanged callback
                isCheckbox: false, // No checkbox
                isCross: false, // No cross icon
              ),
              OptionTile(
                icon: Icons.downhill_skiing, // Feet icon
                label: languageStrings['feet']!,
                value: feetSelected,
                onChanged: getOnChanged(4), // Pass the correct onChanged callback
                isCheckbox: false, // No checkbox
                isCross: false, // No cross icon
              ),
              OptionTile(
                icon: Icons.arrow_downward_sharp, // Underground icon
                label: languageStrings['underground']!,
                value: undergroundSelected,
                onChanged: getOnChanged(5), // Pass the correct onChanged callback
                isCheckbox: widget.numberOfPlayers != 6, // Only show checkbox if not 6 players
                isCross: widget.numberOfPlayers == 4, // Show red cross for 4 players
              ),
              SizedBox(height: 20),
              // Apply button
              ElevatedButton(
                onPressed: () {
                  // Handle Apply action (perhaps saving settings or applying changes)
                  // Pass the values to the next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowPlayerNamesScreen(
                        
                        playerNames: widget.playerNames,
                      ),
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
                  languageStrings['apply']!,
                  style: TextStyle(
                    fontFamily: 'Poppins', // Poppins font
                    fontSize: 14, // Button text size
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

  // Method to return onChanged callback for 1st and 6th options
  ValueChanged<bool?>? getOnChanged(int index) {
    if (widget.numberOfPlayers == 6) {
      // If it's 6 players, don't show checkbox for 1st and 6th
      if (index == 0 || index == 5) return null;  // Hide checkbox (not clickable)
    }
    return (bool? value) {
      setState(() {
        if (index == 0) {
          hatSelected = value!;
          if (hatSelected) undergroundSelected = false; // Disable Underground if Hat is selected
        }
        if (index == 5) {
          undergroundSelected = value!;
          if (undergroundSelected) hatSelected = false; // Disable Hat if Underground is selected
        }
        if (index == 1) headSelected = value!;
        if (index == 2) upperBodySelected = value!;
        if (index == 3) lowerBodySelected = value!;
        if (index == 4) feetSelected = value!;
      });
      if (!hatSelected) {
        setState(() {
          undergroundSelected = true;
        });
      }
    };
  }

  // Function to get language strings based on selected language
  Map<String, String> getLanguageStrings(String languageCode) {
    Map<String, Map<String, String>> languageStrings = {
      'EN': {
        'select_parts': 'Select the parts you want to draw',
        'hat': 'Hat',
        'head': 'Head',
        'upper_body': 'Upper Body',
        'lower_body': 'Lower Body',
        'feet': 'Feet',
        'underground': 'Underground',
        'apply': 'Apply',
      },
      'DE': {
        'select_parts': 'Wählen Sie die Teile aus, die Sie zeichnen möchten',
        'hat': 'Hut',
        'head': 'Kopf',
        'upper_body': 'Oberkörper',
        'lower_body': 'Unterkörper',
        'feet': 'Füße',
        'underground': 'Untergrund',
        'apply': 'Bewerben',
      },
      'FR': {
        'select_parts': 'Sélectionnez les parties à dessiner',
        'hat': 'Chapeau',
        'head': 'Tête',
        'upper_body': 'Haut du corps',
        'lower_body': 'Bas du corps',
        'feet': 'Pieds',
        'underground': 'Souterrain',
        'apply': 'Appliquer',
      },
      'ES': {
        'select_parts': 'Seleccione las partes que desea dibujar',
        'hat': 'Sombrero',
        'head': 'Cabeza',
        'upper_body': 'Cuerpo superior',
        'lower_body': 'Cuerpo inferior',
        'feet': 'Pies',
        'underground': 'Subterráneo',
        'apply': 'Aplicar',
      },
      'IT': {
        'select_parts': 'Seleziona le parti da disegnare',
        'hat': 'Cappello',
        'head': 'Testa',
        'upper_body': 'Parte superiore del corpo',
        'lower_body': 'Parte inferiore del corpo',
        'feet': 'Piedi',
        'underground': 'Sottosuolo',
        'apply': 'Applica',
      },
    };
    return languageStrings[languageCode] ?? languageStrings['EN']!;
  }
}

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool isCheckbox;  // Whether to show a checkbox for this option
  final bool isCross;  // Whether to show the red cross icon for disabled options

  const OptionTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.isCheckbox,  // Determines whether to show checkbox
    required this.isCross,  // Determines whether to show the red cross
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF2ED0C2)),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      trailing: isCross
          ? Icon(
              Icons.close,
              color: Colors.red,
            )  // Show a red cross if the option is disabled
          : (isCheckbox
              ? Checkbox(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Color(0xFF2ED0C2),
                )
              : null),  // Show the checkbox or nothing based on conditions
    );
  }
}
