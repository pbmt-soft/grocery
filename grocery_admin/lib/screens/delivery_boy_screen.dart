import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:grocery_admin/widget/sidebar.dart';

class DeliveryBoyScreen extends StatefulWidget {
  static const String id='delivery-boy-screen';

  @override
  _DeliveryBoyScreenState createState() => _DeliveryBoyScreenState();
}

class _DeliveryBoyScreenState extends State<DeliveryBoyScreen> {
  SideBarWidget _sideBar=SideBarWidget();


  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFda3f50),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Grocery Dashboard'),
      ),
      sideBar: _sideBar.sideBarMenus(context, DeliveryBoyScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Boy Screen',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Manage all the Delivery Boys Activities'),
              Divider(thickness: 5,),


            ],
          ),
        ),
      ),
    );
  }
}
