import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_vendor/providers/product_provider.dart';
import 'package:grocery_vendor/services/firebase_services.dart';
import 'package:grocery_vendor/widgets/banner_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BannerScreen extends StatefulWidget {

  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {

  bool _visible=false;
  File _image;
  bool isPickAvail=false;
  String pickerError='';
  var _imagePathText=TextEditingController();
  FirebaseServices _services=FirebaseServices();


  @override
  Widget build(BuildContext context) {

    var _provider=Provider.of<ProductProvider>(context);
    return Scaffold(
      body: ListView(
        children: [
          BannerCard(),
          Divider(thickness: 3,),
          SizedBox(height: 20,),
          Container(child: Center(child: Text('ADD NEW BANNER',style: TextStyle(fontWeight: FontWeight.bold),),),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey[200],
                      child:_image!=null ? Image.file(_image,fit: BoxFit.fill,) : Center(child: Text('No Image Selected'),),
                    ),
                  ),
                  TextFormField(
                    controller: _imagePathText,
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20,),
                  Visibility(
                    visible: _visible ? false : true,
                    child: Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: (){
                                setState(() {
                                  _visible=true;
                                });
                            },
                            child: Text('Add New Banner',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Container(
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Expanded(
                                child: FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: (){
                                      getBannerImage().then((value){
                                        if(_image != null){
                                          setState(() {
                                            _imagePathText.text=_image.path;
                                          });
                                        }
                                      });
                                  },
                                  child: Text('Upload Image',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: _image!= null ? false : true,
                                  child: FlatButton(
                                    color: _image != null ?Theme.of(context).primaryColor : Colors.grey,
                                    onPressed: (){
                                      EasyLoading.show(status: 'Saving...');
                                        uploadFile(_image.path,_provider.shopName).then((url){
                                          if(url != null){
                                            _services.saveBanner(url);
                                            setState(() {
                                              _imagePathText.clear();
                                              _image=null;
                                            });
                                            EasyLoading.dismiss();
                                            _provider.alertDialog(
                                              context: context,
                                              title: 'Banner Saved',
                                              content: 'Banner Saved',
                                            );
                                          }else{
                                            EasyLoading.dismiss();
                                            _provider.alertDialog(
                                              context: context,
                                              title: 'Banner Upload',
                                              content: 'Banner Upload failed',
                                            );
                                          }
                                        });
                                    },
                                    child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FlatButton(
                                  color: Colors.black54,
                                  onPressed: (){
                                      setState(() {
                                        _visible=false;
                                        _imagePathText.clear();
                                        _image=null;
                                      });
                                  },
                                  child: Text('Cancel',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<File> getBannerImage()async{
    final picker=ImagePicker();
    final pickedFile=await picker.getImage(source:ImageSource.gallery,imageQuality: 20,maxHeight: 100, maxWidth: 100);
    if(pickedFile != null){
      setState(() {
        _image=File(pickedFile.path);
      });

    }else{
      this.pickerError='No image selected.';
      print('No image selected.');

    }
    return _image;
  }

  Future<String> uploadFile(filePath,shopName) async {
    File file = File(filePath);
    var timestamp=Timestamp.now().microsecondsSinceEpoch;
    FirebaseStorage _storage=FirebaseStorage.instance;
    try {
      await _storage
          .ref('vendorBanner/$shopName/$timestamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('vendorBanner/$shopName/$timestamp')
        .getDownloadURL();
    return downloadURL;
  }
}
