import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/providers/auth_provider.dart';
import 'package:grocery_vendor/providers/product_provider.dart';
import 'package:grocery_vendor/screens/add_new_product.dart';
import 'package:grocery_vendor/screens/login_screen.dart';
import 'package:grocery_vendor/screens/register_screen.dart';
import 'package:grocery_vendor/screens/splash_screen.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:grocery_vendor/widgets/reset_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async{
  Provider.debugCheckInvalidValueType=null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_)=>AuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (_)=>ProductProvider(),
    ),
  ],child: MyApp(),),);
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2536c2),
        fontFamily: 'Lato',
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        RegisterScreen.id:(context)=>RegisterScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        ResetPassword.id:(context)=>ResetPassword(),
        AddNewProduct.id:(context)=>AddNewProduct(),
      },
    );
  }
}