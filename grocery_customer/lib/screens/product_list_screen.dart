import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/stores_provider.dart';
import 'package:grocery_customer/widgets/products/product_list.dart';
import 'package:grocery_customer/widgets/vendor_appbar.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  static const String id='product-list-screen';

  @override
  Widget build(BuildContext context) {

    var _storeProvider=Provider.of<StoreProvider>(context);
    return Scaffold(
        body:NestedScrollView(
        headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
      return [
        SliverAppBar(
          title: Text(_storeProvider.selectProductCategory,style: TextStyle(color: Colors.white,),),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ];
    },
          body: ListView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              ProductListWidget(),
            ],
          ),
    )
    );
  }
}
