import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  GradientText(
    this.text,
    this.textsize, {
    required this.gradient,
  });

  final String text;
  final double textsize;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Lato",
          fontWeight: FontWeight.bold,
          // The color must be set to white for this to work
          color: Colors.white,
          fontSize: textsize,
        ),
      ),
    );
  }
}
