// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
// import 'package:parliament_app/src/features/child-home/presentation/pages/crash_detect/glad_ok_screen.dart';
import 'package:parliament_app/src/features/child-home/presentation/widgets/slide_action_button.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class CrashDetectedScreen extends StatefulWidget {
  @override
  _CrashDetectedScreenState createState() => _CrashDetectedScreenState();
}

class _CrashDetectedScreenState extends State<CrashDetectedScreen> {
  Timer? _timer;
  int _countdown = 60;
  final GlobalKey<SlideActionState> _slideKeyOk = GlobalKey();
  final GlobalKey<SlideActionState> _slideKeyCall = GlobalKey();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
          _callEmergency();
        }
      });
    });
  }

  void _callEmergency() {
    final Uri phoneUri = Uri(scheme: 'tel', path: '911');
    launchUrl(phoneUri);
  }

  void _stopCountdown() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .15,
              ),
              Text(
                'Car crash detected',
                style: TextStyle(
                  color: AppColors.darkBrown,
                  fontSize: 24,
                  fontFamily: "Museo-Bolder",
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Calling 911 to report car crash in',
                style: TextStyle(color: AppColors.darkBrown, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  border:
                      Border.all(color: AppColors.primaryLightGreen, width: 5),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Center(
                  child: Text(
                    '$_countdown',
                    style: TextStyle(
                      color: AppColors.primaryLightGreen,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomSlideAction(
                    slideKey: _slideKeyOk,
                    text: "Slide to confirm I'm Ok",
                    textColor: Colors.white,
                    outerColor: AppColors.primaryLightGreen,
                    iconData: Icons.check,
                    onSubmit: () {
                      _stopCountdown();
                      context.pushReplacement(AppRoutes.gladYoureOkScreen);
                    },
                  ),
                  SizedBox(height: 16),
                  CustomSlideAction(
                    slideKey: _slideKeyCall,
                    text: "Slide to Call 911",
                    textColor: Colors.white,
                    outerColor: Colors.red,
                    iconData: Icons.phone,
                    onSubmit: () {
                      _stopCountdown();
                      _callEmergency();
                      return null;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
