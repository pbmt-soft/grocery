


import 'package:flutter/cupertino.dart';
import 'package:grocery_vendor/screens/banner_screen.dart';
import 'package:grocery_vendor/screens/dashboard_screen.dart';
import 'package:grocery_vendor/screens/products_screen.dart';

class DrawerServices{

  Widget drawerScreen( dynamic title){
    if(title=='DashBoard'){
      return MainScreen();
    }
    if(title=='Products'){
      return ProductsScreen();
    }
    if(title=='Banner'){
      return BannerScreen();
    }
    if(title=='Coupons'){
      return MainScreen();
    }
    if(title=='Orders'){
      return MainScreen();
    }
    if(title=='Reports'){
      return MainScreen();
    }
    if(title=='Setting'){
      return MainScreen();
    }
    if(title=='LogOut'){
      return MainScreen();
    }
    return  MainScreen();
  }
}