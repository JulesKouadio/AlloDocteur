import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constant.dart';
import 'ecran/home/home_page.dart';
import 'ecran/profile/profil_pages/page/page_deux.dart';
import 'ecran/profile/profil_pages/page/page_dispo.dart';
import 'ecran/profile/profil_pages/page/page_tarif.dart';
import 'ecran/profile/profil_pages/page/page_un.dart';
import 'ecran/sign_in/components/sign_in_form.dart';
import 'ecran/sign_up/components/reglementations/terms_and_conditions.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //   if (Platform.isAndroid) {
  //     await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  //   }
  // });
  Get.put(TermsAndConditionsController());
  Get.put(TarifController());
  Get.put(DisponibiliteController());
  Get.put(GenreController());
  Get.put(ServiceController());
  Get.put(PraticienInfosController());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AnimationScreen(),
    );
  }
}

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return AnimatedSplashScreen(
      duration: 4000,
      splash: 'assets/images/doctolo_logo.png',
      splashIconSize: getProportionateScreenWidth(200),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.white,
      nextScreen: MyHomePage(currentIndex: 0,),
    );
  }
}
