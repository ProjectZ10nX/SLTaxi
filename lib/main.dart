import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mrdrop/screens/ProfileCreate.dart';
=======
import 'package:mrdrop/screens/languageSelection.dart';
import 'package:mrdrop/screens/home_screen.dart';
>>>>>>> df2844511e7d835cc9a456e74d52e20a7a049c37

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      localizationsDelegates: [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English
      ],
=======
    return const MaterialApp(
>>>>>>> df2844511e7d835cc9a456e74d52e20a7a049c37
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Set HomePage as the initial screen
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC5F146),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/bgrlogo.png',
              width: 300,
              height: 300,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
<<<<<<< HEAD
                MaterialPageRoute(builder: (context) => ProfileCreatePage()),
=======
                MaterialPageRoute(builder: (context) => const HomeScreen()),
>>>>>>> df2844511e7d835cc9a456e74d52e20a7a049c37
              );
            },
            child: const Text("Go"),
          ),
        ],
      ),
    );
  }
}
