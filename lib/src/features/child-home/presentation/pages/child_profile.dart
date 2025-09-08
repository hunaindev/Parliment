// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
// import 'package:parliament_app/src/core/widgets/custom_outlined_button.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/profile_bloc.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/profile_event.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/profile_state.dart';

class ChildProfileScreen extends StatefulWidget {
  const ChildProfileScreen({super.key});

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  UserEntity? _user;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _dobController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() {
    UserEntity? user = context.read<UserCubit>().state;
    if (user != null) {
      print("user: $user");
      setState(() {
        _user = user;
        imageUrl = user.image;
        _firstNameController.text = user.name?.split(' ').first ?? '';
        _lastNameController.text = user.name?.split(' ').last ?? '';
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          context.read<UserCubit>().setUser(state.user);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile updated successfully")),
          );
          // Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileUpdating;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AbsorbPointer(
            absorbing: isLoading,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    const TextWidget(
                      text: 'Edit Child Profile',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Museo-Bolder",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _imageFile != null
                            ? FileImage(File(_imageFile!.path))
                            : (imageUrl != null && imageUrl!.isNotEmpty
                                ? NetworkImage(imageUrl!) as ImageProvider
                                : null),
                        child: _imageFile == null &&
                                (imageUrl == null || imageUrl!.isEmpty)
                            ? const Icon(Icons.camera_alt,
                                size: 30, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      controller: _firstNameController,
                      label: 'First Name',
                      hintText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      controller: _lastNameController,
                      label: "Last Name",
                      hintText: "Last Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      controller: _emailController,
                      label: "Email",
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      controller: _phoneController,
                      label: "Phone Number",
                      hintText: "Phone Number",
                      keyboardType: TextInputType.phone,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.primaryLightGreen,
                          )
                        : CustomButton(
                            fontSize: 16,
                            onPressed: () {
                              context.read<ProfileBloc>().add(UpdateUserProfile(
                                    name:
                                        "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
                                    email: _user?.email ?? '',
                                    phone: _phoneController.text.trim(),
                                    imagePath: _imageFile?.path,
                                  ));
                            },
                            textColor: Colors.white,
                            text: 'Update Profile',
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
