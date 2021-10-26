import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grocery_vendor/providers/product_provider.dart';
import 'package:grocery_vendor/widgets/category_list.dart';
import 'package:provider/provider.dart';

class AddNewProduct extends StatefulWidget {
  static const String id='add-new-product';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey=GlobalKey<FormState>();
  List<String> _collection=[
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
   String dropdownValue;
  var _categoryTextController=TextEditingController();
  var _subcategoryTextController=TextEditingController();
  var _comparedPriceTextController=TextEditingController();
  var _brandTextController=TextEditingController();
  var _lowStockTextController=TextEditingController();
  var _stockTextController=TextEditingController();
   File _image= null;
  bool _visible=false;
  bool _track=false;
  String productName='';
  String description='';
  String sku='';
  String weight='';
  double price=0;
  double tax=0;
  double comparedPrice=0;

  @override
  Widget build(BuildContext context) {

    var _provider=Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key:_formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Container(
                          child: Text('Products / Add'),
                        ),
                      ),
                      FlatButton.icon(
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                           if(_categoryTextController.text.isNotEmpty){
                             if(_subcategoryTextController.text.isNotEmpty){
                               if(_image!=null){
                                 EasyLoading.show(status: 'Saving...');
                                 _provider.uploadFile(_image.path, productName).then((url){
                                   if(url != null){
                                     EasyLoading.dismiss();
                                     _provider.saveProductDataToDb(
                                       context: context,
                                       comparedPrice:int.parse(_comparedPriceTextController.text),
                                       brand: _brandTextController.text,
                                       price: price,
                                       collection: dropdownValue,
                                       description: description,
                                       lowStock: int.parse(_lowStockTextController.text),
                                       stockQty: int.parse(_stockTextController.text),
                                       sku: sku,
                                       tax: tax,
                                       weight: weight,
                                       productName: productName,
                                     );
                                     setState(() {
                                       _formKey.currentState.reset();
                                       _comparedPriceTextController.clear();
                                       _subcategoryTextController.clear();
                                       _categoryTextController.clear();
                                       dropdownValue='';
                                       _brandTextController.clear();
                                       _track=false;
                                       _image=null;
                                       _visible=false;

                                     });
                                   }else{
                                     _provider.alertDialog(
                                         context: context,
                                         title: 'IMAGE UPLOAD',
                                         content: 'Failed to upload product image'
                                     );
                                   }
                                 });
                               }else{
                                 _provider.alertDialog(
                                     context: context,
                                     title: 'PRODUCT IMAGE',
                                     content: 'Product Image not selected'
                                 );
                               }
                             }else{
                               _provider.alertDialog(
                                 context: context,
                                 title: 'Sub Category',
                                 content: 'Sub category not selected',
                               );
                             }
                           }else{
                             _provider.alertDialog(
                               context: context,
                               title: 'Main Category',
                               content: 'Main category not selected',
                             );
                           }
                          }
                        },
                        icon: Icon(Icons.save,color:Colors.white),
                        label: Text('Save',style: TextStyle(color:Colors.white),),
                      ),

                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                Tab(text: 'GENERAL',),
                Tab(text: 'INVENTORY',),
              ],),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter product name';
                                    }
                                    setState(() {
                                      productName=value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Product Name*',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  maxLength: 500,
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter description ';
                                    }
                                    setState(() {
                                      description=value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'About Product*',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      _provider.getProductImage().then((image){
                                        setState(() {
                                          _image =image;
                                        });
                                      });
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: Center(
                                          child: _image==null ? Text('Select Image') : Image.file(_image),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter selling price ';
                                    }
                                    setState(() {
                                      price=double.parse(value);
                                    });
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Price*',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _comparedPriceTextController,
                                  validator:(value){
                                    if(price>double.parse(value)){
                                      return 'Compared price should be higher than price';
                                    }
                                    setState(() {
                                      comparedPrice=double.parse(value);
                                    });
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Compared Price',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
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
                                TextFormField(
                                  controller: _brandTextController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'Brand',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter SKU ';
                                    }
                                    setState(() {
                                      sku=value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'SKU',//item code
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
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
                                      IconButton(onPressed: (){
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
                                TextFormField(
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter weight. ';
                                    }
                                    setState(() {
                                      weight=value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Weight.  eg:- kg, gr,etc',//item code
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  validator:(value){
                                    if(value.isEmpty){
                                      return 'Enter tax % ';
                                    }
                                    setState(() {
                                      tax=double.parse(value);
                                    });
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Tax %',//item code
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text('Track Inventory'),
                              activeColor: Theme.of(context).primaryColor,
                              subtitle: Text('Switch ON to Track Inventory',style:TextStyle(color:Colors.grey,fontSize: 12),),
                              value: _track,
                              onChanged: (selected){
                                setState(() {
                                  _track= !_track;
                                });
                              },
                            ),
                            Visibility(
                              visible: _track,
                              child: SizedBox(height: 300,
                                width: double.infinity,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                       controller: _stockTextController,
                                          decoration: InputDecoration(
                                            labelText: 'Inventory Quantity*',
                                            labelStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _lowStockTextController,
                                          decoration: InputDecoration(
                                            labelText: 'Inventory low stock quantity',
                                            labelStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
