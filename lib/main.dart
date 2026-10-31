import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rotary_parking/auth/profile.dart';
import 'package:rotary_parking/bloc/parking_bloc.dart';
import 'package:rotary_parking/core/di/service_locator.dart';
import 'package:rotary_parking/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:rotary_parking/features/auth/presentation/pages/login.dart';
import 'package:rotary_parking/features/auth/presentation/pages/signup.dart';
import 'package:rotary_parking/firebase_options.dart';
import 'package:rotary_parking/screens/map_screen.dart';

void main() async {
  initServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthCubit>()..init(),
        ),
        BlocProvider(
          create: (context) => sl<ParkingBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MapScreen(),
        routes: {
          "login": (context) => const Login(),
          "signup": (context) => const SignUp(),
          "custom_map": (context) => const MapScreen(),
          "profile": (context) => const Profile(),
        },
      ),
    );
  }
}
