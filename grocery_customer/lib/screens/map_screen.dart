
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocery_customer/providers/auth_provider.dart';
import 'package:grocery_customer/providers/location_provider.dart';
import 'package:grocery_customer/screens/landing_screen.dart';
import 'package:grocery_customer/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class MapScreen extends StatefulWidget {
  static const String id='map-screen';

  @override
  _State createState() => _State();
}

class _State extends State<MapScreen> {
   LatLng currentLocation=LatLng(37.421632,122.084664);
   GoogleMapController _mapController;
  bool _locating= false;
  bool _loggedin=false;
   User user;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser()async {
    setState(() {
      User user=FirebaseAuth.instance.currentUser;
    });
    if(user !=null){
      setState(() {
        _loggedin=true;
        user=FirebaseAuth.instance.currentUser;
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    final locationData=Provider.of<LocationProvider>(context);
    final auth=Provider.of<AuthProvider>(context);

    setState(() {
      currentLocation= LatLng(locationData.latitude,locationData.longitude);
    });
    void onCreated(GoogleMapController controller){
      setState(() {
        _mapController=controller;
      });
    }
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:currentLocation,zoom: 14.4746,
                ),
                zoomGesturesEnabled: false,
                minMaxZoomPreference: MinMaxZoomPreference(
                    1.5,20.8
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                onCameraMove: (CameraPosition position){
                  setState(() {
                    _locating=true;
                  });
                  locationData.onCameraMove(position);
                },
                onMapCreated: onCreated,
                onCameraIdle: (){
                  setState(() {
                    _locating=false;
                  });
                  locationData.getMoveCamera();
                },
              ),
              Center(
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(bottom: 40),
                  child: Image.asset('images/marker.png'),
                ),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  height: 200,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start ,
                    children: [
                      _locating ?LinearProgressIndicator(
                        backgroundColor:Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ) :Container(
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right:20),
                        child: TextButton.icon(icon:Icon(Icons.location_searching) ,
                          label:  Flexible(child:
                          Text(_locating ? 'Locating...': locationData.selectedAddress == null ?'Locating...' :locationData.selectedAddress.featureName,overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),)
                            ,),
                          onPressed: () {  },
                       ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right:20),
                          child: Text(_locating ? '':locationData.selectedAddress == null ?'' :locationData.selectedAddress.addressLine,overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),)
                            ,),

                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:SizedBox(
                          width: MediaQuery.of(context).size.width-40,
                          child:AbsorbPointer(
                            absorbing: _locating? true:false,
                            child: FlatButton(onPressed: ()async{
                              locationData.savePrefs();
                              if(_loggedin==false){
                                Navigator.pushNamed(context,LoginScreen.id );
                              }else{
                                setState(() {
                                  auth.latitude=locationData.latitude;
                                  auth.longitude=locationData.longitude;
                                  auth.address=locationData.selectedAddress.addressLine;
                                  auth.location=locationData.selectedAddress.featureName;
                                });
                                auth.updateUser(id: user.uid , number: user.phoneNumber).then((value){
                                  Navigator.pushNamed(context,MainScreen.id);
                                });

                              }
                            },

                              color:_locating? Colors.grey: Theme.of(context).primaryColor,
                              child: Text('Confirm Location',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

