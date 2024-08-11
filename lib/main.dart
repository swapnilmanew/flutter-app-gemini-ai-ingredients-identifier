import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gemini/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(apiKey: 'AIzaSyAIB5CUUEVZfZk0YLq2sn1ulyTmtebFLVU');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.sora().fontFamily),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
