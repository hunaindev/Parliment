// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_outlined_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:parliament_app/src/features/family_management/domain/entities/member_entity.dart';

class AddMemberDialog extends StatefulWidget {
  final Future<void> Function(MemberEntity member) onCreate;

  const AddMemberDialog({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFF5F7FA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Add Member',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryLightGreen,
                    backgroundImage:
                        imagePath != null ? FileImage(File(imagePath!)) : null,
                    child: imagePath == null
                        ? Icon(Icons.add_a_photo, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 24),
              CustomInputField(
                controller: nameController,
                hintText: 'Name',
                label: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.black,
                    )),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomOutlinedButton(
                    width: MediaQuery.of(context).size.width * 0.35,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: "Cancel",
                    height: 60,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: CustomButton(
                      onPressed: () async {
                        if (_isLoading) return;

                        // if (imagePath == null) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text("Please select an image")),
                        //   );
                        //   return;
                        // }

                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        final member = MemberEntity(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          image: imagePath ?? '',
                        );

                        try {
                          await widget.onCreate(member);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to add member: $e")),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context);
                        }
                      },
                      text: 'Create',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
