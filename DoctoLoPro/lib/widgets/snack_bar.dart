import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant.dart';

void showCustomSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 2),
      content: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(8),
            vertical: getProportionateScreenHeight(13)),
        height: getProportionateScreenHeight(50),
        width: getProportionateScreenWidth(120),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.7),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            textScaler: MediaQuery.textScalerOf(context),
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}

void showCustomDialog(BuildContext context, String message, String titre) {
  // theme
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: AdaptiveText(
          text: titre,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: getProportionateScreenWidth(22),
          ),
        ),
        content: AdaptiveText(
          text: message,
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: getProportionateScreenWidth(18),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: AdaptiveText(
              text: 'OK',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: getProportionateScreenWidth(15),
              ),
            ),
          ),
        ],
      );
    },
  );
}
