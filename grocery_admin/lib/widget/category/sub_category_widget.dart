import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin/services/firebase_service.dart';

class SubCategoryWidget extends StatefulWidget {
  final String categoryName;
  SubCategoryWidget(this.categoryName);

  @override
  _SubCategoryWidgetState createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  FirebaseServices _services=FirebaseServices();
  var _subCatNameTextController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 300,
        child: Padding(padding: EdgeInsets.all(10.0),
        child:FutureBuilder<DocumentSnapshot>(
          future: _services.category.doc(widget.categoryName).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if(!snapshot.hasData){
                return Center(child: Text('No SubCategories added'),);
              }
              Map<String,dynamic> data=snapshot.data.data();
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Main Category : '),
                            Text(widget.categoryName,style:TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        Divider(thickness: 4,),
                      ],
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index){
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              child: Text('${index+1}'),
                            ),
                            title: Text(data['subCat'][index]['name']),
                          );
                        },
                        itemCount: data['subCat']== null ? 0: data['subCat'].length,
                      ),

                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          color: Colors.grey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Add New Sub Category',style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              SizedBox(height: 6,),
                              Row(
                                children: [
                                  Expanded(child:
                                  SizedBox(
                                    height: 30,
                                    child: TextField(
                                      controller: _subCatNameTextController,
                                      decoration: InputDecoration(
                                        hintText: 'Sub Category Name',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.only(left: 10,)
                                      ),
                                    ),),
                                  ),
                                  FlatButton(onPressed: (){
                                    if(_subCatNameTextController.text.isEmpty){
                                     return  _services.showMyDialog(
                                        context: context,
                                        title: 'Add new Sub Category',
                                        message: 'Need to give Subcategory Name',
                                      );
                                    }
                                    DocumentReference doc=_services.category.doc(widget.categoryName);
                                    doc.update({
                                      'subCat':FieldValue.arrayUnion(
                                        [
                                          {
                                            'name': _subCatNameTextController.text,

                                          }
                                        ]
                                      ),
                                    });
                                    setState(() {});
                                    _subCatNameTextController.clear();
                                  },
                                    child: Text('Save',style: TextStyle(color: Colors.white),),
                                    color: Colors.black45,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              );

            }

            return Center(child: CircularProgressIndicator());
          },
        ),
        ),

      ),
    );
  }
}
