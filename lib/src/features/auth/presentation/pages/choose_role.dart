// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:parliament_app/main.dart';
// import 'package:parliament_app/main.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/auth_bloc.dart';
// import 'package:parliament_app/src/features/auth/presentation/blocs/auth_bloc.dart';
// import 'package:parliament_app/src/core/widgets/drawer_widget.dart';
// import 'package:parliament_app/src/core/widgets/svg_picture.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/role_cubit.dart';
import 'package:parliament_app/src/features/auth/presentation/widgets/role_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChooseRoleScreen extends StatefulWidget {
  @override
  _ChooseRoleScreenState createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  String? _selectedRole;
  // final String finalRole;

  void _continueAction() {
    // final state = context.read<AuthBloc>().state;

    // if (state is AuthSuccess) {
    if (_selectedRole != null) {
      print(_selectedRole);
      context.read<RoleCubit>().chooseRole(_selectedRole!.toLowerCase());
      context
          .read<AuthBloc>()
          .add(ChooseRoleEvent(_selectedRole!.toLowerCase()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RoleSuccess) {
          print("🔁 Auth State Changed: ${state.source}");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Role selection success !')),
          );

          if (state.user.role == "child") {
            if (state.user.isVerify!) {
              if (state.user.isLinked == false) {
                context.go(AppRoutes.linkToParent); // 🔁 Redirect if not linked
              } else {
                context.go(AppRoutes.childHome);
              }
            } else {
              context.go(AppRoutes.otpVerify);
            }
          }
          if (state.user.role == "parent") {
            print("Not Fsdfwdfsfsfsdfsdfsdff");
            if (state.user.isVerify != null && state.user.isVerify!) {
              context.go(AppRoutes.parentHome);
            } else {
              context.go(AppRoutes.otpVerify);
            }
          }
        } else if (state is AuthError) {
          // print(state);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );

          // CustomAlerts.showErrorAlert("Error", state.message);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 40),
                // Logo
                Image.asset(
                  "assets/icons/onlyLogo.png",
                  height: screenHeight * .20,
                ),
                // SvgPictureWidget(path: "assets/icons/logo.svg", height: 120),

                // const SizedBox(height: 10),
                // Title
                const TextWidget(
                  text: '1Parliament1',
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Museo-Bolder',
                  color: AppColors.primaryLightGreen,
                ),
                const SizedBox(height: 30),
                // Subtitle
                const TextWidget(
                  text: 'Get Started',
                  fontSize: 20,
                  color: AppColors.darkBrown,
                  fontFamily: 'Museo-Bolder',
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 6),
                // Description
                const TextWidget(
                  text:
                      'This is an app that allows Parents to gently monitor the safety of their children from sex offenders.',
                  textAlign: TextAlign.center,
                  // fontSize: 18,
                  color: AppColors.darkBrown,
                  fontFamily: 'Museo-Bold',
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 30),
                const TextWidget(
                  text: 'Which one are you?',
                  fontSize: 20,
                  color: AppColors.darkGray,
                  fontFamily: 'Museo-Bolder',
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 10),

                // const SizedBox(height: 30),
                // Role Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoleButton(
                      label: 'Parent',
                      imagePath: 'assets/icons/parent.svg',
                      isSelected: _selectedRole == 'Parent',
                      onTap: () {
                        setState(() {
                          _selectedRole = 'Parent';
                        });
                      },
                    ),
                    RoleButton(
                      label: 'Children',
                      imagePath: 'assets/icons/children.svg',
                      isSelected: _selectedRole == 'child',
                      onTap: () {
                        setState(() {
                          _selectedRole = 'child';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Continue Button
                BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                  return Opacity(
                    opacity: state is AuthLoading ? 0.5 : 1.0,
                    child: IgnorePointer(
                      ignoring: state is AuthLoading,
                      child: CustomButton(
                        text: "Continue",
                        onPressed: () {
                          print("object");
                          _continueAction();
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
