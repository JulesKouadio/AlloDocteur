import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctolopro/ecran/home/home_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../profile/profile_screen.dart';
import '../../../constant.dart';
import '../../../widgets/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../sign_in/components/sign_in_form.dart';
import 'reglementations/terms_and_conditions.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailControler = TextEditingController();
  TextEditingController passWordControler = TextEditingController();
  TextEditingController confirmPassWordControler = TextEditingController();
  TextEditingController nameControler = TextEditingController();
  TextEditingController corporationControler = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String cityControler = "";
  String birthdayControler = "";
  TextEditingController firstNameControler = TextEditingController();

  final TermsAndConditionsController _controller = Get.find();
  final PraticienInfosController praticienInfosController = Get.find();

  String? mtoken = '';
  bool city_taped = false;
  bool birthday_taped = false;
  var day = 1;
  var mois = 1;
  var annee = 2000;
  // =======================
  bool passWordVisible = false;
  bool confirmPassWordVisible = false;
  bool checked = false;
  bool coched = false;
  bool emailUsed = false;
  void Email() {
    setState(() {
      emailUsed = !emailUsed;
    });
  }

// ================location==========
  double _currentLatitude = 0;
  double _currentLongitude = 0;
  // ========la localisation ponctuelle du patient===========
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLatitude = position.latitude;
      _currentLongitude = position.longitude;
    });
  }

  // =============fin location=======
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

  // =========================
  List<String> Villes = [
    "Abidjan",
    "Yamoussoukro",
    "Bouaké",
    "Adzopé",
    "Grand-Bassam",
    "Bingerville",
    "San-Pédro",
    "Sassandra",
    "Grand-Lahou",
    "Abengourou",
    "Bondoukou",
    "Toumodi"
  ];
  List<bool> cityBool = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  bool canRegister() {
    return _controller.isAccepted.value &&
        nameControler.text.isNotEmpty &&
        corporationControler.text.isNotEmpty &&
        cityControler != "" &&
        firstNameControler.text.isNotEmpty &&
        emailControler.text.isNotEmpty &&
        passWordControler.text.isNotEmpty &&
        confirmPassWordControler.text.isNotEmpty;
  }

  bool cantRegister() {
    return !_controller.isAccepted.value &&
        (nameControler.text.isEmpty ||
            corporationControler.text.isEmpty ||
            cityControler == "" ||
            emailControler.text.isEmpty ||
            firstNameControler.text.isEmpty ||
            passWordControler.text.isEmpty ||
            confirmPassWordControler.text.isEmpty);
  }

// =========================
  @override
  void dispose() {
    nameControler.dispose();
    emailControler.dispose();
    passWordControler.dispose();
    confirmPassWordControler.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    passWordVisible = false;
    confirmPassWordVisible = false;
    checked = false;
    _getCurrentLocation();
  }

  Future<void> signUp() async {
    try {
      await FirebaseFirestore.instance
          .collection('Praticiens')
          .doc(emailControler.text)
          .set({
        "Nom": nameControler.text.trim(),
        "Prénoms": firstNameControler.text.trim(),
        "Corporation": corporationControler.text.trim(),
        "Adresse": cityControler,
        "Email": emailControler.text.trim(),
        "Localisation":_currentLatitude.toString()+" "+_currentLongitude.toString(),
        "Indication": "",
        "Contact": "",
      });
      // ====================
      praticienInfosController.nom = nameControler.text.trim();
      praticienInfosController.prenoms = firstNameControler.text.trim();
      praticienInfosController.corporation = corporationControler.text.trim();
      // ====================
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailControler.text.trim(),
          password: passWordControler.text.trim());
      // ====================
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => MyHomePage(currentIndex: 4,)),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      // Email();
      // showCustomDialog(context, e.message!, "Alerte");
      // =====================
      if (e.code == 'email-already-in-use') {
        showCustomDialog(context, e.message!, "Alerte");
      } else {
        showCustomDialog(context, e.message!, "Alerte");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));

// ================
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return gradientStartColor;
      }
      return !_controller.isAccepted.value ? Colors.white : Colors.black;
    }

// ================
    // void enregistrerTokenFCM() async {
    //   User? user = _auth.currentUser;
    //   if (user != null) {
    //     String? token = await FirebaseMessaging.instance.getToken();
    //     await FirebaseFirestore.instance
    //         .collection('UserTokens')
    //         .doc(user.uid)
    //         .set({
    //       'token': token,
    //     });
    //         }
    // }
// ================
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: getProportionateScreenHeight(15),
          ),
          //  Nom et Prénoms
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(15)),
          // Corporation
          corporationFormField(),

          SizedBox(height: getProportionateScreenHeight(15)),

          // Ville d'exercice
          Visibility(
            visible: !birthday_taped,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  city_taped = !city_taped;
                });
              },
              child: Container(
                height: getProportionateScreenHeight(46),
                width: getProportionateScreenHeight(330),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                          color: Colors.black,
                        ),
                        left: BorderSide(
                          color: Colors.black,
                        ),
                        right: BorderSide(
                          color: Colors.black,
                        ),
                        bottom: BorderSide(color: Colors.black))),
                child: Row(
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    SvgPicture.asset(
                      "assets/icons/location.svg",
                      width: getProportionateScreenHeight(22),
                      height: getProportionateScreenHeight(22),
                      colorFilter:
                          ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Text(
                        cityControler != ""
                            ? cityControler
                            : "Ville de résidence",
                        style: cityControler != ""
                            ? GoogleFonts.oswald(
                                fontSize: getProportionateScreenWidth(18),
                                fontWeight: FontWeight.normal)
                            : TextStyle(
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold,
                                fontSize: getProportionateScreenHeight(15),
                                color: gradientStartColor)),
                  ],
                ),
              ),
            ),
          ),
          //===============
          Visibility(
              visible: !city_taped,
              child: Column(
                children: [
                  Visibility(
                      visible: !birthday_taped,
                      child: Column(
                        children: [
                          SizedBox(height: getProportionateScreenHeight(15)),
                          buildEmailFormField(),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          buildPasswordFormField(),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          buildConformPassFormField(),
                          SizedBox(height: getProportionateScreenHeight(20)),
// Termes et conditions
                          Row(
                            children: [
                              Obx(() => Checkbox(
                                  checkColor: green,
                                  activeColor: gradientEndColor,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: _controller.isAccepted.value,
                                  onChanged: (_) {})),
                              SizedBox(
                                width: getProportionateScreenWidth(300),
                                child: Column(
                                  children: [
                                    Text(
                                      "Pour continuer veuillez lire et\n accepter nos",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      textScaler:
                                          MediaQuery.textScalerOf(context),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenWidth(17),
                                          color: gradientStartColor,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      TermsAndConditions()));
                                        },
                                        child: AdaptiveText(
                                            text: "termes et conditions",
                                            style: TextStyle(
                                                fontFamily: 'Gilroy',
                                                color: gradientEndColor,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        17),
                                                fontWeight: FontWeight.w900))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: getProportionateScreenHeight(50),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  backgroundColor: gradientStartColor,
                                ),
                                onPressed: () {
                                  // =====tu finis d'envoyer les données stp patiente=====
                                  if (canRegister()) {
                                    signUp().then((_) {
                                      patience();
                                    });
// =========Créer le Token de l'utilisateur non affilié et sauvegarde  dans firebase==========
                                    // enregistrerTokenFCM();
                                  } else if (cantRegister()) {
                                    return showCustomDialog(
                                        context,
                                        "Vous devez donner votre consentement pour continuer.",
                                        "Consentement Requis");
                                  } else {
                                    return showCustomDialog(
                                        context,
                                        "Assurez-vous que vous avez remplir les champs et donner votre consentement pour continuer",
                                        "Conditions préalables");
                                  }
                                  setState(() {
                                    validerCliquer = !validerCliquer;
                                  });
                                },
                                child: !validerCliquer
                                    ? AdaptiveText(
                                        text: "valider",
                                        style: GoogleFonts.montserrat(
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))
                                    : SpinKitThreeBounce(
                                        color: Colors.white,
                                        size:
                                            getProportionateScreenHeight(15))),
                          ),
                          SizedBox(height: getProportionateScreenHeight(50)),
                        ],
                      )),
                ],
              )),
          // Visibility pour la ville
          Visibility(
              visible: city_taped,
              child: Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(15)),
                child: Scrollbar(
                  thumbVisibility: true,
                  interactive: true,
                  trackVisibility: true,
                  thickness: getProportionateScreenWidth(5),
                  radius: Radius.circular(20),
                  child: Container(
                    height: getProportionateScreenHeight(300),
                    width: getProportionateScreenWidth(370),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300]),
                    child: ListView.builder(
                        itemCount: Villes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                EdgeInsets.all(getProportionateScreenHeight(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Villes[index],
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        color: gradientStartColor)),
                                Visibility(
                                  visible: true,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Pour rentrer dans la CONDITION IF il faut que soit condition1 soit
                                      // vraie ou condition2 soit vraie.Mtn à l'initialisation,on entre car
                                      // la condition1 est vraie or dès qu'on entre 1 devient faux.Et 2 est faux partout sauf sur
                                      // toogle coché
                                      if (!cityBool.contains(true) ||
                                          cityBool[index]) {
                                        setState(() {
                                          cityBool[index] = !cityBool[index];
                                          // ============
                                          cityBool[index]
                                              ? cityControler = Villes[index]
                                              : cityControler = "";
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: getProportionateScreenHeight(20),
                                      width: getProportionateScreenHeight(20),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: cityBool[index]
                                          ? Icon(Icons.check,
                                              color: gradientStartColor)
                                          : Container(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              )),
          // Visibility pour la date de naissance
          Visibility(
              visible: birthday_taped,
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
                        minValue: 1,
                        maxValue: 31,
                        value: day,
                        zeroPad: true,
                        infiniteLoop: true,
                        itemWidth: getProportionateScreenHeight(50),
                        itemHeight: getProportionateScreenHeight(33),
                        onChanged: (value) {
                          setState(() {
                            day = value;
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
                        minValue: 1,
                        maxValue: 12,
                        value: mois,
                        zeroPad: true,
                        infiniteLoop: true,
                        itemWidth: getProportionateScreenHeight(50),
                        itemHeight: getProportionateScreenHeight(33),
                        onChanged: (value) {
                          setState(() {
                            mois = value;
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
                      NumberPicker(
                        minValue: 1920,
                        maxValue: 2020,
                        itemCount: 4,
                        value: annee,
                        zeroPad: true,
                        infiniteLoop: true,
                        itemWidth: getProportionateScreenHeight(60),
                        itemHeight: getProportionateScreenHeight(33),
                        onChanged: (value) {
                          setState(() {
                            annee = value;
                            birthdayControler = day.toString() +
                                "/" +
                                mois.toString() +
                                "/" +
                                annee.toString();
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
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: !confirmPassWordVisible,
      controller: confirmPassWordControler,
      style: GoogleFonts.oswald(
          fontSize: getProportionateScreenWidth(18),
          fontWeight: FontWeight.normal),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) =>
          value != null && value != passWordControler.text.trim()
              ? "Mots de passe non conformes!"
              : null,
      cursorColor: gradientStartColor,
      decoration: InputDecoration(
        filled: true,
        contentPadding:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(12)),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide(color: gradientStartColor, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: const BorderSide(width: 3, color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: BorderSide(color: gradientStartColor, width: 3),
        ),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
        border: const OutlineInputBorder(),
        fillColor: Colors.white,
        labelText: "Confirmation",
        hintText: "Confirmez votre mot de passe",
        hintStyle: TextStyle(
            fontFamily: 'Gilroy',
            color: Colors.grey,
            fontSize: getProportionateScreenWidth(16),
            fontWeight: FontWeight.w900),
        labelStyle: TextStyle(
            fontFamily: 'Gilroy',
            color: gradientStartColor,
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.w900),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                confirmPassWordVisible = !confirmPassWordVisible;
              });
            },
            icon: Icon(
              confirmPassWordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            )),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: CustomSurffixIcon(
            svgIcon: "assets/icons/lock.svg",
          ),
        ),
      ),
    );
  }

  buildPasswordFormField() {
    return MyTextFormField(
      myAutovalidateMode: AutovalidateMode.onUserInteraction,
      myCursorColor: gradientStartColor,
      myHintText: 'Entrez votre mot de passe',
      myLabelText: 'Mot de passe',
      myObscureText: passWordVisible,
      mySuffixIconLink: "assets/icons/lock.svg",
      myTextController: passWordControler,
      myTextStyle: GoogleFonts.oswald(
          fontSize: getProportionateScreenWidth(18),
          fontWeight: FontWeight.normal),
      myTextInputType: TextInputType.text,
    );
  }

  buildEmailFormField() {
    return MyTextFormField(
      myAutovalidateMode: AutovalidateMode.onUserInteraction,
      myCursorColor: gradientStartColor,
      myHintText: 'Entrez votre mail',
      myLabelText: 'Email',
      myObscureText: passWordVisible,
      mySuffixIconLink: "assets/icons/Mail.svg",
      myTextController: emailControler,
      myTextStyle: GoogleFonts.oswald(
          fontSize: getProportionateScreenWidth(18),
          fontWeight: FontWeight.normal),
      myTextInputType: TextInputType.emailAddress,
    );
  }

  buildLastNameFormField() {
    return MyTextFormField(
      myAutovalidateMode: AutovalidateMode.onUserInteraction,
      myCursorColor: gradientStartColor,
      myHintText: 'Nom',
      myLabelText: 'Nom',
      myObscureText: passWordVisible,
      mySuffixIconLink: "assets/icons/profile.svg",
      myTextController: nameControler,
      myTextStyle: GoogleFonts.oswald(
          fontSize: getProportionateScreenWidth(18),
          fontWeight: FontWeight.normal),
      myTextInputType: TextInputType.name,
    );
  }

  corporationFormField() {
    return MyTextFormField(
      myAutovalidateMode: AutovalidateMode.onUserInteraction,
      myCursorColor: gradientStartColor,
      myHintText: 'Corporation',
      myLabelText: 'Corporation',
      myObscureText: passWordVisible,
      mySuffixIconLink: "assets/icons/corporation.svg",
      myTextController: corporationControler,
      myTextStyle: GoogleFonts.oswald(
          fontSize: getProportionateScreenWidth(18),
          fontWeight: FontWeight.normal),
      myTextInputType: TextInputType.text,
    );
  }

  buildFirstNameFormField() {
    return MyTextFormField(
      myAutovalidateMode: AutovalidateMode.onUserInteraction,
      myCursorColor: gradientStartColor,
      myHintText: "Prénoms",
      myLabelText: 'Prénoms',
      myObscureText: passWordVisible,
      mySuffixIconLink: "assets/icons/profile.svg",
      myTextController: firstNameControler,
      myTextStyle: GoogleFonts.oswald(
          fontSize: getProportionateScreenWidth(18),
          fontWeight: FontWeight.normal),
      myTextInputType: TextInputType.name,
    );
  }
}
