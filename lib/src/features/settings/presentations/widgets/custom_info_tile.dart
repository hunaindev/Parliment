import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';

class CustomInfoTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;

  const CustomInfoTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.contentPadding,
  }) : super(key: key);

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      child: ListTile(
        onTap: onTap,
        // tileColor: Colors.blueGrey.shade50,
        title: TextWidget(
          text: title,
          fontWeight: FontWeight.bold,
          // style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            : null,
        leading: leading,
        trailing: trailing,
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
