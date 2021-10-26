import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_vendor/providers/product_provider.dart';
import 'package:grocery_vendor/services/firebase_services.dart';
import 'package:grocery_vendor/widgets/category_list.dart';
import 'package:provider/provider.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;

  EditViewProduct({this.productId});

  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services=FirebaseServices();
  final _formkey=GlobalKey<FormState>();
  var _brandText=TextEditingController();
  var _skuText=TextEditingController();
  var _productNameText=TextEditingController();
  var _weightText=TextEditingController();
  var _priceText=TextEditingController();
  var _comparedPriceText=TextEditingController();
  var _description=TextEditingController();
  var _categoryTextController=TextEditingController();
  var _subcategoryTextController=TextEditingController();
  var _stockTextController=TextEditingController();
  var _lowstockTextController=TextEditingController();
  var _taxTextController=TextEditingController();
  DocumentSnapshot doc;
  double discount;
  String image,categoryImage;
  File _image;
  bool _visible=false;
  bool _editing=true;
  List<String> _collection=[
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String dropdownValue;

  @override
  void initState() {
   getProductDetails();
    super.initState();
  }
  Future<void>getProductDetails()async{
    _services.products.doc(widget.productId).get().then((DocumentSnapshot document){
      if(document.exists){
        setState(() {
          doc=document;
          _brandText.text=document.data()['brand'];
          _skuText.text=document.data()['sku'];
          _productNameText.text=document.data()['productName'];
          _weightText.text=document.data()['weight'];
          _priceText.text=document.data()['price'].toString();
          _comparedPriceText.text=document.data()['comparedPrice'].toString();
          var difference=double.parse(_comparedPriceText.text)-double.parse(_priceText.text);
          discount=(difference / double.parse(_comparedPriceText.text)*100);
          image=document.data()['productImage'];
          _description.text=document.data()['description'];
          _categoryTextController.text=document.data()['category']['mainCategory'];
          _subcategoryTextController.text=document.data()['category']['subcategory'];
          dropdownValue=document.data()['collection'];
          _stockTextController.text=document.data()['stockQty'].toString();
          _lowstockTextController.text=document.data()['lowstockQty'].toString();
          _taxTextController.text=document.data()['tax'].toString();
          categoryImage=document.data()['categoryImage'];
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    var _provider=Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          FlatButton(onPressed:(){
            setState(() {
              _editing=false;
            });
          }, child:Text('Edit',style: TextStyle(color: Colors.white),))
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(color:Colors.black87,
                  child: Center(child: Text('Cancel',style: TextStyle(color:Colors.white),)),),
              ),
            ),
            Expanded(child: AbsorbPointer(
              absorbing: _editing,
              child: InkWell(
                onTap: (){
                  if(_formkey.currentState.validate()){
                    EasyLoading.show(status: 'Saving...');
                    if(_image!=null){
                      _provider.uploadFile(_image.path, _productNameText.text).then((url) {
                        if(url!=null){
                          EasyLoading.dismiss();
                          _provider.updateProductDataToDb(
                            context: context,
                            productName: _productNameText.text,
                            weight: _weightText.text,
                            tax: double.parse(_taxTextController.text),
                            stockQty: int.parse(_stockTextController.text),
                            sku: _skuText.text,
                            price: double.parse(_priceText.text),
                            lowStock: int.parse(_lowstockTextController.text),
                            description: _description.text,
                            collection: dropdownValue,
                            brand: _brandText.text,
                            comparedPrice: int.parse(_comparedPriceText.text),
                            productId: widget.productId,
                            image: image,
                            category: _categoryTextController.text,
                            subCategory: _subcategoryTextController.text,
                            categoryImage:categoryImage,
                          );
                        }
                      });
                    }else{
                      _provider.updateProductDataToDb(
                        context: context,
                        productName: _productNameText.text,
                        weight: _weightText.text,
                        tax: double.parse(_taxTextController.text),
                        stockQty: int.parse(_stockTextController.text),
                        sku: _skuText.text,
                        price: double.parse(_priceText.text),
                        lowStock: int.parse(_lowstockTextController.text),
                        description: _description.text,
                        collection: dropdownValue,
                        brand: _brandText.text,
                        comparedPrice: int.parse(_comparedPriceText.text),
                        productId: widget.productId,
                        image: image,
                        category: _categoryTextController.text,
                        subCategory: _subcategoryTextController.text,
                        categoryImage:categoryImage,
                      );
                      EasyLoading.dismiss();
                    }
                    _provider.resetProvider();
                  }
                },
                child: Container(color:Colors.pinkAccent,
                  child: Center(child: Text('Save',style: TextStyle(color:Colors.white),)),),
              ),
            )),
          ],
        ),
      ),
      body:doc==null? Center(child: CircularProgressIndicator()): Form(
        key: _formkey,
        child: Padding(padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            AbsorbPointer(
              absorbing: _editing,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 30,
                        child: TextFormField(
                          controller: _brandText,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:10,right: 10),
                            hintText: 'Brand',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Theme.of(context).primaryColor.withOpacity(.1),

                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('SKU : '),
                          Container(
                            width: 50,
                            child: TextFormField(
                              controller: _skuText,
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                  SizedBox(
                    height: 20,
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      controller: _productNameText,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      controller: _weightText,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            prefixText: '\$',
                          ),
                          controller: _priceText,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        width: 80,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            prefixText: '\$',
                          ),
                          controller: _comparedPriceText,
                          style: TextStyle(fontSize: 15,decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.red,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left:8.0,right:8.0),
                          child: Text('${discount.toStringAsFixed(0)}% OFF',style: TextStyle(color:Colors.white),),
                        ),
                      ),
                    ],
                  ),
                  Text('Inclusive of all Taxes',style:TextStyle(color: Colors.grey,fontSize: 12),),
                  InkWell(
                    onTap: (){
                      _provider.getProductImage().then((image) {
                        setState(() {
                          _image=image;
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _image !=null ? Image.file(_image,height: 300,): Image.network(image,fit: BoxFit.fill,),

                    ),
                  ),
                  Text('About this product',style: TextStyle(fontSize: 20),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      controller: _description,
                      style: TextStyle(
                          color:Colors.grey,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,bottom: 10),
                    child: Row(
                      children: [
                        Text('Category',style: TextStyle(color: Colors.grey,fontSize: 16),),
                        SizedBox(width: 10,),
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: true,
                            child: TextFormField(
                              validator:(value){
                                if(value.isEmpty){
                                  return 'Select category name ';
                                }
                                return null;
                              },
                              controller: _categoryTextController,
                              decoration: InputDecoration(
                                hintText: 'Not Selected',//item code
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _editing ? false:true,
                          child: IconButton(onPressed: (){
                            showDialog(context: context, builder: (BuildContext context){
                              return CategoryList() ;
                            }).whenComplete((){
                              setState(() {
                                _categoryTextController.text=_provider.selectedCat;
                                _visible=true;
                              });
                            });
                          },
                            icon: Icon(Icons.edit_outlined),),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 20),
                      child: Row(
                        children: [
                          Text('Sub Category',style: TextStyle(color: Colors.grey,fontSize: 16),),
                          SizedBox(width: 10,),
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: true,
                              child: TextFormField(
                                validator:(value){
                                  if(value.isEmpty){
                                    return 'Select sub category name ';
                                  }
                                  return null;
                                },
                                controller: _subcategoryTextController,
                                decoration: InputDecoration(
                                  hintText: 'Not Selected',//item code
                                  labelStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(onPressed: (){
                            showDialog(context: context, builder: (BuildContext context){
                              return SubCategoryList() ;
                            }).whenComplete((){
                              setState(() {
                                _subcategoryTextController.text=_provider.selectedSubCat;
                              });
                            });
                          },
                            icon: Icon(Icons.edit_outlined),),
                        ],),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text('Collection',style: TextStyle(color: Colors.grey),),
                        SizedBox(width: 10,),
                        DropdownButton<String>(
                          items: _collection.map<DropdownMenuItem<String>>((String value){
                            return DropdownMenuItem<String>(
                                value: value,
                                child:Text(value)

                            );
                          }).toList(),
                          hint: Text('Select Collection'),
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          onChanged: (String value){
                            setState(() {
                              dropdownValue=value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text('Stock:'),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          controller: _stockTextController,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Low Stock:'),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          controller: _lowstockTextController,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Tax %:'),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          controller: _taxTextController,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60,),

                ],
              ),
            ),
          ],
        ),),
      ),
    );
  }
}
