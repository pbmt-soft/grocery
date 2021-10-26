import 'package:flutter/material.dart';
import 'package:grocery_vendor/widgets/published_product.dart';
import 'package:grocery_vendor/widgets/unpublished_product.dart';

import 'add_new_product.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
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
                       child: Row(
                          children: [
                            Text('Products'),
                            SizedBox(width: 10,),
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              maxRadius: 8,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('20',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                ),
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                    FlatButton.icon(
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          Navigator.pushNamed(context, AddNewProduct.id);
                        },
                        icon: Icon(Icons.add,color:Colors.white),
                        label: Text('Add New Product',style: TextStyle(color:Colors.white),),
                    ),
                  ],
                ),
              ),
            ),
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
              Tab(text: 'PUBLISHED',),
              Tab(text: 'UN PUBLISHED',),
            ],),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  PublishedProduct(),
                  UnPublishedProduct(),
                ],),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
