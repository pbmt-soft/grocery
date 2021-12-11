import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/stores_provider.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorAppBar extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final _storeData=Provider.of<StoreProvider>(context);

    mapLauncher()async{

      GeoPoint location=_storeData.storedetails['location'];
      final availableMaps = await MapLauncher.installedMaps;


      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title:'${_storeData.storedetails['shopName']} is here',
      );

    }
    return SliverAppBar(
      floating: true,
      snap: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      expandedHeight: 260,
      flexibleSpace: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top:86.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(_storeData.storedetails['imageUrl'])
                  ),
                ),
                child: Container(
                  color: Colors.grey.withOpacity(.7),
                  child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Text(_storeData.storedetails['dialog'],
                          style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                        Text(_storeData.storedetails['address'],
                          style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 12),),
                        Text(_storeData.storedetails['email'],
                          style:TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12),),
                        Text('Distance : ${_storeData.distance}Km',
                          style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                        SizedBox(height: 6,),
                        Row(
                          children: [
                            Icon(Icons.star,color:Colors.white,),
                            Icon(Icons.star,color:Colors.white,),
                            Icon(Icons.star,color:Colors.white,),
                            Icon(Icons.star_half,color:Colors.white,),
                            Icon(Icons.star_outline,color:Colors.white,),
                            SizedBox(width: 5,),
                            Text('(3.5)',style: TextStyle(color: Colors.white),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(backgroundColor: Colors.white,child: IconButton(icon: Icon(Icons.phone,color: Theme.of(context).primaryColor,),
                            onPressed: (){
                              launch('tel: ${_storeData.storedetails['mobile']}');
                            },),),
                            SizedBox(width: 3,),
                            CircleAvatar(backgroundColor: Colors.white,child: IconButton(icon: Icon(Icons.map,color: Theme.of(context).primaryColor,),onPressed: (){
                              mapLauncher();
                            },),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(onPressed: (){},
            icon: Icon(CupertinoIcons.search))
      ],
      title: Text(_storeData.storedetails['shopName'],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
    );
  }
}
