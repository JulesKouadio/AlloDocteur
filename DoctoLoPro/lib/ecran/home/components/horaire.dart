import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant.dart';

class HorairePage extends StatelessWidget {
  final Map<String, String> horaires = {
    "Lundi": "9h00 - 12h00, 14h00 - 18h00",
    "Mardi": "9h00 - 12h00, 14h00 - 18h00",
    "Mercredi": "9h00 - 12h00",
    "Jeudi": "9h00 - 12h00, 14h00 - 18h00",
    "Vendredi": "9h00 - 12h00, 14h00 - 17h00",
    "Samedi": "9h00 - 12h00",
    "Dimanche": "Fermé",
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white,
          statusBarColor: gradientStartColor),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_rounded,
                size: getProportionateScreenHeight(23), color: Colors.black),
          ),
          title: AdaptiveText(
            text: "Les horaires",
            style: GoogleFonts.montserrat(
                fontSize: getProportionateScreenHeight(18),
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: horaires.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: GoogleFonts.montserrat(
                        fontSize: getProportionateScreenHeight(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: GoogleFonts.montserrat(
                        fontSize: getProportionateScreenHeight(14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
