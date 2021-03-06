import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {

final DocumentSnapshot document;


ProductCard(this.document);

  @override
  Widget build(BuildContext context) {

    String offer=((document.data()['comparedPrice'] - document.data()['price']) / document.data()['comparedPrice']*100).toStringAsFixed(0);
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom:BorderSide(width: 1,color: Colors.grey[300]),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top:8.0,bottom: 8.0,left: 10,right: 10),
        child: Row(
          children: [
            Stack(
              children: [

                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 140,
                    width: 130,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                          child: Image.network(document.data()['productImage'])),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right:10,top:3,bottom:3),
                    child: Text('$offer %OFF',style: TextStyle(color:Colors.white,fontSize: 12),),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,top:5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.data()['brand'],style:TextStyle(fontSize: 10)),
                      SizedBox(height: 6,),
                      Text(document.data()['productName'],style:TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 6,),
                      Container(
                          width: MediaQuery.of(context).size.width-160,
                          padding: EdgeInsets.only(left:6,top:10,bottom:10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color:Colors.grey[200],),
                          child: Text(document.data()['weight'],
                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey[600]),)),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Text('\$${document.data()['price'].toStringAsFixed(0)}',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(width: 10,),
                          if(document.data()['comparedPrice'] >0)
                            Text('\$${document.data()['comparedPrice'].toStringAsFixed(0)}',
                            style:TextStyle(decoration:TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 10),),
                        ],
                      ),
                    ],
                  ),
                ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width-160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Card(
                              color: Colors.pink,
                              child: Padding(
                                padding: const EdgeInsets.only(left:30.0,right:30,top:7,bottom:7),
                                child: Text('Add',style:TextStyle(fontWeight: FontWeight.bold,color:Colors.white),),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
