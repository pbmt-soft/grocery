
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_customer/screens/welcome_screen.dart';
import 'package:grocery_customer/services/store_service.dart';
import 'package:grocery_customer/services/user_service.dart';

class StoreProvider with ChangeNotifier{
  StoreServices storeServices=StoreServices();
  UserService _userService=UserService();
  User user=FirebaseAuth.instance.currentUser;
  var userLatitude=0.0;
  var userLongitude=0.0;

 Future<void>getUserLocationData(context)async{
   _userService.getUserDataById(user.uid).then((result){
     if(user!=null){
           this.userLatitude=(result.data()as dynamic)['latitude'];
           this.userLongitude=(result.data()as dynamic)['longitude'];
        notifyListeners();
     }else{
       Navigator.pushReplacementNamed(context, WelcomeScreen.id);
     }
   });
 }

}