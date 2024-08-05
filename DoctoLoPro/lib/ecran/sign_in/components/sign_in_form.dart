import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctolopro/ecran/home/home_page.dart';
import 'package:doctolopro/ecran/profile/profile_screen.dart';
import 'package:get/get.dart';

import '../../../components/default_button.dart';
import '../../../constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../helper/keyboard.dart';
import '../../../widgets/snack_bar.dart';
import '../../forgot_password/forgot_password_screen.dart';

class PraticienInfosController extends GetxController {
  String nom = "";
  String prenoms = "";
  String corporation = "";
}

class SignForm extends StatefulWidget {
  const SignForm({super.key});
  @override
  SignFormState createState() => SignFormState();
}

class SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailControler = TextEditingController();
  TextEditingController passWordControler = TextEditingController();

  // =======================
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailControler.text.trim(),
          password: passWordControler.text.trim());
    } on FirebaseAuthException catch (e) {
      // Affichage de l'erreur par un snackbar
      showCustomSnackbar(context, e.message!);
      //  print("erreur..................:${e.message}");
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  Future<void> getUser() async {
    final user = _auth.currentUser;

    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  final PraticienInfosController praticienInfosController =
      Get.put(PraticienInfosController());
  // ============Infos User=========
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
  // ===============================

  bool passWordVisible = false;

  @override
  void initState() {
    super.initState();
    passWordVisible = false;
  }

// Libération de la mémoire après utilisation
  @override
  void dispose() {
    emailControler.dispose();
    passWordControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => const ForgotPasswordScreen(),
                  ),
                ),
                child: AdaptiveText(
                  text: "Mot de passe oublié?",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenWidth(15),
                    color: gradientStartColor,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Connexion",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to profil screen
                KeyboardUtil.hideKeyboard(context);
                signIn().then((_) {
                  // si SignIn marche alors get User Infos
                  getUser().then((_) {
                    // si getUser marche alors fetch User Infos
                    FetchInfos().then((_) {
                      // si fetch User Infos marche alors ProfileScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => MyHomePage(currentIndex: 4,),
                        ),
                      );
                    });
                  });
                });
              }
            },
          ),
        ],
      ),
    );
  }

// ===================
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
// ===================
}
