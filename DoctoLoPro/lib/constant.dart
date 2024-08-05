import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'components/custom_surfix_icon.dart';

class AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle style;
  const AdaptiveText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      textScaler: MediaQuery.textScalerOf(context),
      style: style,
    );
  }
}

enum MenuState { home, bilan, astuces, profile }

class AppStyle {
  static Color bgColor = const Color(0xff191d2d);
  static Color accentColor = const Color(0xff586af8);
  static Color splineColor = const Color(0xff243199);
}

const Color green = Color(0xFF2FA849);

const Color gradientStartColor = Color(0xff11998e);
const Color gradientEndColor = Color(0xff0575E6);

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 707.428) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 411.428) * screenWidth;
}

double imageScale(BuildContext context) {
  return 411.428 / MediaQuery.of(context).size.width;
}

double textScale(BuildContext context) {
  return MediaQuery.of(context).size.width / 411.428;
}

// ignore: must_be_immutable
class MyTextFormField extends StatefulWidget {
  final TextEditingController myTextController;
  bool myObscureText;
  final TextStyle myTextStyle;
  final Color myCursorColor;
  final AutovalidateMode myAutovalidateMode;
  final TextInputType myTextInputType;
  final String myLabelText, myHintText, mySuffixIconLink;
  MyTextFormField(
      {super.key,
      required this.myTextController,
      required this.myObscureText,
      required this.myTextStyle,
      required this.myCursorColor,
      required this.myAutovalidateMode,
      required this.myLabelText,
      required this.myHintText,
      required this.mySuffixIconLink,
      required this.myTextInputType});

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.myHintText.contains('mot de passe')
          ? !widget.myObscureText
          : false,
      controller: widget.myTextController,
      style: widget.myTextStyle,
      cursorColor: widget.myCursorColor,
      autovalidateMode: widget.myAutovalidateMode,
      validator: (value)
          {
        if (widget.myHintText.contains('mot de passe')) {
          if (value!.length < 6) {
            return "Entrez au moins 6 caratères!";
          } else {
            return null;
          }
        } else if (widget.myHintText.contains('Prénoms')) {
          if (value!.isEmpty |
              !RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ\s-\'-]+$").hasMatch(value)) {
            return "Veuillez entrer un nom valide!";
          } else {
            return null;
          }
        } else if (widget.myHintText.contains('mail')) {
          if (value!.isEmpty | !EmailValidator.validate(value)) {
            return "Veuillez entrer un email valide!";
          } else {
            return null;
          }
        } else {
          return null;
        }
      },
      keyboardType: widget.myTextInputType,
      decoration: InputDecoration(
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(12)), // Hauteur fixe
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide(color: gradientStartColor, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: const BorderSide(width: 3, color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide(color: gradientStartColor, width: 3),
        ),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
        fillColor: Colors.white,
        labelText: widget.myLabelText,
        hintText: widget.myHintText,
        hintStyle: TextStyle(
            fontFamily: 'Gilroy',
            color: Colors.grey,
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.w900),
        labelStyle: TextStyle(
            fontFamily: 'Gilroy',
            color: gradientStartColor,
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.w900),
        suffixIcon: widget.myHintText.contains('mot de passe')
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.myObscureText = !widget.myObscureText;
                  });
                },
                icon: Icon(
                  widget.myObscureText
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey,
                ))
            : null,
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(15)),
          child: CustomSurffixIcon(svgIcon: widget.mySuffixIconLink),
        ),
      ),
    );
  }
}
// ===============
