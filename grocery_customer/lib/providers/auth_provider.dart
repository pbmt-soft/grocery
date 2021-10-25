
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/screens/home_screen.dart';
import 'package:grocery_customer/screens/landing_screen.dart';
import 'package:grocery_customer/screens/main_screen.dart';
import 'package:grocery_customer/services/user_service.dart';

import 'location_provider.dart';

class AuthProvider with ChangeNotifier{

  FirebaseAuth _auth = FirebaseAuth.instance;
   String smsOtp;
   String verificationId;
  String screen;
   double latitude;
  double longitude;
   String address;
   String location;

  String error='';
  UserService _userService=UserService();
  bool loading=false;
  LocationProvider locationData=LocationProvider();


  Future<void>verifyPhone({ BuildContext context, String number,double latitude,double longitude,String address})async{
    this.loading=true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted=
        (PhoneAuthCredential credential)async{
      this.loading=false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };
    final PhoneVerificationFailed verificationFailed=(FirebaseAuthException e){
      this.loading=false;
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
        this.error=e.toString();
        notifyListeners();
      }
    };
    final PhoneCodeSent codeSent=(String verificationId, int resendToken) async {
      this.verificationId=verificationId;
      smsOtpDialog(context,number);
    };
    try{
      _auth.verifyPhoneNumber(phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verifId){
          this.verificationId=verifId;
        },);
    }catch(e){
      this.error=e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<void>smsOtpDialog(BuildContext context, String number){
    return showDialog<void>(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(height: 6,),
                Text('Enter 6 digit OTP received as SMS',
                  style: TextStyle(color: Colors.grey,fontSize: 12),),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value){
                  this.smsOtp=value;
                },
              ),
            ),
            actions:<Widget> [
              TextButton(onPressed: ()async{
                try{
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId,
                      smsCode: smsOtp);
                  final User user= (await _auth.signInWithCredential(credential)).user;
                  if(user!=null){
                    this.loading=false;
                    notifyListeners();
                    _userService.getUserDataById(user.uid).then((snapshot){
                      if(snapshot.exists){
                        if(this.screen=='Login'){
                          if((snapshot.data()as dynamic)['address']!=null){
                            Navigator.pushReplacementNamed(context, MainScreen.id);
                          }
                          Navigator.pushReplacementNamed(context, LandingScreen.id);
                        }else{
                          updateUser(id: user.uid, number: user.phoneNumber);
                          Navigator.pushReplacementNamed(context, MainScreen.id);
                        }
                      }else{
                        _createUser(id: user.uid, number: user.phoneNumber);
                        Navigator.pushReplacementNamed(context, LandingScreen.id);
                      }
                    });

                  }else{
                    print('Login failed');
                  }

                }catch(e){
                  this.error='Invalid OTP';
                  notifyListeners();
                  print(e.toString());
                  Navigator.of(context).pop();
                }
              },
                child: Text('DONE',style: TextStyle(color:Theme.of(context).primaryColor)),
              ),
            ],
          );
        }).whenComplete((){
      this.loading=false;
      notifyListeners();
    });
  }
  void _createUser({ String id, String number}) {
    _userService.createUserData({
      'id':id,
      'number':number,
      'latitude':this.latitude,
      'longitude':this.longitude,
      'address':this.address,

    });
    this.loading=false;
    notifyListeners();
  }
  Future<void> updateUser({ String id,  String number})async {
    _userService.updateUserData({
      'id':id,
      'number':number,
      'latitude':this.latitude,
      'longitude':this.longitude,
      'address':this.address,

    });
    this.loading=false;
    notifyListeners();

  }
}