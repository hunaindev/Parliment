import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CustomSlideAction extends StatelessWidget {
  final Key slideKey;
  final String text;
  final Color textColor;
  final Color outerColor;
  final IconData iconData;
  final VoidCallback onSubmit;

  const CustomSlideAction({
    required this.slideKey,
    required this.text,
    required this.textColor,
    required this.outerColor,
    required this.iconData,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      key: slideKey,
      text: text,
      textStyle: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      outerColor: outerColor,
      innerColor: Colors.white,
      sliderButtonIcon: Icon(
        iconData,
        color: outerColor,
        size: 20,
      ),
      onSubmit: () {
        onSubmit();
        return null;
      },
      elevation: 0,
    );
  }
}
