import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/providers/auth_provider.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController=TextEditingController();
  var _passwordTextController=TextEditingController();
  var _confirmpasswordTextController=TextEditingController();
  var _nameTextController=TextEditingController();
  var _addressTextController=TextEditingController();
  String email;
   String password;
   String mobile;
  String shopName;
  var _dialogTextController=TextEditingController();
  bool _isLoading=false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage=FirebaseStorage.instance;
    try {
      await _storage
          .ref('uploads/shopProfilePic/${_nameTextController.text}.png')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('uploads/shopProfilePic/${_nameTextController.text}.png')
        .getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _userData=Provider.of<AuthProvider>(context);
    scaffoldMessage(message){
      return   ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(message)));
    }
    return _isLoading ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ) : Form( key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Shop Name';
                }
                setState(() {
                  _nameTextController.text=value;
                });
                setState(() {
                  shopName=value;
                });
                return null;
              },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.add_business),
              enabledBorder: OutlineInputBorder(),
              contentPadding: EdgeInsets.zero,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,color:Theme.of(context).primaryColor
                ),
              ),
              labelText: 'Business Name',
              focusColor: Theme.of(context).primaryColor,

            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLength: 8,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Mobile Number';
                }
                setState(() {
                  mobile=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixText: '+509',
                prefixIcon: Icon(Icons.phone_android),
                enabledBorder: OutlineInputBorder(),
                contentPadding: EdgeInsets.zero,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,color:Theme.of(context).primaryColor
                  ),
                ),
                labelText: 'Mobile Number',
                focusColor: Theme.of(context).primaryColor,

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
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
                prefixIcon: Icon(Icons.email),
                enabledBorder: OutlineInputBorder(),
                contentPadding: EdgeInsets.zero,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,color:Theme.of(context).primaryColor
                  ),
                ),
                labelText: 'Email',
                focusColor: Theme.of(context).primaryColor,

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _passwordTextController,
              obscureText: true,
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
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                enabledBorder: OutlineInputBorder(),
                contentPadding: EdgeInsets.zero,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,color:Theme.of(context).primaryColor
                  ),
                ),
                labelText: 'Password',
                focusColor: Theme.of(context).primaryColor,

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _confirmpasswordTextController,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Confirm Password';
                }
                if(_passwordTextController.text != _confirmpasswordTextController.text){
                  return 'Password doesnt match';
                }
                if(value.length<6){
                  return 'Minimum 6 characters.';
                }
                return null;

              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                enabledBorder: OutlineInputBorder(),
                contentPadding: EdgeInsets.zero,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,color:Theme.of(context).primaryColor
                  ),
                ),
                labelText: 'Confirm Password',
                focusColor: Theme.of(context).primaryColor,

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 6,
              controller: _addressTextController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please press Navigation Button';
                }
                if(_userData.shopLatitude==null){
                  return 'Please press Navigation Button';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.contact_mail_outlined),
                enabledBorder: OutlineInputBorder(),
                contentPadding: EdgeInsets.zero,
                suffixIcon: IconButton(icon:Icon(Icons.location_searching),onPressed: (){
                  _addressTextController.text='Locating...\n please wait...';
                  _userData.getCurrentAddress().then((address){
                    if(address!=null){
                      setState(() {
                        _addressTextController.text='${_userData.placeName}\n ${_userData.shopAddress}';
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Couldnt find location... Try again')),
                      );
                    }
                  });
                },),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,color:Theme.of(context).primaryColor
                  ),
                ),
                labelText: 'Business Location',
                focusColor: Theme.of(context).primaryColor,

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
                onChanged: (value){
                  _dialogTextController.text=value;
                },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.comment),
                enabledBorder: OutlineInputBorder(),
                contentPadding: EdgeInsets.zero,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,color:Theme.of(context).primaryColor
                  ),
                ),
                labelText: 'Shop Dialog',
                focusColor: Theme.of(context).primaryColor,

              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: FlatButton(onPressed: (){
                  if(_userData.isPickAvail==true){
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _isLoading=true;
                      });
                      _userData.registerVendor(email, password).then((credential){
                        if(credential.user.uid !=null){
                            uploadFile(_userData.image.path).then((url){
                              if(url!=null){
                                _userData.saveVendorToDb(url: url,
                                    shopName: shopName,
                                    mobile: mobile,
                                    dialog: _dialogTextController.text).then((value){
                                      setState(() {
                                        _isLoading=false;
                                      });
                                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                                });

                              }else{
                                scaffoldMessage('Failed to upload Shop Profile Pic');
                              }
                            });
                        }else{
                          scaffoldMessage(_userData.error);
                        }
                      });
                    }
                  }else{
                     scaffoldMessage('Shop profile pic need to be add.');

                  }

                },
                    color: Theme.of(context).primaryColor,
                    child: Text('Register',style: TextStyle(color:Colors.white),),),
              ),
            ],
          )
        ],
      ),
    );
  }
}
