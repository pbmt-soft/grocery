import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_customer/providers/stores_provider.dart';
import 'package:grocery_customer/services/store_service.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class NearByStore extends StatefulWidget {

  @override
  _NearByStoreState createState() => _NearByStoreState();
}

class _NearByStoreState extends State<NearByStore> {
  StoreServices _storeServices=StoreServices();
  PaginateRefreshedChangeListener refreshedChangeListener=PaginateRefreshedChangeListener();
  @override
  Widget build(BuildContext context) {
    final _storeData=Provider.of<StoreProvider>(context);
    _storeData.getUserLocationData(context);
    String  getDistance(location){
      var distance=Geolocator.distanceBetween(_storeData.userLatitude, _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm=distance/1000;
      return distanceInKm.toStringAsFixed(2);
    }
    return  Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream:_storeServices.getNearbyStore() ,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapShot){
          if(!snapShot.hasData){
            return CircularProgressIndicator();
          }
          List shopDistance=[];
          for(int i=0;i<=snapShot.data.docs.length-1;i++){
            var distance=Geolocator.distanceBetween(_storeData.userLatitude, _storeData.userLongitude, snapShot.data.docs[i]['location'].latitude, snapShot.data.docs[i]['location'].longitude);
            var distanceInKm=distance/1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort();
          if(shopDistance[0]>10){
            return Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30,top: 30,left: 20,right: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text('Currently we are not servicing in your area, Please try again later or try another location',
                          textAlign: TextAlign.left,style: TextStyle(color: Colors.black54,fontSize: 20,),),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                  Image.asset('images/city.png',color: Colors.black12,),
                  Positioned(child: Container(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(' Made by : ',style: TextStyle(color: Colors.black54)),
                        Text('PBMTSoftware ',style: TextStyle(fontWeight:FontWeight.bold,
                            fontFamily: 'Anton',letterSpacing:2,color: Colors.grey),),

                      ],
                    ),
                  ) ,
                    right: 10.0,
                    top: 80,
                  )
                ],
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RefreshIndicator(child: PaginateFirestore(
                bottomLoader: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
                header: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(padding: const EdgeInsets.only(left: 8,right:8,bottom: 10),
                    child: Text('All Nearby Stores',style: TextStyle(fontWeight: FontWeight.w900,fontSize:18 ,),),
                ),
                  Padding(padding: const EdgeInsets.only(left: 8,right:8,top: 20),
                    child: Text('Find out quality products near you',style: TextStyle(fontSize:12 ,
                        color: Colors.grey),),
                    ),
              ],
          ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
          itemBuilderType: PaginateBuilderType.listView,
          itemBuilder: (index,context,document)=>
              Padding(padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Card(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(document['imageUrl'],fit: BoxFit.cover,),),),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              (document.data()as dynamic)['shopName'],
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,),

                          ),
                          SizedBox(height: 3,),
                          Text((document.data()as dynamic)['dialog'],style: TextStyle(color: Colors.grey,fontSize: 10),),
                          SizedBox(height: 3,),
                          Container(
                            width: MediaQuery.of(context).size.width-250,
                            child: Text((document.data()as dynamic)['address'],overflow:TextOverflow.ellipsis ,style: TextStyle(color: Colors.grey,fontSize: 10),),
                          ),
                          SizedBox(height: 3,),
                          Text('${getDistance(document['location'])}Km',style: TextStyle(color: Colors.grey,fontSize: 10),),
                          SizedBox(height: 3,),
                          Row(
                            children: [
                              Icon(Icons.star,size: 12,color: Colors.grey,),
                              SizedBox(width: 4,),
                              Container(
                                width: MediaQuery.of(context).size.width-250,
                                child: Text((document.data()as dynamic)['address'],overflow:TextOverflow.ellipsis ,style: TextStyle(color: Colors.grey,fontSize: 10),),
                              ),
                              SizedBox(height: 3,),
                              Text('${getDistance(document['location'])}Km',overflow:TextOverflow.ellipsis ,style: TextStyle(color: Colors.grey,fontSize: 10),),
                              SizedBox(height: 3,),
                              Row(
                                children: [
                                  Icon(Icons.star,size: 12,color: Colors.grey,),
                                  SizedBox(width: 4,),
                                  Text('3.2',style: TextStyle(color: Colors.grey,fontSize: 10),),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          query: _storeServices.getNearbyStorePagination(),
          listeners: [
            refreshedChangeListener,
          ],
          footer:Padding(
            padding: const EdgeInsets.only(top:30),
            child: Container(
              child: Stack(
                children: [
                  Center(
                    child: Text('** Thats all folks **',style: TextStyle(color: Colors.grey)),
                  ),
                  Image.asset('images/city.png',color: Colors.black12,),
                  Positioned(child: Container(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(' Made by : ',style: TextStyle(color: Colors.black54)),
                        Text('PBMTSoftware ',style: TextStyle(fontWeight:FontWeight.bold,
                            fontFamily: 'Anton',letterSpacing:2,color: Colors.grey),),

                      ],
                    ),
                  ) ,
                    right: 10.0,
                    top: 80,
                  )
                ],
              ),
            ),
          ) ,
          ),
              onRefresh: (){

          }),




            ],
          );
        },
      ),
    );
  }
}
