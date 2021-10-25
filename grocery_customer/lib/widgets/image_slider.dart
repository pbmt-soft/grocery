import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSlider extends StatefulWidget {

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {

int _index=0;
int _length=1;

  Future getSliderImageFromDb()async{
    var _fireStore=FirebaseFirestore.instance;
    QuerySnapshot snapshot=await _fireStore.collection('slider').get();
    if(mounted){
      setState(() {
        _length=snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }
  @override
  void initState() {
    getSliderImageFromDb();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if(_length!=0)
          FutureBuilder(
            future: getSliderImageFromDb(),
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
                        child: Image.network(getImage['image'],fit: BoxFit.fill,));
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
