import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final String name;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final InputBorder? border;
  final double? height;
  final Color? hintTextColor;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.name = '',
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onTap,
    this.border,
    this.height = 60,
    this.hintTextColor,
    this.readOnly = false, // <- ✅ NEW
    this.inputFormatters,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    return TextFormField(
      inputFormatters: widget.inputFormatters,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      focusNode: _focusNode,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: 'Museo-Bolder',
          color:
              widget.hintTextColor ?? const Color.fromARGB(255, 124, 139, 160),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Museo',
          fontSize: 12,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        border: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
        enabledBorder: widget.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryLightGreen,
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: (widget.height! - 24) / 2,
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: isFocused
                      ? AppColors.primaryLightGreen
                      : const Color.fromARGB(135, 24, 24, 24),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      style: const TextStyle(
        fontFamily: 'Museo',
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      cursorColor: AppColors.primaryLightGreen,
    );
  }
}
