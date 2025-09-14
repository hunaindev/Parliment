// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_constants.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/auth/data/models/user_model.dart';
// import 'package:parliament_app/src/features/auth/presentation/pages/reset_password.dart';
// import 'package:parliament_app/src/core/widgets/text_widget.dart';
// import 'reset_password_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String token; // Add token from previous screen

  VerifyOtpScreen({required this.email, required this.token});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    _otpControllers.forEach((c) => c.dispose());
    _focusNodes.forEach((f) => f.dispose());
    super.dispose();
  }

  void _submitOtp() async {
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all 4 digits')),
      );
      return;
    }

    try {
      String? token = await LocalStorage.getToken();
      print(token);

      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/user/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode({'otp': otp}),
      );
      final data = jsonDecode(response.body);
      print(otp);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP Verified')),
        );

        if (widget.email.isNotEmpty && widget.token.isNotEmpty) {
          GoRouter.of(context).go('/reset-password?email=${widget.email}');
        } else {
          await LocalStorage.saveToken(data['accessToken']);
          final selectedUser = UserModel.fromJson(data['userJson']);
          await LocalStorage.saveUser(selectedUser);
          await LocalStorage.saveRole(selectedUser.role);
          Future.microtask(() {
            if (!mounted) return;
            if (selectedUser.role == "parent") {
              context.go(AppRoutes.parentHome);
            } else {
              if (selectedUser.isLinked == false) {
                context.go(AppRoutes.linkToParent); // 🔁 Redirect if not linked
              } else {
                context.go(AppRoutes.childHome);
              }
            }
            // GoRouter.of(context).go('/reset-password?email=${widget.email}');
          });
        }

        // Navigate to Reset Password Screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (_) =>
        //           ResetPasswordScreen(accessToken: data['accessToken'])),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed to verify OTP')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.email + widget.token);
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Image.asset('assets/icons/onlyLogo.png',
                    height: screenHeight * 0.18),
                SizedBox(height: 20),
                TextWidget(
                  text: 'Verify OTP',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Museo-Bolder',
                  color: AppColors.primaryLightGreen,
                ),
                SizedBox(height: 10),
                Text(
                  "Enter the OTP sent to ${widget.email}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkGray,
                      fontFamily: "Museo-Bolder"),
                ),
                SizedBox(height: 30),

                // OTP 4 Box Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 50,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryLightGreen),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.primaryLightGreen, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[index + 1]);
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[index - 1]);
                          }
                        },
                      ),
                    );
                  }),
                ),

                SizedBox(height: 30),
                CustomButton(text: 'Verify OTP', onPressed: _submitOtp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
