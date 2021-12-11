import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/stores_provider.dart';
import 'package:grocery_customer/widgets/categories_widget.dart';
import 'package:grocery_customer/widgets/image_slider.dart';
import 'package:grocery_customer/widgets/my_appbar.dart';
import 'package:grocery_customer/widgets/vendor_appbar.dart';
import 'package:grocery_customer/widgets/vendor_banner.dart';
import 'package:provider/provider.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id='vendor-home-screen';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:NestedScrollView(
        headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
          return [
            VendorAppBar(),
          ];
        },
        body: Column(
          children: [
            VendorBanner(),
            Expanded(child: VendorCategories()),
          ],
        ),
      ),
    );
  }
}
