import 'package:ars_dialog/ars_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/services/firebase_service.dart';

import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  static const String id='login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey=GlobalKey<FormState>();
  FirebaseServices _services=FirebaseServices();
  var _usernameTextController= TextEditingController();
  var _passwordTextController= TextEditingController();
   String username;
   String password;

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 10,
        backgroundColor: Color(0xFFda3f50),
        dialogTransitionType: DialogTransitionType.Shrink,
        transitionDuration: Duration(milliseconds: 500));

     Future<void> _login()async{
  progressDialog.show();
  _services.getAdminCredential().then((value) {
    value.docs.forEach((doc) async {
      if (doc.get('username') == username) {
        if (doc.get('password') == password) {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInAnonymously();
          if (userCredential.user.uid != null) {
            progressDialog.dismiss();
            Navigator.pushReplacementNamed(context, HomeScreen.id);
            return;
          }
          else {
            progressDialog.dismiss();
            _services.showMyDialog(context: context,title: 'Login', message: 'Login Failed');
          }
        } else {
          progressDialog.dismiss();
          _services.showMyDialog(context: context,title: 'Incorrect Password',
              message: 'Password you had enter is incorrect.');
        }
      } else {
        progressDialog.dismiss();
        _services.showMyDialog(context:context,title: 'Invalid Username',
            message: 'Username you have entered is not valid.');
      }
    });
  });
  }





    return Scaffold(
      body:FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(child:Text('Connection Failed'),);
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFFda3f50),
                      Colors.white
                    ],
                    stops: [1.0,1.0],
                    begin: Alignment.topCenter,
                    end: Alignment(0.0,0.0)
                ),
              ),
              child: Center(
                child: Container(
                  width: 400,
                  height: 400,
                  child: Card(
                    elevation: 6,
                    shape: Border.all(color:Theme.of(context).primaryColor,width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Image.asset('images/store.jpg',height: 100,width: 100,),
                                  Text('Grocery Store - Admin',
                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
                                  SizedBox(height: 20,),
                                  TextFormField(
                                    controller: _usernameTextController,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Enter UserName';
                                      }
                                      setState(() {
                                        username=value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'UserName',
                                      prefixIcon: Icon(Icons.person),
                                      hintText: 'User Name',
                                      focusColor: Theme.of(context).primaryColor,
                                      contentPadding: EdgeInsets.only(left: 20,right: 20),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    controller: _passwordTextController,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Enter Password';
                                      }
                                      if(value.length<6){
                                        return 'Minimum 6 Characters';
                                      }
                                      setState(() {
                                        password=value;
                                      });

                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Minimum 6 characters',
                                      prefixIcon: Icon(Icons.vpn_key),
                                      hintText: 'Password',
                                      focusColor: Theme.of(context).primaryColor,
                                      contentPadding: EdgeInsets.only(left: 20,right: 20),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: FlatButton(onPressed: (){
                                    if(_formKey.currentState.validate()) {
                                      _login( );
                                    }
                                  },
                                    color: Theme.of(context).primaryColor,
                                    child: Text('Login',style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(
            child:CircularProgressIndicator(),
          );
        },
      )

      ,
      /* */ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}