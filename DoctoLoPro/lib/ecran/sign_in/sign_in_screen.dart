import 'package:flutter/material.dart';
import '../../constant.dart';
import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = "/sign_in";

  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor:Colors.white,
          appBar: AppBar(
            toolbarHeight: getProportionateScreenHeight(30),
            backgroundColor:gradientStartColor,
            automaticallyImplyLeading: false,
            title: AdaptiveText(
              text: "Se connecter",
              style: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(25),
                  fontWeight: FontWeight.w900),
            ),
          ),
          body:SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Body()),
          ),
    );
  }
}
