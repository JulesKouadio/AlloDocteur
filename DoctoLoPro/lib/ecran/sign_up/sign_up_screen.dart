import 'package:flutter/material.dart';
import '../../constant.dart';
import 'components/body.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "/sign_up";
  const SignUpScreen({super.key,});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: getProportionateScreenHeight(35),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenWidth(50),
              child:  
Transform.rotate(
  angle: -90 * 3.1415926535897932 / 180, 
            child:  Icon(Icons.ios_share_rounded, color: Colors.white,size:getProportionateScreenHeight(22),),
)            ),
          ),
          backgroundColor: gradientStartColor,
          title: AdaptiveText(
            text: "S'inscrire",
            style: TextStyle(
              fontFamily: 'Gilroy',
              color: Colors.white,
              fontSize: getProportionateScreenWidth(25),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: Body(
        ),
      ),
    );
  }
}
