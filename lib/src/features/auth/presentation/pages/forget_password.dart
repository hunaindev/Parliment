import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
// import 'package:parliament_app/src/features/auth/presentation/pages/verify_otp.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String _baseUrl = '$baseUrl/api/v1/user/forget-password';

  bool _isLoading = false;

  Future<void> _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      print("response body: ${response.body.toString()}");
      final data = await jsonDecode(response.body);
      print("data: ${data}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset link sent to $email')),
        );
        Future.microtask(() {
          if (!mounted) return;
          GoRouter.of(context)
              .go('/verify-otp?email=$email&token=${data['token']}');
        });
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (_) => VerifyOtpScreen(
        //             email: email,
        //             token: data['token'],
        //           )),
        // );
      } else {
        final responseData = jsonDecode(response.body);
        print("responseData: $responseData");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseData['message'] ?? 'Failed to send reset link')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/onlyLogo.png',
                    height: screenHeight * 0.18,
                  ),
                  SizedBox(height: 20),
                  TextWidget(
                    text: 'Reset Password',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Museo-Bolder',
                    color: AppColors.primaryLightGreen,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enter your email address and we'll send you instructions to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkGray,
                      fontFamily: "Museo-Bolder",
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomInputField(
                    controller: _emailController,
                    validator: _validateEmail,
                    label: 'Email',
                    hintText: 'Enter your email',
                    name: 'email',
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: _isLoading ? 'Please wait...' : 'Send Reset Link',
                    onPressed: _isLoading ? null : _submitEmail,
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
