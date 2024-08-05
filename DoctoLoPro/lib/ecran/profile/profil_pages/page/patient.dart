import 'package:doctolopro/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class HistoriquePatient extends StatefulWidget {
  final String praticienID;
  final String patientID;
  final String lienDoc;
  final File? imageDocumentPatient;
  const HistoriquePatient(
      {super.key,
      required this.praticienID,
      required this.patientID,
      required this.lienDoc,
      required this.imageDocumentPatient});

  @override
  State<HistoriquePatient> createState() => _HistoriquePatientState();
}

class _HistoriquePatientState extends State<HistoriquePatient> {
  String? _error;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: gradientStartColor,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarColor: Colors.white,
    ));
    _buildImage(widget.imageDocumentPatient!);
  }

  Widget _buildImage(File imageDocument) {
    if (_error != null) {
      return Text('Error: $_error');
    } else
      return Image.file(
        imageDocument,
        height: getProportionateScreenHeight(400),
        width: getProportionateScreenWidth(400),
        fit: BoxFit.cover,
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: getProportionateScreenHeight(25),
              color: Colors.black,
            ),
          ),
          title: Text(
            "Préparer le rendez-vous",
            style: GoogleFonts.montserrat(
              fontSize: getProportionateScreenHeight(17),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: getProportionateScreenHeight(650),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                  child: Row(
                    children: [
                      Container(
                        height: getProportionateScreenHeight(65),
                        width: getProportionateScreenHeight(65),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/docteur.png"),
                          ),
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenHeight(15),
                      ),
                      SizedBox(
                        width: getProportionateScreenHeight(200),
                        height: getProportionateScreenHeight(50),
                        child: Text(
                          "Ferdinand Konan",
                          textScaler: MediaQuery.of(context).textScaler,
                          maxLines: 1,
                          style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(16),
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(60),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Document du patient",
                        textScaler: MediaQuery.of(context).textScaler,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          fontSize: getProportionateScreenHeight(16),
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Transform.rotate(
                        angle: -90 * 3.14 / 180,
                        child: Icon(
                          Icons.note_outlined,
                          size: getProportionateScreenHeight(25),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(400),
                  child: _buildImage(widget.imageDocumentPatient!),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                // ===========Historique===============
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(50),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Historique du patient",
                        textScaler: MediaQuery.of(context).textScaler,
                        maxLines: 1,
                        style: GoogleFonts.montserrat(
                          fontSize: getProportionateScreenHeight(16),
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenHeight(8),
                      ),
                      Icon(
                        Icons.history,
                        size: getProportionateScreenHeight(25),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(getProportionateScreenHeight(5)),
                  child: Center(
                    child: Text(
                      "Ce patient ne s'est jamais fait consulté sur DoctoLo",
                      textScaler: MediaQuery.of(context).textScaler,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: getProportionateScreenHeight(17),
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
