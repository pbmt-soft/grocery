import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/stores_provider.dart';
import 'package:grocery_customer/widgets/categories_widget.dart';
import 'package:grocery_customer/widgets/image_slider.dart';
import 'package:grocery_customer/widgets/my_appbar.dart';
import 'package:grocery_customer/widgets/products/best_selling_products.dart';
import 'package:grocery_customer/widgets/products/featured_product.dart';
import 'package:grocery_customer/widgets/products/recently_added_product.dart';
import 'package:grocery_customer/widgets/vendor_appbar.dart';
import 'package:grocery_customer/widgets/vendor_banner.dart';


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
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            VendorBanner(),
            VendorCategories(),
            //Recently added products
            RecentlyAddedProduct(),
            // Best features products
            BestSellingProducts(),
            //Featured products
            FeaturedProducts(),
          ],
        ),
      ),
    );
  }
}
