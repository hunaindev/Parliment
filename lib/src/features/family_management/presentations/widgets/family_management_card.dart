// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/core/widgets/svg_picture.dart';
import 'package:parliament_app/src/features/family_management/domain/entities/member_entity.dart';
import 'package:parliament_app/src/features/family_management/presentations/widgets/delete_modal.dart';
import 'package:parliament_app/src/features/family_management/presentations/widgets/edit_modal.dart';

class FamilyMemberCard extends StatelessWidget {
  final String name;
  final MemberEntity member;
  // final VoidCallback onEdit;
  final Future<void> Function(MemberEntity member) onEdit;

  final VoidCallback onDelete;

  const FamilyMemberCard({
    super.key,
    required this.name,
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      height: 95,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.darkGray, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primaryLightGreen,
                  child: member.image.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            member.image,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: name,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone,
                              color: AppColors.primaryLightGreen, size: 16),
                          SizedBox(
                            width: 4,
                          ),
                          TextWidget(
                            text: member.phone,
                            fontSize: 12,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => EditMemberDialog(
                      name: name,
                      member: member,
                      onSave: onEdit,
                    ),
                  ),
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
                    builder: (context) => DeleteConfirmationDialog(
                      onConfirm: onDelete,
                    ),
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
