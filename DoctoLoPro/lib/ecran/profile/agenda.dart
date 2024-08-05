import 'package:flutter/material.dart';

class agendaScreen extends StatefulWidget {
  const agendaScreen({super.key});

  @override
  State<agendaScreen> createState() => _agendaScreenState();
}

class _agendaScreenState extends State<agendaScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        backgroundColor:Colors.white,
        body: Container()),
    );
  }
}