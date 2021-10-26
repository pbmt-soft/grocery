import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/services/firebase_service.dart';

class BannerWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    
    FirebaseServices _services=FirebaseServices();
    return StreamBuilder<QuerySnapshot>(
        stream: _services.banners.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: SizedBox(
          child:new  ListView(
            scrollDirection: Axis.horizontal,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 300,
                        child: new Card(
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                              child: Image.network(data['image'],fit: BoxFit.cover,)),
                        ),
                      ),
                      Positioned(child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: (){
                            _services.showDeleteDialog(
                              title: 'Delete Banner Image',
                              message: 'Are you sure you want to delete?',
                              context: context,
                              id: document.id,
                            );
                          },
                          icon: Icon(Icons.delete,color: Colors.red,),
                        ),
                      ),
                      top: 10,
                      right: 10,)
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
        },
    );
  }
}
