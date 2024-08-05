import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../constant.dart';
import '../../message/message_screen.dart';
import '../appointment/appointmenscreen.dart';
import '../document/document_screen.dart';
import 'components/verification_page.dart';
import 'home_screen.dart';

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  var currentIndex;
  static const String routeName = "/home";

   MyHomePage({super.key, required this.currentIndex});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Widget> _pages = [
    HomeScreen(),
    AppointmentScreen(),
    DocumentScreen(),
    MessageScreen(),
    VerificationPage()
  ];

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
        backgroundColor: AppStyle.bgColor,
        body: _pages[widget.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,

          currentIndex: widget.currentIndex,
          onTap: (index) {
            setState(() {
              widget.currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/home.svg",
                width: getProportionateScreenHeight(20),
                height: getProportionateScreenHeight(20),
              ),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/date.svg",
                width: getProportionateScreenHeight(20),
                height: getProportionateScreenHeight(20),
              ),
              label: 'Rendez-vous',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/document.svg",
                width: getProportionateScreenHeight(20),
                height: getProportionateScreenHeight(20),
              ),
              label: 'Document',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/message.svg",
                width: getProportionateScreenHeight(20),
                height: getProportionateScreenHeight(20),
              ),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/profile.svg",
                width: getProportionateScreenHeight(20),
                height: getProportionateScreenHeight(20),
              ),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(color: Colors.white),
          unselectedItemColor:
              Colors.black, // Couleur du texte de l'onglet non sélectionné
          selectedLabelStyle: TextStyle(
              fontFamily: 'Gilroy',
              color: Colors.white,
              fontSize: getProportionateScreenWidth(12),
              fontWeight:
                  FontWeight.w900), // Style du texte de l'onglet sélectionné
          unselectedLabelStyle: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: getProportionateScreenWidth(12),
              fontWeight: FontWeight.w800),
          backgroundColor:
              gradientStartColor, // Style du texte de l'onglet non sélectionné
        ),
      ),
    );
  }
}
