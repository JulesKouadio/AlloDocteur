import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctolopro/components/default_button.dart';
import 'package:doctolopro/ecran/profile/profile_screen.dart';
import 'package:doctolopro/ecran/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../constant.dart';
import 'package:file_picker/file_picker.dart';

import '../../widgets/snack_bar.dart';

class AppointmentScreen extends StatefulWidget {
  static const String routeName = "/appointment";

  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
// =========take document========
  File? _imageDocument;
  File? _document;
  String lienVerso = "";
  String lienDocument = "";
  String lien_un = "";
  String lienImageDocument = "";
  String lienPro = "";
  String lien_trois = "";

  Future<void> _takeDocument() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageDocument = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    //Create a reference for the image to be stored
    Reference referenceImageToUpload =
        referenceDirImages.child(_user!.email.toString() + "_document_santer");
    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(_imageDocument!.path));
      lien_un = await referenceImageToUpload.getDownloadURL();
      //Success: get the download URL
    } catch (error) {
      //Some error occurred
    }

    setState(() {
      lienImageDocument = lien_un;
    });
  }

// ===========Choisir document==========
  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _document = File(result.files.single.path!);
      });
    } else {
      // L'utilisateur a annulé la sélection
    }
    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('document');
    //Create a reference for the image to be stored
    Reference referenceImageToUpload =
        referenceDirImages.child(_user!.email.toString() + "_document_santer");
    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(File(_document!.path));
      lien_trois = await referenceImageToUpload.getDownloadURL();
      //Success: get the download URL
    } catch (error) {
      //Some error occurred
    }

    setState(() {
      lienDocument = lien_trois;
    });
  }

// =============fin choisir document===========
// =========modal sheet==============
  void _showPicker(BuildContext context, String idPraticien) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext) {
        return SafeArea(
          child: Container(
            height: getProportionateScreenHeight(100),
            color: Colors.white,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.photo_camera,
                    size: getProportionateScreenHeight(20),
                    color: Colors.grey,
                  ),
                  title: Text("Photo",
                      textScaler: MediaQuery.of(context).textScaler,
                      maxLines: 2,
                      style: GoogleFonts.montserrat(
                          fontSize: getProportionateScreenHeight(16),
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  onTap: () {
                    _takeDocument().then((_) async {
                      await FirebaseFirestore.instance
                          .collection("Praticiens")
                          .doc(idPraticien)
                          .collection("Consultation")
                          .doc(idPraticien)
                          .update({"Lien_Document": lienImageDocument}).then(
                              (_) {
                        showCustomSnackbar(
                            context, "document envoyé avec succès");
                      });
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.attach_file,
                    size: getProportionateScreenHeight(23),
                    color: Colors.black,
                  ),
                  title: Text("Document",
                      textScaler: MediaQuery.of(context).textScaler,
                      maxLines: 2,
                      style: GoogleFonts.montserrat(
                          fontSize: getProportionateScreenHeight(16),
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  onTap: () {
                    _pickDocument().then((_) async {
                      await FirebaseFirestore.instance
                          .collection("Praticiens")
                          .doc(idPraticien)
                          .collection("Consultation")
                          .doc(idPraticien)
                          .update({"Lien_Document": lienDocument});
                    });
                    ;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// =============fin modal sheet=========
  User? _user;

  Future<void> _getUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    _getUser();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: gradientStartColor,
        systemNavigationBarDividerColor: gradientStartColor,
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: gradientStartColor,
            toolbarHeight: getProportionateScreenHeight(35),
            title: Text(
              'Mes rendez-vous',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: getProportionateScreenHeight(16),
                color: Colors.white,
              ),
            ),
          ),
          body: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(5)),
                        child: TabBar(
                          isScrollable: false,
                          dividerColor: Colors.transparent,
                          controller: tabController,
                          tabs: [
                            Tab(
                              child: Center(
                                child: Text(
                                  "À venir",
                                  textAlign: TextAlign.center,
                                  textScaler: MediaQuery.textScalerOf(context),
                                  style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Center(
                                child: Text(
                                  "Passés",
                                  textAlign: TextAlign.center,
                                  textScaler: MediaQuery.textScalerOf(context),
                                  style: GoogleFonts.montserrat(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          labelStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w900,
                            fontSize: getProportionateScreenWidth(10),
                          ),
                          indicatorColor: gradientStartColor,
                          labelColor: gradientStartColor,
                          unselectedLabelColor: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
// =============A venir ==============
                            Column(
                              children: [
                                // ================Consultation confirmé===========

                                SizedBox(
                                  height: getProportionateScreenHeight(220),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: getProportionateScreenHeight(10),
                                    ),
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Utilisateurs')
                                          .doc(_user!.email)
                                          .collection('Consultation')
                                          .where("Statut_Consultation",
                                              isEqualTo: "confirmée")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child: SpinKitThreeBounce(
                                                  size:
                                                      getProportionateScreenHeight(
                                                          15),
                                                  color: Colors.white));
                                        }
                                        List<DocumentSnapshot> demande =
                                            snapshot.data!.docs;
                                        return demande.length < 1
                                            ? Center(
                                                child: Text(
                                                  "VOUS N'AVEZ AUCUNE CONSULTATION EN VUE",
                                                  textAlign: TextAlign.center,
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize:
                                                          getProportionateScreenHeight(
                                                              20),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          gradientStartColor),
                                                ),
                                              )
                                            : PageView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount: demande.length,
                                                itemBuilder: (context, index) {
                                                  var demandeConsultation =
                                                      demande[index].data()
                                                          as Map<String,
                                                              dynamic>;

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height:
                                                              getProportionateScreenHeight(
                                                                  45),
                                                          width:
                                                              getProportionateScreenHeight(
                                                                  290),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20)),
                                                              color:
                                                                  gradientStartColor,
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left:
                                                                      getProportionateScreenHeight(
                                                                          10)),
                                                              child: Column(
                                                                  children: [
                                                                    // ========Date==========
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: getProportionateScreenHeight(
                                                                              10),
                                                                          horizontal:
                                                                              getProportionateScreenHeight(5)),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          AdaptiveText(
                                                                              text:
                                                                                  // "Date : 25 Juin 2024, 15:45",
                                                                                  demandeConsultation["Date_Consultation"] + " " + demandeConsultation["Heure_Consultation"],
                                                                              style: GoogleFonts.montserrat(fontSize: getProportionateScreenHeight(15), color: Colors.white, fontWeight: FontWeight.bold)),
                                                                          SizedBox(
                                                                            width:
                                                                                getProportionateScreenHeight(15),
                                                                          ),
                                                                          Text(
                                                                              demandeConsultation['Type_Consultation'],
                                                                              textScaler: MediaQuery.of(context).textScaler,
                                                                              textAlign: TextAlign.center,
                                                                              style: GoogleFonts.montserrat(fontSize: getProportionateScreenHeight(14), color: Colors.orange, fontWeight: FontWeight.bold))
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                        // ========Deuxième face=======
                                                        SizedBox(
                                                          height:
                                                              getProportionateScreenHeight(
                                                                  140),
                                                          width:
                                                              getProportionateScreenHeight(
                                                                  290),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20)),
                                                                color: Colors
                                                                    .grey[300],
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.2),
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              2),
                                                                      blurRadius:
                                                                          3),
                                                                ]),
                                                            child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: getProportionateScreenHeight(
                                                                            10),
                                                                        top: getProportionateScreenHeight(
                                                                            10)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              getProportionateScreenHeight(65),
                                                                          width:
                                                                              getProportionateScreenHeight(65),
                                                                          decoration: BoxDecoration(
                                                                              image: DecorationImage(image: AssetImage("assets/images/docteur.png")),
                                                                              color: Colors.white,
                                                                              shape: BoxShape.circle),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: getProportionateScreenHeight(15)),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: getProportionateScreenHeight(170),
                                                                                height: getProportionateScreenHeight(70),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Text(
                                                                                        // "Ferdinand Konan",
                                                                                        demandeConsultation["Praticien_nom"],
                                                                                        textScaler: MediaQuery.of(context).textScaler,
                                                                                        maxLines: 2,
                                                                                        style: GoogleFonts.montserrat(fontSize: getProportionateScreenHeight(16), color: Colors.white, fontWeight: FontWeight.bold)),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                            // "Ferdinand Konan",
                                                                                            "Dentiste",
                                                                                            textScaler: MediaQuery.of(context).textScaler,
                                                                                            maxLines: 2,
                                                                                            style: GoogleFonts.montserrat(fontSize: getProportionateScreenHeight(16), color: Colors.grey, fontWeight: FontWeight.bold)),
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // =======Envoyer document========
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      _showPicker(
                                                                          context,
                                                                          demandeConsultation[
                                                                              "Praticien_ID"]);
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: getProportionateScreenHeight(
                                                                              18)),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                getProportionateScreenHeight(35),
                                                                            width:
                                                                                getProportionateScreenHeight(250),
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.orange.withOpacity(0.8)),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
                                                                              child: Row(
                                                                                children: [
                                                                                  Transform.rotate(
                                                                                    angle: -43 * 3.14 / 180,
                                                                                    child: Icon(
                                                                                      Icons.send,
                                                                                      size: getProportionateScreenHeight(20),
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: getProportionateScreenHeight(10),
                                                                                  ),
                                                                                  Text("Envoyer un document", textScaler: MediaQuery.of(context).textScaler, textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontSize: getProportionateScreenHeight(15), color: Colors.white, fontWeight: FontWeight.bold)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text("Aucun historique")
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  return
                   Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(200)),
                    child: Column(
                      children: [
                        Text(
                          "Plannifiez vos rendez-vous",
                          style: GoogleFonts.montserrat(
                              fontSize: getProportionateScreenHeight(15),
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenHeight(30)),
                          child: DefaultButton(
                            press: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => SignInScreen()),
                                  (route) => false);
                            },
                            text: "Se connecter",
                          ),
                        )
                      ],
                    ),
                  );
                }
              })),
    );
  }
}
