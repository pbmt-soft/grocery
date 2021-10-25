
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/auth_provider.dart';
import 'package:grocery_customer/providers/location_provider.dart';
import 'package:provider/provider.dart';

import 'map_screen.dart';
import 'onboard_screen.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id='welcome-screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {

    final auth=Provider.of<AuthProvider>(context);
    bool _validPhoneNumber=false;
    var _phoneNumberController=TextEditingController();

    void showBottomSheet(context){
      showModalBottomSheet(context: context,
        builder: (context)=>StatefulBuilder(
          builder: (context,StateSetter myState){
            return Container(

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: auth.error=='Invalid OTP'? true:false,
                      child: Container(
                        child: Column(
                          children: [
                            Text('${auth.error}-Try again',style: TextStyle(color: Colors.red,fontSize: 12),),
                            SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ),
                    Text('LOGIN',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    Text('Enter your phone number to proceed',style:TextStyle(fontSize: 12,color: Colors.grey) ,),
                    SizedBox(height: 20,),
                    TextField(
                      decoration: InputDecoration(
                        prefixText: '+509 ',
                        labelText: '8 digit mobile number',
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 8,
                      controller: _phoneNumberController,
                      onChanged: (value){
                        if(value.length==8){
                          myState((){
                            _validPhoneNumber=true;
                          });
                        }else{
                          myState((){
                            _validPhoneNumber=false;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: _validPhoneNumber ? false: true ,
                            child: FlatButton(
                              color:  _validPhoneNumber? Colors.deepOrangeAccent : Colors.grey,
                              onPressed: (){
                                myState((){
                                  auth.loading=true;
                                });
                                String number='+509${_phoneNumberController.text}';
                                auth.verifyPhone(context: context,
                                    number: number).then((value){
                                  _phoneNumberController.clear();
                                  auth.loading=false;
                                });
                              },
                              child:auth.loading ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ): Text(_validPhoneNumber?'CONTINUE':'Enter Phone Number',style: TextStyle(color: Colors.white),),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ).whenComplete((){
        setState(() {
          auth.loading=false;
          _phoneNumberController.clear();
        });
      });
    }
    final locationData=Provider.of<LocationProvider>(context,listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
              child: TextButton(
                onPressed: () {  },
                child: Text('SKIP',style: TextStyle(color: Theme.of(context).primaryColor),),

              ),),
            Column(
              children: [
                Expanded(child: OnBoardScreen(),),
                Text('Ready to order from your nearest shop?',style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10,),
                FlatButton(onPressed: ()async {
                  setState(() {
                    locationData.loading=true;
                  });

                  await locationData.getCurrentPosition();
                  if(locationData.permissionAllowed==true){
                    Navigator.pushReplacementNamed(context, MapScreen.id);
                    setState(() {
                      locationData.loading=false;
                    });
                  }else{
                    print('Permission not allowed');
                    setState(() {
                      locationData.loading=false;
                    });
                  }
                },

                  color: Theme.of(context).primaryColor,
                  child:locationData.loading ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ): Text('Set Delivery Location',style: TextStyle(color: Colors.white),),),
                TextButton(onPressed: ()async{

                  setState(() {
                    auth.screen='Login';
                  });
                  showBottomSheet(context);
                },
                  child:  RichText(text: TextSpan(
                    text: 'Already a customer?',style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                          text: 'Login',style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor)
                      )
                    ],
                  ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

