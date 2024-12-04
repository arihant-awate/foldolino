import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

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

  // Track the current player index to show their part
  int _currentPlayerIndex = 0;

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
                          // Debug: Check if bytes is null
                          if (bytes == null) {
                            print("Error: bytes are null");
                            return;
                          }

                          // Your share functionality here
                          final byteList = bytes!.buffer.asUint8List();
                          print(
                              "Image bytes converted to Uint8List successfully.");

                          try {
                            print(
                                "Attempting to insert image data into Supabase...");

                            final response = await Supabase.instance.client
                                .from('imagesnew') // Your Supabase table name
                                .insert([
                              {
                                'image_data':
                                    byteList, // The byte data to be saved in the image_data column
                                'uploaded_at': DateTime.now()
                                    .toIso8601String(), // Save the timestamp
                              }
                            ]);

                            // Check for errors or successful insertion
                            if (response == null || response.data == null) {
                              print(
                                  "Error: No response received from Supabase.");
                            } else {
                              print('Image data inserted successfully');
                              print('Response data: ${response.data}');
                            }
                          } catch (e) {
                            print(
                                'Exception occurred during Supabase insert: $e');
                          }

                          final tempDir =
                              await getTemporaryDirectory(); // Use 'path_provider' package
                          final tempFile =
                              File('${tempDir.path}/signature.png');
                          await tempFile.writeAsBytes(byteList);
                          print(
                              "Image saved to temporary file: ${tempFile.path}");

                          // Share the image
                          final result = await Share.shareXFiles(
                            [XFile('${tempFile.path}')],
                            text:
                                'Check out this funny creature created by many hands! 😂👾 Download Foldolino now and join the fun!',
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Set black background
          title: Text(
            'Premium Feature',
            style: TextStyle(color: Colors.white), // White text for the title
          ),
          content: Text(
            'This feature is only available for premium users. Would you like to buy the premium version?',
            style: TextStyle(color: Colors.white), // White text for the content
          ),
          actions: [
            TextButton(
              child: Text(
                'Buy Now',
                style: TextStyle(
                    color: Colors.white), // White text for 'Buy Now' button
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Implement buying flow here
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.white), // White text for 'Cancel' button
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

  // Determine the parts based on number of players and hat selection
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

  // Scroll down action
  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset +
          340, // Scroll 340 pixels down (adjust if needed)
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Calculate canvas height based on the number of players
  double _calculateCanvasHeight() {
    double baseHeight = 2000; // Base height for a higher number of players
    double adjustedHeight =
        baseHeight * (widget.numberOfPlayers / 6); // Scaling for 4 to 6 players
    debugPrint(
        'Canvas height for ${widget.numberOfPlayers} players: $adjustedHeight');
    return adjustedHeight;
  }

  // Calculate the height of each section based on number of players
  double _calculateSectionHeight(double canvasHeight) {
    return canvasHeight / widget.numberOfPlayers;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double canvasHeight =
        _calculateCanvasHeight(); // Dynamically calculated height
    double sectionHeight =
        _calculateSectionHeight(canvasHeight); // Height of each section

    List<String> partsToDraw = _getPartsToDraw(); // Get the parts to draw

    // Debugging the parts that players need to draw
    debugPrint("Parts to draw: $partsToDraw");

    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allow the body to extend behind the app bar
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context); // Handles back button press
          return false; // Prevents default behavior
        },
        child: Stack(
          children: [
            // Scrollable Signature Pad Area
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  width: screenWidth,
                  height: canvasHeight, // Dynamically set height
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
            // Draw horizontal dividers directly on the canvas
            ...List.generate(widget.numberOfPlayers - 1, (index) {
              return Positioned(
                top: (index + 1) * sectionHeight, // Position each divider
                left: 0,
                right: 0,
                child: Container(
                  height: 1, // Divider height
                  color: Colors.black, // Divider color
                ),
              );
            }),
            // Positioned tools on the right side
            Positioned(
              top: 40,
              right: 20, // Align the tools to the right
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Right align the column items
                children: [
                  // Display the current player's name and part to draw
                  Text(
                    '${widget.playerNames[_currentPlayerIndex]}: ${partsToDraw[_currentPlayerIndex]}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  // Clear Button with custom icon color
                  FloatingActionButton(
                    onPressed: _handleClearButtonPressed,
                    child: Icon(Icons.delete,
                        size: 20), // Clear icon from default icons
                    backgroundColor: Color(0xFF2ED0C2),
                    foregroundColor: Colors.white,
                    mini: true, // Makes the button smaller
                  ),
                  SizedBox(height: 10),
                  // Pen Thickness Slider
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
                  // Tick Button with custom icon color, only visible for the last player
                  if (_currentPlayerIndex == widget.numberOfPlayers - 1)
                    FloatingActionButton(
                      onPressed: _handleSaveButtonPressed,
                      child: Icon(Icons.check,
                          size: 20), // Tick icon from default icons
                      backgroundColor: Color(0xFF2ED0C2),
                      foregroundColor: Colors.white,
                      mini: true, // Makes the button smaller
                    ),
                  SizedBox(height: 10),
                  // Color Picker Icon Button (Premium feature)
                  IconButton(
                    icon: Icon(Icons.color_lens, size: 40),
                    color: Colors.black,
                    onPressed: _showPremiumDialog,
                  ),
                ],
              ),
            ),
            // Positioned down button in the bottom-left for scrolling and triggering tick
            Positioned(
              bottom: 20,
              left: 10,
              child: FloatingActionButton(
                onPressed: () {
                  // When the down button is pressed on the last player, call the tick button action
                  if (_currentPlayerIndex == widget.numberOfPlayers - 1) {
                    // Simulate pressing the tick button
                    _handleSaveButtonPressed();
                  } else {
                    setState(() {
                      _currentPlayerIndex++;
                    });

                    // Show pop-up on down arrow click
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color(0xFF2ED0C2), // Cyan background
                          title: Text(
                            'Pass the phone to ${widget.playerNames[_currentPlayerIndex]}',
                            style: TextStyle(
                                color: Colors.white), // White text color
                          ),
                          content: Text(
                            'They need to draw: ${partsToDraw[_currentPlayerIndex]}',
                            style: TextStyle(
                                color: Colors.white), // White text color
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    color: Colors.white), // White text color
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

                  // Scroll down when clicking the down button
                  _scrollDown();
                },
                child: Icon(Icons.arrow_downward,
                    size: 30), // Scroll down icon from default icons
                backgroundColor: Color(0xFF2ED0C2),
                foregroundColor: Colors.white,
                mini: false, // Makes the button smaller
              ),
            ),
          ],
        ),
      ),
    );
  }
}
