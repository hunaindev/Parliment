// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_outlined_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:parliament_app/src/features/family_management/domain/entities/member_entity.dart';

class EditMemberDialog extends StatefulWidget {
  final String name;
  final MemberEntity member;
  final Future<void> Function(MemberEntity member) onSave;
  // final VoidCallback onSave;

  const EditMemberDialog({
    Key? key,
    required this.name,
    required this.member,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditMemberDialog> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<EditMemberDialog> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.member.name);
    phoneController = TextEditingController(text: widget.member.phone);
    imagePath =
        widget.member.image.isNotEmpty == true ? widget.member.image : null;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          imagePath = image.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  bool isLoading = false;

  void _handleSave() async {
    setState(() => isLoading = true);

    final updated = MemberEntity(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      relation: widget.member.relation,
      email: widget.member.email,
      image: imagePath ?? widget.member.image,
      imagePath: imagePath ?? null,
    );

    try {
      await widget.onSave(updated); // make this return a Future<bool>
      if (mounted) {
        Navigator.pop(context); // close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Member updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFF5F7FA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      // child:
      // SizedBox(
      //   width: double.infinity,
      //   height: MediaQuery.of(context).size.height * 0.55,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // <-- This is important

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Edit Member',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: imagePath != null
                      ? (imagePath!.startsWith('http')
                          ? NetworkImage(imagePath!) as ImageProvider
                          : FileImage(File(imagePath!)))
                      : null,
                  child: imagePath == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 24),
            CustomInputField(
              controller: nameController,
              hintText: 'Name',
              label: 'Name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black,
                  )),
            ),
            SizedBox(height: 16),
            CustomInputField(
              controller: phoneController,
              label: 'Phone Number',
              hintText: 'Phone Number',
              keyboardType: TextInputType.phone,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black,
                  )),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomOutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: "Cancel",
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 60,
                ),
                SizedBox(width: 8),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: AppColors.primaryLightGreen,
                      ))
                    : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: CustomButton(
                          onPressed: () {
                            _handleSave();
                          },
                          text: isLoading ? 'Saving...' : 'Save',
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
