import 'package:doctolopro/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeureRDV extends StatefulWidget {
  const HeureRDV({super.key});

  @override
  State<HeureRDV> createState() => HeureRDVState();
}

class HeureRDVState extends State<HeureRDV> {
  var perfect = false;

  void switchPerfect() {
    setState(() {
      perfect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: getProportionateScreenHeight(35)),
            child: Text('Heure du rendez-vous',
                style: GoogleFonts.montserrat(
                    fontSize: getProportionateScreenHeight(15),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,
                  size: getProportionateScreenHeight(25),
                  color: Colors.black87)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: getProportionateScreenHeight(150),
                width: getProportionateScreenWidth(400),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCustomDialogTwo(
                                context,
                                "Veuillez confirmer votre rendez-vous!",
                                "CONFIRMATION");
                          },
                          child: Container(
                            height: getProportionateScreenHeight(40),
                            width: getProportionateScreenWidth(80),
                            decoration: BoxDecoration(
                                color: gradientEndColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text('9:00',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(15),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                            ),
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(80),
                          decoration: BoxDecoration(
                              color: gradientEndColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('09:30',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(80),
                          decoration: BoxDecoration(
                              color: gradientEndColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('10:00',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        )
                      ],
                    ),
                    // =============================
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(80),
                          decoration: BoxDecoration(
                              color: gradientEndColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('10:30',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(80),
                          decoration: BoxDecoration(
                              color: gradientEndColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('11:00',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(80),
                          decoration: BoxDecoration(
                              color: gradientEndColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('11:30',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        )
                      ],
                    ),
                    //===============================
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(80),
                          decoration: BoxDecoration(
                              color: gradientEndColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('12:00',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(80),
                          decoration: BoxDecoration(
                              color: gradientEndColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('14:30',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(40),
                          width: getProportionateScreenWidth(80),
                          decoration: BoxDecoration(
                              color: gradientEndColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text('15:00',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Visibility(
                visible: perfect,
                child: Padding(
                  padding:  EdgeInsets.only(top:getProportionateScreenHeight(15)),
                  child: SizedBox(
                    width: getProportionateScreenWidth(400),
                    child: Center(
                      child: Text(
                          'Parfait votre rendez-vous a été enregistré',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style:GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: getProportionateScreenWidth(15),
                          ),),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void showCustomDialogTwo(BuildContext context, String message, String titre) {
  // theme
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Container(
          height: getProportionateScreenHeight(40),
          width: getProportionateScreenWidth(150),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: gradientEndColor.withOpacity(0.3)),
          child: Center(
            child: AdaptiveText(
              text: titre,
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontWeight: FontWeight.w900,
                fontSize: getProportionateScreenWidth(22),
              ),
            ),
          ),
        ),
        content: AdaptiveText(
          text: message,
          style: GoogleFonts.montserrat(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: getProportionateScreenWidth(18),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: getProportionateScreenHeight(40),
                width: getProportionateScreenWidth(120),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: gradientEndColor.withOpacity(0.3)),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: AdaptiveText(
                    text: 'ANNULER',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: getProportionateScreenWidth(15),
                    ),
                  ),
                ),
              ),
              Container(
                height: getProportionateScreenHeight(40),
                width: getProportionateScreenWidth(130),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: gradientEndColor.withOpacity(0.3)),
                child: TextButton(
                  onPressed: () {
                  Navigator.of(context).pop();

                    switchPerfect();
                  },
                  child: AdaptiveText(
                    text: 'CONFIRMER',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: getProportionateScreenWidth(15),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}



}

