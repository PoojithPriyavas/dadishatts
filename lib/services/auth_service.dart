import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/core/colors.dart';
import 'package:text_to_speech/core/style.dart';
import 'package:text_to_speech/presentation/auth/wrapper.dart';
import 'package:text_to_speech/provider/voice_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<void> signInWithEmail(
    String email,
    String password,
    BuildContext context,
    VoiceProvider voiceProvider,
  ) async {
    // final prefData = SharedPrefData();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      voiceProvider.setAuthStatus(false);

      if (userCredential.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: whiteColor,
            content: Text(
              "You have no autharization here, Retry with another credentials",
              style: t14RegularBlack,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      voiceProvider.setAuthStatus(false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: whiteColor,
          content: Text(
            "Error :  ${e.code}",
            style: t14RegularBlack,
          ),
        ),
      );
      // print("Error signing in with email: ${e.code}");
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Wrapper()),
        (route) => false,
      );
      print("User signed out successfully.");
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
