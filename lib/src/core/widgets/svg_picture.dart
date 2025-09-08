import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPictureWidget extends StatelessWidget {
  final String path;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? color;

  const SvgPictureWidget({
    Key? key,
    required this.path,
    this.width = 24,
    this.height = 24,
    this.fit = BoxFit.contain,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        color: color,
        placeholderBuilder: (context) => Icon(
          Icons.error,
          size: width, // Should be fine since width is non-nullable
          color: Colors.red,
        ),
      ),
    );
  }
}
