import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/providers/auth_provider.dart';
import 'package:grocery_vendor/screens/login_screen.dart';
import 'package:provider/provider.dart';


class ResetPassword extends StatefulWidget {
  static const String id='reset-screen';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController=TextEditingController();
  String email;
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    final _userData=Provider.of<AuthProvider>(context);
    scaffoldMessage(message){
      return   ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)));
    }
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  Image.asset('images/reset.jpg',height:180,),
                  SizedBox(height: 20,),
                  RichText(text: TextSpan(
                    text:'',
                    children:[
                      TextSpan(text:'Forgot Password?',style:TextStyle(fontWeight: FontWeight.bold,color:Colors.red),),
                      TextSpan(text:'Dont worry,provide us your registered email,we will send you an email to reset your password',style:TextStyle(fontWeight: FontWeight.bold,color:Colors.red,fontSize: 12),),
                    ],
                  ),),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _emailTextController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Email';
                      }
                      final bool _isValid=EmailValidator.validate(_emailTextController.text);
                      if(!_isValid){
                        return 'Invalid Email Format';
                      }
                      setState(() {
                        email=value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 2),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height:20,),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(onPressed: (){
                          if(_formKey.currentState.validate()){
                            setState(() {
                              _isLoading=true;
                            });
                            _userData.resetPassword(email);
                            scaffoldMessage('Check your email ${_emailTextController.text} for reset link.');
                          }
                          Navigator.pushReplacementNamed(context, LoginScreen.id);
                        },
                          child:_isLoading ? LinearProgressIndicator(): Text('Reset Password',style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
                          color:Theme.of(context).primaryColor, ),
                      ),
                    ],
                  ),
                ],

              ),
            ),
        ),
      ),
    );
  }
}
