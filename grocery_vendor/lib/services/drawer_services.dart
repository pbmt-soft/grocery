
import 'package:flutter/cupertino.dart';
import 'package:grocery_vendor/screens/banner_screen.dart';
import 'package:grocery_vendor/screens/coupon_screen.dart';
import 'package:grocery_vendor/screens/dashboard_screen.dart';
import 'package:grocery_vendor/screens/login_screen.dart';
import 'package:grocery_vendor/screens/order_screen.dart';
import 'package:grocery_vendor/screens/products_screen.dart';
import 'package:grocery_vendor/screens/report_screen.dart';
import 'package:grocery_vendor/screens/setting_screen.dart';

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
      return CouponScreen();
    }
    if(title=='Orders'){
      return OrderScreen();
    }
    if(title=='Reports'){
      return ReportScreen();
    }
    if(title=='Setting'){
      return SettingScreen();
    }
    if(title=='LogOut'){
      return LoginScreen();
    }
    return  MainScreen();
  }
}