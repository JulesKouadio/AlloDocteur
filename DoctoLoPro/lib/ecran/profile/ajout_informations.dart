import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart' as path;
import 'package:doctolopro/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class InfosAdd extends StatefulWidget {
  const InfosAdd({super.key});

  @override
  State<InfosAdd> createState() => _InfosAddState();
}

class _InfosAddState extends State<InfosAdd> {
  //=============Prendre photo============

  File? _imageRecto;
  File? _imageVerso;
  File? _imagePro;

  Future<void> _takeRecto() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageRecto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    //Create a reference for the image to be stored
    Reference referenceImageToUpload =
        referenceDirImages.child(_user!.email.toString() + "id_recto");
    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(_imageRecto!.path));
      lien_un = await referenceImageToUpload.getDownloadURL();
      //Success: get the download URL
    } catch (error) {
      //Some error occurred
    }

    setState(() {
      lienRecto = lien_un;
    });
  }

  Future<void> _takeVerso() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageVerso = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    // ==================
    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    //Create a reference for the image to be stored
    Reference referenceImageToUpload =
        referenceDirImages.child(_user!.email.toString() + "id_verso");
    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(_imageVerso!.path));
      lien_deux = await referenceImageToUpload.getDownloadURL();

      //Success: get the download URL
    } catch (error) {
      //Some error occurred
    }

    setState(() {
      lienVerso = lien_deux;
    });
  }

// =========================

// =========================
  String lienVerso = "";
  String lienRecto = "";
  String lien_un = "";
  String lien_deux = "";
  String lienPro = "";
  String lien_trois = "";
// ==============sauvegarder une photo==========
  Future _uploadFile(File file) async {
    String fileName = path.basename(file.path);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() {});
    String fileURL = await storageReference.getDownloadURL();

    return fileURL;
  }

// =======================Autre sauvegarde=============
  Future<void> _takePro() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imagePro = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    //Create a reference for the image to be stored
    Reference referenceImageToUpload =
        referenceDirImages.child(_user!.email.toString() + "_photo_face");
    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(_imagePro!.path));
      lien_trois = await referenceImageToUpload.getDownloadURL();
      //Success: get the download URL
    } catch (error) {
      //Some error occurred
    }

    setState(() {
      lienPro = lien_trois;
    });
  }

// ==========uploader formations et expérience=====
  Future<void> uploadInfos(var lienRecto, var lienVerso) async {
    // =========fin sauvegarde=======
    await FirebaseFirestore.instance
        .collection("Praticiens")
        .doc(_user!.email)
        .collection("Experiences_Formations")
        .doc("Pro")
        .set({
      "Parcours": extractTexts(formController),
      "Annee_Parcours": extractTexts(yearFormController),
      "Experience": extractTexts(expeController),
      "Annee_Expe": extractTexts(yearExpeController),
      "Numero_Piece_Identite": _cardController.text.trim(),
      "Lien_Recto_Photo_Piece_Identite": lienRecto,
      "Lien_Verso_Photo_Piece_Identite": lienVerso,
      "Nature_Piece": _natureCardController.text,
      "Lien_Photo_Praticien": lienPro
    }).then((_) => patience());
  }

// =======================================
  final ScrollController scrollController = ScrollController();
  final _cardController = TextEditingController();
  final _natureCardController = TextEditingController();

  List<TextEditingController> formController = [];
  List<TextEditingController> yearFormController = [];
// ==========================
  List<TextEditingController> expeController = [];
  List<TextEditingController> yearExpeController = [];
  // =======================================
  List<String> extractTexts(List<TextEditingController> formControllers) {
    return formControllers.map((controller) => controller.text).toList();
  }

  // =======================================
  int seconds = 3;
  bool validerCliquer = false;
  void patience() {
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (seconds == 0) {
        timer.cancel();
        setState(() {
          validerCliquer = !validerCliquer;
        });
        Navigator.of(context).pop();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }
  // =======================================

  void createFormCrontroller() {
    final _universiteController = TextEditingController();
    final _anneeFormationController = TextEditingController();

    formController.add(_universiteController);
    yearFormController.add(_anneeFormationController);
  }

  void createExpeController() {
    final _expeController = TextEditingController();
    final _anneeExpeController = TextEditingController();

    expeController.add(_expeController);
    yearExpeController.add(_anneeExpeController);
  }

  // =User=========
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    createFormCrontroller();
    createExpeController();
    _getUser();
  }

  Future<void> _getUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  int nbreFormation = 1;
  int nbreExperience = 1;
  double heightExperience = 0;
  double heightFormations = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,
                  size: getProportionateScreenHeight(25),
                  color: Colors.black87)),
          title: Center(
            child: Padding(
              padding: EdgeInsets.only(right: getProportionateScreenHeight(35)),
              child: AdaptiveText(
                text: "Expérience & Formations",
                style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: getProportionateScreenHeight(16.5),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: getProportionateScreenHeight(670),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(10),
                  left: getProportionateScreenHeight(4)),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: getProportionateScreenHeight(8)),
                    child: Row(
                      children: [
                        Text("Formation",
                            textScaler: MediaQuery.textScalerOf(context),
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenHeight(17),
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                        SizedBox(
                          width: getProportionateScreenHeight(5),
                        ),
                        Icon(Icons.school_rounded,
                            color: Colors.grey,
                            size: getProportionateScreenHeight(23))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenHeight(20)),
                    child: Column(children: [
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: getProportionateScreenHeight(10)),
                          child: Text("Etablissement",
                              textScaler: MediaQuery.textScalerOf(context),
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87)),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(77),
                        ),
                        Text("Année",
                            textScaler: MediaQuery.textScalerOf(context),
                            style: GoogleFonts.montserrat(
                                fontSize: getProportionateScreenHeight(15),
                                fontWeight: FontWeight.bold,
                                color: Colors.black87))
                      ]),
                      SizedBox(
                        height:
                            getProportionateScreenHeight(55) + heightFormations,
                        child: ListView.builder(
                            itemCount: nbreFormation,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  // Université
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenHeight(10)),
                                    child: Container(
                                      width: getProportionateScreenWidth(190),
                                      height: getProportionateScreenHeight(55),
                                      child: TextFormField(
                                        controller: formController[index],
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        cursorColor: Colors.grey,
                                        keyboardType: TextInputType.text,
                                        style: GoogleFonts.montserrat(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    15),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black54),
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 2.0,
                                            ),
                                          ),
                                          hintText: "Université...",
                                          hintStyle: GoogleFonts.montserrat(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      16),
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                          focusColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: getProportionateScreenHeight(25)),
                                    child: Container(
                                      width: getProportionateScreenWidth(160),
                                      height: getProportionateScreenHeight(55),
                                      child: TextFormField(
                                        controller: yearFormController[index],
                                        onChanged: (value) {
                                          setState(() {});
                                        },
                                        cursorColor: Colors.grey,
                                        keyboardType: TextInputType.text,
                                        style: GoogleFonts.montserrat(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    15),
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black54),
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 2.0,
                                            ),
                                          ),
                                          hintText: "20xxxx...",
                                          hintStyle: GoogleFonts.montserrat(
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                      16),
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                          focusColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        nbreFormation += 1;
                        heightFormations += getProportionateScreenHeight(55);
                        createFormCrontroller();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(3)),
                          child: Icon(
                            CupertinoIcons.add_circled_solid,
                            size: getProportionateScreenHeight(15),
                            color: green,
                          ),
                        ),
                        SizedBox(
                          width: getProportionateScreenHeight(5),
                        ),
                        Text(
                          "Ajoutez plus de formation",
                          textScaler: MediaQuery.textScalerOf(context),
                          style: GoogleFonts.montserrat(
                              fontSize: getProportionateScreenHeight(16),
                              fontWeight: FontWeight.bold,
                              color: green),
                        )
                      ],
                    ),
                  ),
                  // =====fin formation=======
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(15),
                            left: getProportionateScreenHeight(10)),
                        child: Row(
                          children: [
                            Text("Expérience",
                                textScaler: MediaQuery.textScalerOf(context),
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(17),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                            SizedBox(
                              width: getProportionateScreenHeight(5),
                            ),
                            Icon(Icons.medical_services_rounded,
                                color: Colors.grey,
                                size: getProportionateScreenHeight(23))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(20)),
                        child: Column(children: [
                          Row(children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(10)),
                              child: Text("Etablissement",
                                  textScaler: MediaQuery.textScalerOf(context),
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(15),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                            ),
                            SizedBox(
                              width: getProportionateScreenWidth(77),
                            ),
                            Text("Année",
                                textScaler: MediaQuery.textScalerOf(context),
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87))
                          ]),
                          SizedBox(
                            height: getProportionateScreenHeight(55) +
                                heightExperience,
                            child: ListView.builder(
                              itemCount: nbreExperience,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              getProportionateScreenHeight(10)),
                                      child: Container(
                                        width: getProportionateScreenWidth(190),
                                        height:
                                            getProportionateScreenHeight(55),
                                        child: TextFormField(
                                          controller: expeController[index],
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                          cursorColor: Colors.grey,
                                          keyboardType: TextInputType.text,
                                          style: GoogleFonts.montserrat(
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      15),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black54),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 2.0,
                                              ),
                                            ),
                                            hintText: "Hôpital,clinique...",
                                            hintStyle: GoogleFonts.montserrat(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                            focusColor: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              getProportionateScreenHeight(25)),
                                      child: Container(
                                        width: getProportionateScreenWidth(160),
                                        height:
                                            getProportionateScreenHeight(55),
                                        child: TextFormField(
                                          controller: yearExpeController[index],
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                          cursorColor: Colors.grey,
                                          keyboardType: TextInputType.text,
                                          style: GoogleFonts.montserrat(
                                              fontSize:
                                                  getProportionateScreenHeight(
                                                      15),
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black54),
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 2.0,
                                              ),
                                            ),
                                            hintText: "20xxx",
                                            hintStyle: GoogleFonts.montserrat(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        16),
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                            focusColor: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(15),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                nbreExperience += 1;
                                heightExperience +=
                                    getProportionateScreenHeight(55);
                                createExpeController();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: getProportionateScreenHeight(3)),
                                  child: Icon(
                                    CupertinoIcons.add_circled_solid,
                                    size: getProportionateScreenHeight(15),
                                    color: green,
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenHeight(5),
                                ),
                                Text(
                                  "Ajoutez plus d'expérience",
                                  textScaler: MediaQuery.textScalerOf(context),
                                  style: GoogleFonts.montserrat(
                                      fontSize:
                                          getProportionateScreenHeight(16),
                                      fontWeight: FontWeight.bold,
                                      color: green),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),

                  // ==============Numéro d'identité==============

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // =======Nature de la pièce======
                      Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(20),
                            left: getProportionateScreenHeight(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Nature de la pièce d'identité",
                              textScaler: MediaQuery.textScalerOf(context),
                              style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenHeight(16)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: getProportionateScreenHeight(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: getProportionateScreenWidth(300),
                              height: getProportionateScreenHeight(55),
                              child: TextFormField(
                                controller: _natureCardController,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.text,
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: "CNI, Passeport ...",
                                  hintStyle: GoogleFonts.montserrat(
                                      fontSize: getProportionateScreenWidth(16),
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                  focusColor: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(15),
                            left: getProportionateScreenHeight(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Numéro de la pièce d'identité",
                              textScaler: MediaQuery.textScalerOf(context),
                              style: GoogleFonts.montserrat(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenHeight(16)),
                            ),
                          ],
                        ),
                      ),
                      // ==========numéro à proprement parlé========
                      Column(children: [
                        // numéro de la pièce
                        Padding(
                          padding: EdgeInsets.only(
                              right: getProportionateScreenHeight(12),
                              left: getProportionateScreenHeight(10)),
                          child: Container(
                            width: getProportionateScreenWidth(390),
                            height: getProportionateScreenHeight(55),
                            child: TextFormField(
                              controller: _cardController,
                              onChanged: (value) {
                                setState(() {});
                              },
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.montserrat(
                                  fontSize: getProportionateScreenHeight(15),
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54),
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 2.0,
                                  ),
                                ),
                                hintText:
                                    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                                hintStyle: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenWidth(16),
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                                focusColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(15),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: getProportionateScreenHeight(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: getProportionateScreenHeight(5),
                                  right: getProportionateScreenHeight(1),
                                ),
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: getProportionateScreenHeight(20),
                                  color: green,
                                ),
                              ),
                              Text(
                                "Prenez une photo de votre pièce",
                                textScaler: MediaQuery.textScalerOf(context),
                                style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenHeight(15),
                                    fontWeight: FontWeight.bold,
                                    color: green),
                              ),
                              // Prendre photo recto
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _takeRecto();
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenHeight(10)),
                                  child: Container(
                                    height: getProportionateScreenHeight(160),
                                    width: getProportionateScreenHeight(310),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Colors.grey[200],
                                      border: Border.all(
                                          width:
                                              getProportionateScreenHeight(1),
                                          color: green),
                                    ),
                                    child: Center(
                                      child: _imageRecto == null
                                          ? AdaptiveText(
                                              text: 'Recto',
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          18),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )
                                          : Image.file(
                                              _imageRecto!,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              // Prendre photo verso
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _takeVerso();
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          getProportionateScreenHeight(10),
                                      horizontal:
                                          getProportionateScreenHeight(10)),
                                  child: Container(
                                    height: getProportionateScreenHeight(160),
                                    width: getProportionateScreenHeight(310),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Colors.grey[200],
                                      border: Border.all(
                                          width:
                                              getProportionateScreenHeight(1),
                                          color: green),
                                    ),
                                    child: Center(
                                      child: _imageVerso == null
                                          ? AdaptiveText(
                                              text: 'Verso',
                                              style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      getProportionateScreenHeight(
                                                          18),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )
                                          : Expanded(
                                              child: Image.file(
                                                _imageVerso!,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: getProportionateScreenHeight(5),
                                      right: getProportionateScreenHeight(1),
                                    ),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: getProportionateScreenHeight(20),
                                      color: green,
                                    ),
                                  ),
                                  Text(
                                    "Prenez une photo de vous de face",
                                    textScaler:
                                        MediaQuery.textScalerOf(context),
                                    style: GoogleFonts.montserrat(
                                        fontSize:
                                            getProportionateScreenHeight(15),
                                        fontWeight: FontWeight.bold,
                                        color: green),
                                  ),
                                  // Prendre une photo de vous  de face
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _takePro();
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              getProportionateScreenHeight(10)),
                                      child: Container(
                                        height:
                                            getProportionateScreenHeight(300),
                                        width:
                                            getProportionateScreenHeight(310),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: Colors.grey[200],
                                          border: Border.all(
                                              width:
                                                  getProportionateScreenHeight(
                                                      1),
                                              color: green),
                                        ),
                                        child: Center(
                                          child: _imagePro == null
                                              ? AdaptiveText(
                                                  text: 'Votre photo',
                                                  style: GoogleFonts.montserrat(
                                                      fontSize:
                                                          getProportionateScreenHeight(
                                                              18),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                )
                                              : Image.file(
                                                  _imagePro!,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(400),
                                height: getProportionateScreenHeight(40),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      backgroundColor: gradientStartColor,
                                    ),
                                    onPressed: () async {
                                      // =========sauvegarde=======
                                      uploadInfos(lienRecto, lienVerso);
                                      // ====================
                                      setState(() {
                                        validerCliquer = !validerCliquer;
                                      });
                                    },
                                    child: !validerCliquer
                                        ? AdaptiveText(
                                            text: "valider",
                                            style: GoogleFonts.montserrat(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        20),
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))
                                        : SpinKitThreeBounce(
                                            color: Colors.white,
                                            size: getProportionateScreenHeight(
                                                15))),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                            ],
                          ),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
