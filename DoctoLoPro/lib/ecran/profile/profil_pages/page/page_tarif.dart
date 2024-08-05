import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constant.dart';
import 'page_deux.dart';

class TarifController extends GetxController {
  var prix_video = 0.obs;
  var minute_video = 0.obs;
  var prix_presentiel = 0.obs;
  var minute_presentiel = 0.obs;

  void PrixPresentiel(valeur) {
    prix_presentiel.value = valeur;
  }

  void MinutePresentiel(valeur) {
    minute_presentiel.value = valeur;
  }

  void PrixVideo(valeur) {
    prix_video.value = valeur;
  }

  void MinuteVideo(valeur) {
    minute_video.value = valeur;
  }
}

class PageTarif extends StatefulWidget {
  final PageController controller;
  const PageTarif({super.key, required this.controller});

  @override
  State<PageTarif> createState() => PageTarifState();
}

class PageTarifState extends State<PageTarif> {
  final TextEditingController _prixVideoController = TextEditingController();
  final TextEditingController _minuteVideoController = TextEditingController();

  final TextEditingController _prixPresentielController =
      TextEditingController();
  final TextEditingController _minutePresentielController =
      TextEditingController();
  final TarifController _tarifController = Get.put(TarifController());
  final ServiceController serviceController = Get.put(ServiceController());
  int valair = 0;
  var prixString = '';
  var minuteString = "";
  @override


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset:false,
        appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: getProportionateScreenHeight(35),
            leading: GestureDetector(
                onTap: () {
                  widget.controller.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: Icon(Icons.arrow_back,
                    size: getProportionateScreenHeight(25),
                    color: Colors.grey)),
            title: Text("Vos tarifs",
                style: GoogleFonts.montserrat(
                    fontSize: getProportionateScreenHeight(17),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey))),
        body: Padding(
          padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
          child: Column(
            children: [
              if (serviceController.isPresentielAccepted.value &&
                  serviceController.isVideoAccepted.value)

                // ===================
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenHeight(10)),
                      child: Row(
                        children: [
                          Text('Tarif présentiel',
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(17),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(25)),
                      child: Column(children: [
                        Row(children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(10)),
                            child: Text("Prix de la consultation",
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(15),
                          ),
                          Text(
                              "Chaque ${_minutePresentielController.text.trim()} min.",
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87))
                        ]),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(10)),
                              child: Container(
                                width: getProportionateScreenWidth(200),
                                height: getProportionateScreenHeight(45),
                                child: TextFormField(
                                  controller: _prixPresentielController,
                                  onChanged: (value) {
                                    setState(() {
                                      prixString = value;
                                      _tarifController.PrixPresentiel(
                                          int.parse(value));
                                    });
                                  },
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(14),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  decoration: InputDecoration(
                                    hintText:_tarifController.prix_presentiel.value!=0? _tarifController.prix_presentiel.value.toString():"Prix",
                                    focusedBorder:UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:gradientStartColor,width:2
                                      )
                                    ),
                                    hintStyle: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        color: Colors.grey,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w900),
                                    focusColor: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(34)),
                              child: Container(
                                width: getProportionateScreenWidth(150),
                                height: getProportionateScreenHeight(45),
                                child: TextFormField(
                                  controller: _minutePresentielController,
                                  onChanged: (value) {
                                    setState(() {
                                      minuteString = value;
                                      _tarifController.MinutePresentiel(
                                          int.parse(value));
                                    });
                                  },
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(14),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  decoration: InputDecoration(
                                    focusedBorder:UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:gradientStartColor,width:2
                                      )
                                    ),
                                    hintText:_tarifController.minute_presentiel.value!=0? _tarifController.minute_presentiel.value.toString():"minute",
                                    hintStyle: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        color: Colors.grey,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w900),
                                    focusColor: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(15),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Visibility(
                            visible: prixString.isNotEmpty &&
                                minuteString.isNotEmpty,
                            child: Row(
                              children: [
                                Icon(Icons.add,
                                    color: gradientStartColor,
                                    size: getProportionateScreenHeight(20)),
                                Text('Planifiez votre disponibilité',
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.bold,
                                        color: gradientStartColor))
                              ],
                            ),
                          ),
                        ),
                        // =========== appel vidéo ============
                        Padding(
                          padding: EdgeInsets.only(
                              top: getProportionateScreenHeight(25)),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: getProportionateScreenHeight(10)),
                                child: Row(
                                  children: [
                                    Text('Tarif appel vidéo',
                                        style: GoogleFonts.montserrat(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    17),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getProportionateScreenHeight(25)),
                                child: Column(children: [
                                  Row(children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              getProportionateScreenHeight(10)),
                                      child: Text("Prix de la consultation",
                                          style: GoogleFonts.montserrat(
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      15),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87)),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(15),
                                    ),
                                    Text(
                                        "Chaque ${_minuteVideoController.text.trim()} min.",
                                        style: GoogleFonts.montserrat(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    15),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87))
                                  ]),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: getProportionateScreenHeight(
                                                10)),
                                        child: Container(
                                          width:
                                              getProportionateScreenWidth(200),
                                          height:
                                              getProportionateScreenHeight(45),
                                          child: TextFormField(
                                            controller: _prixVideoController,
                                            onChanged: (value) {
                                              setState(() {
                                                prixString = value;
                                                _tarifController.PrixVideo(
                                                    int.parse(value));
                                              });
                                            },
                                            cursorColor: Colors.grey,
                                            keyboardType: TextInputType.number,
                                            style: GoogleFonts.montserrat(
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        14),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                            decoration: InputDecoration(
                                              focusedBorder:UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:gradientStartColor,width:2
                                      )
                                    ),
                                    hintText:_tarifController.prix_video.value!=0? _tarifController.prix_video.value.toString():"Prix",
                                              hintStyle: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          18),
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w900),
                                              focusColor: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: getProportionateScreenHeight(
                                                34)),
                                        child: Container(
                                          width:
                                              getProportionateScreenWidth(150),
                                          height:
                                              getProportionateScreenHeight(45),
                                          child: TextFormField(
                                            controller: _minuteVideoController,
                                            onChanged: (value) {
                                              setState(() {
                                                minuteString = value;
                                                _tarifController.MinuteVideo(
                                                    int.parse(value));
                                              });
                                            },
                                            cursorColor: Colors.grey,
                                            keyboardType: TextInputType.number,
                                            style: GoogleFonts.montserrat(
                                                fontSize:
                                                    getProportionateScreenHeight(
                                                        14),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                            decoration: InputDecoration(
                                              focusedBorder:UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:gradientStartColor,width:2
                                      )
                                    ),
                                    hintText:_tarifController.minute_video.value!=0? _tarifController.minute_video.value.toString():"minute",
                                              hintStyle: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          18),
                                                  color: Colors.grey,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w900),
                                              focusColor: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(15),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget.controller.nextPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeIn);
                                    },
                                    child: Visibility(
                                      visible: prixString.isNotEmpty &&
                                          minuteString.isNotEmpty,
                                      child: Row(
                                        children: [
                                          Icon(Icons.add,
                                              color: gradientStartColor,
                                              size:
                                                  getProportionateScreenHeight(
                                                      20)),
                                          Text('Planifiez votre disponibilité',
                                              style: TextStyle(
                                                  fontFamily: 'Gilroy',
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          15),
                                                  fontWeight: FontWeight.bold,
                                                  color: gradientStartColor))
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ],
                )
              // ===============Only video
              else if (serviceController.isVideoAccepted.value)
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenHeight(10)),
                      child: Row(
                        children: [
                          Text('Tarif appel vidéo',
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(17),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(25)),
                      child: Column(children: [
                        Row(children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(10)),
                            child: Text("Prix de la consultation",
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(15),
                          ),
                          Text(
                              "Chaque ${_minuteVideoController.text.trim()} min.",
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87))
                        ]),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(10)),
                              child: Container(
                                width: getProportionateScreenWidth(200),
                                height: getProportionateScreenHeight(45),
                                child: TextFormField(
                                  controller: _prixVideoController,
                                  onChanged: (value) {
                                    setState(() {
                                      prixString = value;
                                      _tarifController.PrixVideo(
                                          int.parse(value));
                                    });
                                  },
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(14),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  decoration: InputDecoration(
focusedBorder:UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:gradientStartColor,width:2
                                      )
                                    ),
                                    hintText:_tarifController.prix_video.value!=0? _tarifController.prix_video.value.toString():"Prix",
                                    hintStyle: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        color: Colors.grey,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w900),
                                    focusColor: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(34)),
                              child: Container(
                                width: getProportionateScreenWidth(150),
                                height: getProportionateScreenHeight(45),
                                child: TextFormField(
                                  controller: _minuteVideoController,
                                  onChanged: (value) {
                                    setState(() {
                                      minuteString = value;
                                      _tarifController.MinuteVideo(
                                          int.parse(value));
                                    });
                                  },
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(14),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  decoration: InputDecoration(
                                    hintText:_tarifController.minute_video.value!=0? _tarifController.minute_video.value.toString():"minute",
                                    hintStyle: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        color: Colors.grey,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w900),
                                    focusColor: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(15),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Visibility(
                            visible: prixString.isNotEmpty &&
                                minuteString.isNotEmpty,
                            child: Row(
                              children: [
                                Icon(Icons.add,
                                    color: gradientStartColor,
                                    size: getProportionateScreenHeight(20)),
                                Text('Planifiez votre disponibilité',
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.bold,
                                        color: gradientStartColor))
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                )
              // =======only présentiel========
              else if (serviceController.isPresentielAccepted.value)
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenHeight(10)),
                      child: Row(
                        children: [
                          Text('Tarif présentiel',
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(17),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(25)),
                      child: Column(children: [
                        Row(children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenHeight(10)),
                            child: Text("Prix de la consultation",
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(15),
                          ),
                          Text(
                              "Chaque ${_minutePresentielController.text.trim()} min.",
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87))
                        ]),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(10)),
                              child: Container(
                                width: getProportionateScreenWidth(200),
                                height: getProportionateScreenHeight(45),
                                child: TextFormField(
                                  controller: _prixPresentielController,
                                  onChanged: (value) {
                                    setState(() {
                                      prixString = value;
                                      _tarifController.PrixPresentiel(
                                          int.parse(value));
                                    });
                                  },
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(14),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  decoration: InputDecoration(
                                    focusedBorder:UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:gradientStartColor,width:2
                                      )
                                    ),
                                    hintText:_tarifController.prix_presentiel.value!=0? _tarifController.prix_presentiel.value.toString():"Prix",
                                    hintStyle: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        color: Colors.grey,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w900),
                                    focusColor: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(34)),
                              child: Container(
                                width: getProportionateScreenWidth(150),
                                height: getProportionateScreenHeight(45),
                                child: TextFormField(
                                  controller: _minutePresentielController,
                                  onChanged: (value) {
                                    setState(() {
                                      minuteString = value;
                                      _tarifController.MinutePresentiel(
                                          int.parse(value));
                                    });
                                  },
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(14),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  decoration: InputDecoration(
                                    hintText:_tarifController.minute_presentiel.value!=0? _tarifController.minute_presentiel.value.toString():"minute",
                                    hintStyle: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(18),
                                        color: Colors.grey,
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w900),
                                    focusColor: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(15),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Visibility(
                            visible: prixString.isNotEmpty &&
                                minuteString.isNotEmpty,
                            child: Row(
                              children: [
                                Icon(Icons.add,
                                    color: gradientStartColor,
                                    size: getProportionateScreenHeight(20)),
                                Text('Planifiez votre disponibilité',
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.bold,
                                        color: gradientStartColor))
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                )
              else
                Padding(
                  padding:
                      EdgeInsets.only(top: getProportionateScreenHeight(25)),
                  child: Center(
                    child: Text('Veuillez choisir au moins un type de service',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: getProportionateScreenHeight(17),
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
