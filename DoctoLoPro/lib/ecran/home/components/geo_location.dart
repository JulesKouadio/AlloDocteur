import 'package:flutter/material.dart';

class GeoLocationPage extends StatefulWidget {
  const GeoLocationPage({super.key});

  @override
  State<GeoLocationPage> createState() => _GeoLocationPageState();
}

class _GeoLocationPageState extends State<GeoLocationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("assets/images/geo.png"))),
      ),
    ));
  }
}
