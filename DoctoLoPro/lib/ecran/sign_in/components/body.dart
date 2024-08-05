// import 'package:demo/components/social_card.dart';
import '../../../components/no_account_text.dart';
import '../../../constant.dart';
import 'package:flutter/material.dart';
import 'sign_in_form.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                AdaptiveText(text:
                  "Heureux de te revoir !",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color:gradientStartColor,
                    fontSize: getProportionateScreenHeight(25),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                 SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                AdaptiveText(text:
                  "Connecte-toi avec ton email",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    color: gradientStartColor,
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                const SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                SizedBox(height: getProportionateScreenHeight(17)),
                const NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
