// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_outlined_button.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFF5F7FA),
      insetPadding:
          EdgeInsets.symmetric(horizontal: 16), // Full-width on mobile
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child:
          // SizedBox(
          //   width: double.infinity,
          //   height: MediaQuery.of(context).size.height * 0.30,
          //   child:
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // This make the modal to expand as need
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextWidget(
                  text: 'Delete Member',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 20),
                Text(
                  'Are you sure you want to delete this member?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomOutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: "Cancel",
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.35,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: CustomButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    text: 'Delete',
                  ),
                ),
              ],
            ),
          ],
        ),
        // ),
      ),
    );
  }
}
