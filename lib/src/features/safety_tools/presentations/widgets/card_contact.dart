// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/core/widgets/svg_picture.dart';
import 'package:parliament_app/src/features/family_management/presentations/widgets/delete_modal.dart';
// import 'package:parliament_app/src/features/family_management/presentations/widgets/edit_modal.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ContactCard({
    super.key,
    required this.name,
    required this.phone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkGray),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFD3D3F4),
                child: Icon(Icons.person, color: Colors.grey[600], size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    text: name,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone,
                          color: AppColors.primaryLightGreen, size: 16),
                      const SizedBox(width: 4),
                      TextWidget(
                        text: phone,
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  // onTap: () => showDialog(
                  //   context: context,
                  //   builder: (context) => EditMemberDialog(
                  //     name: name,
                  //     onSave: onEdit,
                  //   ),
                  // ),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPictureWidget(
                      path: "assets/icons/edit.svg",
                      width: 20,
                      color: const Color.fromARGB(255, 51, 56, 61),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) =>
                        DeleteConfirmationDialog(onConfirm: () {}),
                  ),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPictureWidget(
                      path: "assets/icons/delete.svg",
                      width: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
