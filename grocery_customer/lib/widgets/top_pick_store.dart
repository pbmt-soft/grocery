import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_customer/providers/stores_provider.dart';
import 'package:grocery_customer/screens/vendor_home_screen.dart';
import 'package:grocery_customer/services/store_service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class TopPickStore extends StatefulWidget {

  @override
  _TopPickStoreState createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  double latitude=0.0;
  double longitude=0.0;

  @override
  void didChangeDependencies() {
    final _storeData=Provider.of<StoreProvider>(context);
    _storeData.determinePosition().then((position){
      setState(() {
        latitude=position.latitude;
        longitude=position.longitude;
      });
    });
    super.didChangeDependencies();
  }

  String  getDistance(location){
    var distance=Geolocator.distanceBetween(latitude, longitude, location.latitude, location.longitude);
    var distanceInKm=distance/1000;
    return distanceInKm.toStringAsFixed(2);
  }
  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices=StoreServices();
  final _storeData=Provider.of<StoreProvider>(context);
 // _storeData.getUserLocationData(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream:_storeServices.getTopPickStore() ,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapShot){
            if(!snapShot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            List shopDistance=[];
            for(int i=0;i<=snapShot.data.docs.length-1;i++){
              var distance=Geolocator.distanceBetween(latitude, longitude, snapShot.data.docs[i]['location'].latitude, snapShot.data.docs[i]['location'].longitude);
              var distanceInKm=distance/1000;
              shopDistance.add(distanceInKm);
            }
            shopDistance.sort();
            if(shopDistance[0]>10){
              return Container();
            }

           return Container(
             child: Padding(
               padding: const EdgeInsets.only(left: 8,right: 8),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(bottom: 10,top: 20),
                     child: Row(
                       children: [
                         SizedBox(
                           height: 50,
                             child: Image.asset('images/like.gif')),
                         Text('Top Picked Stores For You',style: TextStyle(fontWeight: FontWeight.w900,fontSize:18 ,),)
                       ],
                     ),
                   ),
                   Container(
                     child: Flexible(
                       child: ListView(
                         scrollDirection: Axis.horizontal,
                         children: snapShot.data.docs.map((DocumentSnapshot document){
                             if(double.parse(getDistance(document['location'])as dynamic)<=10){
                               return  InkWell(
                                 onTap: (){
                                   _storeData.getSelectedStore(document,getDistance(document['location']));
                                   pushNewScreenWithRouteSettings(
                                     context,
                                     settings: RouteSettings(name: VendorHomeScreen.id),
                                     screen: VendorHomeScreen(),
                                     withNavBar: true,
                                     pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                   );
                                 },
                                 child: Padding(
                                   padding: const EdgeInsets.all(4.0),
                                   child: Container(
                                     width: 80,
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         SizedBox(
                                           width:80,
                                           height: 80,
                                           child: Card(
                                             child: ClipRRect(
                                                 borderRadius: BorderRadius.circular(4),
                                                 child: Image.network(document['imageUrl'],fit: BoxFit.cover,),),),
                                         ),
                                         Container(
                                           height: 30,
                                           child: Text(document['shopName'],
                                             style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                         ),
                                         Text('${getDistance(document['location'])}Km',style: TextStyle(color: Colors.grey,fontSize: 10),),

                                       ],
                                     ),
                                   ),
                                 ),
                               );
                             }else{
                               return Container();
                             }

                           }).toList(),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           );
        },
      ),
    );
  }
}
