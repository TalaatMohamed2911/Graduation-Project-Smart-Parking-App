import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotary_parking/components/button.dart';
import 'package:rotary_parking/components/logo.dart';
import 'package:rotary_parking/components/textformfield.dart';
import 'package:rotary_parking/features/auth/presentation/blocs/auth_cubit.dart';

import '../../../../screens/map_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.isLoggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Welcome ${state.user!.fullname}")),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MapScreen(),
              ),
            );
          } else if (state.isError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message ?? "Error")));
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(27),
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  const Logo(),
                  Center(
                    child: const Text(
                      "SignUp",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "User Name",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  TextFormdesign(
                      enabled: true,
                      obscuretext: false,
                      labeltext: "Enter username",
                      mycontroller: username,
                      validator: (val) {
                        if (val == "") {
                          return "Can't Be Empty";
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 7,
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  TextFormdesign(
                      enabled: true,
                      obscuretext: false,
                      labeltext: "Enter your email",
                      mycontroller: email,
                      validator: (val) {
                        if (val == "") {
                          return "Can't Be Empty";
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 7,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  TextFormdesign(
                      enabled: true,
                      obscuretext: true,
                      labeltext: "Enter your password",
                      mycontroller: pass,
                      validator: (val) {
                        if (val == "") {
                          return "Can't Be Empty";
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                final cubit = BlocProvider.of<AuthCubit>(context);
                return Button(
                  title: state.isLoading ? "Loading" : "Sign Up",
                  onPressed: () {
                    if (formState.currentState!.validate()) {
                      cubit.signup(
                          fullname: username.text,
                          email: email.text,
                          password: pass.text);
                    }
                  },
                );
              },
            ),
            SizedBox(
              height: 17,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Have an account? "),
                      TextSpan(
                          text: "LogIn",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
