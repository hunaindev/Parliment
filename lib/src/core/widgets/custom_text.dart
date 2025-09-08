import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final String fontFamily;
  final TextAlign? textAlign; // Nullable for optional alignment
  final int? maxLines; // Nullable for optional line limit
  final TextOverflow? overflow; // Nullable for optional overflow behavior
  final TextDecoration? textDecoration; // Nullable for optional decoration
  final double? letterSpacing; // Nullable for optional letter spacing
  final double? wordSpacing; // Nullable for optional word spacing

  const TextWidget({
    super.key,
    required this.text,
    this.fontSize = 16.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontFamily = 'Museo-Bold',
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textDecoration,
    this.letterSpacing,
    this.wordSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        // textDecoration: textDecoration,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}