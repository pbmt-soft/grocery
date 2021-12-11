import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:grocery_customer/providers/stores_provider.dart';
import 'package:provider/provider.dart';

class VendorBanner extends StatefulWidget {


  @override
  _VendorBannerState createState() => _VendorBannerState();
}

class _VendorBannerState extends State<VendorBanner> {

  int _index=0;
  int _length=1;

  Future getSliderImageFromDb(StoreProvider storeProvider)async{
    var _fireStore=FirebaseFirestore.instance;
    QuerySnapshot snapshot=await _fireStore.collection('vendorbanner').where('sellerUid',isEqualTo: storeProvider.storedetails['uid']).get();
    if(mounted){
      setState(() {
        _length=snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  void didChangeDependencies() {
    var  _storeProvider=Provider.of<StoreProvider>(context);
    getSliderImageFromDb(_storeProvider);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    var _storeProvider=Provider.of<StoreProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if(_length!=0)
            FutureBuilder(
              future: getSliderImageFromDb(_storeProvider),
              builder: (_,  snapShot){
                return snapShot.data == null ? Center(child: CircularProgressIndicator(),) : Padding(
                  padding: const EdgeInsets.only(top: 4,),
                  child:CarouselSlider.builder(
                      itemCount: ((snapShot.data)as dynamic).length,
                      itemBuilder: (context,int index){
                        DocumentSnapshot sliderImage  = ((snapShot.data)as dynamic)[index];
                        Map getImage = sliderImage.data() as Map;
                        return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(getImage['imageUrl'],fit: BoxFit.fill,));
                      },
                      options: CarouselOptions(
                          viewportFraction: 1,
                          initialPage: 0,
                          autoPlay: true,
                          height: 150,
                          onPageChanged: (int i,carouselPageChangedReason){

                            setState(() {
                              _index=i;
                            });
                          }

                      )),
                );
              },
            ),
          if(_length!=0)
            DotsIndicator(
              dotsCount: _length,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                  size: const Size.square(5.0),
                  activeSize: const Size(18.0,5.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  activeColor: Theme.of(context).primaryColor
              ),
            )
        ],
      ),
    );
  }
}
