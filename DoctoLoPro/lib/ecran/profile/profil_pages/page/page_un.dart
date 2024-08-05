import 'package:doctolopro/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GenreController extends GetxController {
  var isMaleAccepted = false.obs;
  var isFemaleAccepted = false.obs;

  void Male() {
    isMaleAccepted.value = !isMaleAccepted.value;
  }

  void Female() {
    isFemaleAccepted.value = !isFemaleAccepted.value;
  }
}

class PageUn extends StatefulWidget {
  const PageUn({super.key});

  @override
  State<PageUn> createState() => PageUnState();
}

class PageUnState extends State<PageUn> {
  final GenreController _genreController = Get.put(GenreController());
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: getProportionateScreenHeight(35),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,
                  size: getProportionateScreenHeight(25), color: Colors.grey)),
          title: Text("Choix du genre",
              style: GoogleFonts.montserrat(
                  fontSize: getProportionateScreenHeight(15),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: getProportionateScreenHeight(15)),
          child: Column(children: [
            Center(
              child: Container(
                  height: getProportionateScreenHeight(75),
                  width: getProportionateScreenHeight(260),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: getProportionateScreenWidth(20),
                          ),
                          Text('Genre',
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Première case à cocher
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _genreController.Male();
                                });
                              },
                              child: Container(
                                height: getProportionateScreenHeight(20),
                                width: getProportionateScreenHeight(20),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: _genreController.isMaleAccepted.value
                                    ? Icon(Icons.check,
                                        size: getProportionateScreenHeight(15),
                                        color: gradientStartColor)
                                    : Container(),
                              ),
                            ),
                            Text("Masculin",
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(14),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            // Deuxième case à cocher
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _genreController.Female();
                                });
                              },
                              child: Container(
                                height: getProportionateScreenHeight(20),
                                width: getProportionateScreenHeight(20),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: _genreController.isFemaleAccepted.value
                                    ? Icon(Icons.check,
                                        size: getProportionateScreenHeight(15),
                                        color: gradientStartColor)
                                    : Container(),
                              ),
                            ),
                            Text("Féminin",
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(14),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey))
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
