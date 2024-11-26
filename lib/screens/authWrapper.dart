import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrdrop/main.dart';
import 'package:mrdrop/screens/EmailVerification.dart';
import 'package:mrdrop/screens/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  String? nullTxt = "null";
  String? Email = "nomaile";
  Future<String?> _checkRegister() async {
    if (user != null) {
      // Get email from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (userDoc.exists && userDoc.data()?['email'] != null) {
        Email = userDoc.data()?['email'].toString();
        nullTxt = Email;
        return Email;
      } else {
        return nullTxt;
      }
    }
    return nullTxt;
  }

  @override
  Widget build(BuildContext context) {
    _checkRegister();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is authenticated
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            if (user.emailVerified) {
              return const HomeScreen();
            } else if (nullTxt != "null") {
              return EmailVerification(
                Email: Email,
                uid: user.uid,
              );
            } else {
              return EmailVerification(
                Email: Email,
                uid: user.uid,
              );
            }
            // Navigate to the home screen if authenticated
          } else {
            // Navigate to the login screen if not authenticated
            return const HomePage();
          }
        }

        // Show a loading spinner while waiting for authentication state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
