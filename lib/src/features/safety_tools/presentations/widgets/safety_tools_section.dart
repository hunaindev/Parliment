import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';

class SafetyToolSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback? onTap;

  const SafetyToolSection({
    super.key,
    required this.title,
    required this.items,
    this.onTap,
  });

  @override
  /// Builds the widget for a safety tool section with a title, list of items, and optional tap handler.
/// Builds the widget for a safety tool section with a title, list of items, and optional tap handler.
    ///
    /// The widget creates a container with a white background, grey border, and rounded corners.
    /// It displays the section title using a bold text style and lists the provided items with bullet points.
    /// When tapped, it triggers the optional [onTap] callback.
    ///
    /// Parameters:
    /// - [title]: The main title of the safety tool section
    /// - [items]: A list of strings representing the items in the section
    /// - [onTap]: An optional callback function triggered when the section is tapped
    ///
    /// Returns a [Widget] representing the safety tool section with interactive capabilities
    Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.darkGray,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          splashColor: const Color.fromARGB(255, 227, 227, 227).withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: title,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Museo-Bold',
                      ),
                      const SizedBox(height: 8.0),
                      ...items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 14,
                                    color: Color.fromARGB(255, 51, 56, 61),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 51, 56, 61),
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.visible,
                                    // fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
