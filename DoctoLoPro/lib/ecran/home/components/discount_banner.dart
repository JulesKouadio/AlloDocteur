import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../constant.dart';

class DiscountBanner extends StatefulWidget {
  const DiscountBanner({super.key});

  @override
  DiscountBannerState createState() => DiscountBannerState();
}

class DiscountBannerState extends State<DiscountBanner> {

  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _fetchImageUrls();
  }

  Future<void> _fetchImageUrls() async {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('Carousel')
        .doc('carousel_id')
        .get();

    if (documentSnapshot.exists) {
      setState(() {
        // Supposons que votre document a des champs 'image_1', 'image_2', 'image_3'
        _imageUrls = [
          documentSnapshot.get('image_1') as String,
          documentSnapshot.get('image_2') as String,
          documentSnapshot.get('image_3') as String,
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      int currentIndex = 0;

    return Column(
      children: [
        CarouselSlider(
      options: CarouselOptions(
         height: getProportionateScreenHeight(160),
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.9,
                    pauseAutoPlayOnTouch: true,

        onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
      ),
      items: _imageUrls.map((lienImage) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin:const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(lienImage),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        );
      }).toList(),
    ),
        SizedBox(height: getProportionateScreenHeight(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _imageUrls.asMap().entries.map((entry) {
            final int index = entry.key;
            final bool isCurrentPage = index == currentIndex;
            double buttonSize = isCurrentPage ? 35.0 : 15.0;
            return Container(
              width: buttonSize,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isCurrentPage ? green : Colors.white,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
