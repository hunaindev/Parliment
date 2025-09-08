// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/code_generator_cubit.dart';
import 'package:parliament_app/src/features/settings/presentations/blocs/link_code_state.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class GenerateCodeBottomSheet extends StatefulWidget {
  const GenerateCodeBottomSheet({super.key});

  @override
  State<GenerateCodeBottomSheet> createState() =>
      _GenerateCodeBottomSheetState();
}

class _GenerateCodeBottomSheetState extends State<GenerateCodeBottomSheet> {
  String? generatedCode;
  bool isLoading = false;
  Timer? _timer;
  int _timeLeft = 300; // 5 minutes in seconds

  @override
  void initState() {
    super.initState();
    loadSavedCodeIfExists();
  }

  Future<void> loadSavedCodeIfExists() async {
    final savedCode = await LocalStorage.getValue('linkCode');
    final expiry = await LocalStorage.getValue('linkCodeExpiry');
    print("expiry ${expiry}");
    if (savedCode != null && expiry != null) {
      final expiryTime = DateTime.tryParse(expiry);
      if (expiryTime != null && expiryTime.isAfter(DateTime.now())) {
        final secondsLeft = expiryTime.difference(DateTime.now()).inSeconds;
        setState(() {
          generatedCode = savedCode;
          _timeLeft = secondsLeft;
        });
        startTimer();
      } else {
        // Code expired
        await LocalStorage.remove('linkCode');
        await LocalStorage.remove('linkCodeExpiry');
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          timer.cancel();
          generatedCode = null;
          LocalStorage.remove('linkCode');
          LocalStorage.remove('linkCodeExpiry');
        }
      });
    });
  }

  String formatTimeLeft() {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> generateCode() async {
    setState(() => isLoading = true);

    try {
      context.read<LinkCubit>().generateCode();
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      if (!mounted) return; // ✅ Prevent setState if widget is disposed
      setState(() {
        // no-op, placeholder for safety
      });

      startTimer();
    } catch (e) {
      // handle error
    } finally {
      if (!mounted) return; // ✅ Again, check before updating state
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LinkCubit, LinkState>(listener: (context, state) async {
      if (state is CodeGenerated) {
        print("state ${state.code}");
        final expiryTime = DateTime.now().add(Duration(seconds: _timeLeft));
        print("expiryTime ${expiryTime}");
        await LocalStorage.setValue('linkCode', state.code);
        await LocalStorage.setValue(
            'linkCodeExpiry', expiryTime.toIso8601String());

        setState(() {
          generatedCode = state.code;
        });

        startTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Code Created successfully.")),
        );
      } else if (state is LinkError) {
        // print("state error ${state.message}");
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
        //  Fluttertoast.showToast(
        //     msg: "This is Center Short Toast",
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.TOP,
        //     timeInSecForIosWeb: 4,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
    }, builder: (context, state) {
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
              text: 'Generate Link Code',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator(
                    color: AppColors.primaryLightGreen,
                  )
                : Column(
                    children: [
                      Opacity(
                        opacity: (generatedCode != null && _timeLeft > 0)
                            ? 0.5
                            : 1.0,
                        child: CustomButton(
                          onPressed: (generatedCode != null && _timeLeft > 0)
                              ? null // Disabled if code is still valid
                              : generateCode,
                          text: 'Generate Code',
                        ),
                      ),
                      if (generatedCode != null && _timeLeft > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextWidget(
                            text:
                                'You can generate a new code after this one expires.',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
            if (generatedCode != null && !isLoading) ...[
              SizedBox(height: 24),
              TextWidget(
                text: 'Your Code:',
                fontSize: 16,
              ),
              SizedBox(height: 8),
              SelectableText(
                generatedCode!, // ✅ cast state to CodeGenerated
                style: TextStyle(
                  fontSize: 28,
                  color: AppColors.primaryLightGreen,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              SizedBox(height: 8),
              TextWidget(
                text: 'Valid for: ${formatTimeLeft()}',
                fontSize: 14,
                color: AppColors.primaryLightGreen,
              ),
            ],
          ],
        ),
      );
    });
  }
}
