import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotary_parking/components/button.dart';
import 'package:rotary_parking/components/logo.dart';
import 'package:rotary_parking/components/textformfield.dart';
import 'package:rotary_parking/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:rotary_parking/screens/map_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

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
                  const Logo(),
                  const Center(
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                    },
                  ),
                  SizedBox(
                    height: 19,
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
                  InkWell(
                    onTap: null,
                    child: Container(
                      alignment: Alignment.topRight,
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      child: const Text(
                        "forget password?",
                        style: TextStyle(fontSize: 13.5, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previousState, currentState) =>
                  previousState != currentState,
              builder: (context, state) {
                final cubit = BlocProvider.of<AuthCubit>(context);
                return Button(
                  title: state.isLoading ? "Loading" : "Login",
                  onPressed: () async {
                    if (formState.currentState!.validate()) {
                      cubit.login(email.text, pass.text);
                    }
                  },
                );
              },
            ),
            SizedBox(
              height: 17,
            ),
            MaterialButton(
              color: const Color.fromARGB(255, 255, 255, 255),
              textColor: Colors.red,
              height: 48,
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                // signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login with Google    ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Image.asset("assets/images/g.jpg", width: 30),
                ],
              ),
            ),
            SizedBox(
              height: 34,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("signup");
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Dont't Have an account? "),
                      TextSpan(
                          text: "Register",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
