
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider extends ChangeNotifier{
  String selectedCat='not selected';
  String selectedSubCat='not selected';
  String categoryImage;
  File image;
  bool isPickAvail=false;
  String pickerError='';
  String shopName;
   String productUrl;

  selectCategory(maincategory,categoryimage){
    this.selectedCat=maincategory;
    this.categoryImage=categoryimage;
    notifyListeners();
  }

  selectSubCategory(selected){
    this.selectedSubCat=selected;
    notifyListeners();
  }

  Future<File> getProductImage()async{
    final picker=ImagePicker();
    final pickedFile=await picker.getImage(source:ImageSource.gallery,imageQuality: 20,maxHeight: 100, maxWidth: 100);
    if(pickedFile != null){
      this.image=File(pickedFile.path);
      notifyListeners();
    }else{
      this.pickerError='No image selected.';
      print('No image selected.');
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context,title,content}){
    return showCupertinoDialog(context: context,
        builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text(title),
        content:Text(content),
        actions: [
          CupertinoDialogAction(child: Text('OK'),onPressed: (){
            Navigator.pop(context);
          },),
        ],
      );
        });
  }

  getShopName(shopName){
    this.shopName=shopName;
    notifyListeners();
  }

  resetProvider(){
    this.selectedCat=null;
    this.selectedSubCat=null;
    this.categoryImage=null;
    this.image=null;
    this.productUrl=null;
    notifyListeners();
  }

  Future<String> uploadFile(filePath,productName) async {
    File file = File(filePath);
    var timestamp=Timestamp.now().microsecondsSinceEpoch;
    FirebaseStorage _storage=FirebaseStorage.instance;
    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timestamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}/$productName$timestamp')
        .getDownloadURL();
    this.productUrl=downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<void>saveProductDataToDb({productName,description,price,comparedPrice,collection,brand,sku,weight,tax,stockQty,lowStock,context}){
    var timestamp=DateTime.now().microsecondsSinceEpoch;
    User user=FirebaseAuth.instance.currentUser;
   CollectionReference _products= FirebaseFirestore.instance.collection('products');
   try{
        _products.doc(timestamp.toString()).set({
          'seller' : {'shopname' : this.shopName, 'sellerUid':user.uid },
          'productName':productName,
          'description':description,
          'price': price,
          'comparedPrice':comparedPrice,
          'collection':collection,
          'brand':brand,
          'sku':sku,
          'category':{'mainCategory':this.selectedCat,'subcategory':this.selectedSubCat,'categoryImage':this.categoryImage},
          'weight':weight,
          'tax':tax,
          'stockQty':stockQty,
          'lowstockQty':lowStock,
          'published':false,
          'productId':timestamp.toString(),
          'productImage':this.productUrl,
        });
        this.alertDialog(context: context,
        title: 'SAVE DATA',
        content: 'Product details saved successfully');
    }catch(e){
     this.alertDialog(context: context,
         title: 'SAVE DATA',
         content: '${e.toString()}');
   }
   return null;
  }

  Future<void>updateProductDataToDb({productName,description,price,comparedPrice,collection,brand,sku,weight,tax,stockQty,lowStock,category,subCategory,categoryImage,context,image,productId}){
    var timestamp=DateTime.now().microsecondsSinceEpoch;
    User user=FirebaseAuth.instance.currentUser;
    CollectionReference _products= FirebaseFirestore.instance.collection('products');
    try{
      _products.doc(productId).update({
        'productName':productName,
        'description':description,
        'price': price,
        'comparedPrice':comparedPrice,
        'collection':collection,
        'brand':brand,
        'sku':sku,
        'category':{'mainCategory':category,'subcategory':subCategory,'categoryImage':this.categoryImage==null?categoryImage:this.categoryImage},
        'weight':weight,
        'tax':tax,
        'stockQty':stockQty,
        'lowstockQty':lowStock,
        'productImage':this.productUrl == null? image: this.productUrl,
      });
      this.alertDialog(context: context,
          title: 'UPDATE DATA',
          content: 'Product details updated successfully');
    }catch(e){
      this.alertDialog(context: context,
          title: 'UPDATE DATA',
          content: '${e.toString()}');
    }
    return null;
  }

}