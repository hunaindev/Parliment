// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/config/custom_alerts.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/custom_text_button.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/divider_section.dart';
import 'package:go_router/go_router.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/social_buttons_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:parliament_app/src/core/utils/get_FCM_Token.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    // print("login dart");
    // final prefs = await SharedPreferences.getInstance();
    final token = await LocalStorage.getToken();
    final userRole = await LocalStorage.getRole();
    final user = await LocalStorage.getUser();
    // final prefs = await SharedPreferences.getInstance();
    // print("Remaining keys: ${prefs.getKeys()}");

    print("token: ${token}");
    print("userROle: ${userRole}");
    if (token != null && userRole != null) {
      if (user != null && !user.isVerify!) {
        print("object");
      } else {
        if (userRole == "child" && user != null) {
          print(user.isLinked);
          if (user.isLinked == false) {
            context.go(AppRoutes.linkToParent);
          } else {
            context.go(AppRoutes.childHome);
          }
        } else if (userRole == "parent") {
          // ignore: use_build_context_synchronously
          context.go(AppRoutes.parentHome);
        } else {
          context.go(AppRoutes.role);
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      print(email);
      if (email.isEmpty || password.isEmpty) {
        return CustomAlerts.showErrorAlert(
            "Missing Fields", "Email and password are required.");
      }

      try {
        var deviceToken = await getFCMToken();
        print("deviceToken: $deviceToken");
        context.read<AuthBloc>().add(
              LoginEvent(
                  UserEntity(
                    email: _emailController.text,
                    password: _passwordController.text,
                    deviceToken: deviceToken,
                  ),
                  source: "login"),
            );
      } catch (e) {
        CustomAlerts.showErrorAlert("Login Failed", e.toString());
      }
    }
  }

  void _navigateToSignUp() {
    context.push(AppRoutes.signup);
  }

  void _navigateToForgetPassword() {
    context.push(AppRoutes.forgetPassword);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print("state.source: ${state.source}");

          if (state is AuthSuccess && state.source == "login") {
            print("🔁 Auth State Changed: ${state.user.role}");
            context.read<UserCubit>().setUser(state.user);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Success!')),
            );
            if (state.user.role == null || state.user.role!.isEmpty) {
              context.go(AppRoutes.role);
            }

            // if (state.user.role == "child") {
            //   print("state.user.role: ${state.user.isLinked}");
            //   if (state.user.isLinked == false) {
            //     context.go(AppRoutes.linkToParent); // 🔁 Redirect if not linked
            //   } else {
            //     context.go(AppRoutes.childHome);
            //   }
            // }
            if (state.user.role == "child") {
              print("state.user.role: ${state.user.isLinked}");
              if (state.user.isLinked != null && state.user.isLinked!) {
                context.go(AppRoutes.childHome);
              } else {
                context.go(AppRoutes.linkToParent);
              }
            }
            if (state.user.role == "parent") context.go(AppRoutes.parentHome);
          } else if (state is AuthError && state.source == "login") {
            if (state.message == "Otp Not Verify") {
              context.go(AppRoutes.otpVerify);
            } else {
              print("error: ${state.message}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/onlyLogo.png',
                      height: screenHeight * .20,
                    ),
                    TextWidget(
                      text: 'Sign In',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Museo-Bolder',
                      color: AppColors.primaryLightGreen,
                    ),
                    const SizedBox(height: 10),
                    TextWidget(
                      text:
                          'It was popularised in the 1960s with the release of Letraset sheetscontaining Lorem Ipsum.',
                      textAlign: TextAlign.center,
                      fontSize: 14,
                      color: AppColors.darkGray,
                      fontFamily: "Museo-Bolder",
                    ),
                    const SizedBox(height: 20),
                    SocialButtonsSection(),
                    const SizedBox(height: 20),
                    DividerSection(),
                    const SizedBox(height: 10),
                    CustomInputField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      name: 'email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomInputField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      name: 'password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomTextButton(
                        onTap: _navigateToForgetPassword,
                        text: 'Forget Password?',
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                      return Opacity(
                        opacity: state is LoginLoading ? 0.5 : 1.0,
                        child: IgnorePointer(
                          ignoring: state is LoginLoading,
                          child:
                              CustomButton(text: "Log In", onPressed: _login),
                        ),
                      );
                    }),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Don't have account?",
                          style: TextStyle(
                              color: AppColors.darkBrown,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        CustomTextButton(
                            onTap: _navigateToSignUp, text: "Signup")
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
