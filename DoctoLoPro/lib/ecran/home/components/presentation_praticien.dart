import 'package:doctolopro/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PresentationPraticien extends StatefulWidget {
  final String nomPraticien;
  final String prenomPraticien;
  final String metier;
  final String adresse;
  final String indication;
  final String contact;
  const PresentationPraticien(
      {super.key,
      required this.nomPraticien,
      required this.prenomPraticien,
      required this.metier,
      required this.adresse,
      required this.indication,
      required this.contact});

  @override
  State<PresentationPraticien> createState() => PresentationPraticienState();
}

class PresentationPraticienState extends State<PresentationPraticien> {
  @override
  void initState() {
        super.initState();
    getProportionateScreenHeight(20);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: gradientStartColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [],
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,
                  color: Colors.white, size: getProportionateScreenHeight(25))),
        ),
        body: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(200),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: getProportionateScreenHeight(180),
                      decoration: BoxDecoration(
                          color: gradientStartColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                      child: Column(
                        children: [
                          widget.metier.contains("PHARMACIE")
                              ? Container(
                                  height: getProportionateScreenHeight(180),
                                  width: 420,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                      image: DecorationImage(
                                          scale: imageScale(context),
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/pharm.jpg"))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: getProportionateScreenWidth(400),
                                        child: Center(
                                          child: Text(widget.metier,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          16),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(400),
                                        child: Center(
                                          child: Text(widget.adresse,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          16),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  height: getProportionateScreenHeight(100),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/docteur.png')),
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.6)),
                                ),
                          widget.metier.contains("PHARMACIE")
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      top: getProportionateScreenHeight(10)),
                                  child: Column(
                                    children: [
                                      Text(
                                          'Dr.' +
                                              " " +
                                              widget.nomPraticien[0]
                                                  .toUpperCase() +
                                              widget.nomPraticien.substring(1) +
                                              " " +
                                              widget.prenomPraticien[0]
                                                  .toUpperCase() +
                                              widget.prenomPraticien
                                                  .substring(1),
                                          style: GoogleFonts.montserrat(
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      20),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AdaptiveText(
                                              text: "Spécialité : ",
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          19),
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white)),
                                          AdaptiveText(
                                              text: "Cardiologie",
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          19),
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white))
                                        ],
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: getProportionateScreenHeight(415),
              width: double.infinity,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // ====Contatcs===

                    Column(children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(1),
                            left: getProportionateScreenHeight(5)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.contact_phone,
                              color: Colors.black87,
                              size: getProportionateScreenHeight(18),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text('Contacts :',
                                style: GoogleFonts.montserrat(
                                    // fontFamily: 'Gilroy',
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black.withOpacity(0.8))),
                          ],
                        ),
                      ),
                      // ==========Contacts en eux-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child:
                                // ====Contatcs===
                                Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                AdaptiveText(
                                    text: 'Téléphone :',
                                    style: GoogleFonts.montserrat(
                                        // fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(14),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.8))),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                AdaptiveText(
                                    text: '+225 01 73 40 66 88 ',
                                    style: GoogleFonts.montserrat(
                                        // fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.8)))
                              ],
                            ),
                          ),
                          // ===========Email==========
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                AdaptiveText(
                                    text: 'Email :',
                                    style: GoogleFonts.montserrat(
                                        // fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(14),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.8))),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(240),
                                  child: Text('ferdinandkouadio@gmail.com',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.montserrat(
                                          // fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                          // =========Adresse==========
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                AdaptiveText(
                                    text: 'Adresse :',
                                    style: GoogleFonts.montserrat(
                                        // fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(14),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.8))),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                AdaptiveText(
                                    text: 'Yopougon Maroc Kimi',
                                    style: GoogleFonts.montserrat(
                                        // fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.8)))
                              ],
                            ),
                          )
                        ],
                      )
                    ]),
                    // ==========Formation Académique========
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.school_rounded,
                              color: Colors.black87,
                              size: getProportionateScreenHeight(20),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text('Formation Académique :',
                                style: GoogleFonts.montserrat(
                                    // fontFamily: 'Gilroy',
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black.withOpacity(0.8))),
                          ],
                        ),
                      ),
                      // ==========formation en elles-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(240),
                                  height: getProportionateScreenHeight(40),
                                  child: Text(
                                      'Doctorat en Medecine ,\nUniversité Nangui Abrogoua',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                          // ========Année formation========
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(50),
                                top: getProportionateScreenHeight(10)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(5),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Text('2012',
                                    textScaler:
                                        MediaQuery.of(context).textScaler,
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.8)))
                              ],
                            ),
                          )
                          // ======== Fin Année formation========
                        ],
                      )
                    ]),
                    // ========== Fin Formation Académique========
                    // ===========Expérience professionnelle===========
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.medical_services_rounded,
                              color: Colors.black87,
                              size: getProportionateScreenHeight(20),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text('Expérience professionnelle :',
                                style: GoogleFonts.montserrat(
                                    // fontFamily: 'Gilroy',
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black.withOpacity(0.8))),
                          ],
                        ),
                      ),
                      // ==========expériences en elles-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(240),
                                  child: Text('Cardiologie ,Clinique Ste Rita',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                          // ========Année expérience========
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(50),
                                top: getProportionateScreenHeight(10)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(5),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Text('2013-2015',
                                    textScaler:
                                        MediaQuery.of(context).textScaler,
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.8)))
                              ],
                            ),
                          )
                          // ======== Fin Année========
                        ],
                      ),
                      // ==========expériences en elles-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(260),
                                  child: Text(
                                      'Chef de service Cardiologie ,Clinique Ste Rita',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                          // ========Année expérience========
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(50),
                                top: getProportionateScreenHeight(10)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(5),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Text('2015-présent',
                                    textScaler:
                                        MediaQuery.of(context).textScaler,
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.8)))
                              ],
                            ),
                          )
                          // ======== Fin Année========
                        ],
                      )
                    ]),
                    // ===========Fin Expérience professionnelle============
                    // ===========Compétence et Spécialités===========
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sanitizer_rounded,
                              color: Colors.black87,
                              size: getProportionateScreenHeight(24),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text('Spécialités et compétences :',
                                style: GoogleFonts.montserrat(
                                    // fontFamily: 'Gilroy',
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black.withOpacity(0.8))),
                          ],
                        ),
                      ),
                      // ==========expériences en elles-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(240),
                                  child: Text('Cardiologie interventionnelle',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ==========compétences en elles-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(260),
                                  child: Text(
                                      'Diagnostic et traitement des maladies cardiovasculaires',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(260),
                                  child: Text('Chirurgie cardiaque',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ]),
                    // ===========Fin Compétence et Spécialités===========
                    // ===========Affiliation professionnelle===========
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.black87,
                              size: getProportionateScreenHeight(24),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text('Affiliation professionnelle :',
                                style: GoogleFonts.montserrat(
                                    // fontFamily: 'Gilroy',
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black.withOpacity(0.8))),
                          ],
                        ),
                      ),
                      // ==========expériences en elles-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(240),
                                  child: Text(
                                      'Membre de la Société Ivoirienne de Cardiologie',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ==========compétences en elles-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(260),
                                  child: Text(
                                      'Certifié par le Conseil Ivoirien de Cardiologie',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                    // ===========Fin Affiliation professionnelle===========
                    // ===========Publications et recherche==========
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.black87,
                              size: getProportionateScreenHeight(24),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Text('Publications et recherches :',
                                style: GoogleFonts.montserrat(
                                    // fontFamily: 'Gilroy',
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black.withOpacity(0.8))),
                          ],
                        ),
                      ),
                      // ==========expériences en elles-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(270),
                                  child: Text(
                                      '"Impact des nouvelles techniques de chirurgie cardiaque", Journal de Cardiologie, 2019',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ==========compétences en elles-mêmes=========
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(12),
                                top: getProportionateScreenHeight(2)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pix_outlined,
                                  color: Colors.black,
                                  size: getProportionateScreenHeight(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(270),
                                  child: Text(
                                      'Co-auteur du livre "La cardiologie moderne", 2020',
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ])
                  ],
                ),
              ),
            ),

// ==============================
          ],
        ),
      ),
    );
  }
}
