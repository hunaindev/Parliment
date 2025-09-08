// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:parliament_app/main.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:parliament_app/src/core/widgets/main_scaffold.dart';
// import 'package:parliament_app/src/features/child-home/presentation/pages/crash_detect/emergency_number.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/features/child-home/presentation/widgets/slide_action_button.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:go_router/go_router.dart';

class GladYoureOkScreen extends StatelessWidget {
  final GlobalKey<SlideActionState> _slideKeyMinorCrash = GlobalKey();
  final GlobalKey<SlideActionState> _slideKeyNoCrash = GlobalKey();
  final GlobalKey<SlideActionState> _slideKeyCall = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .15,
              ),
              Text(
                'Glad you\'re OK. What happened?',
                style: TextStyle(
                    color: AppColors.darkBrown,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Museo-Bolder"),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CustomSlideAction(
                slideKey: _slideKeyNoCrash,
                text: 'No crash',
                iconData: Icons.car_repair,
                textColor: Colors.white,
                outerColor: AppColors.primaryLightGreen,
                onSubmit: () {
                  // Handle No crash
                },
              ),
              SizedBox(height: 16),
              CustomSlideAction(
                slideKey: _slideKeyMinorCrash,
                text: 'Minor crash',
                iconData: Icons.car_crash,
                textColor: Colors.white,
                outerColor: Colors.yellow,
                onSubmit: () {
                  // Handle Minor crash
                },
              ),
              SizedBox(height: 16),
              // SizedBox(height: 30),
              CustomSlideAction(
                slideKey: _slideKeyCall,
                text: 'Call 911',
                iconData: Icons.phone,
                textColor: Colors.white,
                outerColor: Colors.red,
                onSubmit: () {
                  context.push(AppRoutes.emergencyNumber);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
