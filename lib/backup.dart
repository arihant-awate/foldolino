// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

// class GameCanvasScreen extends StatefulWidget {
//   final int numberOfPlayers;
//   final bool hatSelected;
//   final List<String> playerNames;

//   const GameCanvasScreen({
//     required this.numberOfPlayers,
//     required this.hatSelected,
//     required this.playerNames,
//   });

//   @override
//   _GameCanvasScreenState createState() => _GameCanvasScreenState();
// }

// class _GameCanvasScreenState extends State<GameCanvasScreen> {
//   final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
//   final ScrollController _scrollController = ScrollController();
//   double _penThickness = 5.0; // Default pen thickness
//   Color _penColor = Colors.black; // Default pen color

//   // Clears the signature pad
//   void _handleClearButtonPressed() {
//     signatureGlobalKey.currentState!.clear();
//   }

//   // Saves the signature as an image and navigates to a new screen to display it
//   void _handleSaveButtonPressed() async {
//     final data =
//         await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
//     final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
//     await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (BuildContext context) {
//           return Scaffold(
//             body: Center(
//               child: Container(
//                 color: Colors.grey[300],
//                 child: Image.memory(bytes!.buffer.asUint8List()),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Scroll up action
//   void _scrollUp() {
//     _scrollController.animateTo(
//       _scrollController.offset - 340, // Scroll 100 pixels up
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   // Scroll down action
//   void _scrollDown() {
//     _scrollController.animateTo(
//       _scrollController.offset + 340, // Scroll 100 pixels down
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   // Calculate canvas height based on the number of players
//   double _calculateCanvasHeight() {
//     double baseHeight = 2000; // Base height for a higher number of players
//     double adjustedHeight = baseHeight * (widget.numberOfPlayers / 6); // Scaling for 4 to 6 players
//     debugPrint('Canvas height for ${widget.numberOfPlayers} players: $adjustedHeight');
//     return adjustedHeight;
//   }

//   // Calculate the height of each section based on number of players
//   double _calculateSectionHeight(double canvasHeight) {
//     return canvasHeight / widget.numberOfPlayers;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double canvasHeight = _calculateCanvasHeight(); // Dynamically calculated height
//     double sectionHeight = _calculateSectionHeight(canvasHeight); // Height of each section

//     // Debugging the parts that players need to draw
//     debugPrint("Parts to draw based on ${widget.numberOfPlayers} players:");

//     List<String> partsToDraw = [];

//     if (widget.numberOfPlayers == 4) {
//       // For 4 players: head, upper body, lower body, feet
//       partsToDraw = ["Head", "Upper Body", "Lower Body", "Feet"];
//     } else if (widget.numberOfPlayers == 5) {
//       if (widget.hatSelected) {
//         // For 5 players with hatSelected = true: hat, head, upper body, lower body, feet
//         partsToDraw = ["Hat", "Head", "Upper Body", "Lower Body", "Feet"];
//       } else {
//         // For 5 players with hatSelected = false: head, upper body, lower body, feet, underground
//         partsToDraw = ["Head", "Upper Body", "Lower Body", "Feet", "Underground"];
//       }
//     } else if (widget.numberOfPlayers == 6) {
//       // For 6 players: head, upper body, lower body, feet, underground, hat
//       partsToDraw = ["Hat", "Head", "Upper Body", "Lower Body", "Feet", "Underground"];
//     }

//     // Debug the parts
//     debugPrint("Parts: $partsToDraw");

//     return Scaffold(
//       extendBodyBehindAppBar: true, // Allow the body to extend behind the app bar
//       body: WillPopScope(
//         onWillPop: () async {
//           Navigator.pop(context); // Handles back button press
//           return false; // Prevents default behavior
//         },
//         child: Stack(
//           children: [
//             // Scrollable Signature Pad Area
//             Positioned.fill(
//               child: SingleChildScrollView(
//                 controller: _scrollController,
//                 child: Container(
//                   width: screenWidth,
//                   height: canvasHeight, // Dynamically set height
//                   child: SfSignaturePad(
//                     key: signatureGlobalKey,
//                     backgroundColor: Colors.white,
//                     strokeColor: _penColor,
//                     minimumStrokeWidth: _penThickness,
//                     maximumStrokeWidth: _penThickness,
//                   ),
//                 ),
//               ),
//             ),
//             // Draw horizontal dividers directly on the canvas
//             ...List.generate(widget.numberOfPlayers - 1, (index) {
//               return Positioned(
//                 top: (index + 1) * sectionHeight, // Position each divider
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 1, // Divider height
//                   color: Colors.black, // Divider color
//                 ),
//               );
//             }),
//             // Positioned tools on the right side
//             Positioned(
//               top: 100,
//               right: 10,
//               child: Column(
//                 children: [
//                   // Clear Button with custom icon color
//                   FloatingActionButton(
//                     onPressed: _handleClearButtonPressed,
//                     child: Icon(Icons.delete, size: 20), // Clear icon from default icons
//                     backgroundColor: Color(0xFF2ED0C2),
//                     foregroundColor: Colors.white,
//                     mini: true, // Makes the button smaller
//                   ),
//                   SizedBox(height: 10),
//                   // Pen Thickness Slider
//                   Slider(
//                     value: _penThickness,
//                     thumbColor: Color(0xFF2ED0C2),
//                     inactiveColor: Colors.white,
//                     activeColor: Color(0xFF2ED0C2),
//                     min: 1.0,
//                     max: 10.0,
//                     divisions: 9,
//                     label: 'Thickness: ${_penThickness.toStringAsFixed(1)}',
//                     onChanged: (value) {
//                       setState(() {
//                         _penThickness = value;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 10),
//                   // Tick Button with custom icon color
//                   FloatingActionButton(
//                     onPressed: _handleSaveButtonPressed,
//                     child: Icon(Icons.check, size: 20), // Tick icon from default icons
//                     backgroundColor: Color(0xFF2ED0C2),
//                     foregroundColor: Colors.white,
//                     mini: true, // Makes the button smaller
//                   ),
//                 ],
//               ),
//             ),
//             // Positioned up and down buttons on the left side for scrolling
//             Positioned(
//               top: 100,
//               left: 10,
//               child: Column(
//                 children: [
//                   // Scroll Up Button with custom icon color
//                   FloatingActionButton(
//                     onPressed: _scrollUp,
//                     child: Icon(Icons.arrow_upward, size: 20), // Scroll up icon from default icons
//                     backgroundColor: Color(0xFF2ED0C2),
//                     foregroundColor: Colors.white,
//                     mini: true, // Makes the button smaller
//                   ),
//                   SizedBox(height: 10),
//                   // Scroll Down Button with custom icon color
//                   FloatingActionButton(
//                     onPressed: _scrollDown,
//                     child: Icon(Icons.arrow_downward, size: 20), // Scroll down icon from default icons
//                     backgroundColor: Color(0xFF2ED0C2),
//                     foregroundColor: Colors.white,
//                     mini: true, // Makes the button smaller
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// void _handleSaveButtonPressed() async {
//   try {
//     // Convert the signature to an image
//     final data = await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
//     final bytes = await data.toByteData(format: ui.ImageByteFormat.png);

//     // Check if bytes are null
//     if (bytes == null) {
//       print("Error: Image conversion failed (bytes is null)");
//       return;
//     }

//     // Convert bytes to Uint8List
//     final byteList = bytes.buffer.asUint8List();

//     // Save the image to a temporary file
//     final tempDir = await getTemporaryDirectory(); // Use 'path_provider' package
//     final fileName = '${DateTime.now().millisecondsSinceEpoch}_signature.png';
//     final tempFile = File('${tempDir.path}/$fileName');
//     await tempFile.writeAsBytes(byteList);

//     print("Image saved to temporary file: ${tempFile.path}");

//     // Upload the image to Supabase Storage
//     print("Uploading image to Supabase Storage...");
//     final bucketName = 'images-bucket'; // Replace with your bucket name
//     final storageResponse = await Supabase.instance.client.storage
//         .from(bucketName)
//         .upload('public/$fileName', tempFile);

//     if (storageResponse == null) {
//       print("Error uploading image: ${storageResponse}");
//       return;
//     }
//     else{
//         print("Uploaded Successfully: ${storageResponse}");
//     }

//     // Get the public URL of the uploaded image
//     final publicUrl = Supabase.instance.client.storage
//         .from(bucketName)
//         .getPublicUrl('public/$fileName');

//     print("Image uploaded successfully. Public URL: $publicUrl");

//     // Insert the image metadata into the `images` table
//     print("Inserting image metadata into the `images` table...");
//     final dbResponse = await Supabase.instance.client.from('imagesnew').insert({
//       'image_name': fileName,
//       'image_url': publicUrl,
//       'uploaded_at': DateTime.now().toIso8601String(),
//     });

//     if (dbResponse.error != null) {
//       print("Error inserting image metadata: ${dbResponse.error!.message}");
//     } else {
//       print("Image metadata inserted successfully.");
//       print("Response data: ${dbResponse.data}");
//     }

//     // Optional: Share the image
//     await Share.shareXFiles(
//       [XFile(tempFile.path)],
//       text: 'Check out this funny creature created by many hands! 😂👾 Download Foldolino now and join the fun!',
//     );
//     print("Image shared successfully!");

//   } catch (e) {
//     print("Error during the save process: $e");
//   }
// }
