
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/screens/landing_screen.dart';
import 'package:grocery_customer/screens/map_screen.dart';
import 'package:grocery_customer/screens/welcome_screen.dart';
import 'package:grocery_customer/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id='splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  User user=FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ),(){
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if(user ==null){
          Navigator.pushReplacementNamed(context,WelcomeScreen.id);
        }else{
          getUserData();
          Navigator.pushReplacementNamed(context,HomeScreen.id);
        }
      });
    }
    );
    super.initState();
  }

  getUserData()async{
    UserService _userServices=UserService();
    _userServices.getUserDataById(user.uid).then((result){
      if((result.data()as dynamic)['address']!=null){
        updatePrefs(result);
      }
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });

  }

  Future<void>updatePrefs(result)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);

    Navigator.pushReplacementNamed(context, MainScreen.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/store.jpg'),
              Text('Grocery Store  - Customer',
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),)
            ],
          )

      ),
    );
  }
}