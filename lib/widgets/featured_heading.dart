import 'package:allodocteur/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeaturedHeading extends StatelessWidget {
  const FeaturedHeading({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.06,
        left: screenSize.width / 15,
        right: screenSize.width / 15,
      ),
      child:  
   
      
      
      Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Text(
              'Informations',
              style: GoogleFonts.acme(
                  fontSize:getProportionateScreenHeight(25),
                  fontWeight: FontWeight.w900,
                  color:Color(0xFF263b5e)
              ),
            ),
                Expanded(
                  child: Text(
                    'En savoir plus',
                    textAlign: TextAlign.end,
                    style: GoogleFonts.acme(
                  fontSize:getProportionateScreenHeight(20),
                  fontWeight: FontWeight.w200,
                  color:Colors.black38
              ),
                  ),
                ),
              ],
            ),
    );
  }
}
