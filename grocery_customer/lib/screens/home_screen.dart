import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/auth_provider.dart';
import 'package:grocery_customer/providers/location_provider.dart';
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

    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
          return [
            MyAppBar()
          ];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 0.0),
          children: [
            ImageSlider(),
            Container(
              height: 220,
                color: Colors.white,
                child: TopPickStore(),),
            Divider(thickness: 5,),
            Padding(
              padding: const EdgeInsets.only(top:6.0),
              child: NearByStore(),
            ),
          ],
        ),
      ),
    );
  }
}
