import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/services/child_realtime_service.dart';
import 'package:parliament_app/src/core/services/location_service.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_input_field.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/settings/data/data_sources/remote/profile_remote_datasource.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/code_generator_cubit.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/link_code_state.dart';
import 'package:go_router/go_router.dart';

class LinkToParent extends StatefulWidget {
  const LinkToParent({super.key});

  @override
  State<LinkToParent> createState() => _LinkToParentState();
}

class _LinkToParentState extends State<LinkToParent> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<LinkCubit, LinkState>(
      listener: (context, state) {
        if (state is CodeVerified) {
          // Navigator.pop(context);
          context.go(AppRoutes.childHome);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Code Verified Successfully")),
          );
        } else if (state is LinkError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LinkLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  LocalStorage.clear();
                  context.go(AppRoutes.login);
                },
                icon: Icon(Icons.arrow_back_ios)),
          ),
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'assets/icons/onlyLogo.png',
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                ),
                                const SizedBox(height: 20),
                                TextWidget(
                                  text: 'Link to Child',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Museo-Bolder',
                                  color: AppColors.primaryLightGreen,
                                ),
                                const SizedBox(height: 10),
                                const TextWidget(
                                  text:
                                      'Enter the 6-digit code provided by your parent to link your account.',
                                  textAlign: TextAlign.center,
                                  color: AppColors.darkBrown,
                                  fontFamily: 'Museo-Bold',
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 30),
                                Form(
                                  key: _formKey,
                                  child: CustomInputField(
                                    label: "Link Code",
                                    hintText: "Enter your 6-letter code",
                                    controller: _codeController,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade400),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a code';
                                      }
                                      if (value.length != 6) {
                                        return 'Code must be 6 letters';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primaryLightGreen,
                                    ),
                                  )
                                : CustomButton(
                                    text: "Verify Code",
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final code =
                                            _codeController.text.trim();
                                        print(code);
                                        await context
                                            .read<LinkCubit>()
                                            .verifyCode(code);
                                        final profile =
                                            ProfileRemoteDataSource();
                                        final user = await profile.getUser();
                                        print("user: ${user.userId}");
                                        print("""
userId: ${user.userId},
name: ${user.name},
image: ${user.image},
parentId: ${user.parentId}
""");
                                        final service = LocationService();
                                        print("Getting location... $service");
                                        final location =
                                            await service.getCurrentLocation();
                                        print("location: $location");
                                        if (location != null) {
                                          await ChildRealtimeService()
                                              .sendLocationToRealtimeDatabase(
                                            location,
                                            user.userId.toString(),
                                            user.name.toString(),
                                            user.image.toString(),
                                            user.parentId.toString(),
                                          );
                                        } else {
                                          debugPrint(
                                              '⚠️ Location is null. Cannot send to Realtime Database.');
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  '⚠️ Failed to get location. Please enable GPS.'),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
