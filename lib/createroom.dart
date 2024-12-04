import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  late String roomCode;
  bool isButtonEnabled = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    roomCode = generateRoomCode();
    _createGame();
    // Start polling every 5 seconds
    
  }

  // Generate a random room code between 1000 and 9999
  String generateRoomCode() {
    final random = Random();
    int roomCode = 1000 + random.nextInt(9000);
    return roomCode.toString();
  }

  // Create a new game in the Supabase database
  Future<void> _createGame() async {
    final response = await Supabase.instance.client.from('games').insert({
      'game_code': roomCode,
      'number_of_players': 1,
    });

    if (response.error != null) {
      print('Error creating game: ${response.error!.message}');
    } else {
      print('Game created with code: $roomCode');
    }
    print("calling add player");

    // Add the creator as the first player
    _addPlayer();
  }

  // Add a new player to the game
 Future<void> _addPlayer() async {
  // Prepare the player data
  Map<String, dynamic> playerData = {
    'player_name': 'Player1', // Replace this with the actual player's name dynamically
    'game_code': roomCode,     // Use the dynamically generated game code
    'player_number': 1,        // You can dynamically assign player_number based on your logic
    'joined_at': DateTime.now().toIso8601String(), // Timestamp when the player joins
  };

  // Debugging: Log the player data being sent
  print("Adding player with the following data: $playerData");

  final response = await Supabase.instance.client.from('players').insert([playerData]);

  // Debugging: Check if there was an error in the response
  if (response.error != null) {
    print('Error adding player: ${response.error!.message}');
    print('Error details: ${response.error!.details}');
  } else {
    print('Player added to the game successfully.');
    print('Response data: ${response.data}');
  }
}


  // Update the number of players in the game
  Future<void> _updatePlayerCount() async {
    final response = await Supabase.instance.client
        .from('players')
        .select('count')
        .eq('game_code', roomCode);
        

    if (response != null) {
      print('Error fetching player count: ${response}');
      return;
    }

    final playerCount = response[0]['count'];
    if (playerCount >= 4) {
      setState(() {
        isButtonEnabled = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the screen is disposed
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.3,
                child: LinearProgressIndicator(
                  value: 1,
                  backgroundColor: Colors.grey[300],
                  color: Color(0xFF2ED0C2),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              Text(
                "Room Code",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenHeight * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.01),

              Text(
                roomCode,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenHeight * 0.1,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2ED0C2),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),

              Text(
                "Waiting for other players...",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenHeight * 0.04,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.1),

              ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        // Navigate to the game screen or start the game
                        print("Game started");
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled ? Color(0xFF2ED0C2) : Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Start",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenHeight * 0.05,
                    fontWeight: FontWeight.bold,
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
