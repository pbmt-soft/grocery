import 'package:flutter/material.dart';
import 'package:grocery_vendor/screens/login_screen.dart';
import 'package:grocery_vendor/widgets/image_picker.dart';
import 'package:grocery_vendor/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  static const String id='register-screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                    ShopPicCard(),
                   RegisterForm(),
                  Row(

                    children: [
                      FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: RichText(text: TextSpan(
                            text:'',
                            children: [
                              TextSpan(text:'Already have an account?',style:TextStyle(color: Colors.black)),
                              TextSpan(text:'Login',style:TextStyle(color: Colors.blue)),
                            ]
                        ),

                        ),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
