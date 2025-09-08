// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/services/child_realtime_service.dart';
// import 'package:parliament_app/src/core/services/child_location_service.dart';
import 'package:parliament_app/src/core/services/location_service.dart';
// import 'package:parliament_app/src/core/services/child_firestore_service.dart';
// import 'package:parliament_app/src/core/services/child_location_service.dart';
// import 'package:parliament_app/src/core/services/parent_firestore_service.dart';
// import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
// import 'package:parliament_app/src/features/auth/presentation/blocs/user_cubit.dart';
// import 'package:parliament_app/src/features/home/presentation/blocs/location/location_cubit.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/profile_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/code_generator_cubit.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/link_code_state.dart';
import 'package:go_router/go_router.dart';

class LinkCodeBottomSheet extends StatefulWidget {
  const LinkCodeBottomSheet({super.key});

  @override
  State<LinkCodeBottomSheet> createState() => _LinkCodeBottomSheetState();
}

class _LinkCodeBottomSheetState extends State<LinkCodeBottomSheet> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LinkCubit, LinkState>(
      listener: (context, state) {
        if (state is CodeVerified) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Code Verified Successfully")),
          );
        } else if (state is LinkError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LinkLoading;

        return Container(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                text: 'Enter Link Code',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 24),
              Form(
                key: _formKey,
                child: CustomInputField(
                  label: "Code",
                  hintText: "Enter your 6-letter code",
                  controller: _codeController,
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a code';
                    }
                    if (value.length != 6) {
                      return 'Code must be 6 letters';
                    }
                    // if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    //   return 'Code must contain only letters';
                    // }
                    return null;
                  },
                  inputFormatters: [
                    // FilteringTextInputFormatter.allow(
                    //     RegExp(r'[a-zA-Z]')), // Only letters
                    LengthLimitingTextInputFormatter(6), // Max 6 characters
                  ],
                ),
              ),
              SizedBox(height: 16),
              isLoading
                  ? CircularProgressIndicator(
                      color: AppColors.primaryLightGreen,
                    )
                  : CustomButton(
                      text: "Verify Code",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final code = _codeController.text.trim();

                          // 1️⃣ Get Location First
                          final service = LocationService();
                          print("📍 Getting location...");
                          final location = await service.getCurrentLocation();
                          print("📍 location: $location");

                          if (location != null) {
                            // 2️⃣ Then Verify Code
                            await context.read<LinkCubit>().verifyCode(code);

                            // 3️⃣ Then Get User
                            final user =
                                await ProfileRemoteDataSource().getUser();
                            print("👤 User fetched: ${user.userId}");

                            print("""
🧾 userId: ${user.userId},
name: ${user.name},
image: ${user.image},
parentId: ${user.parentId}
""");

                            // 4️⃣ Then Update Realtime Database
                            await ChildRealtimeService()
                                .sendLocationToRealtimeDatabase(
                              location,
                              user.userId.toString(),
                              user.name.toString(),
                              user.image.toString(),
                              user.parentId.toString(),
                            );
                            print("navigating to child home screen");
                            context.go(AppRoutes.childHome, extra: true);
                          } else {
                            debugPrint(
                                '⚠️ Location is null. Cannot send to Realtime Database.');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '⚠️ Failed to get location. Please enable GPS.'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 3),
                              ),
                            );

                            // Optional: Show a Snackbar or Dialog
                          }
                        }
                      }),
            ],
          ),
        );
      },
    );
  }
}
