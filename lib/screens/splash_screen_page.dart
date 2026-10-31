import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rotary_parking/screens/map_screen.dart';

import '../features/auth/presentation/blocs/auth_cubit.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        Future.delayed(const Duration(seconds: 2)).then(
          (_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MapScreen(),
              ),
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: LottieBuilder.asset(
                "assets/animation/splash.json",
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Raknety:)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
