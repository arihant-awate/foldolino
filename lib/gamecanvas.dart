import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class GameCanvasScreen extends StatefulWidget {
  final int numberOfPlayers;
  final bool hatSelected;
  final List<String> playerNames;

  const GameCanvasScreen({
    required this.numberOfPlayers,
    required this.hatSelected,
    required this.playerNames,
  });

  @override
  _GameCanvasScreenState createState() => _GameCanvasScreenState();
}

class _GameCanvasScreenState extends State<GameCanvasScreen> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  double _penThickness = 5.0; // Default pen thickness
  Color _penColor = Colors.black; // Default pen color
  String selectedLanguage = 'EN'; // Default language

  // Track the current player index to show their part
  int _currentPlayerIndex = 0;

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

  // Get language strings based on selected language
  Map<String, String> getLanguageStrings(String languageCode) {
    Map<String, Map<String, String>> languageStrings = {
      'EN': {
        'room_code': 'Room Code',
        'waiting_for_players': 'Waiting for other players...',
        'start': 'Start',
        'clear': 'Clear',
        'share': 'Share',
        'premium_feature': 'Premium Feature',
        'premium_message': 'This feature is only available for premium users. Would you like to buy the premium version?',
        'buy_now': 'Buy Now',
        'cancel': 'Cancel',
        'pass_the_phone': 'Pass the phone to',
        'draw_part': 'They need to draw: ',
      },
      'DE': {
        'room_code': 'Raumcode',
        'waiting_for_players': 'Warten auf andere Spieler...',
        'start': 'Starten',
        'clear': 'Löschen',
        'share': 'Teilen',
        'premium_feature': 'Premium Funktion',
        'premium_message': 'Diese Funktion ist nur für Premium-Nutzer verfügbar. Möchten Sie die Premium-Version kaufen?',
        'buy_now': 'Jetzt kaufen',
        'cancel': 'Abbrechen',
        'pass_the_phone': 'Geben Sie das Telefon weiter an',
        'draw_part': 'Sie müssen zeichnen: ',
      },
      'FR': {
        'room_code': 'Code de la salle',
        'waiting_for_players': 'En attendant d\'autres joueurs...',
        'start': 'Démarrer',
        'clear': 'Effacer',
        'share': 'Partager',
        'premium_feature': 'Fonction Premium',
        'premium_message': 'Cette fonctionnalité est uniquement disponible pour les utilisateurs premium. Souhaitez-vous acheter la version premium?',
        'buy_now': 'Acheter maintenant',
        'cancel': 'Annuler',
        'pass_the_phone': 'Passez le téléphone à',
        'draw_part': 'Ils doivent dessiner: ',
      },
      'ES': {
        'room_code': 'Código de la sala',
        'waiting_for_players': 'Esperando a otros jugadores...',
        'start': 'Empezar',
        'clear': 'Borrar',
        'share': 'Compartir',
        'premium_feature': 'Función Premium',
        'premium_message': 'Esta característica está disponible solo para usuarios premium. ¿Te gustaría comprar la versión premium?',
        'buy_now': 'Comprar ahora',
        'cancel': 'Cancelar',
        'pass_the_phone': 'Pasa el teléfono a',
        'draw_part': 'Ellos necesitan dibujar: ',
      },
      'IT': {
        'room_code': 'Codice della stanza',
        'waiting_for_players': 'In attesa di altri giocatori...',
        'start': 'Inizia',
        'clear': 'Pulisci',
        'share': 'Condividi',
        'premium_feature': 'Funzione Premium',
        'premium_message': 'Questa funzionalità è disponibile solo per gli utenti premium. Vuoi acquistare la versione premium?',
        'buy_now': 'Compra ora',
        'cancel': 'Annulla',
        'pass_the_phone': 'Passa il telefono a',
        'draw_part': 'Devono disegnare: ',
      },
    };
    return languageStrings[languageCode] ?? languageStrings['EN']!;
  }

  // Clears the signature pad
  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  // Saves the signature as an image and navigates to a new screen to display it
  void _handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    ui.Image image = await signatureGlobalKey.currentState!.toImage();
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Stack(
                children: [
                  // Left side player names and drawn parts dynamically
                  Positioned(
                    left: 10,
                    top: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(widget.numberOfPlayers, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            '${widget.playerNames[index]}: ${_getPartsToDraw()[index]}', // Dynamically get parts
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins'),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Image
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        color: Colors.white,
                        child: Image.memory(bytes!.buffer.asUint8List()),
                      ),
                    ),
                  ),

                  // Right side share button
                  Positioned(
                    right: 10,
                    top: 50,
                    child: IconButton(
                      icon: Icon(Icons.share, color: Colors.white),
                      onPressed: () async {
                        try {
                          if (bytes == null) {
                            print("Error: bytes are null");
                            return;
                          }

                          final byteList = bytes!.buffer.asUint8List();
                          print("Image bytes converted to Uint8List successfully.");

                          try {
                            final response = await Supabase.instance.client
                                .from('imagesnew') // Your Supabase table name
                                .insert([
                              {
                                'image_data': byteList,
                                'uploaded_at': DateTime.now().toIso8601String(),
                              }
                            ]);

                            if (response == null || response.data == null) {
                              print("Error: No response received from Supabase.");
                            } else {
                              print('Image data inserted successfully');
                            }
                          } catch (e) {
                            print('Exception occurred during Supabase insert: $e');
                          }

                          final tempDir = await getTemporaryDirectory();
                          final tempFile = File('${tempDir.path}/signature.png');
                          await tempFile.writeAsBytes(byteList);
                          print("Image saved to temporary file: ${tempFile.path}");

                          final result = await Share.shareXFiles(
                            [XFile('${tempFile.path}')],
                            text: 'Check out this funny creature created by many hands! 😂👾 Download Foldolino now and join the fun!',
                          );

                          if (result.status == ShareResultStatus.success) {
                            print('Thank you for sharing the picture!');
                          }
                          print("Image shared successfully!");
                        } catch (e) {
                          print("Error during share process: $e");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPremiumDialog() {
    final languageStrings = getLanguageStrings(selectedLanguage);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            languageStrings['premium_feature']!,
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            languageStrings['premium_message']!,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text(
                languageStrings['buy_now']!,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Implement buying flow here
              },
            ),
            TextButton(
              child: Text(
                languageStrings['cancel']!,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  List<String> _getPartsToDraw() {
    List<String> partsToDraw = [];

    if (widget.numberOfPlayers == 4) {
      partsToDraw = ["Head", "Upper Body", "Lower Body", "Feet"];
    } else if (widget.numberOfPlayers == 5) {
      if (widget.hatSelected) {
        partsToDraw = ["Hat", "Head", "Upper Body", "Lower Body", "Feet"];
      } else {
        partsToDraw = [
          "Head",
          "Upper Body",
          "Lower Body",
          "Feet",
          "Underground"
        ];
      }
    } else if (widget.numberOfPlayers == 6) {
      partsToDraw = [
        "Hat",
        "Head",
        "Upper Body",
        "Lower Body",
        "Feet",
        "Underground"
      ];
    }

    return partsToDraw;
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset + 340,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  double _calculateCanvasHeight() {
    double baseHeight = 2000;
    double adjustedHeight =
        baseHeight * (widget.numberOfPlayers / 6);
    debugPrint(
        'Canvas height for ${widget.numberOfPlayers} players: $adjustedHeight');
    return adjustedHeight;
  }

  double _calculateSectionHeight(double canvasHeight) {
    return canvasHeight / widget.numberOfPlayers;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double canvasHeight = _calculateCanvasHeight();
    double sectionHeight = _calculateSectionHeight(canvasHeight);

    List<String> partsToDraw = _getPartsToDraw();
    final languageStrings = getLanguageStrings(selectedLanguage);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  width: screenWidth,
                  height: canvasHeight,
                  child: SfSignaturePad(
                    key: signatureGlobalKey,
                    backgroundColor: Colors.white,
                    strokeColor: _penColor,
                    minimumStrokeWidth: _penThickness,
                    maximumStrokeWidth: _penThickness,
                  ),
                ),
              ),
            ),
            if (_currentPlayerIndex != widget.numberOfPlayers - 1)...[
              ...List.generate(widget.numberOfPlayers - 1, (index) {
                return Positioned(
                  top: (index + 1) * sectionHeight,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    color: Colors.black,
                  ),
                );
              }),
            ],
            Positioned(
              top: 40,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.playerNames[_currentPlayerIndex]}: ${partsToDraw[_currentPlayerIndex]}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: _handleClearButtonPressed,
                    child: Icon(Icons.delete, size: 20),
                    backgroundColor: Color(0xFF2ED0C2),
                    foregroundColor: Colors.white,
                    mini: true,
                  ),
                  SizedBox(height: 10),
                  Slider(
                    value: _penThickness,
                    thumbColor: Color(0xFF2ED0C2),
                    inactiveColor: Colors.white,
                    activeColor: Color(0xFF2ED0C2),
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    label: 'Thickness: ${_penThickness.toStringAsFixed(1)}',
                    onChanged: (value) {
                      setState(() {
                        _penThickness = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  if (_currentPlayerIndex == widget.numberOfPlayers - 1)
                    FloatingActionButton(
                      onPressed: _handleSaveButtonPressed,
                      child: Icon(Icons.check, size: 20),
                      backgroundColor: Color(0xFF2ED0C2),
                      foregroundColor: Colors.white,
                      mini: true,
                    ),
                  SizedBox(height: 10),
                  IconButton(
                    icon: Icon(Icons.color_lens, size: 40),
                    color: Colors.black,
                    onPressed: _showPremiumDialog,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 10,
              child: FloatingActionButton(
                onPressed: () {
                  if (_currentPlayerIndex == widget.numberOfPlayers - 1) {
                    _handleSaveButtonPressed();
                  } else {
                    setState(() {
                      _currentPlayerIndex++;
                    });

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color(0xFF2ED0C2),
                          title: Text(
                            '${languageStrings['pass_the_phone']} ${widget.playerNames[_currentPlayerIndex]}',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            '${languageStrings['draw_part']}${partsToDraw[_currentPlayerIndex]}',
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                '${languageStrings['cancel']}',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  _scrollDown();
                },
                child: Icon(Icons.arrow_downward, size: 30),
                backgroundColor: Color(0xFF2ED0C2),
                foregroundColor: Colors.white,
                mini: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}