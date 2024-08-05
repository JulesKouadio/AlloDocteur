import 'package:flutter/material.dart';
import '../../constant.dart';
import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const String routeName = "/forgot_password";

  const ForgotPasswordScreen({super.key});
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
              child:  Icon(Icons.arrow_back,color:Colors.white,size:getProportionateScreenHeight(25)),
            ),
          ),
          backgroundColor: gradientStartColor,
          title: AdaptiveText(
            text: "Réinitialisation",
            style: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w900,
                fontSize: getProportionateScreenWidth(25),
                color: Colors.white),
          ),
        ),
        body: const Body(),
      ),
    );
  }
}
