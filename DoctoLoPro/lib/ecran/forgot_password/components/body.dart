import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/default_button.dart';
import '../../../components/no_account_text.dart';
import '../../../constant.dart';
import '../../../widgets/snack_bar.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // ===========================
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              AdaptiveText(
                text: "Mot de Passe Oublié",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color:gradientStartColor,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              AdaptiveText(
                text:
                    "Veuilez renseigner votre mail et vous recevrez \nun lien afin de réinitialiser votre mot de passe",
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: getProportionateScreenWidth(17),
                    color:gradientStartColor,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              const ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  ForgotPassFormState createState() => ForgotPassFormState();
}

class ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailControler = TextEditingController();
  // =======================
  Future resetPassWord() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailControler.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Affichage de l'erreur par un snackbar
      showCustomSnackbar(context, e.message!);
    }
  }

// Libération de la mémoire après utilisation
  @override
  void dispose() {
    emailControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailControler,
            style: GoogleFonts.oswald(
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.w900),
            cursorColor:gradientStartColor,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? "Veuillez entrer un email valide!"
                    : null,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide(color:gradientStartColor, width: 5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(width: 3, color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide(color:gradientStartColor, width: 3),
              ),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(40.0)),
              fillColor: Colors.white,
              labelText: "Email",
              hintText: "Entrez votre mail",
              hintStyle: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Colors.grey,
                  fontSize: getProportionateScreenWidth(16),
                  fontWeight: FontWeight.w900),
              labelStyle: TextStyle(
                  fontFamily: 'Gilroy',
                  color: Colors.grey,
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.w900),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          // FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Continuez",
            press: () {
              if (_formKey.currentState!.validate()) {
                showCustomDialog(
                    context,
                    "Veuillez vérifier votre adresse mail.Nous vous avons envoyé un mail afin réinitialiser votre mot de passe",
                    "Vérification");
                resetPassWord();
              }
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          const NoAccountText(),
        ],
      ),
    );
  }
}
