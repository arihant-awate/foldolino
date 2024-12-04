import 'package:flutter/material.dart';
import 'package:foldolino/gamecanvas.dart';

class SettingsScreen extends StatefulWidget {
  final int numberOfPlayers; // Pass the number of players
    final List<String> playerNames;
  const SettingsScreen({required this.numberOfPlayers,required this.playerNames,});

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

  @override
  void initState() {
    super.initState();

    // Automatically select the first and last option based on the number of players
    if (widget.numberOfPlayers == 6) {
      hatSelected = true; // First option (Hat) selected
      undergroundSelected = true; // Last option (Underground) selected
    }


    // If there are 5 players, check the Head option by default
    if (widget.numberOfPlayers == 5) {
      headSelected = true;
    }

    if (widget.numberOfPlayers == 4) {
      hatSelected = false;
      undergroundSelected = false;
    }
    
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Select the parts you want to draw",
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
                label: "Hat",
                value: hatSelected,
                onChanged: getOnChanged(0), // Pass the correct onChanged callback
                isCheckbox: widget.numberOfPlayers != 6, // Only show checkbox if not 6 players
                isCross: widget.numberOfPlayers == 4, // Show red cross for 4 players
              ),
              OptionTile(
                icon: Icons.face_5_rounded, // Head icon
                label: "Head",
                value: headSelected,
                onChanged: getOnChanged(1), // Pass the correct onChanged callback
                isCheckbox: false, // Remove checkbox for Head
                isCross: false, // No cross icon
              ),
              OptionTile(
                icon: Icons.person, // Upper body icon
                label: "Upper Body",
                value: upperBodySelected,
                onChanged: getOnChanged(2), // Pass the correct onChanged callback
                isCheckbox: false, // No checkbox
                isCross: false, // No cross icon
              ),
              OptionTile(
                icon: Icons.person_2_outlined, // Lower body icon
                label: "Lower Body",
                value: lowerBodySelected,
                onChanged: getOnChanged(3), // Pass the correct onChanged callback
                isCheckbox: false, // No checkbox
                isCross: false, // No cross icon
              ),
              OptionTile(
                icon: Icons.downhill_skiing, // Feet icon
                label: "Feet",
                value: feetSelected,
                onChanged: getOnChanged(4), // Pass the correct onChanged callback
                isCheckbox: false, // No checkbox
                isCross: false, // No cross icon
              ),
              OptionTile(
                icon: Icons.arrow_downward_sharp, // Underground icon
                label: "Underground",
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
                        hatSelected: hatSelected,
                        undergroundSelected: undergroundSelected,
                        numberofp: widget.numberOfPlayers,
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
                  'Apply',
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
}// Import the GameCanvasScreen



class ShowPlayerNamesScreen extends StatelessWidget {

  final bool hatSelected; // Received from SettingsScreen
  final bool undergroundSelected;
  final int numberofp; 
  final List<String> playerNames;// Received from SettingsScreen

  const ShowPlayerNamesScreen({
    
    required this.hatSelected,
    required this.undergroundSelected,
    required this.numberofp,
    required this.playerNames
  
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Player Selection',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          
        ),
         scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView to avoid overflow
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Progress Indicator
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: Colors.grey[300],
                  color: Color(0xFF2ED0C2), // Blue theme color
                ),
              ),
              SizedBox(height: 20),

              // Title Text
              Text(
                "Ready to Play?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              // Subtitle Text
              Text(
                "Here are your selected options",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Display selected options
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF2ED0C2), size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Hat Selected: ${hatSelected ? 'Yes' : 'No'}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF2ED0C2), size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Underground Selected: ${undergroundSelected ? 'Yes' : 'No'}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Play Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to GameCanvasScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameCanvasScreen(numberOfPlayers: numberofp , hatSelected: hatSelected,playerNames: playerNames,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2ED0C2), // Blue theme color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  elevation: 5,
                ),
                child: Text(
                  'Play',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),  // Further reduced space at the bottom for better padding
            ],
          ),
        ),
      ),
    );
  }
}
