import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'onboarding.dart'; // Import the Foldolino onboarding screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://daphaycufnkiqbrieqep.supabase.co', // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRhcGhheWN1Zm5raXFicmllcWVwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI0Nzk4MjEsImV4cCI6MjA0ODA1NTgyMX0.Im5BP760LWtg0Lcbee6B34Gl3HL-9K-nxhP8lctpDr0',  // Replace with your Supabase anon API key
  );
  runApp(FoldolinoApp());
}

class FoldolinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foldolino',
      theme: ThemeData(
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0xFF2ED0C2), // Set cyan color for CircularProgressIndicator
        ),
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF2ED0C2), // Set cursor color to cyan
          selectionColor: Color(0xFFD1ECE9), // Set the selection color
          selectionHandleColor: Color(0xFF2ED0C2), // Set the selection handle color
        ),
      ),
      home: FoldolinoOnboardingScreen(), // Set the onboarding screen as the home screen
      routes: {
        '/onboarding': (context) => FoldolinoOnboardingScreen(),
        // Add other routes here as needed, e.g., AccountTypeScreen, LoginScreen, etc.
      },
    );
  }
}
