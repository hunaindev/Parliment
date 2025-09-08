import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_outlined_button.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/profile_bloc.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/profile_event.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/profile_state.dart';

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({super.key});

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  UserEntity? _user; // state variable to hold the user
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    loadUser(); // load user when widget initializes
  }

  void loadUser() async {
    UserEntity? user = context.read<UserCubit>().state; // ✅ always latest
    print(user);
    if (user != null) {
      setState(() {
        _user = user;
        imageUrl = user.image;
        _nameController.text = user.name ?? '';
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
      });
    } else {
      print("No user found in localStorage");
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

  // print("localStorage suer : ${user!.name}");

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
      if (state is ProfileUpdated) {
        context.read<UserCubit>().setUser(state.user);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );

        Navigator.pop(context); // Now close after success
      } else if (state is ProfileError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    }, builder: (context, state) {
      final isLoading = state is ProfileUpdating;

      return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AbsorbPointer(
            // ⛔ Prevent interaction during loading
            absorbing: isLoading,
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
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  const TextWidget(
                    text: 'Edit Profile',
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
                          : (_user?.image != null && _user!.image!.isNotEmpty
                              ? NetworkImage(_user!.image!) as ImageProvider
                              : null),
                      child: _imageFile == null &&
                              (_user?.image == null || _user!.image!.isEmpty)
                          ? const Icon(Icons.camera_alt,
                              size: 30, color: Colors.grey)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    controller: _nameController,
                    label: 'Full Name',
                    hintText: 'Full Name',
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _phoneController,
                    label: "Phone Number",
                    hintText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomOutlinedButton(
                        width: MediaQuery.of(context).size.width * 0.40,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        title: "Cancel",
                        height: 60,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: CustomButton(
                          onPressed: () {
// This correctly dispatches the event to the BLoC instance found in the context.
                            context.read<ProfileBloc>().add(UpdateUserProfile(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  imagePath: _imageFile?.path,
                                ));
                            // Navigator.pop(context);
                          },
                          text: 'Save',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
