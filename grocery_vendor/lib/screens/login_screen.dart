import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_vendor/providers/auth_provider.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:grocery_vendor/screens/register_screen.dart';
import 'package:grocery_vendor/widgets/reset_password_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id='login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
   Icon icon;
  bool _visible=false;
   String email;
   String password;
  var _emailTextController=TextEditingController();
  var _passwordTextController=TextEditingController();
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    final _userData=Provider.of<AuthProvider>(context);
    scaffoldMessage(message){
      return   ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)));
    }
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children:[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('LOGIN',style:TextStyle(fontFamily: 'Anton',fontSize: 30),),
                              SizedBox(width: 20,),
                              Image.asset('images/store.jpg',height: 60,)
                            ],
                          ),
                          SizedBox(height: 20,),
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
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 2),
                              ),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _passwordTextController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Password';
                              }
                              if(value.length<6){
                                return 'Minimum 6 characters.';
                              }
                              setState(() {
                                password=value;
                              });
                              return null;
                            },
                            obscureText: _visible==false ? true : false ,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(icon: _visible ?  Icon(Icons.visibility) : Icon(Icons.visibility_off), onPressed: () {
                                setState(() {
                                  _visible = !_visible;
                                });
                              },),
                              enabledBorder: OutlineInputBorder(),
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Password',
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.vpn_key),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 2),
                              ),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.pushNamed(context, ResetPassword.id);
                                },
                                child: Text( 'Forgot Password?',textAlign: TextAlign.end,
                                      style: TextStyle(color:Colors.blue,fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Expanded(
                                child: FlatButton(onPressed: (){
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _isLoading=true;
                                    });
                                    _userData.loginVendor(email, password).then((credential){
                                      if(credential!=null){
                                        setState(() {
                                          _isLoading=false;
                                        });
                                        Navigator.pushReplacementNamed(context, HomeScreen.id);
                                      }else{
                                        setState(() {
                                          _isLoading=false;
                                        });
                                        scaffoldMessage(_userData.error);
                                      }
                                    });
                                  }

                                },
                                    child:_isLoading ? LinearProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      backgroundColor: Colors.transparent,
                                    ):Text('Login',style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold)),
                                  color:Theme.of(context).primaryColor, ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(

                            children: [
                              FlatButton(
                                padding: EdgeInsets.zero,
                                onPressed: (){
                               Navigator.pushNamed(context, RegisterScreen.id);
                              },
                                  child: RichText(text: TextSpan(
                                    text:'',
                                    children: [
                                      TextSpan(text:'Dont have an account?',style:TextStyle(color: Colors.black)),
                                      TextSpan(text:'Register',style:TextStyle(color: Colors.red)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
