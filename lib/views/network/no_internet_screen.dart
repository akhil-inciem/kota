import 'package:flutter/material.dart';
import 'dart:math';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> with SingleTickerProviderStateMixin {
  bool isSpinning = false;
  double rotationTurns = 0;

  void _onTryAgainPressed() async {
    setState(() {
      isSpinning = true;
      rotationTurns += 1; // One full turn (360°)
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isSpinning = false;
    });

    // Optional: Add logic to recheck network status here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                Text(
                  'No Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'You’re offline. Please check your internet connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: isSpinning ? null : _onTryAgainPressed,
                  icon: AnimatedRotation(
                    turns: rotationTurns,
                    duration: Duration(seconds: 2),
                    curve: Curves.linear,
                    child: Icon(Icons.refresh),
                  ),
                  label: Text("Try Again"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
