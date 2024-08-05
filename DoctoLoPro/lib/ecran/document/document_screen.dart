import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../../components/custom_bottom_nav_bar.dart';
import '../../components/default_button.dart';
import '../../constant.dart';
import '../sign_in/sign_in_screen.dart';

class DocumentScreen extends StatelessWidget {
  static const String routeName = "/document";

  const DocumentScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // changer la couleur de systemNavigationBarColor ce qui est plus bas que la bottomNavigationBar et qui vient avec le tel
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          systemNavigationBarColor: gradientStartColor,
          systemNavigationBarDividerColor: gradientStartColor),
    );
    SizeConfig().init(context);

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: gradientStartColor,
              toolbarHeight: getProportionateScreenHeight(35),
              title: Text(
                'Mes documents',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: getProportionateScreenHeight(16),
                  color: Colors.white,
                ),
              ),
            ),
            body: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(200)),
                      child: Column(children: [
                        Center(
                          child: Container(
                            child: SvgPicture.asset(
                              "assets/icons/document.svg",
                              colorFilter: ColorFilter.mode(
                                  Colors.grey, BlendMode.srcIn),
                              width: getProportionateScreenHeight(50),
                              height: getProportionateScreenHeight(50),
                            ),
                          ),
                        ),
                        Text('Déposez vos documents ici.',
                            style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: getProportionateScreenHeight(20),
                                color: Colors.grey))
                      ]),
                    );
                  } else {
                    return 
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(200)),
                      child: Column(
                        children: [
                          Text(
                            "Gérez vos documents médicaux",
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenHeight(15),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenHeight(30)),
                            child: DefaultButton(
                              press: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => SignInScreen()),
                                    (route) => false);
                              },
                              text: "Se connecter",
                            ),
                          )
                        ],
                      ),
                    );
                  }
                })));
  }
}
