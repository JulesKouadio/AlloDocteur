import 'package:allodocteur/constants.dart';
import 'package:allodocteur/widgets/bottom_bar.dart';
import 'package:allodocteur/widgets/carousel.dart';
import 'package:allodocteur/widgets/featured_heading.dart';
import 'package:allodocteur/widgets/featured_tiles.dart';
import 'package:allodocteur/widgets/main_heading.dart';
import 'package:allodocteur/widgets/top_bar_contents.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  double opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    const Color gradientStartColor = Color(0xff11998e);
    const Color gradientEndColor = Color(0xff0575E6);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
              preferredSize: Size(screenSize.width, 1000),
              child: TopBarContents(opacity),
            ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenSize.height * 0.85,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [gradientStartColor, gradientEndColor],
                        begin: const FractionalOffset(0.2, 0.2),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: getProportionateScreenWidth(50),
                        top: getProportionateScreenHeight(100)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: getProportionateScreenHeight(360),
                          width: getProportionateScreenWidth(115),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  scale: imageScale(context),
                                  image: AssetImage(
                                      'assets/images/stethoscope.png'),
                                  fit: BoxFit.contain)),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    FloatingSearchBar(screenSize: screenSize),
                    FeaturedHeading(screenSize: screenSize),
                    FeaturedTiles(screenSize: screenSize),
                    MainHeading(screenSize: screenSize),
                    MainCarousel(),
                    SizedBox(
                      height: screenSize.height / 10,
                    ),
                    BottomBar(),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Je crée la classe FloatingSearchBar ici car j'avais du mal à l'importer
class FloatingSearchBar extends StatefulWidget {
  const FloatingSearchBar({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  _FloatingSearchBarState createState() => _FloatingSearchBarState();
}

class _FloatingSearchBarState extends State<FloatingSearchBar> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _specialitycontroller = TextEditingController();
    final TextEditingController _locationcontroller = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(400)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding:
                  EdgeInsets.only(bottom: getProportionateScreenHeight(25),left:getProportionateScreenWidth(15)),
              child: AdaptiveText(
                  text: 'Trouvez un spécialiste près de chez vous',
                  style: GoogleFonts.acme(
                      fontSize: getProportionateScreenWidth(15),
                      color: Colors.white))),
          // Début de la barre de recherche

          Form(
            key: _formKey,
            child: Padding(
              padding:  EdgeInsets.only(left:getProportionateScreenWidth(15)),
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: getProportionateScreenHeight(80),
                        width: getProportionateScreenWidth(130),
                        child:
                            // Spécialité,
                            TextFormField(
                          controller: _specialitycontroller,
                          style: GoogleFonts.acme(
                              color: Colors.grey,
                              fontSize: getProportionateScreenWidth(7),
                              fontWeight: FontWeight.w900),
                          cursorColor: Colors.grey,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(50)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(50),
                              ),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            fillColor: Colors.white,
                            hintText: 'Nom, Spécialité, Etablissement, ...',
                            hintStyle: GoogleFonts.acme(
                                color: Colors.grey,
                                fontSize: getProportionateScreenWidth(7),
                                fontWeight: FontWeight.w400),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenWidth(1)),
                              child: Icon(Icons.search, color: Colors.grey),
                            ),
                          ),
                        )),
                    // Fin Spécialité
                    VerticalDivider(color:Colors.black,width:getProportionateScreenWidth(0.1),),
                    // Début Localisation
                    Container(
                      height: getProportionateScreenHeight(80),
                      width: getProportionateScreenWidth(95),
                      child: TextFormField(
                        controller: _locationcontroller,
                        style: GoogleFonts.acme(
                            color: Colors.grey,
                            fontSize: getProportionateScreenWidth(7),
                            fontWeight: FontWeight.w900),
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.horizontal(left: Radius.circular(0)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(0),
                            ),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          fillColor: Colors.white,
                          hintText: 'Où?',
                          hintStyle: GoogleFonts.acme(
                              color: Colors.grey,
                              fontSize: getProportionateScreenWidth(7),
                              fontWeight: FontWeight.w400),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenWidth(1)),
                            child: Icon(Icons.location_on, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    // Taper sur Rechercher
                   
                  
                  Stack(
                    children: [
                      Container(
                    height: getProportionateScreenHeight(80),
                        width: getProportionateScreenWidth(60),
                    child: TextFormField(
                            style: GoogleFonts.acme(
                                color: Colors.grey,
                                fontSize: getProportionateScreenWidth(7),
                                fontWeight: FontWeight.w900),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(50)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(50),
                                ),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              fillColor: Colors.white,
                              hintStyle: GoogleFonts.acme(
                                  color: Colors.grey,
                                  fontSize: getProportionateScreenWidth(7),
                                  fontWeight: FontWeight.w400),
                             
                            ),
                          ),
                  ),
                  // Recherche
                  Padding(
                              padding: EdgeInsets.symmetric(vertical:getProportionateScreenHeight(5.8)),
                              child: Container(
                                
                                    height:getProportionateScreenHeight(63),
                                  width:getProportionateScreenWidth(58),
                                  decoration:BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          bottomRight: Radius.circular(50),
                                        ),
                                        color:AppStyle.gradientStartColor),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: getProportionateScreenWidth(7)),
                                            child: AdaptiveText(
                                              text: 'Rechercher',
                                              style: GoogleFonts.acme(
                                                fontSize: getProportionateScreenWidth(8),
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            )),
                                            SizedBox(width:getProportionateScreenWidth(2),),
                                        Icon(Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: getProportionateScreenWidth(8))
                                      ],
                                    ),
                                  ),
                            )
                    ],
                  )
                  ]
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
