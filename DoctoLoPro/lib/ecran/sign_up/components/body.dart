import '../../../constant.dart';
import 'package:flutter/material.dart';
import 'sign_up_form.dart';

class Body extends StatefulWidget {
  const Body({super.key,});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // ===========fin paramètre=================
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(13),
              ),
              AdaptiveText(
                text: "Veuillez entrer vos identifiants",
                style: TextStyle(
                    color: gradientStartColor,
                    fontFamily: 'Gilroy',
                    fontSize: getProportionateScreenWidth(25),
                    fontWeight: FontWeight.w900),
              ),
               SignUpForm(
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.06),
            ],
          ),
        ),
      ),
    );
  }
}
