import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctolopro/widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant.dart';

class CalendarScreen extends StatefulWidget {
  final String nomPraticien;
  final String praticienID;

  const CalendarScreen(
      {super.key, required this.nomPraticien, required this.praticienID});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
// ========findIndices==========
  List<int> findIndices(String targetDate, List appointments) {
    List<int> indices = [];
    for (int i = 0; i < appointments.length; i++) {
      if (appointments[i].contains(targetDate)) {
        indices.add(i);
      }
    }
    return indices;
  }

// =============================
  Future<void> getUser() async {
    final user = _auth.currentUser;

    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

// ========bottomSheet====================
  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext) {
        return Container(
          height: getProportionateScreenHeight(150),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Wrap(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: getProportionateScreenHeight(3),
                        width: getProportionateScreenHeight(50),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: getProportionateScreenHeight(300),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _motifController =
                                  "Première consultation en médécine générale";
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                              "Première consultation en médécine générale",
                              textScaler: MediaQuery.of(context).textScaler,
                              maxLines: 2,
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: getProportionateScreenHeight(300),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _motifController =
                                  "Consultation de suivie en médécine générale";
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                              "Consultation de suivie en médécine générale",
                              textScaler: MediaQuery.of(context).textScaler,
                              maxLines: 2,
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

// ============================
  int seconds = 3;
  bool validerCliquer = false;
  void patience() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (seconds == 0) {
        timer.cancel();
        setState(() {
          validerCliquer = !validerCliquer;
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  String userName = "";
// ==========================
  Future<void> _fetchUserInfos() async {
    final utilisateur =
        FirebaseFirestore.instance.collection('Utilisateurs').doc(_user!.email);

    final docSnapshot = await utilisateur.get();

    // Parcourez les documents
    if (docSnapshot.exists) {
      final nom = docSnapshot.data()?['Nom'];
      final nomUser = nom != null ? nom : "";
// =============================
      final prenom = docSnapshot.data()?['Prénoms'];
      final prenomUser = prenom != null ? prenom : "";
      setState(() {
        userName = nomUser + " " + prenomUser;
      });
    }
  }

// ========extraires les dates creneau occupés=========
  List extractDates(List list) {
    return list.map((item) {
      return item.split('--')[0];
    }).toList();
  }
  // ========fin extraction les dates creneau occupés=========

  // ========extraires les heures creneau occupés=========
  List extractTime(List list) {
    return list.map((item) {
      return item.split('--')[1];
    }).toList();
  }
  // ========fin extraction les heures creneau occupés=========

  List creneau = [];
  Future<void> FetchPraticienCreneau() async {
    final documents = await FirebaseFirestore.instance
        .collection('Praticiens')
        .doc(widget.praticienID)
        .collection('creneau_occupé')
        .get();

    List fetchedCreneau = [];
    for (var doc in documents.docs) {
      fetchedCreneau.add(doc["occuper"]);
    }

    setState(() {
      creneau = fetchedCreneau;
    });
  }

  // ==========uploader formations et expérience=====
  Future<void> uploadInfos() async {
    if (_user != null) {
      if (_motifController.isNotEmpty &
          (cocher_cabinet || cocher_video) &
          (indexHeureTaped != 100) &
          (indexDateTaped != 100)) {
        await FirebaseFirestore.instance
            .collection("Praticiens")
            .doc(widget.praticienID)
            .collection("Consultation")
            .doc(widget.praticienID)
            .set({
          "Motif_Consultation": _motifController,
          "Type_Consultation": cocher_cabinet ? "Au cabinet" : "En vidéo",
          "Date_Consultation": theTexteAdapter(_selectedDay.weekday + indexDate,
              _selectedDay.day + indexDate, _selectedDay.month),
          "Heure_Consultation": calculateFinalTime(
              heureDebut, minuteDebut, indexHeureTaped, 15, heureFin),
          "Statut_Consultation": "En cours de traitement",
          "Praticien_nom": widget.nomPraticien,
          "Praticien_ID": widget.praticienID,
          "Patient_nom": userName,
          "Patient_ID": _user!.email,
          "Lien_Document": ""
        }).then((_) {
          patience();
        });
      } else {
        showCustomDialog(context,
            "Assurez-vous d'avoir fourni toutes les informations", "Attention");
      }
    } else {
      showCustomDialog(
          context, "Veuillez d'abord vous connecter", "Connexion requise");
    }
  }

// ===========get Absence day============
  List numPresents = [];

  Future<void> getAbsenceDay() async {
    final jours = await FirebaseFirestore.instance
        .collection("Praticiens")
        .doc(widget.praticienID)
        .collection("Préférences")
        .doc(widget.praticienID)
        .get();
    List number = [0, 1, 2, 3, 4, 5, 6];
    List weekend = [
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi",
      "Dimanche"
    ];
    List nombre = [];
    if (jours.exists) {
      setState(() {
        numPresents = jours["SemaineIndex"];
      });
      for (var elt in number) {
        if (!numPresents.contains(elt)) {
          nombre.add(weekend[elt]);
        }
      }
      setState(() {
        absence = nombre;
      });
    }
  }

// ======================================
  int heureDebut = 9;
  int heureFin = 16;
  int minuteDebut = 0;
  int minuteFin = 0;
  bool enPresentiel = true;
  bool enVideo = true;
  Future<void> getHours() async {
    final jours = await FirebaseFirestore.instance
        .collection("Praticiens")
        .doc(widget.praticienID)
        .collection("Préférences")
        .doc(widget.praticienID)
        .get();
    if (jours.exists) {
      setState(() {
        heureDebut = int.parse(jours["Heure_Ouverture"].split(":")[0]);
        heureFin = int.parse(jours["Heure_Fermeture"].split(":")[0]);
        minuteDebut = int.parse(jours["Heure_Ouverture"].split(":")[1]);
        minuteFin = int.parse(jours["Heure_Fermeture"].split(":")[1]);
        // ===========================================
        enPresentiel = jours["Services_Présentiel"];
        enVideo = jours["Services_Video"];
      });
    }
  }

// ======================================
  DateTime _selectedDay = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool cocher_cabinet = false;
  bool cocher_video = false;
  int minuteSelected = 0;
  int minutefinale = 0;
  int nbreItems = 0;
  List dateChoisie = [];
  int indexHeureTaped = 100;
  int indexDateTaped = 100;
  int indexDate = 1;
  bool arrow_forward = false;
  bool arrow_back = false;
  var _motifController = "Choisir un motif...";
  var couleur;
  void boolDate() {
    for (var i = 0; i < 30; i++) {
      setState(() {
        dateChoisie.add(false);
      });
    }
  }

  void updateMinuteSelected(int newMinute) {
    setState(() {
      minuteSelected = newMinute;
    });
  }

  void NbreItems(List liste) {
    setState(() {
      nbreItems = 4 + liste.length;
    });
  }

  List absence = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
    getUser();
    getHours();
    getAbsenceDay();
    boolDate();
    _fetchUserInfos();
    FetchPraticienCreneau();
    NbreItems(absence);
  }

// =============
  var incrementation = 0;
// =============
  void more() {
    setState(() {
      _selectedDay = DateTime.utc(
          _selectedDay.year, _selectedDay.month, _selectedDay.day + nbreItems);
      // =============
      incrementation += 1;
    });
  }

  void less() {
    setState(() {
      _selectedDay = DateTime.utc(
          _selectedDay.year, _selectedDay.month, _selectedDay.day - nbreItems);
      // ============
      incrementation -= 1;
    });
  }

  String calculateFinalTime(int startingHour, int startingMinute, int index,
      int constant, int endHour) {
    // Calculer le produit de l'index et de la constante
    int product = index * constant;

    // Diviser le produit par 60
    double result = product / 60;

    // Obtenir la partie entière et la partie fractionnaire
    int integerPart = result.floor();
    double fractionalPart = result - integerPart;

    // Ajouter la partie entière à l'heure de départ
    int finalHour = startingHour + integerPart;

    // Vérifier si l'heure finale dépasse l'heure de fin
    // if (finalHour >= endHour) {
    //   finalHour = endHour;
    //   fractionalPart =
    //       0; // Mettre les minutes à zéro si l'heure de fin est atteinte
    // }

    // Convertir la partie fractionnaire en minutes
    int finalMinutes = ((fractionalPart + (startingMinute / 60)) * 60).round();
    String formattedMinutes =
        finalMinutes == 0 ? '00' : finalMinutes.toString();

    if (finalMinutes == 0) {
      formattedMinutes = "00";
    } else if (finalMinutes >= 60) {
      finalHour += (finalMinutes / 60).floor();
      formattedMinutes =
          (((finalMinutes / 60) - (finalMinutes / 60).floor()) * 60)
              .round()
              .toString()
              .padLeft(2, "0");
    }
    // Afficher le résultat final
    return '${finalHour}:${formattedMinutes}';
  }

// =============
  String jourDeLaSemaine(int weekDay) {
    int dDay = weekDay % 7;
    if (dDay == 1) {
      return 'Lundi';
    } else if (dDay == 2) {
      return "Mardi";
    } else if (dDay == 3) {
      return "Mercredi";
    } else if (dDay == 4) {
      return "Jeudi";
    } else if (dDay == 5) {
      return "Vendredi";
    } else if (dDay == 6) {
      return 'Samedi';
    } else {
      return "Dimanche";
    }
  }

  // =========================
  String Mois(int dDay) {
    if (dDay == 1) {
      return 'Janvier';
    } else if (dDay == 2) {
      return "Février";
    } else if (dDay == 3) {
      return "Mars";
    } else if (dDay == 4) {
      return "Avril";
    } else if (dDay == 5) {
      return "Mai";
    } else if (dDay == 6) {
      return 'Juin';
    } else if (dDay == 7) {
      return "Juillet";
    } else if (dDay == 8) {
      return "Août";
    } else if (dDay == 9) {
      return "Septembre";
    } else if (dDay == 10) {
      return "Octobre";
    } else if (dDay == 11) {
      return "Novembre";
    } else {
      return "Décembre";
    }
  }

  List trenteUn = [1, 3, 5, 7, 8, 10, 12];
  List exception = [2];

  theTexte(weekDay, day, month) {
    if (trenteUn.contains(month)) {
      if (day > 31) {
        return SizedBox(
          height: getProportionateScreenHeight(36),
          width: getProportionateScreenWidth(85),
          child: Column(
            children: [
              Text(jourDeLaSemaine(weekDay),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(13),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text((day % 31).toString() + " " + Mois(month + 1),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(12),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))
            ],
          ),
        );
      } else {
        return SizedBox(
          height: getProportionateScreenHeight(36),
          width: getProportionateScreenWidth(85),
          child: Column(
            children: [
              Text(jourDeLaSemaine(weekDay),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(13),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text((day).toString() + " " + Mois(month),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(12),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))
            ],
          ),
        );
      }
    } else if (exception.contains(month)) {
      if (day > 28) {
        return SizedBox(
          height: getProportionateScreenHeight(36),
          width: getProportionateScreenWidth(85),
          child: Column(
            children: [
              Text(jourDeLaSemaine(weekDay),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(13),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text((day % 28).toString() + " " + Mois(month + 1),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(12),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))
            ],
          ),
        );
      } else {
        return SizedBox(
          height: getProportionateScreenHeight(36),
          width: getProportionateScreenWidth(85),
          child: Column(
            children: [
              Text(jourDeLaSemaine(weekDay),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(13),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text((day).toString() + " " + Mois(month),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(12),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))
            ],
          ),
        );
      }
    } else {
      if (day > 30) {
        return SizedBox(
          height: getProportionateScreenHeight(36),
          width: getProportionateScreenWidth(85),
          child: Column(
            children: [
              Text(jourDeLaSemaine(weekDay),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(13),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text((day % 30).toString() + " " + Mois(month + 1),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(12),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))
            ],
          ),
        );
      } else {
        return SizedBox(
          height: getProportionateScreenHeight(36),
          width: getProportionateScreenWidth(85),
          child: Column(
            children: [
              Text(jourDeLaSemaine(weekDay),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(13),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Text((day).toString() + " " + Mois(month),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                      fontSize: getProportionateScreenHeight(12),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))
            ],
          ),
        );
      }
    }
  }

// ==========jour choisi adapté===============
  theTexteAdapter(weekDay, day, month) {
    if (trenteUn.contains(month)) {
      if (day > 31) {
        return jourDeLaSemaine(weekDay) +
            " " +
            (day % 31).toString() +
            " " +
            Mois(month + 1);
      } else {
        return jourDeLaSemaine(weekDay) +
            " " +
            (day).toString() +
            " " +
            Mois(month);
      }
    } else if (exception.contains(month)) {
      if (day > 28) {
        return jourDeLaSemaine(weekDay) +
            " " +
            (day % 28).toString() +
            " " +
            Mois(month + 1);
      } else {
        return jourDeLaSemaine(weekDay) +
            " " +
            (day).toString() +
            " " +
            Mois(month);
      }
    } else {
      if (day > 30) {
        return jourDeLaSemaine(weekDay) +
            " " +
            (day % 30).toString() +
            " " +
            Mois(month + 1);
      } else {
        return jourDeLaSemaine(weekDay) +
            " " +
            (day).toString() +
            " " +
            Mois(month);
      }
    }
  }

// ===========================================
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: getProportionateScreenHeight(683),
          width: getProportionateScreenWidth(410),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(children: [
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_back,
                          size: getProportionateScreenHeight(25),
                          color: Colors.black87,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenHeight(50),
                        bottom: getProportionateScreenHeight(10)),
                    child: AdaptiveText(
                        text: 'Type de consultation',
                        style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(16),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                  ),
                ],
              ),
              Column(
                children: [
                  // Début Cabinet
                  Visibility(
                    visible: enPresentiel,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(2),
                          left: getProportionateScreenHeight(8),
                          right: getProportionateScreenHeight(8)),
                      child: Container(
                        height: getProportionateScreenHeight(60),
                        decoration: cocher_cabinet
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border(
                                    top: BorderSide(
                                        width: 4,
                                        color: gradientStartColor
                                            .withOpacity(0.6)),
                                    bottom: BorderSide(
                                        width: 4,
                                        color: gradientStartColor
                                            .withOpacity(0.6)),
                                    left: BorderSide(
                                        width: 4,
                                        color: gradientStartColor
                                            .withOpacity(0.6)),
                                    right: BorderSide(
                                        width: 4,
                                        color: gradientStartColor
                                            .withOpacity(0.6))))
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            height: getProportionateScreenHeight(50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: gradientEndColor.withOpacity(0.3)),
                            child: // Première case à cocher
                                GestureDetector(
                              onTap: () {
                                setState(() {
                                  !cocher_video
                                      ? cocher_cabinet = !cocher_cabinet
                                      : null;
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: getProportionateScreenHeight(15),
                                  ),
                                  Container(
                                    height: getProportionateScreenHeight(20),
                                    width: getProportionateScreenHeight(20),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: cocher_cabinet
                                        ? Center(
                                            child: Icon(Icons.check,
                                                size:
                                                    getProportionateScreenHeight(
                                                        15),
                                                color: gradientStartColor),
                                          )
                                        : Container(),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenHeight(20),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width:
                                            getProportionateScreenHeight(120),
                                        child: Row(
                                          children: [
                                            Text("Au cabinet",
                                                style: GoogleFonts.montserrat(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            14),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            getProportionateScreenHeight(120),
                                        child: Row(
                                          children: [
                                            Text('Dès Lun. à 12:00',
                                                style: GoogleFonts.montserrat(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            14),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenHeight(90),
                                  ),
                                  Icon(Icons.home_rounded,
                                      color: Colors.white,
                                      size: getProportionateScreenHeight(30))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Fin cabinet
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  // Début Vidéo
                  Visibility(
                    visible: enVideo,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(2),
                          left: getProportionateScreenHeight(8),
                          right: getProportionateScreenHeight(8)),
                      child: Container(
                        height: getProportionateScreenHeight(60),
                        decoration: cocher_video
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border(
                                    top: BorderSide(
                                        width: getProportionateScreenHeight(3),
                                        color: gradientStartColor
                                            .withOpacity(0.6)),
                                    bottom: BorderSide(
                                        width: getProportionateScreenHeight(3),
                                        color: gradientStartColor
                                            .withOpacity(0.6)),
                                    left: BorderSide(
                                        width: getProportionateScreenHeight(3),
                                        color: gradientStartColor
                                            .withOpacity(0.6)),
                                    right: BorderSide(
                                        width: getProportionateScreenHeight(3),
                                        color: gradientStartColor
                                            .withOpacity(0.6))))
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            height: getProportionateScreenHeight(50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: gradientEndColor.withOpacity(0.3)),
                            child: // Première case à cocher
                                GestureDetector(
                              onTap: () {
                                setState(() {
                                  !cocher_cabinet
                                      ? cocher_video = !cocher_video
                                      : null;
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: getProportionateScreenHeight(15),
                                  ),
                                  Container(
                                    height: getProportionateScreenHeight(20),
                                    width: getProportionateScreenHeight(20),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: cocher_video
                                        ? Center(
                                            child: Icon(Icons.check,
                                                size:
                                                    getProportionateScreenHeight(
                                                        15),
                                                color: gradientStartColor),
                                          )
                                        : Container(),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenHeight(20),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width:
                                            getProportionateScreenHeight(120),
                                        child: Row(
                                          children: [
                                            Text("En vidéo",
                                                style: GoogleFonts.montserrat(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            14),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            getProportionateScreenHeight(122),
                                        child: Row(
                                          children: [
                                            Text('Dès Ven. à 15:00',
                                                style: GoogleFonts.montserrat(
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            14),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenHeight(90),
                                  ),
                                  Icon(Icons.phone_android_rounded,
                                      color: Colors.white,
                                      size: getProportionateScreenHeight(30))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  // Fin vidéo
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: getProportionateScreenHeight(10)),
                    child: Text("Motif de consultation",
                        textScaler: MediaQuery.of(context).textScaler,
                        style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(16),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                  ),
                ],
              ),
              // ==========motif de consultation======
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showPicker(context);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _motifController,
                        style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(15),
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Container(
                        height: getProportionateScreenHeight(1),
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              // =======colonne pour la visibilité======
              Column(
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Center(
                    child: Text("Selectionnez la date",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(16),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (incrementation > 0) {
                            less();
                          }
                        },
                        child: Icon(Icons.arrow_back_ios_rounded,
                            size: getProportionateScreenHeight(23),
                            color: gradientStartColor.withOpacity(0.7)),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(50),
                        width: getProportionateScreenWidth(345),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 30,
                            itemBuilder: ((context, index) {
                              return Visibility(
                                visible: !absence.contains(jourDeLaSemaine(
                                    _selectedDay.weekday + index)),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // =====Date cliquée======
                                      indexDate = index;
                                      indexDateTaped = index;
                                      // =====Fin date cliquée=======
                                      // ==========
                                      arrow_forward = !arrow_forward;
                                      arrow_back = !arrow_back;
                                      // ===========
                                    });
                                  },
                                  child: Container(
                                    decoration: indexDateTaped == index
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border(
                                                right: BorderSide(
                                                    width: getProportionateScreenHeight(
                                                        2.5),
                                                    color: gradientStartColor
                                                        .withOpacity(0.7)),
                                                left: BorderSide(
                                                    width:
                                                        getProportionateScreenHeight(
                                                            2.5),
                                                    color: gradientStartColor
                                                        .withOpacity(0.7)),
                                                bottom: BorderSide(
                                                    width:
                                                        getProportionateScreenHeight(
                                                            2.5),
                                                    color: gradientStartColor
                                                        .withOpacity(0.7)),
                                                top: BorderSide(width: getProportionateScreenHeight(2.5), color: gradientStartColor.withOpacity(0.7))))
                                        : null,
                                    child: Row(
                                      children: [
                                        theTexte(
                                            _selectedDay.weekday + index,
                                            _selectedDay.day + index,
                                            _selectedDay.month),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                      ),
                      GestureDetector(
                        onTap: () {
                          more();
                        },
                        child: Icon(Icons.arrow_forward_ios_rounded,
                            size: getProportionateScreenHeight(23),
                            color: gradientStartColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Center(
                    child: Text("Selectionnez l'heure",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(16),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenHeight(15),
                        right: getProportionateScreenHeight(15)),
                    child: Divider(),
                  ),
                  // GridView
                  StatefulBuilder(builder: ((context, setState) {
                    return SizedBox(
                      height: getProportionateScreenHeight(148),
                      width: getProportionateScreenHeight(300),
                      child: GridView.builder(
                          itemCount: (heureFin - heureDebut - 1) * 5,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.7, crossAxisCount: 4),
                          itemBuilder: (context, index) {
                            var visible;
                            // ========visibilité====================
                            if ((int.parse(calculateFinalTime(heureDebut,
                                        minuteDebut, index, 15, heureFin)
                                    .split(":")[0]) >
                                heureFin)) {
                              visible = false;
                            } else if ((int.parse(calculateFinalTime(heureDebut,
                                            minuteDebut, index, 15, heureFin)
                                        .split(":")[0]) ==
                                    heureFin &&
                                int.parse(calculateFinalTime(heureDebut,
                                            minuteDebut, index, 15, heureFin)
                                        .split(":")[1]) >=
                                    minuteFin)) {
                              visible = false;
                            } else {
                              visible = true;
                            }
                            // =======index et heures occupées=======
                            List heuresOccupees = [];
                            List indexHeuresOccupees = findIndices(
                                theTexteAdapter(
                                    _selectedDay.weekday + indexDate,
                                    _selectedDay.day + indexDate,
                                    _selectedDay.month),
                                extractDates(creneau));
                            for (var index in indexHeuresOccupees) {
                              heuresOccupees.add(extractTime(creneau)[index]);
                            }

                            return GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    indexHeureTaped = index;
                                  },
                                );
                              },
                              child: Visibility(
                                visible: !heuresOccupees.contains(
                                    calculateFinalTime(heureDebut, minuteDebut,
                                        index, 15, heureFin)),
                                child: Container(
                                  decoration: indexHeureTaped == index
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border(
                                              top: BorderSide(
                                                  width:
                                                      getProportionateScreenHeight(
                                                          3),
                                                  color: gradientStartColor
                                                      .withOpacity(0.6)),
                                              bottom: BorderSide(
                                                  width:
                                                      getProportionateScreenHeight(
                                                          3),
                                                  color: gradientStartColor
                                                      .withOpacity(0.6)),
                                              left: BorderSide(
                                                  width:
                                                      getProportionateScreenHeight(
                                                          3),
                                                  color: gradientStartColor
                                                      .withOpacity(0.6)),
                                              right: BorderSide(width: getProportionateScreenHeight(3), color: gradientStartColor.withOpacity(0.6))))
                                      : null,
                                  child: Visibility(
                                    visible: visible,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              getProportionateScreenHeight(5),
                                          vertical:
                                              getProportionateScreenHeight(5)),
                                      height: getProportionateScreenHeight(10),
                                      width: getProportionateScreenWidth(30),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            gradientEndColor.withOpacity(0.3),
                                      ),
                                      child: Center(
                                        child: Text(
                                            calculateFinalTime(
                                                heureDebut,
                                                minuteDebut,
                                                index,
                                                15,
                                                heureFin),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        15),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  })),
                  // Fin GridView et début Valider
                  // espace entre GridView et valider
                  SizedBox(
                    height:(!enPresentiel || !enVideo)? getProportionateScreenHeight(110):getProportionateScreenHeight(55),
                  ),
                  SizedBox(
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
                          uploadInfos();
                          setState(() {
                            validerCliquer = !validerCliquer;
                          });
                        },
                        child: !validerCliquer
                            ? AdaptiveText(
                                text: "valider",
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenWidth(20),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))
                            : SpinKitThreeBounce(
                                color: Colors.white,
                                size: getProportionateScreenHeight(15))),
                  )
                ],
              ),
              // ============showModalBottomSheet===============

              // ============Fin showModalBottomSheet===========
            ]),
          ),
        ),
      ),
    );
  }
}

List<bool> motifsBool = [false, false];
