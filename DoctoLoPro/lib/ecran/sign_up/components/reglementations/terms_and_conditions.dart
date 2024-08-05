import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constant.dart';

class TermsAndConditionsController extends GetxController {
  var isAccepted = false.obs;

  void acceptTerms() {
    isAccepted.value = true;
  }

  void rejectTerms() {
    isAccepted.value = false;
  }
}

class TermsAndConditions extends StatelessWidget {
  final TermsAndConditionsController _controller =
      Get.put(TermsAndConditionsController());

  TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    // changer la couleur de systemNavigationBarColor ce qui est plus bas que la bottomNavigationBar et qui vient avec le tel
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarDividerColor: Colors.white),
    );
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
      height: getProportionateScreenHeight(700),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(getProportionateScreenHeight(8)),
              child: Text(
                textScaler: MediaQuery.textScalerOf(context),
                """Politique de confidentialité et conditions d'utilisation

Dernière mise à jour : 22/03/2024

Merci de votre intérêt pour DoctoLo. La confidentialité de nos patients est une priorité absolue pour nous. Cette politique de confidentialité et ces conditions d'utilisation décrivent comment nous recueillons, utilisons et protégeons les informations que vous nous fournissez lorsque vous utilisez notre site internet et notre application mobile.

                    Informations que nous recueillons

Lorsque vous utilisez notre site internet ou notre application, nous pouvons recueillir les types d'informations suivants :

- Informations personnelles : nom, prénom, date de naissance, adresse, numéro de téléphone, adresse e-mail, etc.
- Informations médicales : antécédents médicaux, traitements en cours, allergies, etc.
- Informations de localisation : si vous nous autorisez à accéder à votre localisation.
		
                      Utilisation des informations

Nous utilisons les informations recueillies pour les finalités suivantes :

- Assurer le bon fonctionnement de notre site internet et de notre application.
- Répondre à vos demandes et vous fournir les services demandés.
- Améliorer nos services et adapter notre offre à vos besoins.

                    Protection des informations

Nous prenons toutes les mesures nécessaires pour protéger vos informations personnelles. Cela inclut la sécurisation de nos systèmes informatiques, la limitation de l'accès aux informations et la sensibilisation de notre personnel à la protection des données.

                    Partage des informations

Nous ne partageons vos informations qu'avec des tiers dans les cas suivants :

- Lorsque cela est nécessaire pour fournir les services que vous avez demandés.
- Lorsque la loi l'exige ou lorsque nous sommes légalement autorisés à le faire.
- Avec votre consentement exprès.

                    Vos droits

Vous avez le droit d'accéder à vos informations personnelles, de les corriger, de les supprimer ou d'en limiter l'utilisation. Vous pouvez également vous opposer au traitement de vos informations pour des raisons légitimes.

                    Conditions d'utilisation

En accédant à notre site internet ou en utilisant notre application mobile, vous acceptez les conditions d'utilisation suivantes :

1. Utilisation du site internet et de l'application : Vous vous engagez à utiliser notre site internet et notre application de manière légale et conforme aux présentes conditions d'utilisation.

2. Propriété intellectuelle : Tous les contenus présents sur notre site internet et notre application, y compris les textes, les images, les vidéos, les logos, les marques, etc., sont protégés par des droits de propriété intellectuelle et ne peuvent être utilisés sans autorisation préalable.

3. Limitation de responsabilité : Nous nous efforçons de maintenir notre site internet et notre application accessibles et sécurisés, mais nous ne pouvons garantir leur disponibilité permanente et nous déclinons toute responsabilité en cas de dommages résultant de leur utilisation.

4. Modifications : Nous nous réservons le droit de modifier nos politiques de confidentialité et nos conditions d'utilisation à tout moment. Les modifications prendront effet dès leur publication sur notre site internet ou notre application.

5. Droit applicable : Les présentes conditions d'utilisation sont régies par le droit applicable dans votre pays.

                    Contact

Si vous avez des questions ou des préoccupations concernant notre politique de confidentialité ou nos conditions d'utilisation, veuillez nous contacter à l'adresse suivante : doctolo@gmail.com.""",
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: getProportionateScreenWidth(15),
                    fontWeight: FontWeight.w900),
              ),
            ),
            // Fin Termes et politique de confidentialité
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: getProportionateScreenWidth(150),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: gradientEndColor.withOpacity(0.8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _controller.rejectTerms();
                        Navigator.pop(context);
                      },
                      child: AdaptiveText(
                        text: "Retour",
                        style: GoogleFonts.oswald(
                            fontSize: getProportionateScreenWidth(20),
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: getProportionateScreenWidth(150),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: gradientStartColor.withOpacity(0.8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _controller.acceptTerms();
                        Navigator.pop(context);
                      },
                      child: AdaptiveText(
                        text: "Accepter",
                        style: GoogleFonts.oswald(
                            fontSize: getProportionateScreenWidth(20),
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    )));
  }
}
