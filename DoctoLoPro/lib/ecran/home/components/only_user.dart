import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant.dart';
import 'doctors.dart';
import 'medecin_details.dart';

class OnlyConnectedUsers extends StatefulWidget {
  const OnlyConnectedUsers({super.key});

  @override
  State<OnlyConnectedUsers> createState() => _OnlyConnectedUsersState();
}

class _OnlyConnectedUsersState extends State<OnlyConnectedUsers> {
  // ===================================
  final _specialityController = TextEditingController();
  final _adresseController = TextEditingController();

  List<Doctor> _doctors = []; // Initialize as an empty list
  List<Doctor> _filteredDoctors = []; // For filtered results
  String _jobQuery = '';
  String _placeQuery = '';

  double longitude = 0.0;
  double latitude = 0.0;

  Future<void> _loadDoctors() async {
    final doctors = <Doctor>[];
    // ================
    final firestore = FirebaseFirestore.instance;
    final collections = ['Praticiens', 'Pharmacie'];

    for (final collectionName in collections) {
      final collection = firestore.collection(collectionName);
      final snapshot = await collection.get();
      // ================
      for (final doc in snapshot.docs) {
        final doctorData = doc.data();
        doctors.add(Doctor(
          lastName: doctorData['Nom'] as String,
          firstName: doctorData['Prénoms'] as String,
          speciality: doctorData['Corporation'] as String,
          adresse: doctorData['Adresse'] as String,
          geolocation: doctorData['Localisation'] as String,
          indication: doctorData['Indication'] as String,
          contact: doctorData['Contact'] as String,
          praticenID: doctorData['Email'],
        ));
      }
    }

    setState(() {
      _doctors = doctors;
      _filteredDoctors = doctors;
    });
  }

  void _filterDoctors() {
    setState(() {
      _filteredDoctors = _doctors
          .where((doctor) =>
              doctor.speciality
                  .toLowerCase()
                  .contains(_jobQuery.trim().toLowerCase()) &&
              doctor.adresse
                  .toLowerCase()
                  .contains(_placeQuery.trim().toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: gradientStartColor,
        systemNavigationBarDividerColor: gradientStartColor));
    _loadDoctors();
    getProportionateScreenHeight(300);
  }

  @override
  void dispose() {
    _specialityController.dispose();
    _adresseController.dispose();
    super.dispose();
  }
// ===================================

  final List<String> textList = [
    'un kinésithérapeute',
    'un ophtalmologue',
    'une gynécologue',
    "un radiologue",
    "un dentiste"
  ];
// ==============
  @override
  Widget build(BuildContext context) {
    // User? user = _auth.currentUser;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarDividerColor: gradientStartColor,
        statusBarColor: gradientStartColor,
        systemNavigationBarColor: gradientStartColor,
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(624.1),
                child: Stack(children: [
                  Positioned(
                    child: Column(
                      children: [
                        Container(
                            height: getProportionateScreenHeight(250),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                                color: gradientStartColor),
                            child: Column(
                              children: [
                                // Le titre DoctoLo
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: getProportionateScreenWidth(8)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "DoctoLo",
                                        style: GoogleFonts.montserrat(
                                            // fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    25),
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                // Fin du titre
                                Center(
                                  child: Text('Prenez rendez-vous avec',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              getProportionateScreenHeight(18),
                                          color: Colors.white)),
                                ),
                                // Carousel pour la Corporation
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: getProportionateScreenHeight(30),
                                      width: getProportionateScreenWidth(300),
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          viewportFraction: 1.0,
                                          enlargeCenterPage: true,
                                          scrollDirection: Axis.vertical,
                                        ),
                                        items: textList.map((text) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                child: Center(
                                                  child: Text(
                                                    text,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.montserrat(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            getProportionateScreenHeight(
                                                                20),
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                // Fin du carousel

                                SizedBox(
                                  height: getProportionateScreenHeight(20),
                                ),
                                // Zone de Recherche
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenHeight(10)),
                                  child: Row(
                                    children: [
                                      // Qui cherchez-vous?
                                      Container(
                                        width: getProportionateScreenWidth(230),
                                        height:
                                            getProportionateScreenHeight(45),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40),
                                              bottomLeft: Radius.circular(40)),
                                        ),
                                        child: TextFormField(
                                          controller: _specialityController,
                                          onChanged: (value) {
                                            setState(() {
                                              _jobQuery = value;
                                              _filterDoctors();
                                            });
                                          },
                                          cursorColor: Colors.grey,
                                          decoration: InputDecoration(
                                            hintText: "Qui cherchez-vous?",
                                            hintStyle: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        18),
                                                color: Colors.grey,
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.w900),
                                            focusColor: Colors.grey,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: Colors.grey,
                                              size: getProportionateScreenWidth(
                                                  17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Le lieu
                                      Container(
                                        width: getProportionateScreenWidth(150),
                                        height:
                                            getProportionateScreenHeight(45),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(40),
                                              bottomRight: Radius.circular(40)),
                                        ),
                                        child: TextFormField(
                                          controller: _adresseController,
                                          onChanged: (value) {
                                            setState(() {
                                              _placeQuery = value;
                                              _filterDoctors();
                                            });
                                          },
                                          cursorColor: Colors.grey,
                                          decoration: InputDecoration(
                                            hintText: "Où?",
                                            hintStyle: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        17),
                                                color: Colors.grey,
                                                fontFamily: 'Gilroy',
                                                fontWeight: FontWeight.w900),
                                            focusColor: Colors.grey,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.location_on,
                                              color: Colors.grey,
                                              size: getProportionateScreenWidth(
                                                  18),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // Fin recherche
                              ],
                            )),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _jobQuery.isEmpty && _placeQuery.isEmpty,
                    child: Positioned(
                      top: getProportionateScreenHeight(170),
                      right: getProportionateScreenWidth(0),
                      left: getProportionateScreenWidth(0),
                      child: SizedBox(
                          height: getProportionateScreenHeight(150),
                          width: getProportionateScreenWidth(400),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: getProportionateScreenHeight(150),
                              aspectRatio: 15 / 8,
                              autoPlay: false,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              viewportFraction: 0.9,
                            ),
                            items: [
                              Container(
                                height: getProportionateScreenHeight(150),
                                width: getProportionateScreenWidth(350),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(5)),
                                    Center(
                                      child: Text("Journée mondiale de l'ouie",
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          textScaler:
                                              MediaQuery.textScalerOf(context),
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      18),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Icon(Icons.hearing_outlined,
                                        size: getProportionateScreenHeight(100),
                                        color: Colors.white),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: getProportionateScreenHeight(
                                                5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text('En savoir plus',
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            12),
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            Icon(Icons.arrow_forward_ios,
                                                size:
                                                    getProportionateScreenHeight(
                                                        12),
                                                color: Colors.white)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: getProportionateScreenHeight(150),
                                width: getProportionateScreenWidth(350),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(5)),
                                    Center(
                                      child: Text("Journée mondiale du coeur",
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          textScaler:
                                              MediaQuery.textScalerOf(context),
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      18),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Icon(Icons.heart_broken_outlined,
                                        size: getProportionateScreenHeight(100),
                                        color: Colors.white),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: getProportionateScreenHeight(
                                                5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text('En savoir plus',
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                    fontSize:
                                                        getProportionateScreenHeight(
                                                            12),
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            Icon(Icons.arrow_forward_ios,
                                                size:
                                                    getProportionateScreenHeight(
                                                        12),
                                                color: Colors.white)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                  Visibility(
                    visible: !_jobQuery.isEmpty || !_placeQuery.isEmpty,
                    child: Positioned(
                      top: getProportionateScreenHeight(170),
                      left: 0,
                      right: 0,
                      child: _filteredDoctors.isEmpty
                          ? Column(
                              children: [
                                Image.asset(
                                  "assets/icons/no_result_fond.png",
                                  height: getProportionateScreenHeight(50),
                                  width: getProportionateScreenWidth(50),
                                  scale: imageScale(context),
                                ),
                                Center(
                                  child: Text('Ooops! aucun résultat trouvé',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize:
                                              getProportionateScreenHeight(13),
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )
                          : SizedBox(
                              height: getProportionateScreenHeight(500),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemCount: _filteredDoctors
                                    .length, // Use filtered list
                                itemBuilder: (context, index) {
                                  final doctors = _filteredDoctors[index];

                                  String metier = doctors.speciality;
                                  String prenomPraticien =
                                      doctors.lastName[0].toUpperCase() +
                                          doctors.lastName.substring(1);
                                  String nom = doctors.speciality
                                          .contains("PHARMACIE")
                                      ? doctors.firstName
                                      : doctors.firstName.substring(
                                          doctors.firstName.lastIndexOf(" ") +
                                              1,
                                          doctors.firstName.length);
                                  String nomPraticien =
                                      nom[0].toUpperCase() + nom.substring(1);
                                  // ==location==
                                  String longitudeStr = doctors.geolocation
                                      .substring(
                                          doctors.geolocation.indexOf(" ") + 1);
                                  double longitude =
                                      doctors.geolocation != "Pas renseigné"
                                          ? double.parse(longitudeStr)
                                          : 0.0;
                                  String latitudeStr = doctors.geolocation
                                      .substring(
                                          0, doctors.geolocation.indexOf(" "));
                                  double latitude =
                                      doctors.geolocation != "Pas renseigné"
                                          ? double.parse(latitudeStr)
                                          : 0.0;
                                  // ==fin location====

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  MedecinDetails(
                                                    nomPraticien: nomPraticien,
                                                    prenomPraticien:
                                                        prenomPraticien,
                                                    metier: metier,
                                                    adresse: doctors.adresse,
                                                    indication:
                                                        doctors.indication,
                                                    contact: doctors.contact,
                                                    praticienID:
                                                        doctors.praticenID,
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                  )));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              getProportionateScreenWidth(20)),
                                      child: Container(
                                          height:
                                              getProportionateScreenHeight(180),
                                          width:
                                              getProportionateScreenWidth(350),
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  getProportionateScreenWidth(
                                                      10),
                                              vertical:
                                                  getProportionateScreenHeight(
                                                      10)),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15.0)),
                                            color: Colors.grey[300],
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        15),
                                              ),
                                              //  Début Nom Hopital
                                              Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        35),
                                                width: double.infinity,
                                                color: gradientEndColor
                                                    .withOpacity(0.6),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          getProportionateScreenHeight(
                                                              10)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width:
                                                            getProportionateScreenHeight(
                                                                250),
                                                        child: Text(
                                                            doctors.speciality
                                                                    .contains(
                                                                        "PHARMACIE")
                                                                ? doctors
                                                                    .speciality
                                                                : "Doct'Air Hospital",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Gilroy',
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    getProportionateScreenHeight(
                                                                        13),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Fin Nom Hopital

                                              // Début Photo,Renseignement et Indisponibilité
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        getProportionateScreenHeight(
                                                            15),
                                                    left:
                                                        getProportionateScreenHeight(
                                                            8),
                                                    right:
                                                        getProportionateScreenHeight(
                                                            5)),
                                                child: Row(
                                                  children: [
                                                    // Photo
                                                    Container(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              100),
                                                      width:
                                                          getProportionateScreenWidth(
                                                              100),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              gradientEndColor
                                                                  .withOpacity(
                                                                      0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: doctors
                                                                  .speciality
                                                                  .contains(
                                                                      "PHARMACIE")
                                                              ? DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: AssetImage(
                                                                      "assets/images/pharm.jpg"))
                                                              : DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/images/docteur.png"))),
                                                    ),
                                                    // Renseignement
                                                    SizedBox(
                                                      width:
                                                          getProportionateScreenHeight(
                                                              14),
                                                    ),
                                                    Container(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              110),
                                                      width:
                                                          getProportionateScreenWidth(
                                                              210),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    getProportionateScreenWidth(
                                                                        200),
                                                                child: Text(
                                                                    doctors.speciality.contains(
                                                                            "PHARMACIE")
                                                                        ? nomPraticien +
                                                                            " " +
                                                                            prenomPraticien
                                                                        : "Dr. " +
                                                                            nomPraticien +
                                                                            " " +
                                                                            prenomPraticien,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Gilroy',
                                                                        fontSize:
                                                                            getProportionateScreenHeight(
                                                                                13),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    getProportionateScreenWidth(
                                                                        180),
                                                                child: Text(
                                                                    doctors.speciality.contains(
                                                                            "PHARMACIE")
                                                                        ? "Pharmacien Principal"
                                                                        : "${doctors.speciality[0].toUpperCase() + doctors.speciality.substring(1)}",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Gilroy',
                                                                        fontSize:
                                                                            getProportionateScreenHeight(
                                                                                12),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w900,
                                                                        color: gradientEndColor
                                                                            .withOpacity(0.5))),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                getProportionateScreenHeight(
                                                                    8),
                                                          ),
                                                          // Adresse
                                                          Row(
                                                            children: [
                                                              Text('Adresse',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Gilroy',
                                                                      fontSize:
                                                                          getProportionateScreenHeight(
                                                                              10),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .black)),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                        getProportionateScreenWidth(
                                                                            160),
                                                                    child: Text(
                                                                        "${doctors.adresse}",
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Gilroy',
                                                                            fontSize:
                                                                                getProportionateScreenHeight(11),
                                                                            fontWeight: FontWeight.w900,
                                                                            color: gradientEndColor.withOpacity(0.5))),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "Disponibilité",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Gilroy',
                                                                      fontSize:
                                                                          getProportionateScreenHeight(
                                                                              10),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: Colors
                                                                          .black))
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  doctors.speciality
                                                                          .contains(
                                                                              "PHARMACIE")
                                                                      ? "Ouverte"
                                                                      : "Dans 2 Jours",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Gilroy',
                                                                      fontSize:
                                                                          getProportionateScreenHeight(
                                                                              10),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: gradientEndColor
                                                                          .withOpacity(
                                                                              0.5)))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                  Visibility(
                    visible: _jobQuery.isEmpty && _placeQuery.isEmpty,
                    child: Positioned(
                        top: getProportionateScreenHeight(325),
                        left: 0,
                        right: 0,
                        child: Container(
                          height: getProportionateScreenHeight(300),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              )),
                          child: Column(children: [
                            Center(
                              child: AdaptiveText(
                                  text: 'DoctoLo',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w900,
                                      fontSize:
                                          getProportionateScreenHeight(22),
                                      color: Colors.black54)),
                            ),
                            Center(
                              child: AdaptiveText(
                                  text: 'Prenez votre santé en main.',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w900,
                                      fontSize:
                                          getProportionateScreenHeight(17),
                                      color: Colors.black54)),
                            ),
                            Container(
                              height: getProportionateScreenHeight(220),
                              width: getProportionateScreenHeight(200),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/en_main.jpg"))),
                            )
                          ]),
                        )),
                  )
                ]
                    // =============

                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
