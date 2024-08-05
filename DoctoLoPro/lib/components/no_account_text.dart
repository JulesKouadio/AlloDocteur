import 'package:flutter/material.dart';
import '../constant.dart';
import '../ecran/sign_up/sign_up_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AdaptiveText(text:
          "Vous n'avez pas de compte? ",
          style: TextStyle(
              color:Colors.grey,
              fontWeight: FontWeight.w900,
              fontSize: getProportionateScreenWidth(18),
              fontFamily: 'Gilroy'),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const SignUpScreen(),
                      ),
                    ),
          child: AdaptiveText(text:
            "S'inscrire",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: getProportionateScreenWidth(18),
                fontFamily: 'Gilroy',
                color: gradientStartColor),
          ),
        ),
      ],
    );
  }
}
