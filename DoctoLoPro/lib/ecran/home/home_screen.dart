import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constant.dart';
import 'components/only_user.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  Widget build(BuildContext context) {

    // changer la couleur de systemNavigationBarColor ce qui est plus bas que la bottomNavigationBar et qui vient avec le tel
    SystemChrome.setSystemUIOverlayStyle(
       SystemUiOverlayStyle(
        systemNavigationBarColor:gradientStartColor,
        systemNavigationBarDividerColor:gradientStartColor
      ),
    );
    // Vous devez l'appeler sur votre écran de départ
    SizeConfig().init(context);    
    return SafeArea(
      child: Scaffold(
        backgroundColor:Colors.white,
        body:OnlyConnectedUsers(),
         

       
      ),
    );
  }
}
