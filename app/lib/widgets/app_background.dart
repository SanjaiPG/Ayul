// File: lib/widgets/app_background.dart

import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We use a Stack to place the Image in the background and the child in the foreground.
    return Stack(
      children: <Widget>[
        // 1. Background Image
        Positioned.fill(
          child: Image.asset(
            // NOTE: You MUST add this asset path to your pubspec.yaml file under 'assets:'
            'assets/images/mandala_background.jpg',
            fit:
                BoxFit.cover, // Ensures the image covers the entire screen area
            alignment: Alignment
                .centerRight, // Adjusts the positioning to keep the mandala pattern visible
            opacity: const AlwaysStoppedAnimation<double>(
                0.9), // Set opacity for a subtle watermark effect
          ),
        ),

        // 2. The main content of the app
        child,
      ],
    );
  }
}
