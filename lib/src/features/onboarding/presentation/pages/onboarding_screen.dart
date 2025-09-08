// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:parliament_app/src/core/config/app_colors.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
// import 'package:parliament_app/src/core/config/local_storage.dart';
import 'package:parliament_app/src/core/widgets/custom_button.dart';
import 'package:parliament_app/src/core/widgets/custom_text.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  void initState() async {
    // TODO: implement initState
    super.initState();
    // final isNew = await LocalStorage.getNew();

    // await LocalStorage.setNew();
    // if (isNew) context.go(AppRoutes.role);
    // // if (isNew)
    // context.go(AppRoutes.login);
  }

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to 1Parliament1",
      "body":
          "Stay connected with loved ones and gain peace of mind with real-time location tracking.",
      "image": "assets/animations/logo.svg",
      "slide": "assets/animations/secure_animation.json",
    },
    {
      "title": "Live GPS Tracking",
      "body":
          "Track every family member's location in real time with accurate GPS updates.",
      "image": "assets/onboarding2.png",
      "slide": "assets/animations/gps_tracking_animation1.json",
    },
    {
      "title": "Smart Geofencing",
      "body":
          "Set up zones like home, school, or work and get notified when someone enters or leaves.",
      "image": "assets/onboarding3.png",
      "slide": "assets/animations/smart_geolocation_animation.json",
    },
    {
      "title": "Parental Control Dashboard",
      "body":
          "Easily manage family safety, view location history, and adjust settings to suit your needs.",
      "image": "assets/onboarding4.png",
      "slide": "assets/animations/dashboard_anim.json",
    },
    {
      "title": "Offender Awareness Alerts",
      "body":
          "Get notified if a registered sex offender is nearby—powered by official national registry data.",
      "image": "assets/onboarding5.png",
      "slide": "assets/animations/warning_animation.json",
    },
  ];

  void _nextPage() {
    // Navigate to Login
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 247, 252),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/onlyLogo.png',
                              height: screenHeight * .20,
                            ),
                            TextWidget(
                              text: "1Parliament1",
                              // style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLightGreen,
                              fontFamily: 'Museo-Bolder',
                              // ),
                            ),
                          ],
                        ),
                        Lottie.asset(
                          data["slide"]!,
                          height: screenHeight * .24,

                          // width: 200,
                        ), // SvgPicture.asset(data["slide"]!, height: 140),
                        // SizedBox(height: 20),
                        Column(
                          children: [
                            Text(
                              data["title"]!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 12),
                            TextWidget(
                              text: data["body"]!,
                              textAlign: TextAlign.center,
                              // style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(onboardingData.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? const Color(0xFF95C11F)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width * .85,
                // padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  text: "Get Started",
                  onPressed: _nextPage,
                  height: 60,
                )),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
