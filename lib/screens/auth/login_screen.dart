import 'package:ecommerceapllication/screens/auth/signup_screen.dart';
import 'package:ecommerceapllication/screens/home_screen.dart';
import 'package:ecommerceapllication/widgets/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/my_text_formfields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordC = TextEditingController();
  final emailC = TextEditingController();
  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isPassword = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                  color: Colors.green.shade800,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
              textAlign: TextAlign.center,
            ),
            Text(
              'Please Login First',
              style: TextStyle(
                  color: Colors.green.shade800,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2),
            ),
            Form(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                children: [
                  EcoTextFields(
                      controller: emailC,
                      focusNode: emailFocusNode,
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email)),
                  EcoTextFields(
                    controller: passwordC,
                    focusNode: passFocusNode,
                    isPassword: isPassword,
                    title: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    Icon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                        icon: isPassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Buttons(
                    loading: loading,
                    title: 'Log in',
                    onTap: () async {
                      var email = emailC.text.trim();
                      var password = passwordC.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        Utils.showMyDialogue('Please Fill All The Fields');
                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      try {
                        final auth = FirebaseAuth.instance;
                        UserCredential userCredential =
                            await auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        setState(() {
                          loading = true;
                        });
                        if (userCredential.user != null) {
                          setState(() {
                            loading = false;
                          });
                          Utils.showMyDialogue('User Login');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                          setState(() {
                            loading = false;
                          });
                        } else {}
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Utils.showMyDialogue('User not found');
                          setState(() {
                            loading = false;
                          });
                        } else if (e.code == 'wrong-password') {
                          Utils.showMyDialogue('Wrong Password');
                          setState(() {
                            loading = false;
                          });
                        }
                      } catch (e) {
                        Utils.showMyDialogue('Something went wrong');
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(letterSpacing: 2),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 2),
                          ))
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }
}
