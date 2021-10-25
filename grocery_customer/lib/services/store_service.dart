import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices{
  getTopPickStore() {
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopName').snapshots();
  }
  getNearbyStore(){
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified',isEqualTo: true)
        .orderBy('shopName').snapshots();
  }
  getNearbyStorePagination(){
    return FirebaseFirestore.instance.collection('vendors')
        .where('accVerified',isEqualTo: true)
        .orderBy('shopName');
  }
}

