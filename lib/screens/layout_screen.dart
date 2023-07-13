import 'package:ecommerceapllication/screens/auth/login_screen.dart';
import 'package:ecommerceapllication/screens/splash_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/web_main_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/web_screens.dart';
import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      if(constraints.minWidth > 600){
        return  WebMainScreen();
      }else{
        return const SplashScreen();
      }
    });
  }
}
