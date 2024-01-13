import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class TopBarContents extends StatefulWidget {
  final double opacity;

  TopBarContents(this.opacity);

  @override
  _TopBarContentsState createState() => _TopBarContentsState();
}

class _TopBarContentsState extends State<TopBarContents> {


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(screenSize.width, getProportionateScreenWidth(50)),
      child: Container(
        color: Colors.white.withOpacity(widget.opacity),
        child: Padding(
          padding: EdgeInsets.only(left:getProportionateScreenWidth(10),top:getProportionateScreenHeight(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    // SizedBox(width: screenSize.width /7),
                    AdaptiveText(
                      text:'AlloDocteur',
                      style: GoogleFonts.acme(
                        color:Colors.white,
                        fontSize:getProportionateScreenWidth(12),
                        fontWeight: FontWeight.w900,
                        // letterSpacing: 3,
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right:getProportionateScreenWidth(10),top:getProportionateScreenHeight(10)),
                      child: Row(
                        children: [
                          // Connexion
                          Container(
                            height:getProportionateScreenHeight(40),
                            width:getProportionateScreenWidth(60),
                      decoration:BoxDecoration(
                        borderRadius:BorderRadius.circular(10),
                        color:AppStyle.gradientStartColor,
                        
                      ),
                      child:Center(
                        child: AdaptiveText(text:'Se connecter ?', style:GoogleFonts.acme(
                          fontSize:getProportionateScreenWidth(8),
                          color:Colors.white,
                        ),),
                      ),
                          ),
                         
                        ],
                      ),
                    )
                  
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
