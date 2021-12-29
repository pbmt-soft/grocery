import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/services/product_services.dart';
import 'package:grocery_customer/widgets/products/product_card_widget.dart';

class BestSellingProducts extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    ProductServices _services= ProductServices();
    return FutureBuilder<QuerySnapshot>(
      future: _services.products.where('published',isEqualTo:true).where('collection',isEqualTo:'Best Selling').get(),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  height: 46,
                  child:Center(
                    child: Text('Best Selling',style:TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset(2.0,2.0),
                              blurRadius: 3.0,
                              color: Colors.black54
                          )
                        ] ),),
                  ) ,
                ),
              ),
            ),
            ListView(
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
