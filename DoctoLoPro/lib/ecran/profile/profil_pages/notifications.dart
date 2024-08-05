import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant.dart';
import 'downloadImage/image_downloader.dart';
import 'page/patient.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = "/cart";
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  User? _user;
  String lienDoc = "";
  Future<void> getLienDoc(String praticienID) async {
    final document = await FirebaseFirestore.instance
        .collection("Praticiens")
        .doc(praticienID)
        .collection("Consultation")
        .doc(praticienID)
        .get();

    if (document.exists) {
      setState(() {
        lienDoc = document["Lien_Document"];
      });
    } else {}
  }

  File? _imagePatient;

  Future<void> downloadImage(String patientID) async {
    try {
      final file = await ImageDownloader(
        imageUrl: lienDoc,
        fileName: '${patientID}.jpg',
      ).downloadImage();
      setState(() {
        _imagePatient = file;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: getProportionateScreenHeight(40),
              width: getProportionateScreenWidth(40),
              child: Icon(Icons.arrow_back,
                  color: Colors.white, size: getProportionateScreenHeight(25)),
            ),
          ),
          backgroundColor: gradientStartColor,
          title: Row(
            children: [
              Column(
                children: [
                  AdaptiveText(
                    text: "Notifications",
                    style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(18),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Praticiens")
                        .doc(_user!.email)
                        .collection("Consultation")
                        .where("Statut_Consultation",
                            isEqualTo: "En cours de traitement")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int numberDemandes = snapshot.data!.size;
                        return AdaptiveText(
                          text: numberDemandes > 1
                              ? "Vous avez $numberDemandes demandes"
                              : "Vous avez $numberDemandes demande",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(15),
                          ),
                        );
                      } else {
                        return AdaptiveText(
                          text: "Chargement...",
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: getProportionateScreenWidth(15),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(15)),
            child: Column(
              children: [
                Column(
                  children: [
                    AdaptiveText(
                        text: "Demande de consultation",
                        style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(18),
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: getProportionateScreenHeight(270),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(10),
                        ),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Praticiens')
                              .doc(_user!.email)
                              .collection('Consultation')
                              .where("Statut_Consultation",
                                  isEqualTo: "En cours de traitement")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                  child: SpinKitThreeBounce(
                                      size: getProportionateScreenHeight(15),
                                      color: Colors.white));
                            }
                            List<DocumentSnapshot> demande =
                                snapshot.data!.docs;
                            if (demande.length < 1) {
                              return Center(
                                child: Text(
                                  "VOUS N'AVEZ ACTUELLEMENT AUCUNE DEMANDE DE CONSULTATION",
                                  textAlign: TextAlign.center,
                                  textScaler: MediaQuery.of(context).textScaler,
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(20),
                                      fontWeight: FontWeight.bold,
                                      color: gradientStartColor),
                                ),
                              );
                            } else {
                              return PageView.builder(
                                controller: _pageController,
                                scrollDirection: Axis.horizontal,
                                itemCount: demande.length,
                                itemBuilder: (context, index) {
                                  var demandeConsultation = demande[index]
                                      .data() as Map<String, dynamic>;

                                  return GestureDetector(
                                    onTap: () {
                                      getLienDoc(demandeConsultation[
                                              'Praticien_ID'])
                                          .then((_) {
                                        downloadImage(
                                            demandeConsultation['Patient_ID']);
                                      }).then((_) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    HistoriquePatient(
                                                      praticienID:
                                                          demandeConsultation[
                                                              'Praticien_ID'],
                                                      patientID:
                                                          demandeConsultation[
                                                              'Patient_ID'],
                                                      lienDoc: lienDoc,
                                                      imageDocumentPatient:
                                                          _imagePatient,
                                                    )));
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          getProportionateScreenHeight(5)),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    45),
                                            width: getProportionateScreenHeight(
                                                320),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20)),
                                                color: gradientStartColor,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        getProportionateScreenHeight(
                                                            10)),
                                                child: Column(children: [
                                                  // ========Date==========
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical:
                                                            getProportionateScreenHeight(
                                                                10),
                                                        horizontal:
                                                            getProportionateScreenHeight(
                                                                5)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        AdaptiveText(
                                                            text: demandeConsultation[
                                                                    "Date_Consultation"] +
                                                                " " +
                                                                demandeConsultation[
                                                                    "Heure_Consultation"],
                                                            style: GoogleFonts.montserrat(
                                                                fontSize:
                                                                    getProportionateScreenHeight(
                                                                        14),
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          width:
                                                              getProportionateScreenHeight(
                                                                  10),
                                                        ),
                                                        AdaptiveText(
                                                            text: demandeConsultation[
                                                                "Type_Consultation"],
                                                            style: GoogleFonts.montserrat(
                                                                fontSize:
                                                                    getProportionateScreenHeight(
                                                                        14),
                                                                color: Colors
                                                                    .orange,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                      ],
                                                    ),
                                                  )
                                                ]),
                                              ),
                                            ),
                                          ),
                                          // ========Deuxième face=======
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    140),
                                            width: getProportionateScreenHeight(
                                                290),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20)),
                                                  color: Colors.grey[300],
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        offset: Offset(0, 2),
                                                        blurRadius: 3),
                                                  ]),
                                              child: Column(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          getProportionateScreenHeight(
                                                              10),
                                                      top:
                                                          getProportionateScreenHeight(
                                                              15)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                65),
                                                        width:
                                                            getProportionateScreenHeight(
                                                                65),
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/images/docteur.png")),
                                                            color: Colors.white,
                                                            shape: BoxShape
                                                                .circle),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left:
                                                                getProportionateScreenHeight(
                                                                    15)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  getProportionateScreenHeight(
                                                                      120),
                                                              child: Text(
                                                                  // "Ferdinand Konan",
                                                                  demandeConsultation[
                                                                      "Patient_nom"],
                                                                  textScaler: MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                                  maxLines: 2,
                                                                  style: GoogleFonts.montserrat(
                                                                      fontSize:
                                                                          getProportionateScreenHeight(
                                                                              16),
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  getProportionateScreenHeight(
                                                                      10),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .info_outline_rounded,
                                                              size:
                                                                  getProportionateScreenHeight(
                                                                      28),
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // =======Decliner et Accepter========
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          getProportionateScreenHeight(
                                                              12),
                                                      top:
                                                          getProportionateScreenHeight(
                                                              18)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          String docId =
                                                              demande[index].id;

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Praticiens')
                                                              .doc(demandeConsultation[
                                                                  "Praticien_ID"])
                                                              .collection(
                                                                  'Consultation')
                                                              .doc(docId)
                                                              .update({
                                                            "Statut_Consultation":
                                                                "confirmée"
                                                          }).then((_) async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "Utilisateurs")
                                                                .doc(demandeConsultation[
                                                                    "Patient_ID"])
                                                                .collection(
                                                                    "Consultation")
                                                                .add({
                                                              "Motif_Consultation":
                                                                  demandeConsultation[
                                                                      "Motif_Consultation"],
                                                              "Type_Consultation":
                                                                  demandeConsultation[
                                                                      "Type_Consultation"],
                                                              "Date_Consultation":
                                                                  demandeConsultation[
                                                                      "Date_Consultation"],
                                                              "Heure_Consultation":
                                                                  demandeConsultation[
                                                                      "Heure_Consultation"],
                                                              "Statut_Consultation":
                                                                  "confirmée",
                                                              "Praticien_nom":
                                                                  demandeConsultation[
                                                                      "Praticien_nom"],
                                                              "Praticien_ID":
                                                                  demandeConsultation[
                                                                      "Praticien_ID"],
                                                              "Patient_nom":
                                                                  demandeConsultation[
                                                                      "Patient_nom"],
                                                              "Patient_ID":
                                                                  demandeConsultation[
                                                                      "Patient_ID"],
                                                            }).then((_) async {
                                                              // ==========
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Praticiens')
                                                                  .doc(_user!
                                                                      .email)
                                                                  .collection(
                                                                      'creneau_occupé')
                                                                  .add({
                                                                "occuper": demandeConsultation[
                                                                        "Date_Consultation"] +
                                                                    "--" +
                                                                    demandeConsultation[
                                                                        "Heure_Consultation"]
                                                              });
                                                            });
                                                          });
                                                        },
                                                        child: Container(
                                                          height:
                                                              getProportionateScreenHeight(
                                                                  30),
                                                          width:
                                                              getProportionateScreenHeight(
                                                                  110),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              color: Colors
                                                                  .orange),
                                                          child: Center(
                                                            child: Text(
                                                                "Accepter",
                                                                textScaler: MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.montserrat(
                                                                    fontSize:
                                                                        getProportionateScreenHeight(
                                                                            15),
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            getProportionateScreenHeight(
                                                                30),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          String docId =
                                                              demande[index].id;

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Praticiens')
                                                              .doc(_user!.email)
                                                              .collection(
                                                                  'Consultation')
                                                              .doc(docId)
                                                              .delete();
                                                        },
                                                        child: Container(
                                                          height:
                                                              getProportionateScreenHeight(
                                                                  30),
                                                          width:
                                                              getProportionateScreenHeight(
                                                                  90),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              color:
                                                                  Colors.grey),
                                                          child: Center(
                                                            child: Text(
                                                                "Décliner",
                                                                textScaler: MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.montserrat(
                                                                    fontSize:
                                                                        getProportionateScreenHeight(
                                                                            14),
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // ================Consultation confirmé===========
                AdaptiveText(
                    text: "Consultation confirmée",
                    style: GoogleFonts.montserrat(
                        fontSize: getProportionateScreenHeight(18),
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),

                SizedBox(
                  height: getProportionateScreenHeight(220),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: getProportionateScreenHeight(10),
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Praticiens')
                          .doc(_user!.email)
                          .collection('Consultation')
                          .where("Statut_Consultation", isEqualTo: "confirmée")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: SpinKitThreeBounce(
                                  size: getProportionateScreenHeight(15),
                                  color: Colors.white));
                        }
                        List<DocumentSnapshot> demande = snapshot.data!.docs;
                        return demande.length < 1
                            ? Center(
                                child: Text(
                                  "VOUS N'AVEZ AUCUNE CONSULTATION EN VUE",
                                  textAlign: TextAlign.center,
                                  textScaler: MediaQuery.of(context).textScaler,
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(20),
                                      fontWeight: FontWeight.bold,
                                      color: gradientStartColor),
                                ),
                              )
                            : PageView.builder(
                                controller: _pageController,
                                scrollDirection: Axis.horizontal,
                                itemCount: demande.length,
                                itemBuilder: (context, index) {
                                  var demandeConsultation = demande[index]
                                      .data() as Map<String, dynamic>;

                                  return GestureDetector(
                                    onTap: () {
                                      // ==tel le lien de l'image du patient===
                                      getLienDoc(demandeConsultation[
                                              'Praticien_ID'])
                                          .then((_) {
                                        //====ensuite tel l'image =======
                                        downloadImage(
                                            demandeConsultation['Patient_ID']);
                                      }).then((_) {
                                        // ======enfin va  à la page du patient pour afficher tous ça=====
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    HistoriquePatient(
                                                      praticienID:
                                                          demandeConsultation[
                                                              'Praticien_ID'],
                                                      patientID:
                                                          demandeConsultation[
                                                              'Patient_ID'],
                                                      lienDoc: lienDoc,
                                                      imageDocumentPatient:
                                                          _imagePatient,
                                                    )));
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(45),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20)),
                                              color: gradientStartColor,
                                            ),
                                            child: Column(children: [
                                              // ========Date==========
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        getProportionateScreenHeight(
                                                            10),
                                                    horizontal:
                                                        getProportionateScreenHeight(
                                                            15)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    AdaptiveText(
                                                        text: demandeConsultation[
                                                                "Date_Consultation"] +
                                                            " " +
                                                            demandeConsultation[
                                                                "Heure_Consultation"],
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize:
                                                                    getProportionateScreenHeight(
                                                                        14),
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    SizedBox(
                                                      width:
                                                          getProportionateScreenHeight(
                                                              10),
                                                    ),
                                                    AdaptiveText(
                                                        text: demandeConsultation[
                                                            "Type_Consultation"],
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize:
                                                                    getProportionateScreenHeight(
                                                                        14),
                                                                color: Colors
                                                                    .orange,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ),
                                        ),
                                        // ========Deuxième face=======
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(140),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20)),
                                                color: Colors.grey[300],
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 3),
                                                ]),
                                            child: Column(children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        getProportionateScreenHeight(
                                                            10),
                                                    top:
                                                        getProportionateScreenHeight(
                                                            15)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              65),
                                                      width:
                                                          getProportionateScreenHeight(
                                                              65),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/images/docteur.png")),
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              getProportionateScreenHeight(
                                                                  15)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                getProportionateScreenHeight(
                                                                    120),
                                                            child: Text(
                                                                // "Ferdinand Konan",
                                                                demandeConsultation[
                                                                    "Patient_nom"],
                                                                textScaler: MediaQuery.of(
                                                                        context)
                                                                    .textScaler,
                                                                maxLines: 2,
                                                                style: GoogleFonts.montserrat(
                                                                    fontSize:
                                                                        getProportionateScreenHeight(
                                                                            16),
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                getProportionateScreenHeight(
                                                                    10),
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .info_outline_rounded,
                                                            size:
                                                                getProportionateScreenHeight(
                                                                    28),
                                                            color: Colors.white,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // =======Decliner et Accepter========
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        getProportionateScreenHeight(
                                                            10),
                                                    top:
                                                        getProportionateScreenHeight(
                                                            18)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {},
                                                      child: Container(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                30),
                                                        width:
                                                            getProportionateScreenHeight(
                                                                125),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color:
                                                                Colors.orange),
                                                        child: Center(
                                                          child: Text(
                                                              "Décaler le rdv",
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.montserrat(
                                                                  fontSize:
                                                                      getProportionateScreenHeight(
                                                                          15),
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          getProportionateScreenHeight(
                                                              35),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        String docId =
                                                            demande[index].id;

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Praticiens')
                                                            .doc(_user!.email)
                                                            .collection(
                                                                'Consultation')
                                                            .doc(docId)
                                                            .delete();
                                                      },
                                                      child: Container(
                                                        height:
                                                            getProportionateScreenHeight(
                                                                30),
                                                        width:
                                                            getProportionateScreenHeight(
                                                                90),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: Colors.grey),
                                                        child: Center(
                                                          child: Text("Annuler",
                                                              textScaler:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .textScaler,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.montserrat(
                                                                  fontSize:
                                                                      getProportionateScreenHeight(
                                                                          14),
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                      },
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
