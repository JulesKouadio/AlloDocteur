import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctolopro/ecran/profile/profil_pages/page/page_deux.dart';
import 'package:doctolopro/ecran/profile/profil_pages/page/page_tarif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant.dart';
import '../../widgets/snack_bar.dart';
import 'profil_pages/page/page_dispo.dart';
import 'profil_pages/page/page_un.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _controller = PageController();
  final TarifController tarifController = Get.find();
  final DisponibiliteController dispoController = Get.find();
  final GenreController genreController = Get.find();
  final ServiceController serviceController = Get.find();
  // =User=========
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
    _getUser();
    fetchExistence();
  }

  bool prefExiste = false;
  fetchExistence() async {
    final collectionPref = await FirebaseFirestore.instance
        .collection('Praticiens')
        .doc(_user!.email)
        .collection("Préférences")
        .doc(_user!.email)
        .get();

    setState(() {
      prefExiste = collectionPref.exists;
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
        "Sexe": genreController.isMaleAccepted.value ? "Masculin" : "Féminin",
        "Services_Présentiel": serviceController.isPresentielAccepted.value,
        "Services_Video": serviceController.isVideoAccepted.value,
        "PrixPresentiel": tarifController.prix_presentiel.value,
        "MinutePresentiel": tarifController.minute_presentiel.value,
        "PrixVideo": tarifController.prix_video.value,
        "MinuteVideo": tarifController.minute_video.value,
        "Heure_Ouverture": dispoController.ouverture.value,
        "Heure_Fermeture": dispoController.fermeture.value,
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
        "Sexe": genreController.isMaleAccepted.value ? "Masculin" : "Féminin",
        "Services_Présentiel": serviceController.isPresentielAccepted.value,
        "Services_Video": serviceController.isVideoAccepted.value,
        "PrixPresentiel": tarifController.prix_presentiel.value,
        "MinutePresentiel": tarifController.minute_presentiel.value,
        "PrixVideo": tarifController.prix_video.value,
        "MinuteVideo": tarifController.minute_video.value,
        "Heure_Ouverture": dispoController.ouverture.value,
        "Heure_Fermeture": dispoController.fermeture.value,
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
    }
  }

  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: getProportionateScreenHeight(15)),
        child: Column(
          children: [
            // page view
            SizedBox(
              height: getProportionateScreenHeight(550),
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    onLastPage = (index == 3);
                  });
                },
                children: [
                  PageUn(),
                  PageDeux(
                    controller: _controller,
                  ),
                  PageTarif(
                    controller: _controller,
                  ),
                  PageDispo(
                    controller: _controller,
                  )
                ],
              ),
            ),

            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            Spacer(),
            Padding(
              padding:
                  EdgeInsets.only(bottom: getProportionateScreenHeight(15)),
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
                      // onLastPage? then firebase
                      onLastPage
                          ? upload()
                          : _controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                    },
                    child: onLastPage
                        ? AdaptiveText(
                            text: "valider",
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                        : AdaptiveText(
                            text: "Suivant",
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.w900,
                                color: Colors.white))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
