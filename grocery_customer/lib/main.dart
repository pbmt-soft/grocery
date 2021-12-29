import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/auth_provider.dart';
import 'package:grocery_customer/providers/location_provider.dart';
import 'package:grocery_customer/providers/stores_provider.dart';
import 'package:grocery_customer/screens/favourite_screen.dart';
import 'package:grocery_customer/screens/home_screen.dart';
import 'package:grocery_customer/screens/landing_screen.dart';
import 'package:grocery_customer/screens/login_screen.dart';
import 'package:grocery_customer/screens/main_screen.dart';
import 'package:grocery_customer/screens/map_screen.dart';
import 'package:grocery_customer/screens/my_orders_screen.dart';
import 'package:grocery_customer/screens/product_list_screen.dart';
import 'package:grocery_customer/screens/profile_screen.dart';
import 'package:grocery_customer/screens/splash_screen.dart';
import 'package:grocery_customer/screens/vendor_home_screen.dart';
import 'package:grocery_customer/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_)=>AuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (_)=>LocationProvider(),
    ),
    ChangeNotifierProvider(
      create: (_)=>StoreProvider(),
    ),
  ],child: MyApp(),),);
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF84c225),
        fontFamily: 'Lato',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        WelcomeScreen.id: (context)=>WelcomeScreen(),
        MapScreen.id:(context)=>MapScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        LandingScreen.id:(context)=>LandingScreen(),
        MainScreen.id:(context)=>MainScreen(),
        ProfileScreen.id:(context)=>ProfileScreen(),
        FavouriteScreen.id:(context)=>FavouriteScreen(),
        MyOrdersScreen.id:(context)=>MyOrdersScreen(),
        VendorHomeScreen.id:(context)=>VendorHomeScreen(),
        ProductListScreen.id:(context)=>ProductListScreen(),
      },
    );
  }
}



