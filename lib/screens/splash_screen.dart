import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rotary_parking/screens/map_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashTransition: SplashTransition.slideTransition,
      animationDuration: const Duration(milliseconds: 600),
      duration: 4350,
      splashIconSize: 500,
      backgroundColor: const Color(0xFF002448),
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(
              "assets/animation/splash.json",
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Welocme to Parking App",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      nextScreen: const MapScreen(),
    );
  }
}
