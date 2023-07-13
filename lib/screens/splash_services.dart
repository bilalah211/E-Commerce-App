import 'dart:async';
import 'package:ecommerceapllication/screens/landing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashServices {
  isLogin(context) {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LandingScreen();
      }));
    });
  }
}
