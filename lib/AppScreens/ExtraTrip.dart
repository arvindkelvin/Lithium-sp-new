// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../l10n/app_localizations.dart';

class ExtraTrip extends StatefulWidget {
  const ExtraTrip({Key? key}) : super(key: key);
  @override
  State<ExtraTrip> createState() => _ExtraTripState();
}

class _ExtraTripState extends State<ExtraTrip> {
  Utility utility = Utility();
  String? selecteddate;
  String? selecteddatesend;
  String? fromdate;
  String? extrahours;
  String? fromdatesend;
  String? todate;
  String? todatesend;
  String? starttime;
  String? starttimesend;
  String? endtime;
  String? endtimesend;
  String? triptostamp;
  String? tripfromstamp;
  String shiftstarttime = "00:00";
  String shiftendtime = "00:00";
  String checkinTime = "00:00";
  String checkoutTime = "00:00";
  bool imagebool = false;
  final date2 = DateTime.now();
  late File _image;
  String? fromdatevaild;
  String? selecteddatevaild;
  String imgname = '';
  TextEditingController tripidcontroller = TextEditingController();
  TextEditingController tripcommentcontroller = TextEditingController();
  final birthday = DateTime(1994, 12, 16);
  bool afterselectdate = false;

  @override
  void initState() {
    super.initState();
    sessionManager.internetcheck().then((intenet) async {
      if (intenet) {
        //utility.showYourpopupinternetstatus(context);
        utility.GetUserdata();
        // checkupdate(_30minstr);

        // loading();
        // Loginapi(serveruuid, serverstate);
      } else {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final overlay = Overlay.of(context);
        if (overlay == null) return;

        showTopSnackBar(
          overlay,
          const CustomSnackBar.error(
            message: "Please Check Your Internet Connection",
          ),
        );
        //});
      }
    });
  }

  Map<String, String> marathiToEnglish = {
    '०': '0',
    '१': '1',
    '२': '2',
    '३': '3',
    '४': '4',
    '५': '5',
    '६': '6',
    '७': '7',
    '८': '8',
    '९': '9',
  };

  String convertMarathiToEnglish(String marathiNumber) {
    String englishNumber = '';
    for (int i = 0; i < marathiNumber.length; i++) {
      String digit = marathiNumber[i];
      if (marathiToEnglish.containsKey(digit)) {
        englishNumber += marathiToEnglish[digit]!;
      } else {
        englishNumber += digit; // If it's not a Marathi number, keep it as it is
      }
    }
    return englishNumber;
  }

  vailddata() {
    // Convert Marathi numbers to English numbers
    String fromDateEnglish = convertMarathiToEnglish(fromdatesend ?? '');
    String toDateEnglish = convertMarathiToEnglish(todatesend ?? '');
    String startTimeEnglish = convertMarathiToEnglish(starttimesend ?? '');
    String endTimeEnglish = convertMarathiToEnglish(endtimesend ?? '');

    if (fromDateEnglish.isNotEmpty &&
        toDateEnglish.isNotEmpty &&
        startTimeEnglish.isNotEmpty &&
        endTimeEnglish.isNotEmpty) {
      getextrahours("$fromDateEnglish $startTimeEnglish", "$toDateEnglish $endTimeEnglish");
      print("from == $fromDateEnglish $startTimeEnglish end== $toDateEnglish $endTimeEnglish");
    }
  }



  // vailddata() {
  //   if (fromdatesend != null &&
  //       todatesend != null &&
  //       starttimesend != null &&
  //       endtimesend != null) {
  //     getextrahours(
  //         "$fromdatesend " " $starttimesend", "$todatesend " " $endtimesend");
  //     print(
  //         "from == $fromdatesend " " $starttimesend end== $todatesend " " $endtimesend");
  //   }
  // }

  void loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // dialogContext = context;
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            // ignore: unnecessary_new
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/lithiugif.gif',
                  width: 50,
                  // color: HexColor(Colorscommon.greencolor),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text("Loading")),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPicker(context) {
    FocusScope.of(context).requestFocus(FocusNode());

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        getImageGallery(context, ImageSource.gallery);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      getImageGallery(context, ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImageGallery(BuildContext context, var type) async {
    final pickedFile =
    await ImagePicker().getImage(source: type, imageQuality: 50);
    final bytesdata = await pickedFile!.readAsBytes();
    final bytes = bytesdata.buffer.lengthInBytes;

    setState(() {
      if (pickedFile != null) {
        if (bytes <= 512000) {
          setState(() {
            _image = File(pickedFile.path);
            imgname = _image.path.split('/').last;
            imagebool = true;
            print('sel img = $_image');
          });
        } else {
          Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.maxfilesize,
              gravity: ToastGravity.CENTER);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  // submitextrahours(String selecteddate, String tripfromstamp,
  //     String triptostamp, String extrahourstr) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String city = prefs.getString("city") ?? "No City Available";
  //   // String url = CommonURL.BASE_URL;
  //   // print(tripcommentcontroller.text);
  //   // print(tripidcontroller.text);
  //   loading();
  //   var url = Uri.parse(CommonURL.herokuurl);
  //   // String url = CommonURL.URL;
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //   print(utility.lithiumid);
  //   print(utility.service_provider_c);
  //
  //   // var uri = Uri.parse(url);
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "extraTripAdd";
  //   request.fields['idUser'] = utility.userid;
  //   request.fields['lithiumID'] = utility.lithiumid;
  //   request.fields['service_provider_c'] = utility.service_provider_c;
  //   request.fields['tripFromTime'] = tripfromstamp;
  //   request.fields['tripToTime'] = triptostamp;
  //   request.fields['tripDate'] = selecteddate.toString();
  //   request.fields['tripComment'] = tripcommentcontroller.text;
  //   request.fields['tripId'] = tripidcontroller.text;
  //   request.fields['tripTotalHours'] = extrahourstr;
  //   request.fields['city'] = city; // Include the city parameter
  //
  //
  //   print("Request== $request");
  //   print(utility.userid);
  //   print(utility.lithiumid);
  //   print(utility.service_provider_c);
  //   print(tripfromstamp);
  //   print(triptostamp);
  //   print(selecteddate);
  //   print(tripcommentcontroller.text);
  //   print(tripidcontroller.text);
  //   print(tripidcontroller.text);
  //   print("city==$city");
  //   if (imagebool == true) {
  //     request.files
  //         .add(await http.MultipartFile.fromPath('tripFile', _image.path));
  //   }
  //
  //   print("extra hours = $url, ${request.fields}");
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     //var responseString = response.body.substring(response.body.indexOf('{'));
  //     //Map<String, dynamic> jsonInput = jsonDecode(responseString);
  //     print("jsonInput$jsonInput");
  //     String status = jsonInput['status'].toString();
  //     String message = jsonInput['message'].toString();
  //
  //     if (status == 'true') {
  //       Navigator.pop(context);
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //       // setState(() {
  //       //   var str = jsonInput['totalTripDays'].toString();
  //       //   extrahours = str;
  //       // });
  //     } else {
  //       // Navigator.pop(context);
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //   } else {}
  //
  //   Navigator.pop(context);
  //   setState(() {});
  // }

  String convertMarathiToEnglishSubmit(String marathiNumber) {
    Map<String, String> marathiToEnglish = {
      '०': '0',
      '१': '1',
      '२': '2',
      '३': '3',
      '४': '4',
      '५': '5',
      '६': '6',
      '७': '7',
      '८': '8',
      '९': '9',
    };

    String englishNumber = '';
    for (int i = 0; i < marathiNumber.length; i++) {
      String digit = marathiNumber[i];
      if (marathiToEnglish.containsKey(digit)) {
        englishNumber += marathiToEnglish[digit]!;
      } else {
        englishNumber += digit; // If it's not a Marathi number, keep it as it is
      }
    }
    return englishNumber;
  }

  bool validateEnglishNumber(String number) {
    // Regular expression to check if the string contains only digits
    RegExp digitRegExp = RegExp(r'^[0-9]+$');
    return digitRegExp.hasMatch(number);
  }

  // Future<void>submitextrahours(String selecteddate, String tripfromstamp,
  //      String triptostamp, String extrahourstr) async {
  //
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String city = prefs.getString("city") ?? "No City Available";
  //
  //   // Convert Marathi numerals to English numerals if needed
  //   String tripFromStampEnglish = isMarathiNumber(tripfromstamp)
  //       ? convertMarathiToEnglishSubmit(tripfromstamp)
  //       : tripfromstamp;
  //
  //   String tripToStampEnglish = isMarathiNumber(triptostamp)
  //       ? convertMarathiToEnglishSubmit(triptostamp)
  //       : triptostamp;
  //
  //   var url = Uri.parse(CommonURL.herokuurl);
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //
  //   loading();
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "extraTripAdd";
  //   request.fields['idUser'] = utility.userid;
  //   request.fields['lithiumID'] = utility.lithiumid;
  //   request.fields['service_provider_c'] = utility.service_provider_c;
  //
  //   // Set tripFromTime and tripToTime based on input format
  //   request.fields['tripFromTime'] = tripFromStampEnglish;
  //   request.fields['tripToTime'] = tripToStampEnglish;
  //
  //   request.fields['tripDate'] = selecteddate;
  //   request.fields['tripComment'] = tripcommentcontroller.text;
  //   request.fields['tripId'] = tripidcontroller.text;
  //   request.fields['tripTotalHours'] = extrahourstr;
  //   request.fields['city'] = city;
  //
  //   if (imagebool == true) {
  //     request.files.add(await http.MultipartFile.fromPath('tripFile', _image.path));
  //   }
  //
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     String status = jsonInput['status'].toString();
  //     String message = jsonInput['message'].toString();
  //
  //     if (status == 'true') {
  //       Navigator.pop(context);
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //   }
  //
  //   Navigator.pop(context);
  //   setState(() {});
  // }

  bool isMarathiNumber(String number) {
    // Regular expression to check if the string contains Marathi numerals
    RegExp marathiRegExp = RegExp(r'^[०-९]+$');
    return marathiRegExp.hasMatch(number);
  }


  Future<void>submitextrahours(String selecteddate, String tripfromstamp,
      String triptostamp, String extrahourstr) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String city = prefs.getString("city") ?? "No City Available";

    // Regular expression to identify Marathi numerals in the timestamp
    RegExp marathiRegExp = RegExp(r'[०-९]');

    // Convert Marathi numerals to English numerals if needed
    if (marathiRegExp.hasMatch(tripfromstamp)) {
      tripfromstamp = convertMarathiToEnglishSubmit(tripfromstamp);
    }

    if (marathiRegExp.hasMatch(triptostamp)) {
      triptostamp = convertMarathiToEnglishSubmit(triptostamp);
    }

    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    // if (selecteddate != tripfromstamp.substring(0, 10)) {
    //   Fluttertoast.showToast(
    //     msg: "Selected date and trip start date must be the same",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //   );
    //   return; // Exit function if dates are not the same
    // }

    loading();

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "extraTripAdd";
    request.fields['idUser'] = utility.userid;
    request.fields['lithiumID'] = utility.lithiumid;
    request.fields['service_provider_c'] = utility.service_provider_c;

    // Set tripFromTime and tripToTime based on input format
    request.fields['tripFromTime'] = tripfromstamp;
    request.fields['tripToTime'] = triptostamp;

    request.fields['tripDate'] = selecteddate;
    request.fields['tripComment'] = tripcommentcontroller.text;
    request.fields['tripId'] = tripidcontroller.text;
    request.fields['tripTotalHours'] = extrahourstr;
    //request.fields['city'] = city;

    log('fieldvalue${request.fields}');

    if (imagebool == true) {
      request.files.add(await http.MultipartFile.fromPath('tripFile', _image.path));
    }

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      print('jsonresponse$jsonInput');
      String status = jsonInput['status'].toString();
      String message = jsonInput['message'].toString();

      print('message--$message, $status');

      if (status == 'true') {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }

    Navigator.pop(context);
    setState(() {});
  }



  // submitextrahours(String selecteddate, String tripfromstamp,
  //     String triptostamp, String extrahourstr) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String city = prefs.getString("city") ?? "No City Available";
  //
  //   String tripFromStampEnglish = convertMarathiToEnglishSubmit(tripfromstamp);
  //   String tripToStampEnglish = convertMarathiToEnglishSubmit(triptostamp);
  //
  //
  //   var url = Uri.parse(CommonURL.herokuurl);
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //
  //   print("selecteddate== $selecteddate $tripfromstamp.substring(0, 10)");
  //
  //   if (selecteddate != tripfromstamp.substring(0, 10)) {
  //     Fluttertoast.showToast(
  //       msg: "Selected date and trip start date must be the same",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //     );
  //     return; // Exit function if dates are not the same
  //   }
  //   loading();
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "extraTripAdd";
  //   request.fields['idUser'] = utility.userid;
  //   request.fields['lithiumID'] = utility.lithiumid;
  //   request.fields['service_provider_c'] = utility.service_provider_c;
  //   request.fields['tripFromTime'] = tripfromstamp;
  //   request.fields['tripToTime'] = triptostamp;
  //   request.fields['tripFromTime'] = tripfromstamp;
  //   request.fields['tripToTime'] = triptostamp;
  //   request.fields['tripDate'] = selecteddate.toString();
  //   request.fields['tripComment'] = tripcommentcontroller.text;
  //   request.fields['tripId'] = tripidcontroller.text;
  //   request.fields['tripTotalHours'] = extrahourstr;
  //   request.fields['city'] = city;
  //
  //   if (imagebool == true) {
  //     request.files
  //         .add(await http.MultipartFile.fromPath('tripFile', _image.path));
  //   }
  //
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     String status = jsonInput['status'].toString();
  //     String message = jsonInput['message'].toString();
  //
  //     if (status == 'true') {
  //       Navigator.pop(context);
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //   }
  //
  //   Navigator.pop(context);
  //   setState(() {});
  // }


  getextrahours(String tripfromstamp, String triptostamp) async {
    // String url = CommonURL.BASE_URL;
    var url = Uri.parse(CommonURL.localone);
    Map<String, String> postdata = {
      "from": "calculateTotalTripHours",
      "tripFromTime": tripfromstamp,
      "tripToTime": triptostamp,
    };
    // print(postdata.toString());
    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(url,
        body: jsonEncode(postdata), headers: requestHeaders);

    // //print("${response.statusCode}");
    // print("${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("cacelist$jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'].toString();

      if (status == 'true') {
        extrahours = jsonInput['totalTripDays'].toString();
      } else {
        // Navigator.pop(context);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
    setState(() {});
  }

  getshiftdetails(String tripdate) async {

    utility.showYourPopUp(context);

    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    String dataJson = jsonEncode([
      {
        "service_provider": utility.service_provider_c,
        'tripDate': tripdate
      }
    ]);

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getShiftandCheckintime";
    request.fields['data'] = dataJson;

    print("getshift fields = ${request.fields.toString()}");

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    afterselectdate = true;
    utility.closeLoader(context);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      print("getshift resp = $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'].toString();

      if (status == 'true') {
        var shiftdetails = jsonInput['data'];

        if (shiftdetails.isNotEmpty){
          setState(() {
            shiftstarttime = shiftdetails[0]['shift_start__c'].toString();
            shiftendtime = shiftdetails[0]['shift_end__c'].toString();
            checkinTime = shiftdetails[0]['login__c'].toString();
            checkoutTime = shiftdetails[0]['logout__c'].toString();
          });
        }
        else{
          print("No Data");
        }


      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  double daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inSeconds / 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text("Extra Trip"),
      //   backgroundColor: HexColor("#520283"),
      // ),

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CommonAppbar(
            title: AppLocalizations.of(context)!.extra_Trip,
            appBar: AppBar(),
            widgets: const [],
          ),
        ),
        body: Container(
          color: HexColor(Colorscommon.backgroundcolor),
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(children: [
              // Center(
              //     child: Padding(
              //         padding: const EdgeInsets.only(
              //           top: 10,
              //           left: 5,
              //           right: 5,
              //         ),
              //         child: Text(
              //           "Enter Extra Hours Information",
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               color: HexColor(Colorscommon.greencolor)),
              //         ))),
              Container(
                  margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Avenirtextmedium(
                        customfontweight: FontWeight.w500,
                        fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                            AppLocalizations.of(context)!.id == "आयडी" ||
                            AppLocalizations.of(context)!.id == "आयडी" ||
                            AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                            AppLocalizations.of(context)!.id == "ಐಡಿ")
                            ? 12
                            : 15,
                        text: AppLocalizations.of(context)!.trip_Date,
                        textcolor: HexColor(Colorscommon.greendark),
                      )
                    // child: Text(
                    //   "Trip Date",
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w400,
                    //       color: HexColor(Colorscommon.greendark2)),
                    // ),
                  )),
              Bouncing(
                  onPress: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    Future<String> fromdatee =
                    utility.Displaydate2(context, "1", "0", "", "");

                    fromdatee.then((value) {
                      //("datepick" + value.toString());
                      // fromdatevaild = value.toString();
                      selecteddatevaild = value.toString();
                      selecteddatesend = utility.DateConvert3(value.toString());
                      fromdate = null;
                      fromdatevaild = null;
                      fromdatesend = null;
                      todate = null;
                      todatesend = null;
                      starttime = null;
                      starttimesend = null;
                      endtime = null;
                      endtimesend = null;

                      setState(() {
                        selecteddate =
                            utility.DateConvertINDIA1(value.toString());
                      });
                      getshiftdetails(selecteddatesend!);
                    });
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        //  side: BorderSide(width: 0.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.blueAccent)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/DateInput.png"),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        // Icon(
                        //   Icons.calendar_month_outlined,
                        //   color: HexColor(Colorscommon.greencolor),
                        // ),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Avenirtextbook(
                                customfontweight: FontWeight.w500,
                                fontsize: (AppLocalizations.of(context)!.id ==
                                    "ஐடி" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id ==
                                        "आयडी" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ" ||
                                    AppLocalizations.of(context)!.id ==
                                        "ಐಡಿ")
                                    ? 12
                                    : 14,
                                text: " " + (selecteddate ?? "Select  Date"),
                                textcolor: HexColor(Colorscommon.greydark2),
                              ),
                            )
                          // child: Text(
                          //   " " + (selecteddate ?? "Select  Date"),
                          //   // textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //       color: HexColor(Colorscommon.greydark2)),
                          // ),
                        ),
                      ],
                    ),
                  )),

              Visibility(
                visible: afterselectdate,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                              // height: 40,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    text: AppLocalizations.of(context)!.shift_StartTime + " : ",
                                    textcolor: HexColor(Colorscommon.greendark),
                                  )
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                              // height: 40,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    text: shiftstarttime != "null" && shiftstarttime != "" ?  shiftstarttime : "00:00",
                                    textcolor: HexColor(Colorscommon.greydark2),
                                  )
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                              // height: 40,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    text: AppLocalizations.of(context)!.shift_EndTime + " : ",
                                    textcolor: HexColor(Colorscommon.greendark),
                                  )
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                              // height: 40,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    text: shiftendtime != "null" && shiftendtime != "" ? shiftendtime : "00:00",
                                    textcolor: HexColor(Colorscommon.greydark2),
                                  )
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                              // height: 40,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    text: AppLocalizations.of(context)!.checkintime + " : ",
                                    textcolor: HexColor(Colorscommon.greendark),
                                  )
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                              // height: 40,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    text: checkinTime != "null" && checkinTime != "" ? checkinTime : "00:00",
                                    textcolor: HexColor(Colorscommon.greydark2),
                                  )
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                              // height: 40,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    text: AppLocalizations.of(context)!.checkouttime + " : ",
                                    textcolor: HexColor(Colorscommon.greendark),
                                  )
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                              // height: 40,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    text: checkoutTime != "null" && checkoutTime != "" ? checkoutTime : "00:00",
                                    textcolor: HexColor(Colorscommon.greydark2),
                                  )
                              )),
                        ),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Avenirtextmedium(
                              customfontweight: FontWeight.w500,
                              fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ")
                                  ? 12
                                  : 15,
                              text: AppLocalizations.of(context)!.trip_Id,
                              textcolor: HexColor(Colorscommon.greendark),
                            )
                          // child: Text(
                          //   "Trip ID",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w400,
                          //       color: HexColor(Colorscommon.greendark2)),
                          // ),
                        )),
                    Container(
                      height: 40,
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          //  side: BorderSide(width: 0.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.blueAccent)),
                      child: Center(
                        child: TextFormField(
                          controller: tripidcontroller,
                          style: TextStyle(
                              fontFamily: "AvenirLTStd-Book",
                              fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ")
                                  ? 12
                                  : 14,
                              fontWeight: FontWeight.w500,
                              color: HexColor(Colorscommon.greydark2)),
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Padding(
                              padding:
                              const EdgeInsets.only(top: 7, bottom: 7, left: 1),
                              child: Image.asset(
                                'assets/Reason.png',
                                width: 10,
                                height: 10,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
//                        prefixIcon: new Padding(
//    padding: const EdgeInsets.only( top: 15, left: 5, right: 0, bottom: 15),
//    child: new SizedBox(
//             height: 4,
//             child: Image.asset('assets/TimeInput.png"'),
//    ),
// ),
                            // prefixIcon: padding(
                            //   width: 20,
                            //   height: 20,
                            //   decoration: const BoxDecoration(
                            //     image: DecorationImage(
                            //       image: AssetImage("assets/TimeInput.png"),
                            //       fit: BoxFit.fitHeight,
                            //     ),
                            //   ),
                            // ),
                            hintStyle: TextStyle(
                                fontFamily: "AvenirLTStd-Book",
                                fontSize: (AppLocalizations.of(context)!.id ==
                                    "ஐடி" ||
                                    AppLocalizations.of(context)!.id == "आयडी" ||
                                    AppLocalizations.of(context)!.id == "आयडी" ||
                                    AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                    AppLocalizations.of(context)!.id == "ಐಡಿ")
                                    ? 12
                                    : 14,
                                fontWeight: FontWeight.w500,
                                color: HexColor(Colorscommon.greydark2)),

                            // child: Avenirtextbook(
                            //         customfontweight: FontWeight.w500,
                            //         fontsize: 14,
                            //         text: " " + (selecteddate ?? "Select  Date"),
                            //         textcolor: HexColor(Colorscommon.greydark2),
                            //       ),
                            hintText: AppLocalizations.of(context)!.trip_Id_select,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            // contentPadding: EdgeInsetsDirectional.only(start: 10.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Avenirtextmedium(
                              customfontweight: FontWeight.w500,
                              fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ")
                                  ? 12
                                  : 15,
                              text: AppLocalizations.of(context)!.trip_StartTime,
                              textcolor: HexColor(Colorscommon.greendark),
                            )
                          // child: Text(
                          //   "Trip Start  Time",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w400,
                          //       color: HexColor(Colorscommon.greendark2)),
                          // ),
                        )),
                    // Container(
                    //     margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //             child: Container(
                    //           child: Text(
                    //             "* Date",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: HexColor(Colorscommon.greencolor)),
                    //           ),
                    //         )),
                    //         Expanded(
                    //             child: Container(
                    //           child: Text(
                    //             "* Time",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: HexColor(Colorscommon.greencolor)),
                    //           ),
                    //         ))
                    //       ],
                    //     )),
                    Row(
                      children: [
                        Expanded(
                            child: Bouncing(
                              onPress: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (selecteddate == null) {
                                  Fluttertoast.showToast(
                                    msg: "Please Select Trip Date",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                } else {
                                  // Future<String> fromdatee =
                                  //   utility.Displaydate(context, "1", "0", "");
                                  // Future<String> fromdatee =
                                  //     utility.Displaydate(context, "2", "0", "");
                                  Future<String> fromdatee = utility.Displaydate2(
                                      context, "1", "1", selecteddatevaild ?? "", "");
                                  //  Future<String> fromdatee = utility.Displaydate(
                                  //   context, "", "1", fromdatevaild ?? "");

                                  fromdatee.then((value) {
                                    //("datepick" + value.toString());=
                                    fromdatevaild = value.toString();
                                    fromdatesend = utility.DateConvert3(value.toString());

                                    setState(() {
                                      fromdate =
                                          utility.DateConvertINDIA1(value.toString());
                                      vailddata();
                                    });
                                  });
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                height: 40,
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    //  side: BorderSide(width: 0.0, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Icon(
                                    //   Icons.calendar_month_outlined,
                                    //   color: HexColor(Colorscommon.greencolor),
                                    // ),
                                    // Avenirtextbook(
                                    //   customfontweight: FontWeight.w500,
                                    //   fontsize: 14,
                                    //   text: " " + (fromdate ?? "Select Date"),
                                    //   textcolor: HexColor(Colorscommon.greydark2),
                                    // )
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/DateInput.png"),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.calendar_month_outlined,
                                    //   color: HexColor(Colorscommon.greencolor),
                                    // ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          " " + (fromdate ?? "Select Date"),
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'AvenirLTStd-Book',
                                              fontSize: (AppLocalizations.of(context)!
                                                  .id ==
                                                  "ஐடி" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "ಐಡಿ")
                                                  ? 12
                                                  : 14,
                                              fontWeight: FontWeight.w500,
                                              color: HexColor(Colorscommon.greydark2)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // child: Text(
                                //   "* Date",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       color: HexColor(Colorscommon.greencolor)),
                                // ),
                              ),
                            )),
                        Expanded(
                            child: Bouncing(
                              onPress: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Future<String> fromdatee = utility.selectTimeto(context);

                                fromdatee.then((value) {
                                  setState(() {
                                    debugPrint('selectedvalue' + value.toString());

                                    if (value != "null") {
                                      starttime = value.substring(0, value.indexOf('.'));
                                      var pos = value.lastIndexOf('.');
                                      starttimesend = value.substring(pos + 1);
                                      print("starttimesend$starttimesend");
                                      vailddata();
                                    }
                                  });
                                });
                                print("startdate====$fromdatesend");
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                height: 40,
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    //  side: BorderSide(width: 0.0, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/TimeInput.png"),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.calendar_month_outlined,
                                    //   color: HexColor(Colorscommon.greencolor),
                                    // ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          " " + (starttime ?? "Select Time"),
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'AvenirLTStd-Book',
                                              fontSize: (AppLocalizations.of(context)!
                                                  .id ==
                                                  "ஐடி" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "ಐಡಿ")
                                                  ? 12
                                                  : 14,
                                              fontWeight: FontWeight.w500,
                                              color: HexColor(Colorscommon.greydark2)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Avenirtextmedium(
                              customfontweight: FontWeight.w500,
                              fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ")
                                  ? 12
                                  : 15,
                              text: AppLocalizations.of(context)!.trip_endtime,
                              textcolor: HexColor(Colorscommon.greendark),
                            )
                          // child: Text(
                          //   "Trip End  Time",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w400,
                          //       color: HexColor(Colorscommon.greendark2)),
                          // ),
                        )),
                    // Container(
                    //     margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //             child: Container(
                    //           child: Text(
                    //             "* Date",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: HexColor(Colorscommon.greencolor)),
                    //           ),
                    //         )),
                    //         Expanded(
                    //             child: Container(
                    //           child: Text(
                    //             "* Time",
                    //             style: TextStyle(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: HexColor(Colorscommon.greencolor)),
                    //           ),
                    //         ))
                    //       ],
                    //     )),
                    Row(
                      children: [
                        Expanded(
                            child: Bouncing(
                              onPress: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (fromdate == null) {
                                  Fluttertoast.showToast(
                                    msg: "Please Select From Date",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                } else {
                                  // Future<String> fromdatee = utility.Displaydate(
                                  //     context, "", "1", fromdatevaild ?? "");
                                  Future<String> fromdatee = utility.Displaydate(
                                      context, "1", "1", selecteddatevaild ?? "", "1");

                                  fromdatee.then((value) {
                                    //("datepick" + value.toString());
                                    todatesend = utility.DateConvert3(value.toString());

                                    setState(() {
                                      todate =
                                          utility.DateConvertINDIA1(value.toString());
                                      vailddata();
                                    });
                                  });
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                height: 40,
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    //  side: BorderSide(width: 0.0, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/DateInput.png"),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.calendar_month_outlined,
                                    //   color: HexColor(Colorscommon.greencolor),
                                    // ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          " " + (todate ?? "Select Date"),
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'AvenirLTStd-Book',
                                              fontSize: (AppLocalizations.of(context)!
                                                  .id ==
                                                  "ஐடி" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "ಐಡಿ")
                                                  ? 12
                                                  : 14,
                                              fontWeight: FontWeight.w500,
                                              color: HexColor(Colorscommon.greydark2)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // child: Text(
                                //   "* Date",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       color: HexColor(Colorscommon.greencolor)),
                                // ),
                              ),
                            )),
                        Expanded(
                            child: Bouncing(
                              onPress: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Future<String> fromdatee = utility.selectTimeto(context);

                                fromdatee.then((value) {
                                  setState(() {
                                    debugPrint('selectedvalue' + value.toString());

                                    if (value != "null") {
                                      endtime = value.substring(0, value.indexOf('.'));
                                      var pos = value.lastIndexOf('.');
                                      endtimesend = value.substring(pos + 1);
                                      vailddata();
                                    }
                                  });
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                height: 40,
                                decoration: const ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    //  side: BorderSide(width: 0.0, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(width: 2),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("assets/TimeInput.png"),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.calendar_month_outlined,
                                    //   color: HexColor(Colorscommon.greencolor),
                                    // ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          " " + (endtime ?? "Select Time"),
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'AvenirLTStd-Book',
                                              fontSize: (AppLocalizations.of(context)!
                                                  .id ==
                                                  "ஐடி" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "आयडी" ||
                                                  AppLocalizations.of(context)!.id ==
                                                      "ಐಡಿ")
                                                  ? 12
                                                  : 14,
                                              fontWeight: FontWeight.w500,
                                              color: HexColor(Colorscommon.greydark2)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                margin: const EdgeInsets.all(10.0),
                                height: 20,
                                child: Avenirtextmedium(
                                  customfontweight: FontWeight.w500,
                                  fontsize: (AppLocalizations.of(context)!.id ==
                                      "ஐடி" ||
                                      AppLocalizations.of(context)!.id ==
                                          "आयडी" ||
                                      AppLocalizations.of(context)!.id ==
                                          "आयडी" ||
                                      AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                      AppLocalizations.of(context)!.id == "ಐಡಿ")
                                      ? 12
                                      : 15,
                                  text: AppLocalizations.of(context)!.extra_Hours,
                                  textcolor: HexColor(Colorscommon.greendark),
                                )
                              // child: Text(
                              //   "Extra hours",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w400,
                              //       color: HexColor(Colorscommon.greendark2)),
                              // ),
                            )),
                        Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10.0),
                              // height: 20,
                              child: Text(
                                (extrahours == null)
                                    ? "0 Hour 0 minute ".toLowerCase()
                                    : "$extrahours".toLowerCase(),
                                style: TextStyle(
                                    fontSize: (AppLocalizations.of(context)!.id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "आयडी" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    fontWeight: FontWeight.bold,
                                    color: HexColor(Colorscommon.greencolor)),
                              ),
                            ))
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 5, right: 10, left: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Avenirtextmedium(
                              customfontweight: FontWeight.w500,
                              fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ")
                                  ? 12
                                  : 15,
                              text: AppLocalizations.of(context)!.comments,
                              textcolor: HexColor(Colorscommon.greendark),
                            )
                          // child: Text(
                          //   "Comments",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.w400,
                          //       color: HexColor(Colorscommon.greendark2)),
                          // ),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextField(
                          controller: tripcommentcontroller,
                          maxLines: null,
                          cursorColor: HexColor(Colorscommon.greydark2),
                          // controller: descriptioncontroller,
                          style: TextStyle(
                              fontFamily: 'AvenirLTStd-Book',
                              fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "आयडी" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id == "ಐಡಿ")
                                  ? 12
                                  : 14,
                              fontWeight: FontWeight.w500,
                              color: HexColor(Colorscommon.greydark2)),
                          // style: TextStyle(
                          //     color: HexColor(Colorscommon.greydark2),
                          //     fontFamily: "TomaSans-Regular"),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,

                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white, width: 0.1)),

                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 0.1)),
                            hintText: 'Enter Comments',
                            hintStyle: TextStyle(
                                fontFamily: 'AvenirLTStd-Book',
                                fontSize: (AppLocalizations.of(context)!.id ==
                                    "ஐடி" ||
                                    AppLocalizations.of(context)!.id == "आयडी" ||
                                    AppLocalizations.of(context)!.id == "आयडी" ||
                                    AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                    AppLocalizations.of(context)!.id == "ಐಡಿ")
                                    ? 12
                                    : 14,
                                fontWeight: FontWeight.w500,
                                color: HexColor(Colorscommon.greydark2)),
                            // prefixIcon: Icon(
                            //   Icons.access_time,
                            //   color: HexColor(Colorscommon.greendark),
                            // ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Image.asset(
                                'assets/DateInput.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                            // hintStyle: TextStyle(
                            //     color: HexColor(Colorscommon.greycolor),
                            //     fontFamily: "TomaSans-Regular"),
                          ),
                        ),
                      ),
                    ),
                    // Bouncing(
                    //   onPress: () {
                    //     FocusManager.instance.primaryFocus?.unfocus();
                    //   },
                    //   child: Container(
                    //     margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                    //     child: Align(
                    //       alignment: Alignment.centerLeft,
                    //       child: Container(
                    //         width: MediaQuery.of(context).size.width / 3,
                    //         height: 40,
                    //         decoration: const ShapeDecoration(
                    //           shape: RoundedRectangleBorder(
                    //             side:
                    //                 BorderSide(width: 1.0, style: BorderStyle.solid),
                    //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //           ),
                    //         ),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           // ignore: prefer_const_literals_to_create_immutables
                    //           children: [
                    //             Icon(
                    //               Icons.upload_file,
                    //               color: HexColor(Colorscommon.greencolor),
                    //             ),
                    //             Text(
                    //               " Upload files",
                    //               style: TextStyle(
                    //                   color: HexColor(Colorscommon.greycolor),
                    //                   fontFamily: "TomaSans-Regular"),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin:
                              const EdgeInsets.only(top: 5, right: 10, left: 10),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Avenirtextmedium(
                                    customfontweight: FontWeight.w500,
                                    fontsize: (AppLocalizations.of(context)!.id ==
                                        "ஐடி" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "आयडी" ||
                                        AppLocalizations.of(context)!.id ==
                                            "ಐಡಿ" ||
                                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                                        ? 12
                                        : 15,
                                    text: AppLocalizations.of(context)!
                                        .upload_Attachments,
                                    textcolor: HexColor(Colorscommon.greendark),
                                  )
                                // child: Text(
                                //   "Upload Attachments",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.w400,
                                //       color: HexColor(Colorscommon.greendark2)),
                                // ),
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Bouncing(
                                  onPress: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    _showPicker(context);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10, right: 3, left: 3),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 40,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 0.0,
                                              style: BorderStyle.solid,
                                              color: HexColor(Colorscommon.greenlight2),
                                            ),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(5.0)),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage("assets/Upload.png"),
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Avenirtextmedium(
                                                customfontweight: FontWeight.w500,
                                                fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                    AppLocalizations.of(context)!.id == "आयडी" ||
                                                    AppLocalizations.of(context)!.id == "आयडी" ||
                                                    AppLocalizations.of(context)!.id == "ಐಡಿ")
                                                    ? 12
                                                    : 15,
                                                text: imgname != ''
                                                    ? ' File Attached'
                                                    : ' Upload Files',
                                                textcolor: HexColor(Colorscommon.greydark2),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: imgname != '',
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete_forever),
                                    color: Colors.red,
                                    onPressed: () {
                                      setState(() {
                                        imgname = '';
                                        imagebool = false;
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                    Bouncing(
                      onPress: () {
                        if (selecteddatesend == null) {
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!.selectfromdate,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else if (fromdatesend == null) {
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!.selectstartdate,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else if (starttimesend == null) {
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!.selectstarttime,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else if (todatesend == null) {
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!.selectenddate,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else if (endtimesend == null) {
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context)!.selectendtime,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        }
                        //  else if (tripcommentcontroller.text.isEmpty) {
                        //   Fluttertoast.showToast(
                        //     msg: "Please Enter comments",
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.CENTER,
                        //   );
                        // }
                        else if (tripidcontroller.text.isEmpty) {
                          if (imagebool == false) {
                            Fluttertoast.showToast(
                              msg: AppLocalizations.of(context)!.idorfile,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          } else if (imagebool == true) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            utility.GetUserdata().then((value) => {
                              sessionManager
                                  .internetcheck()
                                  .then((intenet) async {
                                if (intenet) {
                                  submitextrahours(
                                      selecteddatesend!,
                                      "$fromdatesend " " $starttimesend",
                                      "$todatesend " " $endtimesend",
                                      extrahours!);
                                  // checkupdate(_30minstr);,
                                  // loading();
                                  // Loginapi(serveruuid, serverstate);
                                } else {
                                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (!mounted) return;

                                  final overlay = Overlay.of(context);
                                  if (overlay == null) return;

                                  showTopSnackBar(
                                    overlay,
                                    const CustomSnackBar.error(
                                      message: "Please Check Your Internet Connection",
                                    ),
                                  );
                                  //});
                                }
                              }),
                            });
                            // print("tripidcontroller.tgfchjjihgjjgext");
                          }
                        } else {
                          FocusManager.instance.primaryFocus?.unfocus();
                          utility.GetUserdata().then((value) => {
                            sessionManager.internetcheck().then((intenet) async {
                              if (intenet) {
                                //utility.showYourpopupinternetstatus(context);
                                submitextrahours(
                                    selecteddatesend!,
                                    "$fromdatesend " " $starttimesend",
                                    "$todatesend " " $endtimesend",
                                    extrahours!);
                                // checkupdate(_30minstr);,
                                // loading();
                                // Loginapi(serveruuid, serverstate);
                              } else {
                                // WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!mounted) return;

                                final overlay = Overlay.of(context);
                                if (overlay == null) return;

                                showTopSnackBar(
                                  overlay,
                                  const CustomSnackBar.error(
                                    message: "Please Check Your Internet Connection",
                                  ),
                                );
                                //});
                              }
                            }),
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor(Colorscommon.greenlight2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),

                          child: Avenirtextblack(
                            customfontweight: FontWeight.normal,
                            fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                AppLocalizations.of(context)!.id == "आयडी" ||
                                AppLocalizations.of(context)!.id == "आयडी" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ")
                                ? 12
                                : 14,
                            text: AppLocalizations.of(context)!.submit,
                            textcolor: Colors.white,
                          ),
                          // child: const Text(
                          //   "Submit",
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //   ),
                          // ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ]),
          ),
        ));
  }
}