import 'package:doctolopro/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceController extends GetxController {
  var isPresentielAccepted = false.obs;
  var isVideoAccepted = false.obs;

  void Presentiel() {
    isPresentielAccepted.value = !isPresentielAccepted.value;
  }

  void Video() {
    isVideoAccepted.value = !isVideoAccepted.value;
  }
}

class PageDeux extends StatefulWidget {
  final PageController controller;
  const PageDeux({super.key, required this.controller});

  @override
  State<PageDeux> createState() => PageDeuxState();
}

class PageDeuxState extends State<PageDeux> {
 
  final ServiceController _serviceController = Get.put(ServiceController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white));
    return SafeArea(
      child: Scaffold(
        backgroundColor:Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
                onTap: () {
                  widget.controller.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: Icon(Icons.arrow_back,
                    size: getProportionateScreenHeight(25),
                    color: Colors.grey)),
            title: Text("Service",
                style: GoogleFonts.montserrat(
                    fontSize: getProportionateScreenHeight(17),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey))),
        body: Column(children: [
          Center(
            child: Container(
                height: getProportionateScreenHeight(130),
                width: getProportionateScreenHeight(280),
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
                        Text('Type de consultation',
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenHeight(15),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: getProportionateScreenHeight(8),
                    ),
                    Container(
                      width: getProportionateScreenWidth(310),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("En présentiel",
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _serviceController.Presentiel();
                              });
                            },
                            child: Container(
                              height: getProportionateScreenHeight(20),
                              width: getProportionateScreenHeight(20),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Obx(() => _serviceController
                                      .isPresentielAccepted.value
                                  ? Icon(Icons.check, color: gradientStartColor,size:getProportionateScreenHeight(15))
                                  : Container()),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    Container(
                      width: getProportionateScreenWidth(310),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Par appel vidéo",
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _serviceController.Video();
                              });
                            },
                            child: Container(
                              height: getProportionateScreenHeight(20),
                              width: getProportionateScreenHeight(20),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Obx(() => _serviceController
                                      .isVideoAccepted.value
                                  ? Icon(Icons.check, color: gradientStartColor,size:getProportionateScreenHeight(15))
                                  : Container()),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
          if (_serviceController.isPresentielAccepted.value)
            GestureDetector(
              onTap: () {
                widget.controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: getProportionateScreenHeight(10),
                    left: getProportionateScreenHeight(8)),
                child: Row(
                  children: [
                    Icon(Icons.add,
                        color: gradientStartColor,
                        size: getProportionateScreenHeight(20)),
                    Text("vos tarifs pour la consultation en présentiel",
                        style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: getProportionateScreenHeight(14),
                            fontWeight: FontWeight.bold,
                            color: gradientStartColor))
                  ],
                ),
              ),
            )
          else
            Container(),
          if (_serviceController.isVideoAccepted.value)
            GestureDetector(
              onTap: () {
                widget.controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              child: Padding(
                padding: EdgeInsets.only(left: getProportionateScreenHeight(8)),
                child: Row(
                  children: [
                    Icon(Icons.add,
                        color: gradientStartColor,
                        size: getProportionateScreenHeight(20)),
                    Text("vos tarifs pour la video-consultation ",
                        style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: getProportionateScreenHeight(14),
                            fontWeight: FontWeight.bold,
                            color: gradientStartColor))
                  ],
                ),
              ),
            )
          else
            Container()
        ]),
      ),
    );
  }
}
