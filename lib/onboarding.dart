import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foldolino/gamemode.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FoldolinoOnboardingScreen extends StatefulWidget {
  @override
  _FoldolinoOnboardingScreenState createState() => _FoldolinoOnboardingScreenState();
}

class _FoldolinoOnboardingScreenState extends State<FoldolinoOnboardingScreen> {
  final PageController _controller = PageController();

  final List<OnboardingContent> contents = [
    OnboardingContent(
      image: 'assets/images/onboard1.png',
      title: "Create Together",
      description:
          "Draw different parts with friends and combine them into unique characters.",
   
    ),
    OnboardingContent(
      image: 'assets/images/onboard2.png',
      title: "Explore Creativity",
      description:
          "Unleash your imagination with every stroke and share it with the world.",
    ),
    OnboardingContent(
      image: 'assets/images/onboard3.png',
      title: "Play & Discover",
      description:
          "Pass the screen, add your piece, and watch art come to life, part by part.",
    ),
  ];

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
              itemCount: contents.length,
              itemBuilder: (context, index) => _buildLandscapeContent(contents[index], screenWidth, screenHeight),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: contents.length,
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
                        'PLAY FOLDOLINO',
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
                      onPressed: () {
                        // Add functionality for "HOW DO I PLAY THIS GAME?" if needed
                      },
                      child: Text(
                        'HOW DO I PLAY THIS GAME?',
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

  Widget _buildLandscapeContent(OnboardingContent content, double screenWidth, double screenHeight) {
    final textWidth = screenWidth * 0.5; // Constrain text width to force line wrapping

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              content.image,
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
                  content.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: screenHeight * 0.06, // Larger title size
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2ED0C2),
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  width: textWidth, // Limit width to force line breaks
                  child: Text(
                    content.description,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: screenHeight * 0.045, // Larger description size
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.5, // Adjust line height for readability
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

class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}
