import 'dart:html';
import 'package:ars_dialog/ars_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/services/firebase_service.dart';
import 'package:firebase/firebase.dart' as fb;

class BannerUploadWidget extends StatefulWidget {


  @override
  _BannerUploadWidgetState createState() => _BannerUploadWidgetState();
}

class _BannerUploadWidgetState extends State<BannerUploadWidget> {

  FirebaseServices _services=FirebaseServices();
  bool _visible=false;
  var _filenameTextController=TextEditingController();
  bool _imageSelected=true;
   String _url;
  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 10,
        backgroundColor: Color(0xFFda3f50),
        dialogTransitionType: DialogTransitionType.Shrink,
        transitionDuration: Duration(milliseconds: 500));
    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  children: [
                    AbsorbPointer(
                      absorbing:true,
                      child: SizedBox(width: 300,height: 30,child: TextField(
                        controller: _filenameTextController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,width: 1,
                                )
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'No image selected',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20)
                        ),
                      ),),
                    ),
                    FlatButton(onPressed: (){
                      uploadStorage();
                    },
                      child: Text('Upload Image',style: TextStyle(color: Colors.white),),
                      color: Colors.black45,
                    ),
                    SizedBox(width: 10,),
                    AbsorbPointer(
                      absorbing: _imageSelected,
                      child: FlatButton(onPressed: (){
                        progressDialog.show();
                        _services.uploadBannerImageToDb(_url).then((downloadUrl){
                          if(downloadUrl != null){
                            progressDialog.dismiss();
                            _services.showMyDialog(
                                title: 'New Banner Image',
                                message: 'Saved Banner Image Successfully.',
                                context: context
                            );

                          }
                        });
                      },
                        child: Text('Save Image',style: TextStyle(color: Colors.white),),
                        color:_imageSelected?  Colors.black12 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _visible ? false : true,
              child: FlatButton(onPressed: (){
                setState(() {
                  _visible=true;
                });
              },
                child: Text('Add New Banners',style: TextStyle(color: Colors.white),),
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void uploadImage({@required Function(File file) onSelected}) {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file=uploadInput.files.first;
      final reader=FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });

  }

  void uploadStorage(){
    final dateTime=DateTime.now();
    final path='bannerImage/$dateTime.png';
    uploadImage(onSelected: (File file) {
      if(file != null){
        setState(() {
          _filenameTextController.text=file.name;
          _imageSelected=false;
          _url=path;
        });
        fb.storage().refFromURL('gs://grocery-2f62f.appspot.com').child(path).put(file);
      }
    });
  }
}
