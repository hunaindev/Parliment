// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/config/custom_alerts.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
// import 'package:parliament_app/src/features/auth/domain/entities/user_entity.dart';
import 'package:parliament_app/src/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class LinkChild extends StatefulWidget {
  @override
  _LinkChildState createState() => _LinkChildState();
}

class _LinkChildState extends State<LinkChild> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _linkChild() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      if (email.isEmpty) {
        return CustomAlerts.showErrorAlert(
            "Missing Field", "Email is required.");
      }

      try {
        context.read<AuthBloc>().add(
          LinkChildEvent(email, source: "link_child"),
              // LinkChildEvent(
                  // email: _emailController.text, source: "link_child"),
            );
      } catch (e) {
        CustomAlerts.showErrorAlert("Link Failed", e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LinkSuccess && state.source == "link_child") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Child Linked Successfully!')),
            );
            context.go(AppRoutes.childHome);
          } else if (state is AuthError && state.source == "link_child") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
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
                      text: 'Link Parent',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Museo-Bolder',
                      color: AppColors.primaryLightGreen,
                    ),
                    const SizedBox(height: 10),
                    TextWidget(
                      text:
                          'Enter your Parent\'s email address to link their account',
                      textAlign: TextAlign.center,
                      fontSize: 14,
                      color: AppColors.darkGray,
                      fontFamily: "Museo-Bolder",
                    ),
                    const SizedBox(height: 30),
                    CustomInputField(
                      controller: _emailController,
                      label: 'parent Email',
                      hintText: 'Enter parent\'s email',
                      name: 'email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter parent\'s email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomButton(text: "Link Child", onPressed: _linkChild),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
