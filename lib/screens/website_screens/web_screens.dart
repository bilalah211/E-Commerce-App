import 'package:ecommerceapllication/screens/website_screens/web_main_screen.dart';
import 'package:ecommerceapllication/utils/utils.dart';
import 'package:ecommerceapllication/widgets/buttons.dart';
import 'package:ecommerceapllication/widgets/my_text_formfields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../firebase_services/firebase_services.dart';

class WebSiteLoginScreen extends StatefulWidget {
  static const String id = "WebSite";
  const WebSiteLoginScreen({super.key});

  @override
  State<WebSiteLoginScreen> createState() => _WebSiteLoginScreenState();
}

class _WebSiteLoginScreenState extends State<WebSiteLoginScreen> {
  final passwordC = TextEditingController();
  final userNameC = TextEditingController();
  bool loading = false;
  bool isPassword = true;

  submit(BuildContext context) async {

    setState(() {
      loading = true;
    });
    await FirebaseServices.adminSignIn(userNameC.text).then((value) async {
      if (value['username'] == userNameC.text &&
          value['password'] == passwordC.text) {
        try {
          UserCredential user = await FirebaseAuth.instance.signInAnonymously();
          if (user != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => WebMainScreen()));
          }
        } catch (e) {
          setState(() {
            loading = false;
          });
          Utils.showMyDialogue(e.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade800, width: 3),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome Admin',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Text(
                      'Log in to your Account',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    EcoTextFields(
                      controller: userNameC,
                      labelText: 'Email',
                    ),
                    EcoTextFields(
                      controller: passwordC,
                      labelText: 'Password',
                      isPassword: isPassword,
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
                    SizedBox(
                      height: 5.h,
                    ),
                    Buttons(
                        title: 'Login',
                        loading: loading,
                        onTap: () async {
                          submit(context);
                        })
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
