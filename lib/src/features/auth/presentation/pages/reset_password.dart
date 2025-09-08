import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/reset_password_remote_datasource.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String accessToken;
  const ResetPasswordScreen({required this.accessToken, super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = _newPasswordController.text.trim();

    setState(() => _isLoading = true);

    try {
      final message = await ResetPasswordRemoteDatasource().resetPassword(
        newPassowrd: newPassword,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Password reset successful')),
      );
      GoRouter.of(context).go('/login');

      // Navigator.pop(context); // You can redirect to login screen instead
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/icons/onlyLogo.png',
                      height: screenHeight * 0.18),
                  const SizedBox(height: 20),
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Museo-Bolder',
                      color: AppColors.primaryLightGreen,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Set your new password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGray,
                        fontFamily: "Museo-Bolder"),
                  ),
                  const SizedBox(height: 30),
                  CustomInputField(
                    controller: _newPasswordController,
                    label: 'New Password',
                    hintText: 'Enter new password',
                    name: 'new_password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hintText: 'Re-enter new password',
                    name: 'confirm_password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _newPasswordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: _isLoading ? 'Resetting...' : 'Reset Password',
                    onPressed: _isLoading ? null : _resetPassword,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
