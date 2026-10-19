import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotary_parking/auth/login.dart';
import 'package:rotary_parking/auth/profile.dart';
import 'package:rotary_parking/auth/signup.dart';
import 'package:rotary_parking/bloc/parking_bloc.dart';
import 'package:rotary_parking/screens/map_screen.dart';
import 'package:rotary_parking/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyD8ye5q0Be4MNA_OoRVAuyLfat1mJ0ybY8',
      appId: '1:514714792399:android:dfb3bbda6a8b5ed3dd62ba',
      messagingSenderId: '514714792399',
      projectId: 'rotary-parking',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
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
