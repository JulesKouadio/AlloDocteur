import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctolopro/constant.dart';
import 'package:doctolopro/ecran/home/components/verification_page.dart';
import 'package:doctolopro/ecran/profile/ajout_informations.dart';
import 'package:doctolopro/ecran/sign_up/components/reglementations/terms_and_conditions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../sign_in/components/sign_in_form.dart';
import 'preference_screen.dart';
import 'profil_pages/notifications.dart';
import 'profil_pages/page/page_dispo.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List lesIcons = [
    Icons.settings,
    Icons.event_available,
    Icons.person_add,
    Icons.notifications,
    Icons.info_outline,
    Icons.logout
  ];
  // =======================
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  Future<void> _getUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  // ==========Fetch Infos============
  Future<void> FetchInfos() async {
    if (_user != null) {
      final collections = await FirebaseFirestore.instance
          .collection("Praticiens")
          .doc(_user!.email)
          .get();
      setState(() {
        praticienInfosController.nom = collections['Nom'];
        praticienInfosController.prenoms = collections['Prénoms'];
        praticienInfosController.corporation = collections['Corporation'];
      });
      ;
    } else {
      praticienInfosController.nom = "";
      praticienInfosController.prenoms = "";
      praticienInfosController.corporation = "";
    }
  }
  // =====================
  @override
  void initState() {
    _getUser();
    FetchInfos();
    super.initState();
  }

  final PageController controller = PageController();
  List lesTitres = [
    "Préférences",
    "Mettre à jour mes disponibilités",
    "Ajout d'informations",
    "Notifications",
    "Termes et conditions",
    "Quitter"
  ];
  List lesPages = [
    PreferencesScreen(),
    PageDispo(),
    InfosAdd(),
    NotificationScreen(),
    TermsAndConditions(),
    PreferencesScreen(),
  ];

  Future<void> seDeconnecter() async {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => VerificationPage()),
        (Route<dynamic> route) => false,
      );
      ;
    });
  }

  final PraticienInfosController praticienInfosController = Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: gradientStartColor,
        systemNavigationBarDividerColor: gradientStartColor));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: gradientStartColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          // leading: Padding(
          //   padding: EdgeInsets.only(left: getProportionateScreenHeight(5)),
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (builder) => MyHomePage()));
          //     },
          //     child: Icon(Icons.arrow_back,
          //         color: Colors.white, size: getProportionateScreenHeight(25)),
          //   ),
          // ),
          actions: [
            GestureDetector(
              onTap: () {
                // ====Modifier=====
              },
              child: Padding(
                padding:
                    EdgeInsets.only(right: getProportionateScreenHeight(5)),
                child: Icon(Icons.more_vert_outlined,
                    color: Colors.white,
                    size: getProportionateScreenHeight(20)),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: getProportionateScreenHeight(180),
                color: gradientStartColor,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: getProportionateScreenHeight(100),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/docteur.png')),
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(11),
                    ),
                    Text(
                        praticienInfosController.nom.isNotEmpty
                            ? "Dr. " +
                                praticienInfosController.prenoms.substring(
                                    praticienInfosController.prenoms
                                            .lastIndexOf(" ") +
                                        1,
                                    praticienInfosController.prenoms.length) +
                                " " +
                                praticienInfosController.nom
                            : 'Dr. Votre Nom',
                        style: GoogleFonts.montserrat(
                            // fontFamily: 'Gilroy',
                            fontSize: getProportionateScreenHeight(16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                    Text(
                        praticienInfosController.corporation.isNotEmpty
                            ? praticienInfosController.corporation
                            : 'votre domaine',
                        style: GoogleFonts.montserrat(
                            // fontFamily: 'Gilroy',
                            fontSize: getProportionateScreenHeight(14),
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              Container(
                  height: getProportionateScreenHeight(380),
                  child: ListView.builder(
                      itemCount: lesIcons.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            index == lesIcons.length - 1
                                ? seDeconnecter()
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => lesPages[index]));
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.all(getProportionateScreenHeight(8)),
                            child: Container(
                              height: getProportionateScreenHeight(38),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey[200]),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: getProportionateScreenWidth(15),
                                  ),
                                  Icon(lesIcons[index],
                                      color: Colors.grey,
                                      size: getProportionateScreenHeight(25)),
                                  SizedBox(
                                    width: getProportionateScreenWidth(20),
                                  ),
                                  Text(lesTitres[index],
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey))
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
