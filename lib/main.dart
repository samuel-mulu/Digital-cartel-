import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Import the HomePage widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Friends Bingo House',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to HomePage after a delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/logo.webp',
              fit: BoxFit.cover,
            ),
          ),
          // Centered content without gradient or blur
          const Column(
            children: [
              // App Name at the top
              Padding(
                padding: EdgeInsets.only(top: 50.0), // Add top padding
                child: Text(
                  'Friends Bingo House',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(), // Push the loading indicator down to the bottom
              // Loading indicator at the bottom
              CircularProgressIndicator(
                color: Colors.white,
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
