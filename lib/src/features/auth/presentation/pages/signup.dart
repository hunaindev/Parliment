// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/services/location_service.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
// import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/custom_text_button.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/divider_section.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/social_buttons_section.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/terms_checkbox.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(text: '');
  // final _parentEmailController = TextEditingController(text: '');
  final _passwordController = TextEditingController();
  bool _termsAccepted = false;
  var role = null;
  void initState() {
    super.initState();
    role = context.read<RoleCubit>().state;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() async {
    print("signup ");
    if (_formKey.currentState!.validate()) {
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please accept the terms and conditions')),
        );
        return;
      }

      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        final deviceToken = await LocalStorage.getDeviceToken();

        if (email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Email and password are required.")),
          );
          return;
        }

        final service = LocationService();
        print("📍 Getting location...");
        final location = await service.getCurrentLocation();
        print("📍 location: $location");

        print("Longitude: ${location?.longitude}");
        print("Latitude: ${location?.latitude}");

        final bloc = context.read<AuthBloc>();
        print("👉 Bloc instance: $bloc");

        bloc.add(SignupEvent(
          UserEntity(
            name: _nameController.text,
            email: email,
            password: password,
            deviceToken: deviceToken.toString(),
            lat: location?.latitude?.toString(),
            lng: location?.longitude?.toString(),
          ),
          source: "signup",
        ));
      } catch (e, stackTrace) {
        print("❌ Signup error: $e");
        print("🔍 StackTrace: $stackTrace");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.toString()}')),
        );
      }
    }
  }

  void _navigateToSignIn() {
    context.push(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print("state.source ${state.source}");
          if (state is AuthSuccess && state.source == "signup") {
            print("🔁 Auth State Changed: ${state.user.role}");
            context
                .read<UserCubit>()
                .setUser(state.user); // <-- Global user state set

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('SignUp success!')),
            );
            context.go(AppRoutes.role);
            // CustomAlerts.showInfoAlert("Success", "Login");
            // if (state.user.role == "child") context.go(AppRoutes.);
            // if (state.user.role == "parent")
          } else if (state is AuthError && state.source == "signup") {
            // print(state);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
            print("📣 Showing snackbar for error: ${state.message}");
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
                      text: 'Sign Up',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Museo-Bolder',
                      color: AppColors.primaryLightGreen,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'It was popularised in the 1960s with the release of Letraset sheetscontaining Lorem Ipsum.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGray,
                        fontFamily: "Museo-Bolder",
                      ),
                    ),
                    const SizedBox(height: 20),
                    SocialButtonsSection(),
                    const SizedBox(height: 20),
                    DividerSection(),
                    const SizedBox(height: 20),
                    CustomInputField(
                      controller: _nameController,
                      label: 'Name',
                      hintText: 'Enter your name',
                      name: 'name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomInputField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      name: 'email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
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
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // if (role == "child")
                    //   CustomInputField(
                    //     controller: _parentEmailController,
                    //     label: 'Parent Email',
                    //     hintText: 'Enter your parent email',
                    //     name: 'Parent Email',
                    //     validator: (value) {
                    //       if (value == null || value.isEmpty) {
                    //         return 'Please enter parent email';
                    //       }
                    //       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}')
                    //           .hasMatch(value)) {
                    //         return 'Please enter a valid email';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    const SizedBox(height: 10),
                    FormField<bool>(
                      validator: (value) {
                        if (!_termsAccepted) {
                          return 'You must accept the terms and conditions';
                        }
                        return null;
                      },
                      builder: (state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TermsCheckboxRow(
                            onChanged: (value) {
                              setState(() {
                                _termsAccepted = value ?? false;
                              });
                              state.didChange(value);
                            },
                            value: _termsAccepted,
                          ),
                          if (state.hasError)
                            Text(
                              state.errorText!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                      return Stack(
                        alignment: Alignment
                            .center, // Center the loader over the button
                        children: [
                          Opacity(
                            opacity: state is SignupLoading ? 0.5 : 1.0,
                            child: CustomButton(
                              text: "Create Account",
                              onPressed: _signup,
                            ),
                          ),
                          // CustomButton(
                          //   text: "Create Account",
                          //   onPressed: _signup,
                          // ),
                          // if (state is ifdjsk)
                          //   const Positioned.fill(
                          //     child: Center(
                          //       child: CircularProgressIndicator(
                          //         color: AppColors.primaryLightGreen,
                          //       ),
                          //     ),
                          //   ),
                        ],
                      );
                    }),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Do you have account?",
                          style: TextStyle(color: AppColors.darkBrown),
                        ),
                        const SizedBox(width: 4),
                        CustomTextButton(
                            onTap: _navigateToSignIn, text: "Sign In")
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
