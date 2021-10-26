import 'dart:core';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/services/firebase_service.dart';
import 'package:grocery_admin/widget/vendor/vendor_box_details.dart';


class VendorDataTable extends StatefulWidget {

  @override
  _VendorDataTableState createState() => _VendorDataTableState();
}

class _VendorDataTableState extends State<VendorDataTable> {
  FirebaseServices _services=FirebaseServices();

  int tag = 0;
  List<String> options = [
    'All Vendors', 'Active Vendors', 'Inactive Vendors',
    'Top Picked', 'Top Rated',
  ];
  bool topPicked;
  bool active;
  filter(val){
    if(val==1){
      setState(() {
        active=true;
      });
    }
    if(val==2){
      setState(() {
        active=false;
      });
    }
    if(val==3){
      setState(() {
        topPicked=true;
      });
    }
    if(val==0){
      setState(() {
        topPicked=null;
        active=null;
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    ChipsChoice<int>.single(
    value: tag,
      onChanged: (val)
    { setState(() {
      tag = val;
    });
    filter(val);
    },
      choiceItems: C2Choice.listFrom<int, String>(
        activeStyle: (i,v){
          return C2ChoiceStyle(
            brightness: Brightness.dark,
            color: Colors.black54
          );
        },
        source: options,
        value: (i, v) => i,
        label: (i, v) => v,
      ),
    ),
        Divider(thickness: 5,),
        StreamBuilder(
          stream: _services.vendors.where('isTopPicked',isEqualTo: topPicked).where('accVerified',isEqualTo:active).snapshots(),
            builder:(context,snapshot){
            if(snapshot.hasError){
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                columns:<DataColumn> [
                  DataColumn(label: Text('Active / Inactive'),),
                  DataColumn(label: Text('Top Picked'),),
                  DataColumn(label: Text('Shop Name'),),
                  DataColumn(label: Text('Rating'),),
                  DataColumn(label: Text('Total Sales'),),
                  DataColumn(label: Text('Mobile'),),
                  DataColumn(label: Text('Email'),),
                  DataColumn(label: Text('View Details'),),
                ],
                rows: _vendorDetailsRows(snapshot.data as dynamic,_services),

              ),
            );
            }),
      ],
    );
  }

  List<DataRow> _vendorDetailsRows(QuerySnapshot snapshot,FirebaseServices services){
    List<DataRow>newList=snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(
          cells: [
            DataCell(IconButton(onPressed: (){
              services.updateVendorStatus(
                id: (document.data()as dynamic)['uid'],
                status: (document.data()as dynamic)['accVerified'],
              );
            },
            icon: (document.data() as dynamic)['accVerified'] ?
                Icon(Icons.check_circle,color:Colors.green):
                Icon(Icons.remove_circle,color:Colors.red,
                  ),
                ),
            ),
            DataCell(
              IconButton(onPressed: (){
                services.updateVendorPicked(
                  id: (document.data()as dynamic)['uid'],
                  status: (document.data()as dynamic)['isTopPicked'],
                );
              },
                icon: (document.data() as dynamic)['isTopPicked'] ?
                Icon(Icons.check_circle,color:Colors.green):
                Icon(null,),
              ),
            ),
            DataCell(Text((document.data() as dynamic)['shopName'])),
            DataCell(Row(
              children: [
                Icon(Icons.star,color: Colors.grey,),
                Text('3.5'),
              ],
            ),),
            DataCell(Text('20,000')),
            DataCell(Text((document.data() as dynamic)['mobile'])),
            DataCell(Text((document.data() as dynamic)['email'])),
            DataCell(IconButton(onPressed: (){
              showDialog(context: context,
                  builder: (BuildContext context){
                return VendorBoxDetails((document.data() as dynamic)['uid']);
                  } );
            },
                icon:Icon(Icons.info_outline),
                ),
              ),

          ],
      );

    }).toList();
    return newList;
  }
}
