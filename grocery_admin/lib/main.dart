import 'package:ars_dialog/ars_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/screens/banner_screen.dart';
import 'package:grocery_admin/screens/category_screens.dart';
import 'package:grocery_admin/screens/delivery_boy_screen.dart';
import 'package:grocery_admin/screens/home_screen.dart';
import 'package:grocery_admin/screens/login_screen.dart';
import 'package:grocery_admin/screens/splash_screen.dart';
import 'package:grocery_admin/screens/vendor_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Grocery Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFda3f50),

      ),
      home: SplashScreen(),
      routes: {
        HomeScreen.id:(context)=>HomeScreen(),
        SplashScreen.id:(context)=>SplashScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        BannerScreen.id:(context)=>BannerScreen(),
        VendorScreen.id:(context)=>VendorScreen(),
        CategoryScreen.id:(context)=>CategoryScreen(),
        DeliveryBoyScreen.id:(context)=>DeliveryBoyScreen(),
      },
    );
  }
}


