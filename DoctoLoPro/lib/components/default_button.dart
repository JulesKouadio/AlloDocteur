import 'package:flutter/material.dart';
import '../constant.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
  }) : super(key: key);
  final String? text;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return 
    SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(50),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor:gradientStartColor,
        ),
        onPressed: press as void Function()?,
        child: AdaptiveText(
          text: text!,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: getProportionateScreenWidth(28),
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
