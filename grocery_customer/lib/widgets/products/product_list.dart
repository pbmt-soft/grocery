import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/stores_provider.dart';
import 'package:grocery_customer/services/product_services.dart';
import 'package:grocery_customer/widgets/products/product_card_widget.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    ProductServices _services= ProductServices();
    var _storeProvider=Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.products.where('published',isEqualTo:true).where('category.mainCategory',isEqualTo:_storeProvider.selectProductCategory).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child:CircularProgressIndicator());
        }
        if(snapshot.data.docs.isEmpty){
          return Container();
        }

        return Column(
          children: [
            Container(
              height: 50,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6,right:2 ),
                      child: Chip(
                        backgroundColor: Colors.white,
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                        ),
                          label: Text('Sub-category'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              height: 56,
              child:Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: Text('${snapshot.data.docs.length} Items',style:TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[600]) ,),
                    ),
                  ],
                ),
              ) ,
            ),
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data();
                return ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
