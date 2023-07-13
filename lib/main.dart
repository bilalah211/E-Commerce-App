import 'package:ecommerceapllication/screens/bottom_navigation.dart';
import 'package:ecommerceapllication/screens/layout_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/addProuduct_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/dashboard_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/deleteProdut_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/updateProduct_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/web_main_screen.dart';
import 'package:ecommerceapllication/screens/website_screens/web_screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCAlQJLkTFtQEnlqM5S9EkNX_yLWLqIMvo",
            authDomain: "e-commerce-application-97d89.firebaseapp.com",
            projectId: "e-commerce-application-97d89",
            storageBucket: "e-commerce-application-97d89.appspot.com",
            messagingSenderId: "404732265983",
            appId: "1:404732265983:web:09e6b145c7b4f3255c13ca"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LandingScreen(),
        routes: {
          WebSiteLoginScreen.id: (context) => WebSiteLoginScreen(),
          WebMainScreen.id: (context) => const WebMainScreen(),
          AddProduct.id: (context) => const AddProduct(),
          UpdateProductScreen.id: (context) => UpdateProductScreen(),
          DeleteProduct.id: (context) => const DeleteProduct(),
          DashBoard.id: (context) => const DashBoard(),
        },
        //FirebaseAuth.instance.currentUser == null
        //     ? const LoginScreen()
        //     : const HomeScreen(),
      ),
    );
  }
}
