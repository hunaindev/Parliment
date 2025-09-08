// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:parliament_app/src/core/config/app_routes.dart';
import 'package:go_router/go_router.dart';

class SosButton extends StatefulWidget {
  const SosButton({super.key});

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.6,
        height: screenHeight * 0.25,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Colors.white, const Color.fromARGB(255, 214, 212, 212)],
            center: AlignmentDirectional(0.05, 0.05),
            focal: AlignmentDirectional(0, 0),
            radius: 0.5,
            focalRadius: 0,
            stops: [0.75, 1.0],
          ),
          border: Border.all(
            color: Color.fromARGB(255, 161, 180, 36),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              spreadRadius: 1,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: Ink(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 161, 180, 36),
              shape: BoxShape.circle,
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                context.push(AppRoutes.carCrash);
              },
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('SOS Triggered!')),
                );
              },
              splashColor: const Color(0xFF7FAE1B).withOpacity(0.4),
              highlightColor: const Color(0xFFAEDB4F).withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "SOS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Museo-Bolder",
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Press for 3 second",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
