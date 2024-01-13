import 'package:allodocteur/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainHeading                                                                                                extends StatelessWidget {
  const MainHeading({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(
              top: screenSize.height / 10,
              bottom: screenSize.height / 15,
            ),
            width: screenSize.width,
            child: Text(
              'Nos Services',
              textAlign: TextAlign.center,
              style: GoogleFonts.acme(
                fontSize:getProportionateScreenHeight(40),
                fontWeight: FontWeight.w900,
                color:Colors.black87
              ),
            ),
          );
  }
}
