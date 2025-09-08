import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_outlined_button.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/link_code_state.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/reset_password_cubit.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, LinkState>(
      listener: (context, state) {
        if (state is LinkLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is LinkSuccess) {
          Navigator.of(context).pop(); // Close loading dialog
          Navigator.of(context).pop(); // Close bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password updated successfully")),
          );
        } else if (state is LinkError) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(height: 20),
              const TextWidget(
                text: 'Change Password',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Museo-Bolder",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const TextWidget(
                text: "New Password",
                fontWeight: FontWeight.bold,
              ),
              CustomInputField(
                controller: _newPassword,
                obscureText: true,
                hintText: 'New Password',
                label: 'New Password',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter new password';
                  }
                  if (value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
              const SizedBox(height: 16),
              const TextWidget(
                text: "Confirm Password",
                fontWeight: FontWeight.bold,
              ),
              CustomInputField(
                controller: _confirmPassword,
                obscureText: true,
                hintText: 'Confirm Password',
                label: 'Confirm Password',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value.trim() != _newPassword.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
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
                        if (_formKey.currentState!.validate()) {
                          final newPass = _newPassword.text.trim();
                          context
                              .read<ResetPasswordCubit>()
                              .resetPassword(newPass);
                        }
                      },
                      text: 'Save',
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
