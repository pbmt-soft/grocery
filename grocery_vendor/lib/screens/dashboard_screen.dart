import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:grocery_vendor/widgets/drawer_menu_widget.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        direction: Axis.horizontal,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Card(
              elevation: 4,
              child: Padding(padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Image.asset('images/deliveryboy.png',fit: BoxFit.fill,),),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text('Delevery Boy ()',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Card(
              elevation: 4,
              child: Padding(padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Image.asset('images/orders.png',fit: BoxFit.fill,),),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text('Orders ()',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Card(
              elevation: 4,
              child: Padding(padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Image.asset('images/products.png',fit: BoxFit.fill,),),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text('Products ()',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Card(
              elevation: 4,
              child: Padding(padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Image.asset('images/report.png',fit:BoxFit.fill,),),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text('Reports',style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
