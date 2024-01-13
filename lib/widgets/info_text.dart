import 'package:allodocteur/constants.dart';
import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  final String type;
  final String text;

  InfoText({required this.type, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$type: ',
          textScaler:MediaQuery.of(context).textScaler,
          style: TextStyle(
            color: Colors.white,
            fontSize: getProportionateScreenWidth(6),
          ),
        ),
        Flexible(
          child: Text(
            text,
                      textScaler:MediaQuery.of(context).textScaler,
            style: TextStyle(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(6),
            ),
          ),
        )
      ],
    );
  }
}
