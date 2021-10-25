
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/auth_provider.dart';
import 'package:grocery_customer/providers/location_provider.dart';
import 'package:grocery_customer/screens/welcome_screen.dart';
import 'package:grocery_customer/widgets/image_slider.dart';
import 'package:grocery_customer/widgets/my_appbar.dart';
import 'package:grocery_customer/widgets/near_by_store.dart';
import 'package:grocery_customer/widgets/top_pick_store.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  static const String id='home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    final auth=Provider.of<AuthProvider>(context);
    final locationData=Provider.of<LocationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,

      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
          return [
            MyAppBar()
          ];
        },
        body: ListView(
          children: [
            ImageSlider(),
            Container(
              height: 220,
                color: Colors.white,
                child: TopPickStore(),),
            Divider(thickness: 5,),
            NearByStore(),
          ],
        ),
      ),
    );
  }
}
