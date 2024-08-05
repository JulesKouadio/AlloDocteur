import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctolopro/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../constant.dart';

class DisponibiliteController extends GetxController {
  var ouverture = "".obs;
  var fermeture = "".obs;
  List weekday = [].obs;

  void Ouverture(String heure, String minute) {
    ouverture.value = heure + ":" + minute;
  }

  void Fermeture(String heure, String minute) {
    fermeture.value = heure + ":" + minute;
  }

  void WeekDay(List booleen) {
    for (var i = 0; i < booleen.length; i++) {
      if (booleen[i] && !weekday.contains(i)) {
        weekday.add(i);
      }
    }
  }
}

class PageDispo extends StatefulWidget {
  final PageController? controller;
  const PageDispo({super.key, this.controller});

  @override
  State<PageDispo> createState() => PageDispoState();
}

class PageDispoState extends State<PageDispo> {
  final DisponibiliteController _dispoController =
      Get.put(DisponibiliteController());

  List semaine = ["L", "M", "M", "J", "V", "S", "D"];

  List<bool> booleen = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  final DisponibiliteController dispoController = Get.find();

  bool taped = false;
  var hour_ouverture = 0;
  var minute_ouverture = 0;
  var hour_fermeture = 0;
  var minute_fermeture = 0;
  bool toogle_fermeture = false;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
    _getUser();
    fetchExistence();
    super.initState();
  }

  void dispose() {
    dispoController.dispose();
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String sexe = "";
  bool presentiel = false;
  bool video = false;
  String prixPresentiel = "";
  String prixVideo = "";
  String minutePresentiel = "";
  String minuteVideo = "";
  bool prefExiste = false;
  String heureOuverture = "";
  String heureFermeture = "";
  fetchExistence() async {
    final collectionPref = await FirebaseFirestore.instance
        .collection('Praticiens')
        .doc(_user!.email)
        .collection("Préférences")
        .doc(_user!.email)
        .get();

    setState(() {
      prefExiste = collectionPref.exists;
      sexe = collectionPref["Sexe"];
      presentiel = collectionPref["Services_Présentiel"];
      video = collectionPref["Services_Video"];
      prixPresentiel = collectionPref["PrixPresentiel"];
      prixVideo = collectionPref["PrixVideo"];
      minutePresentiel = collectionPref["MinutePresentiel"];
      minuteVideo = collectionPref["MinuteVideo"];
      heureFermeture=collectionPref["Heure_Fermeture"];
      heureOuverture=collectionPref["Heure_Ouverture"];
    });
  }

  Future<void> _getUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> upload() async {
    if (prefExiste) {
      await FirebaseFirestore.instance
          .collection('Praticiens')
          .doc(_user!.email)
          .collection("Préférences")
          .doc(_user!.email)
          .update({
        "Heure_Ouverture": dispoController.ouverture.value!=""?dispoController.ouverture.value:heureOuverture,
        "Heure_Fermeture": dispoController.fermeture.value!=""?dispoController.fermeture.value:heureFermeture,
        "SemaineIndex": dispoController.weekday
      }).then((_) {
        showCustomSnackbar(context, "informations ajoutées avec succès");
      }).then((_) {
        setState(() {
          dispoController.weekday = [];
        });
      }).then((_) {
        Navigator.pop(context);
      });
    } else {
      await FirebaseFirestore.instance
          .collection('Praticiens')
          .doc(_user!.email)
          .collection("Préférences")
          .doc(_user!.email)
          .set({
        "Sexe": sexe,
        "Services_Présentiel": presentiel,
        "Services_Video": video,
        "PrixPresentiel": prixPresentiel,
        "MinutePresentiel": minutePresentiel,
        "PrixVideo": prixVideo,
        "MinuteVideo": minuteVideo,
        "Heure_Ouverture": dispoController.ouverture.value,
        "Heure_Fermeture": dispoController.fermeture.value,
        "SemaineIndex": dispoController.weekday
      }).then((_) {
        showCustomSnackbar(context, "Mise à jour effectuée");
      }).then((_) {
        setState(() {
          dispoController.weekday = [];
        });
      }).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: getProportionateScreenHeight(35),
              leading: GestureDetector(
                  onTap: () {
                    widget.controller == null
                        ? Navigator.pop(context)
                        : widget.controller!.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                  },
                  child: Icon(Icons.arrow_back,
                      size: getProportionateScreenHeight(25),
                      color: Colors.black)),
              title: Text("Disponibilité",
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(17),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87))),
          body: Stack(
            children: [
              Positioned(
                  child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: getProportionateScreenHeight(8)),
                    child: Row(
                      children: [
                        Text("Jours de la semaine",
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenHeight(17),
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(70),
                    child: ListView.builder(
                        itemCount: semaine.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                booleen[index] = !booleen[index];
                                _dispoController.WeekDay(booleen);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                height: getProportionateScreenHeight(45),
                                width: getProportionateScreenWidth(50),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: booleen[index]
                                      ? gradientStartColor
                                      : Colors.grey[200],
                                ),
                                child: Center(
                                  child: Text(semaine[index],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(17),
                                          fontWeight: FontWeight.bold,
                                          color: booleen[index]
                                              ? Colors.white
                                              : Colors.black54)),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: getProportionateScreenHeight(8),
                            top: getProportionateScreenHeight(15)),
                        child: Text("Plage horaire",
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenHeight(17),
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(20)),
                    child: Column(children: [
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: getProportionateScreenHeight(10)),
                          child: Text("Ouverture",
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87)),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(104),
                        ),
                        Text("Fermeture",
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenHeight(15),
                                fontWeight: FontWeight.bold,
                                color: Colors.black87))
                      ]),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                taped = !taped;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(10)),
                              child: Container(
                                width: getProportionateScreenWidth(165),
                                height: getProportionateScreenHeight(45),
                                child: Column(children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(12),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          hour_ouverture != 0
                                              ? hour_ouverture
                                                      .toString()
                                                      .padLeft(2, "0") +
                                                  " : " +
                                                  minute_ouverture
                                                      .toString()
                                                      .padLeft(2, "0")
                                              : "heure                ",
                                          style: hour_ouverture != 0
                                              ? GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          20),
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold)
                                              : TextStyle(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          20),
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w900)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(8),
                                  ),
                                  Container(
                                    height: getProportionateScreenWidth(2),
                                    width: double.infinity,
                                    color: Colors.grey,
                                  )
                                ]),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                taped = !taped;
                                toogle_fermeture = !toogle_fermeture;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(34)),
                              child: Container(
                                width: getProportionateScreenWidth(175),
                                height: getProportionateScreenHeight(45),
                                child: Column(children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(12),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          hour_fermeture != 0
                                              ? hour_fermeture
                                                      .toString()
                                                      .padLeft(2, "0") +
                                                  " : " +
                                                  minute_fermeture
                                                      .toString()
                                                      .padLeft(2, "0")
                                              : "heure          ",
                                          style: hour_fermeture != 0
                                              ? GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          20),
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold)
                                              : TextStyle(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          20),
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w900)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(8),
                                  ),
                                  Container(
                                    height: getProportionateScreenWidth(2),
                                    width: double.infinity,
                                    color: Colors.grey,
                                  )
                                ]),
                              ),
                            ),
                          )
                        ],
                      ),
                    ]),
                  ),
                ],
              )),
              Visibility(
                visible: taped,
                child: Positioned(
                    top: getProportionateScreenHeight(240),
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenHeight(50)),
                      child: Container(
                        height: getProportionateScreenHeight(100),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NumberPicker(
                              minValue: 0,
                              maxValue: 24,
                              value: toogle_fermeture
                                  ? hour_fermeture
                                  : hour_ouverture,
                              zeroPad: true,
                              infiniteLoop: true,
                              itemWidth: getProportionateScreenHeight(50),
                              itemHeight: getProportionateScreenHeight(30),
                              onChanged: (value) {
                                setState(() {
                                  toogle_fermeture
                                      ? hour_fermeture = value
                                      : hour_ouverture = value;
                                });
                              },
                              textStyle: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontSize: getProportionateScreenHeight(14)),
                              selectedTextStyle: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenHeight(22)),
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                      color: Colors.white,
                                    ),
                                    bottom: BorderSide(color: Colors.white)),
                              ),
                            ),
                            NumberPicker(
                              minValue: 0,
                              maxValue: 59,
                              value: toogle_fermeture
                                  ? minute_fermeture
                                  : minute_ouverture,
                              zeroPad: true,
                              infiniteLoop: true,
                              itemWidth: getProportionateScreenHeight(50),
                              itemHeight: getProportionateScreenHeight(30),
                              onChanged: (value) {
                                setState(() {
                                  toogle_fermeture
                                      ? minute_fermeture = value
                                      : minute_ouverture = value;
                                });
                              },
                              textStyle: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontSize: getProportionateScreenHeight(14)),
                              selectedTextStyle: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenHeight(22)),
                              decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                      color: Colors.white,
                                    ),
                                    bottom: BorderSide(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              Positioned(
                top: getProportionateScreenHeight(245),
                left: getProportionateScreenHeight(190),
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      taped = !taped;
                      toogle_fermeture = false;
                      // ================controller===============
                      _dispoController.Ouverture(
                          hour_ouverture.toString().padLeft(2, "0"),
                          minute_ouverture.toString().padLeft(2, "0"));
                      // ===============================
                      _dispoController.Fermeture(
                          hour_fermeture.toString().padLeft(2, "0"),
                          minute_fermeture.toString().padLeft(2, "0"));
                    });
                  },
                  child: Icon(Icons.remove_circle_outline,
                      color: Colors.white,
                      size: getProportionateScreenHeight(25)),
                ),
              ),
              Positioned(
                top: getProportionateScreenHeight(590),
                right: getProportionateScreenHeight(2),
                left: getProportionateScreenHeight(2),
                child: SizedBox(
                    width: getProportionateScreenWidth(400),
                    height: getProportionateScreenHeight(40),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          backgroundColor: gradientStartColor,
                        ),
                        onPressed: () async {
                          if (dispoController.weekday.isNotEmpty) {
                            upload();
                          } else {
                            showCustomDialog(
                                context,
                                "Vous n'avez pas mentionné votre disponibilité.",
                                "Alerte");
                          }
                        },
                        child: AdaptiveText(
                            text: "valider",
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.bold,
                                color: Colors.white)))),
              )
            ],
          )),
    );
  }
}
