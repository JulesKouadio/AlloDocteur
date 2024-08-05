import 'package:doctolopro/constant.dart';
import 'package:doctolopro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../geolocation/mapbox.dart';
import 'geo_location.dart';
import 'horaire.dart';
import 'pharmacie.dart';
import 'presentation_praticien.dart';
import 'rendez_vous.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class MedecinDetails extends StatefulWidget {
  final String nomPraticien;
  final String prenomPraticien;
  final String metier;
  final String adresse;
  final String indication;
  final String contact;
  final String praticienID;
  final double longitude;
  final double latitude;

  const MedecinDetails(
      {super.key,
      required this.nomPraticien,
      required this.prenomPraticien,
      required this.metier,
      required this.adresse,
      required this.indication,
      required this.contact,
      required this.praticienID,
      required this.longitude,
      required this.latitude});

  @override
  State<MedecinDetails> createState() => _MedecinDetailsState();
}

class _MedecinDetailsState extends State<MedecinDetails> {
  bool coeur_cocher = false;
  double _currentLatitude = 0;
  double _currentLongitude = 0;
  // ========la localisation ponctuelle du patient===========
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLatitude = position.latitude;
      _currentLongitude = position.longitude;
    });
  }

// =============Fonction Appel=================
  Future<void> lancerAppel(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
// =========Fin Fonction Appel==========

  /// Calculates the distance between two geographical points
  /// given their latitude and longitude using the Haversine formula.
  ///
  /// The result is returned in kilometers.
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Rayon de la Terre en kilomètres

    // Convertir les degrés en radians
    double phi1 = lat1 * pi / 180;
    double phi2 = lat2 * pi / 180;
    double deltaPhi = (lat2 - lat1) * pi / 180;
    double deltaLambda = (lon2 - lon1) * pi / 180;

    // Appliquer la formule haversine
    double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Calculer la distance
    double distance = R * c;
    return distance;
  }

  double distance = 0;
  @override
  void initState() {
    super.initState();

    _getCurrentLocation().then((_) {
      if ((widget.latitude != 0) & (widget.longitude != 0)) {
        setState(() {
          distance = calculateDistance(_currentLatitude, _currentLongitude,
              widget.latitude, widget.longitude);
        });
      }
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
    getProportionateScreenHeight(15);
    getProportionateScreenHeight(5);
    getProportionateScreenHeight(20);
    getProportionateScreenHeight(200);
    getProportionateScreenHeight(180);
    getProportionateScreenHeight(100);
    getProportionateScreenHeight(157);
    getProportionateScreenHeight(40);
    getProportionateScreenHeight(35);
    getProportionateScreenHeight(107);
    getProportionateScreenHeight(318);
    getProportionateScreenWidth(10);
    getProportionateScreenHeight(125);
    getProportionateScreenHeight(16);
    getProportionateScreenHeight(175);
    getProportionateScreenHeight(3);
    getProportionateScreenHeight(8);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: gradientStartColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                // ====Pour ajouter aux favoris=====
                setState(() {
                  coeur_cocher = !coeur_cocher;
                });
                coeur_cocher
                    ? showCustomSnackbar(context,
                        "${'Dr.' + " " + widget.nomPraticien[0].toUpperCase() + widget.nomPraticien.substring(1) + " " + widget.prenomPraticien[0].toUpperCase() + widget.prenomPraticien.substring(1)} ajouté à vos favoris")
                    : showCustomSnackbar(context,
                        "${'Dr.' + " " + widget.nomPraticien[0].toUpperCase() + widget.nomPraticien.substring(1) + " " + widget.prenomPraticien[0].toUpperCase() + widget.prenomPraticien.substring(1)} retiré de vos favoris");
              },
              child: Padding(
                padding:
                    EdgeInsets.only(right: getProportionateScreenHeight(5)),
                child: Icon(
                    coeur_cocher
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: getProportionateScreenHeight(20)),
              ),
            )
          ],
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,
                  color: Colors.white, size: getProportionateScreenHeight(25))),
        ),
        body: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(200),
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: getProportionateScreenHeight(180),
                      decoration: BoxDecoration(
                          color: gradientStartColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          )),
                      child: Column(
                        children: [
                          widget.metier.contains("PHARMACIE")
                              ? Container(
                                  height: getProportionateScreenHeight(180),
                                  width: 420,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                      image: DecorationImage(
                                          scale: imageScale(context),
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/pharm.jpg"))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: getProportionateScreenWidth(400),
                                        height:
                                            getProportionateScreenHeight(50),
                                        child: Center(
                                          child: Text(widget.metier,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          16),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(400),
                                        child: Center(
                                          child: Text(widget.adresse,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          16),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(
                                      getProportionateScreenHeight(5)),
                                  child: Container(
                                    height: getProportionateScreenHeight(100),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/docteur.png')),
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.6)),
                                  ),
                                ),
                          widget.metier.contains("PHARMACIE")
                              ? Container()
                              : Column(
                                  children: [
                                    Text(
                                        'Dr.' +
                                            " " +
                                            widget.nomPraticien[0]
                                                .toUpperCase() +
                                            widget.nomPraticien.substring(1) +
                                            " " +
                                            widget.prenomPraticien[0]
                                                .toUpperCase() +
                                            widget.prenomPraticien.substring(1),
                                        style: GoogleFonts.montserrat(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    16),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Text(
                                        widget.metier[0].toUpperCase() +
                                            widget.metier.substring(1),
                                        style: GoogleFonts.montserrat(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    15),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: getProportionateScreenHeight(157),
                    left: getProportionateScreenHeight(15),
                    right: getProportionateScreenHeight(15),
                    child: GestureDetector(
                      onTap: () {
                        !widget.metier.contains("PHARMACIE")
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => CalendarScreen(
                                          nomPraticien: 'Dr.' +
                                              " " +
                                              widget.nomPraticien[0]
                                                  .toUpperCase() +
                                              widget.nomPraticien.substring(1) +
                                              " " +
                                              widget.prenomPraticien[0]
                                                  .toUpperCase() +
                                              widget.prenomPraticien
                                                  .substring(1),
                                          praticienID: widget.praticienID,
                                        )))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => GeoLocationPage()));
                      },
                      child: Container(
                        height: getProportionateScreenHeight(40),
                        width: getProportionateScreenWidth(100),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: gradientEndColor),
                        child: widget.metier.contains("PHARMACIE")
                            ? GestureDetector(
                                onTap: () {
                                  (widget.latitude + widget.longitude) != 0
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) => MapView(
                                                    destinationLatitude:
                                                        widget.latitude,
                                                    destinationLongitude:
                                                        widget.longitude,
                                                    currentLatitude:
                                                        _currentLatitude,
                                                    currentLongitude:
                                                        _currentLongitude,
                                                  )))
                                      : showCustomDialog(
                                          context,
                                          "Cette Pharmacie n'a pas fourni sa geolocalisation.\nVeuillez voir l'indication",
                                          "Alerte");
                                  ;
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenWidth(32)),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/boussole.png",
                                        color: Colors.white,
                                        height:
                                            getProportionateScreenHeight(35),
                                        width: getProportionateScreenWidth(35),
                                      ),
                                      SizedBox(
                                        width: getProportionateScreenWidth(15),
                                      ),
                                      Text(
                                        "ME MONTRER LE CHEMIN",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            // fontFamily: 'Gilroy',
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    15),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        getProportionateScreenHeight(35)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/date.svg',
                                      colorFilter: ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                    Text(
                                      "PRENDRE RENDEZ-VOUS",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          // fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: widget.metier.contains("PHARMACIE")
                    ? getProportionateScreenHeight(180)
                    : getProportionateScreenHeight(107),
                width: getProportionateScreenHeight(318),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenHeight(7),
                          top: getProportionateScreenHeight(7)),
                      child: widget.metier.contains("PHARMACIE")
                          ? Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: getProportionateScreenHeight(20),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(310),
                                  height: getProportionateScreenHeight(40),
                                  child: Text(widget.metier,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: GoogleFonts.montserrat(
                                          // fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: getProportionateScreenHeight(20),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Text('Cabinet ALADE',
                                    style: GoogleFonts.montserrat(
                                        // fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black.withOpacity(0.8))),
                              ],
                            ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: getProportionateScreenHeight(35)),
                          child: SizedBox(
                            width: getProportionateScreenWidth(340),
                            height: widget.metier.contains("PHARMACIE")
                                ? getProportionateScreenHeight(65)
                                : getProportionateScreenHeight(20),
                            child: Text(
                                widget.metier.contains("PHARMACIE")
                                    ? widget.indication
                                    : 'Yopougon Maroc Kimi',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.7))),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.directions_walk,
                                color: Colors.white,
                                size: getProportionateScreenHeight(20),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(10),
                              ),
                              Text('Distance',
                                  style: GoogleFonts.montserrat(
                                      // fontFamily: 'Gilroy',
                                      fontSize:
                                          getProportionateScreenHeight(15),
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black.withOpacity(0.8))),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(35)),
                              child: Text(
                                  "Sis à " +
                                      distance.toStringAsFixed(1) +
                                      " km d'ici en vol d'oiseau",
                                  style: GoogleFonts.montserrat(
                                      // fontFamily: 'Gilroy',
                                      fontSize:
                                          getProportionateScreenHeight(15),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.7))),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )),
            SizedBox(
              height: getProportionateScreenHeight(3),
            ),
            widget.metier.contains("PHARMACIE")
                ? Container(
                    height: getProportionateScreenHeight(80),
                    width: getProportionateScreenHeight(318),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 18),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.credit_card,
                                    color: Colors.white,
                                    size: getProportionateScreenHeight(20),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(10),
                                  ),
                                  Text('Moyens de paiement',
                                      style: GoogleFonts.montserrat(
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: getProportionateScreenHeight(35),
                                      top: getProportionateScreenHeight(6)),
                                  child: Text('Espèces',
                                      style: GoogleFonts.montserrat(
                                          // fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.black.withOpacity(0.7))),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: getProportionateScreenHeight(200),
                    width: getProportionateScreenHeight(318),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.euro_rounded,
                                color: Colors.white,
                                size: getProportionateScreenHeight(20),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(10),
                              ),
                              Text('Tarifs et Remboursements',
                                  style: GoogleFonts.montserrat(
                                      // fontFamily: 'Gilroy',
                                      fontSize:
                                          getProportionateScreenHeight(15),
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black.withOpacity(0.8))),
                            ],
                          ),
                        ),
// Infos pour Tarifs et remboursements
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(35),
                                  top: getProportionateScreenHeight(8)),
                              child: Column(
                                children: [
                                  Text('Convention Secteur 1',
                                      style: GoogleFonts.montserrat(
                                          // fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.black.withOpacity(0.7))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(35),
                                  top: getProportionateScreenHeight(8)),
                              child: Column(
                                children: [
                                  Text('Carte assurance acceptée',
                                      style: GoogleFonts.montserrat(
                                          // fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.black.withOpacity(0.7))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(35),
                                  top: getProportionateScreenHeight(8)),
                              child: Column(
                                children: [
                                  Text('Tiers payant: Sécurité sociale',
                                      style: GoogleFonts.montserrat(
                                          // fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.black.withOpacity(0.7))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, top: 18),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.credit_card,
                                    color: Colors.white,
                                    size: getProportionateScreenHeight(20),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(10),
                                  ),
                                  Text('Moyens de paiement',
                                      style: GoogleFonts.montserrat(
                                          // fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.w900,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: getProportionateScreenHeight(35),
                                      top: getProportionateScreenHeight(6)),
                                  child: Text('Espèces',
                                      style: GoogleFonts.montserrat(
                                          // fontFamily: 'Gilroy',
                                          fontSize:
                                              getProportionateScreenHeight(15),
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.black.withOpacity(0.7))),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
            SizedBox(
              height: getProportionateScreenHeight(3),
            ),
            Container(
              height: getProportionateScreenHeight(50),
              width: getProportionateScreenHeight(318),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: getProportionateScreenHeight(20),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Text('Présentation',
                            style: GoogleFonts.montserrat(
                                // fontFamily: 'Gilroy',
                                fontSize: getProportionateScreenHeight(15),
                                fontWeight: FontWeight.w900,
                                color: Colors.black.withOpacity(0.8))),
                        SizedBox(
                          width: getProportionateScreenHeight(140),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.metier.contains("PHARMACIE")
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => PharmaciePage(
                                              nomPharmacie: widget.metier,
                                              adresse: widget.adresse,
                                              telephone: widget.contact,
                                              horaires:
                                                  'Lundi - Vendredi : 9h - 18h, Samedi : 9h - 13h',
                                              description: 'La' +
                                                  " " +
                                                  widget.metier +
                                                  " " +
                                                  'offre une large gamme de médicaments et de services de santé. Nos pharmaciens sont disponibles pour des consultations personnalisées.',
                                            )))
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            PresentationPraticien(
                                              nomPraticien: widget.nomPraticien,
                                              prenomPraticien:
                                                  widget.prenomPraticien,
                                              metier: widget.metier,
                                              adresse: widget.adresse,
                                              indication: widget.indication,
                                              contact: widget.contact,
                                            )));
                          },
                          child: Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: getProportionateScreenHeight(16)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
// ==============================
            SizedBox(
              height: getProportionateScreenHeight(5),
            ),
            GestureDetector(
              onTap: () {
                widget.contact != ""
                    ? lancerAppel(widget.contact)
                    : showCustomDialog(
                        context,
                        "Cette Pharmacie n'a pas fourni un numéro de téléphone.",
                        "Attention");
              },
              child: Container(
                height: getProportionateScreenHeight(50),
                width: getProportionateScreenHeight(318),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 15),
                      child: widget.metier.contains("PHARMACIE")
                          ? Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: getProportionateScreenHeight(20),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Text('Appeler',
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black.withOpacity(0.8))),
                                SizedBox(
                                  width: getProportionateScreenHeight(177),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: getProportionateScreenHeight(16))
                              ],
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: getProportionateScreenHeight(20),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Text('Horaires',
                                    style: GoogleFonts.montserrat(
                                        // fontFamily: 'Gilroy',
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black.withOpacity(0.8))),
                                SizedBox(
                                  width: getProportionateScreenHeight(177),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                HorairePage()));
                                  },
                                  child: Icon(Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: getProportionateScreenHeight(16)),
                                )
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
