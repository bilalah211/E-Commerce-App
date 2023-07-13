import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapllication/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/buttons.dart';
import '../../widgets/my_text_formfields.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPassC = TextEditingController();
  final emailFocusNode = FocusNode();
  final passFocusNode = FocusNode();
  final cPassFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool formStateLoading = false;
  bool isPassword = true;
  bool isCPassword = true;
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
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
                    'Please Register Your Account Here',
                    style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2),
                  ),
                  Form(
                      key: formKey,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 30),
                        child: Column(
                          children: [
                            EcoTextFields(
                              controller: fullNameC,
                              labelText: 'Full Name',
                              prefixIcon: const Icon(Icons.person),
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Email is badly Formatted";
                                }
                                return null;
                              },
                            ),
                            EcoTextFields(
                              controller: emailC,
                              focusNode: emailFocusNode,
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Email is badly Formatted";
                                }
                                return null;
                              },
                            ),
                            EcoTextFields(
                              controller: passwordC,
                              focusNode: passFocusNode,
                              isPassword: isPassword,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Password Should Not Be Empty";
                                }
                                return null;
                              },
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
                            EcoTextFields(
                              controller: confirmPassC,
                              focusNode: cPassFocusNode,
                              isPassword: isCPassword,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Password Should Not Be Empty";
                                }
                                return null;
                              },
                              title: 'Confirm Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              Icon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isCPassword = !isCPassword;
                                    });
                                  },
                                  icon: isCPassword
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility)),
                            ),
                            SizedBox(
                              height: height * 0.06,
                            ),
                            Buttons(
                              loading: loading,
                              title: 'Sign up',
                              onTap: () async {
                                var fullName = fullNameC.text;
                                var email = emailC.text;
                                var password = passwordC.text;
                                var confirmPass = confirmPassC.text;


                                if (fullName.isEmpty || email.isEmpty ||
                                    password.isEmpty || confirmPass.isEmpty) {
                                  Utils.showMyDialogue(
                                      'Please Fill All The Fields');

                                  return;
                                }


                                if (password.length < 6) {
                                  Utils.showMyDialogue(
                                      'Please provide at least 6 digits');
                                  return;
                                }

                                if (password != confirmPass) {
                                  Utils.showMyDialogue(
                                      'Passwords do not match');
                                  return;
                                }
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  final auth = FirebaseAuth.instance;
                                  UserCredential userCredential =
                                  await auth.createUserWithEmailAndPassword(
                                      email: emailC.text,
                                      password: passwordC.text);
                                  setState(() {
                                    loading = true;
                                  });
                                  if (userCredential.user != null) {
                                    setState(() {
                                      loading = false;
                                    });
                                    final fireStore = FirebaseFirestore
                                        .instance;
                                    String uid = userCredential.user!.uid;

                                    fireStore.collection('Users').doc(uid).set({
                                    'FullName': fullName,
                                    'Email': email,
                                    'Uid': uid,
                                    'ProfileImage': ''
                                    });
                                    Utils.showMyDialogue('Account Created');
                                    setState(() {
                                      loading = false;
                                    });
                                  } else {}
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'email-already-in-use') {
                                    Utils.showMyDialogue(
                                        'Email is already in Use');
                                    setState(() {
                                      loading = false;
                                    });
                                  } else if (e.code == 'weak-password') {
                                    Utils.showMyDialogue('Password is weak');
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
                                  'Already have an account?',
                                  style: TextStyle(letterSpacing: 2),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Log in',
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
          ),
        ));
  }
}
