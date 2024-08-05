import 'package:doctolopro/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PharmaciePage extends StatelessWidget {
  final String nomPharmacie;
  final String adresse;
  final String telephone;
  final String horaires;
  final String description;

  PharmaciePage({
    required this.nomPharmacie,
    required this.adresse,
    required this.telephone,
    required this.horaires,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AdaptiveText(
              text: nomPharmacie,
              style: GoogleFonts.montserrat(
                  fontSize: getProportionateScreenHeight(15),
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withOpacity(0.8))),
        ),
        body: Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Text(
                      adresse,
                      style: GoogleFonts.montserrat(
                          fontSize: getProportionateScreenHeight(15),
                          fontWeight: FontWeight.w900,
                          color: Colors.black.withOpacity(0.6)),
                    ),
                    SizedBox(height: getProportionateScreenHeight(8)),
                    Text('Téléphone : $telephone',
                        style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(15),
                            fontWeight: FontWeight.w900,
                            color: Colors.black.withOpacity(0.6))),
                    SizedBox(height: getProportionateScreenHeight(8)),
                    Text('Horaires : $horaires',
                        style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(15),
                            fontWeight: FontWeight.w900,
                            color: Colors.black.withOpacity(0.6))),
                    SizedBox(height: getProportionateScreenHeight(15)),
                    Text(
                      description,
                      style: GoogleFonts.montserrat(
                          fontSize: getProportionateScreenHeight(15),
                          fontWeight: FontWeight.w900,
                          color: Colors.black.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: PharmaciePage(
//       nomPharmacie: 'Pharmacie de la Santé',
//       adresse: '123 Rue de la Santé, 75001 Paris',
//       telephone: '01 23 45 67 89',
//       horaires: 'Lundi - Vendredi : 9h - 19h, Samedi : 9h - 13h',
//       description: 'La Pharmacie de la Santé offre une large gamme de médicaments et de services de santé. Nos pharmaciens sont disponibles pour des consultations personnalisées.',
//     ),
//   ));
// }
