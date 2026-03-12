// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
// import 'package:flutter_application_sfdc_idp/AppScreens/Earnings/Dashboardtabbar.dart';
// import 'package:flutter_application_sfdc_idp/Colors.dart';
// import 'package:flutter_application_sfdc_idp/CommonColor.dart';
// import 'package:flutter_application_sfdc_idp/CommonText.dart';
// import 'package:flutter_application_sfdc_idp/URL.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_application_sfdc_idp/Bouncing.dart';
// import 'package:flutter_application_sfdc_idp/Utility.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class Earningsnew extends StatefulWidget {
//   const Earningsnew({Key? key}) : super(key: key);
//
//   @override
//   State<Earningsnew> createState() => _EarningsnewState();
// }
//
// class _EarningsnewState extends State<Earningsnew> {
//   Utility utility = Utility();
//   bool listloadstatus = false;
//   final List<TextEditingController> _controllers = [];
//   bool dropdownvaluebool = false;
//   String? dropdownvalue;
//   late File _image;
//   String imgname = '';
//   late String benchFileName;
//   bool imagebool = false;
//   String service_provider = '';
//   String? change_date;
//   List<dynamic> datedroplist = [];
//   String? dropdownvalue2;
//   String? fromdate;
//   String? isgrivanceshowbyweek = "false";
//   String? isWeeklyEarningAlreadyExist = "false";
//   String? isNoGrievanceExist = "false";
//   String? tripTime;
//   String? statusValue;
//   String? totalNoOfTripPerformed;
//   String? todate;
//   List items = [];
//   List firstsfidarray = [];
//   List items2 = [];
//   List weekdetailsarray = [];
//   List<dynamic> serviceDayDetails = [];
//   List additionDeletionData = [];
//   List totalEarningArray = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // print("dropdownvalue$dropdownvalue");
//     Future<String> Serviceprovider = sessionManager.getspid();
//     Serviceprovider.then((value) {
//       service_provider = value.toString();
//     });
//     utility.GetUserdata().then((value) => {
//       sessionManager.internetcheck().then((intenet) async {
//         if (intenet) {
//           utility.showYourpopupinternetstatus(context);
//           // checkupdate(_30minstr);,
//           // loading();
//           // Loginapi(serveruuid, serverstate);
//         } else {
//           showTopSnackBar(
//             context,
//             const CustomSnackBar.error(
//               // icon: Icon(Icons.interests),
//               message: "Please Check Your Internet Connection",
//               // backgroundColor: Colors.white,
//               // textStyle: TextStyle(color: Colors.red),
//             ),
//           );
//         }
//       }), // spuser
//       getweekearnings()
//     });
//   }
//
//   void Raisenogriveance_func() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             insetPadding: const EdgeInsets.all(10),
//             contentPadding: EdgeInsets.zero,
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             titlePadding: EdgeInsets.zero,
//             title: Container(
//               height: 50,
//               color: HexColor(Colorscommon.greencolor),
//               child: Center(
//                 child: Text(
//                   "No Grievance",
//                   style: TextStyle(
//                       fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                           AppLocalizations.of(context)!.id == "आयडी" ||
//                           AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                           AppLocalizations.of(context)!.id == "ಐಡಿ")
//                           ? 15
//                           : 17,
//                       fontFamily: "AvenirLTStd-Black",
//                       fontWeight: FontWeight.w500,
//                       color: HexColor(Colorscommon.whitecolor)),
//                   textAlign: TextAlign.start,
//                 ),
//               ),
//             ),
//             titleTextStyle: TextStyle(color: Colors.grey[700]),
//             // titlePadding: const EdgeInsets.only(left: 5, top: 5),
//             content: Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(top: 5),
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     top: 20, bottom: 10, left: 10, right: 10),
//                 child: Text(
//                   "Do you want to raise no grievance?",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'AvenirLTStd-Book',
//                     fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                         AppLocalizations.of(context)!.id == "आयडी" ||
//                         AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                         AppLocalizations.of(context)!.id == "ಐಡಿ")
//                         ? 13
//                         : 15,
//                     color: HexColor(Colorscommon.greydark2),
//                   ),
//                 ),
//               ),
//             ),
//             actions: <Widget>[
//               Bouncing(
//                 onPress: () async {
//                   Raise_no_griveanceapi(context);
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
//                   height: 30,
//                   width: 80,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       gradient: LinearGradient(colors: [
//                         HexColor(Colorscommon.greencolor),
//                         HexColor(Colorscommon.greencolor),
//                       ])),
//                   child: Center(
//                     child: Avenirtextblack(
//                         text: AppLocalizations.of(context)!.yes,
//                         fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                             AppLocalizations.of(context)!.id == "आयडी" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ")
//                             ? 12
//                             : 13,
//                         textcolor: Colors.white,
//                         customfontweight: FontWeight.w500),
//                     //     child: Text(
//                     //   "Yes",
//                     //   style: TextStyle(
//                     //       color: Colors.white,
//                     //       fontFamily: 'Montserrat',
//                     //       fontWeight: FontWeight.bold),
//                     // )
//                   ),
//                 ),
//               ),
//               Bouncing(
//                 onPress: () async {
//                   Navigator.of(context, rootNavigator: true).pop();
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
//                   height: 30,
//                   width: 80,
//                   decoration: BoxDecoration(
//                       border:
//                       Border.all(color: HexColor(Colorscommon.greencolor)),
//                       borderRadius: BorderRadius.circular(5),
//                       gradient: const LinearGradient(colors: [
//                         Colors.white,
//                         Colors.white
//                         // HexColor(Colorscommon.greencolor),
//                         // HexColor(Colorscommon.greencolor),
//                       ])),
//                   child: Center(
//                     child: Avenirtextblack(
//                         text: AppLocalizations.of(context)!.no,
//                         fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                             AppLocalizations.of(context)!.id == "आयडी" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ")
//                             ? 12
//                             : 13,
//                         textcolor: HexColor(Colorscommon.greencolor),
//                         customfontweight: FontWeight.w500),
//                     //     child: Text(
//                     //   "No",
//                     //   style: TextStyle(
//                     //       color: HexColor(Colorscommon.greencolor),
//                     //       fontFamily: 'Montserrat',
//                     //       fontWeight: FontWeight.bold),
//                     // )
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   }
//
//   Raise_no_griveanceapi(BuildContext context) async {
//     loading();
//     var url = Uri.parse(CommonURL.herokuurl);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//     var fromdatestr = utility.dateconverteryyyymmdd(fromdate ?? "");
//
//     var todatestr = utility.dateconverteryyyymmdd(todate ?? "");
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "noGrievanceWeeklyUpdate";
//     request.fields['service_provider_c'] = service_provider;
//     request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['fromDate'] = fromdatestr;
//     request.fields['endDate'] = todatestr;
//     // request.fields['fromDate'] = "20-11-2022";
//     // request.fields['toDate'] = "26-11-2022";
//     request.fields['date'] = change_date ?? "";
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("daily earn = $jsonInput");
//
//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//
//       if (status == 'true') {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Navigator.of(context).pop();
//         Navigator.of(context).pop();
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const MyTabPage(
//                   title: '',selectedtab: 0,
//                 )));
//       } else {
//         Navigator.of(context).pop();
//         Navigator.of(context).pop();
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {
//       // Navigator.of(context).pop();
//       //   Navigator.of(context).pop();
//     }
//     setState(() {});
//   }
//
//   void _showPicker(context) {
//     FocusScope.of(context).requestFocus(FocusNode());
//
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) {
//           return SafeArea(
//             child: Container(
//               child: Wrap(
//                 children: <Widget>[
//                   ListTile(
//                       leading: const Icon(Icons.photo_library),
//                       title: const Text('Gallery'),
//                       onTap: () {
//                         getImageGallery(context, ImageSource.gallery);
//                         Navigator.of(context).pop();
//                       }),
//                   ListTile(
//                     leading: const Icon(Icons.photo_camera),
//                     title: const Text('Camera'),
//                     onTap: () {
//                       getImageGallery(context, ImageSource.camera);
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   raisegrivenseforaddtiondeletion(BuildContext context, String voucherc,
//       String senddate, String typename, int indexvalue, int indexvalue2) async {
//     loading();
//     var url = Uri.parse(CommonURL.herokuurl);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//     // print("voucherc$voucherc");
//     // print("senddate$senddate");
//     var fromdatestr = utility.dateconverteryyyymmdd(fromdate ?? "");
//
//     var todatestr = utility.dateconverteryyyymmdd(todate ?? "");
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "updateHRGrievanceRise";
//     request.fields['service_provider_c'] = service_provider;
//     request.fields['voucher_c'] = voucherc;
//     request.fields['date'] = senddate;
//     request.fields['fromDate'] = fromdatestr;
//     request.fields['toDate'] = todatestr;
//     // request.fields['fromDate'] = "20-11-2022";
//     // request.fields['toDate'] = "26-11-2022";
//     request.fields['type_c'] = typename;
//     request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//     // print("service_provider$service_provider");
//     // print("voucherc$voucherc");
//     // print("senddate$senddate");
//     // print("todatestr$todatestr");
//     // print("fromdatestr$fromdatestr");
//     // print("typename$typename");
//     var streamResponse = await request.send();
//     // log("streamResponse$streamResponse");
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("daily earn = $jsonInput");
//
//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//
//       if (status == 'true') {
//         additionDeletionData[indexvalue]['data'][indexvalue2]['alreadyRise'] =
//         true;
//         Navigator.of(context).pop();
//         // getearningweeksdetails();
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {}
//
//     Navigator.of(context).pop();
//     setState(() {});
//   }
//
//   tempimagestoreapi(BuildContext context) async {
//     // loading();
//     var url = Uri.parse(CommonURL.herokuurl);
//     // String url = CommonURL.URL;
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//     // var uri = Uri.parse(url);
//     // print(utility.lithiumid);
//     // print(utility.service_provider_c);
//     // for (int i = 0; i < dailyearnindetailslist.length; i++) {
//     // print(jsonEncode(serviceDayDetails));
//     // }
// //     isMonthlyOrWeekly:monthly
// // from:benchFileMoveToServerFolder
//     // benchFile: // multipart form data file
//
//     // var fromdatestr = utility.dateconverteryyyymmdd(fromdate ?? "");
//
//     // var todatestr = utility.dateconverteryyyymmdd(todate ?? "");
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "benchFileMoveToServerFolder";
//     // change_date
//     // debugPrint('serviceDayDetails: $serviceDayDetails');
//     // log("serviceDayDetails$serviceDayDetails");
//     // String str = jsonEncode(serviceDayDetails);
//     request.fields['isMonthlyOrWeekly'] = 'monthly';
//     request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//     request.files
//         .add(await http.MultipartFile.fromPath('benchFile', _image.path));
//
//     // request.files.add(await http.MultipartFile.fromPath('file', _image.path));
//
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       //  log("MonthlyearningSubmitjsonInput$response.body");
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//
//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//
//       // log(message);
//       // log(sql);
//       // print("benchFileName$benchFileName");
//
//       if (status == 'true') {
//         benchFileName = jsonInput['benchFileName'].toString();
//
//       } else {
//         Navigator.of(context, rootNavigator: true).pop();
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {}
//
//     // Navigator.pop(context);
//     setState(() {});
//     // Navigator.pop(context);
//   }
//
//   Future getImageGallery(BuildContext context, var type) async {
//     final pickedFile =
//     await ImagePicker().getImage(source: type, imageQuality: 50);
//     final bytesdata = await pickedFile!.readAsBytes();
//     final bytes = bytesdata.buffer.lengthInBytes;
//
//     setState(() {
//       if (pickedFile != null) {
//         if (bytes <= 512000) {
//           setState(() {
//             _image = File(pickedFile.path);
//             imgname = _image.path.split('/').last;
//             imagebool = true;
//             print('sel img = $_image');
//             tempimagestoreapi(context);
//           });
//         } else {
//           Fluttertoast.showToast(
//               msg: AppLocalizations.of(context)!.maxfilesize,
//               gravity: ToastGravity.CENTER);
//         }
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//                 width: MediaQuery.of(context).size.width - 15,
//                 margin: const EdgeInsets.only(top: 8, right: 10, left: 10),
//                 child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Avenirtextblack(
//                         customfontweight: FontWeight.w500,
//                         fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                             AppLocalizations.of(context)!.id == "आयडी" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ")
//                             ? 12
//                             : 14,
//                         text: AppLocalizations.of(context)!.selectmonth,
//                         textcolor: HexColor(Colorscommon.greenAppcolor))
//                   // child: Text(
//                   //   "Select Month",
//                   //   style: TextStyle(
//                   //       fontWeight: FontWeight.bold,
//                   //       color: HexColor(Colorscommon.greencolor)),
//                   // ),
//                 )),
//             Container(
//               width: MediaQuery.of(context).size.width - 15,
//               height: 40,
//               margin: const EdgeInsets.all(15.0),
//               padding: const EdgeInsets.all(3.0),
//               decoration: ShapeDecoration(
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(
//                       width: 0.4,
//                       style: BorderStyle.solid,
//                       color: HexColor(Colorscommon.greydark2)),
//                   borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                 ),
//               ),
//               child: Theme(
//                 data: Theme.of(context)
//                     .copyWith(canvasColor: Colors.grey.shade100),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton(
//                     hint: const Text("-- Select Month -- "),
//                     style: TextStyle(
//                         fontFamily: 'AvenirLTStd-Book',
//                         fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                             AppLocalizations.of(context)!.id == "आयडी" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ")
//                             ? 12
//                             : 14,
//                         color: HexColor(Colorscommon.greydark2),
//                         fontWeight: FontWeight.w500),
//                     elevation: 0,
//                     value: dropdownvalue,
//                     items: items.map((items) {
//                       return DropdownMenuItem(
//                           value: items,
//                           child: Text(
//                             " " + items.toString(),
//                           ));
//                     }).toList(),
//                     icon: Icon(
//                       Icons.keyboard_arrow_down,
//                       color: HexColor(Colorscommon.greencolor),
//                     ),
//                     onChanged: (value) {
//                       dropdownvalue = value.toString();
//                       dropdownvaluebool = false;
//                       String sfidarrayname;
//                       // setState(() {});
//                       for (int i = 0; i < items.length; i++) {
//                         if (items[i].toString() == value) {
//                           sfidarrayname = firstsfidarray[i].toString();
//                           getweekearningsdetailsbymonth(sfidarrayname);
//                           // break;
//                         }
//                       }
//                       dropdownvalue2 = null;
//
//                       setState(() {});
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Visibility(
//               visible: dropdownvaluebool == true,
//               child: Container(
//                   width: MediaQuery.of(context).size.width - 15,
//                   margin: const EdgeInsets.only(top: 8, right: 10, left: 10),
//                   child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Avenirtextblack(
//                           customfontweight: FontWeight.w500,
//                           fontsize: (AppLocalizations.of(context)!.id ==
//                               "ஐடி" ||
//                               AppLocalizations.of(context)!.id == "आयडी" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ")
//                               ? 12
//                               : 14,
//                           text: AppLocalizations.of(context)!.selectweek,
//                           textcolor: HexColor(Colorscommon.greenAppcolor))
//
//                   )),
//             ),
//             Visibility(
//               visible: dropdownvaluebool == true,
//               child: Container(
//                 width: MediaQuery.of(context).size.width - 15,
//                 height: 40,
//                 margin: const EdgeInsets.all(15.0),
//                 padding: const EdgeInsets.all(3.0),
//                 decoration: ShapeDecoration(
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                         width: 0.4,
//                         style: BorderStyle.solid,
//                         color: HexColor(Colorscommon.greydark2)),
//                     borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                   ),
//                 ),
//                 child: Theme(
//                   data: Theme.of(context)
//                       .copyWith(canvasColor: Colors.grey.shade100),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton(
//                       isExpanded: true,
//                       hint: const Text("-- Select Week -- "),
//                       style: TextStyle(
//                           fontFamily: 'AvenirLTStd-Book',
//                           fontSize: (AppLocalizations.of(context)!.id ==
//                               "ஐடி" ||
//                               AppLocalizations.of(context)!.id == "आयडी" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ")
//                               ? 12
//                               : 14,
//                           color: HexColor(Colorscommon.greydark2),
//                           fontWeight: FontWeight.w500),
//                       elevation: 0,
//                       value: dropdownvalue2,
//                       items: items2.map((items) {
//                         return DropdownMenuItem(
//                             value: items,
//                             child: Text(
//                               " " + items.toString(),
//                             ));
//                       }).toList(),
//                       icon: Icon(
//                         Icons.keyboard_arrow_down,
//                         color: HexColor(Colorscommon.greencolor),
//                       ),
//                       onChanged: (value) {
//                         dropdownvalue2 = value.toString();
//                         for (int i = 0; i < weekdetailsarray.length; i++) {
//                           if (weekdetailsarray[i]['name'].toString() == value) {
//                             // print(weekdetailsarray[i]);
//                             fromdate =
//                                 weekdetailsarray[i]["fromdate"].toString();
//                             todate = weekdetailsarray[i]["todate"].toString();
//                             isgrivanceshowbyweek =
//                                 weekdetailsarray[i]["isGrievance"].toString();
//                           }
//                         }
//                         setState(() {
//                           getearningweeksdetails();
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               // height: MediaQuery.of(context).size.height + 600,
//               child: Column(
//                 children: [
//
//                   Visibility(
//                     visible: dropdownvalue2 != null,
//                     child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             flex: 1,
//                             child: Avenirtextmedium(
//                               customfontweight: FontWeight.w500,
//                               fontsize: (AppLocalizations.of(context)!.id ==
//                                   "ஐடி" ||
//                                   AppLocalizations.of(context)!.id ==
//                                       "आयडी" ||
//                                   AppLocalizations.of(context)!.id ==
//                                       "ಐಡಿ" ||
//                                   AppLocalizations.of(context)!.id == "ಐಡಿ")
//                                   ? 12
//                                   : 14,
//                               text: AppLocalizations.of(context)!
//                                   .totalTripsPerformed,
//                               textcolor: HexColor(Colorscommon.greendark),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Expanded(
//                               flex: 1,
//                               child: Text(
//                                 totalNoOfTripPerformed ?? "0",
//                                 textAlign: TextAlign.center,
//                               )), //utility.Todaystr
//                         ],
//                       ),
//                     ),
//                   ),
//                   Visibility(
//                     visible: dropdownvalue2 != null,
//                     child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                               flex: 1,
//                               child: Avenirtextblack(
//                                   customfontweight: FontWeight.w500,
//                                   fontsize: (AppLocalizations.of(context)!.id ==
//                                       "ஐடி" ||
//                                       AppLocalizations.of(context)!.id ==
//                                           "आयडी" ||
//                                       AppLocalizations.of(context)!.id ==
//                                           "ಐಡಿ")
//                                       ? 12
//                                       : 14,
//                                   text: AppLocalizations.of(context)!
//                                       .servicedaydetails,
//                                   textcolor:
//                                   HexColor(Colorscommon.greenAppcolor))
//                             // child: Text(
//                             //   'Service Days Details',
//                             //   style: TextStyle(
//                             //       color: HexColor(Colorscommon.greencolor),
//                             //       fontWeight: FontWeight.bold),
//                             // ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           const Expanded(flex: 1, child: Text("            ")),
//                           //utility.Todaystr
//                         ],
//                       ),
//                     ),
//                   ),
//                   Visibility(
//                     visible: dropdownvalue2 != null,
//                     child: Container(
//                       color: HexColor(Colorscommon.greencolor),
//                       height: 40,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               '   ' + AppLocalizations.of(context)!.description,
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: (AppLocalizations.of(context)!.id ==
//                                       "ஐடி" ||
//                                       AppLocalizations.of(context)!.id ==
//                                           "आयडी" ||
//                                       AppLocalizations.of(context)!.id ==
//                                           "ಐಡಿ")
//                                       ? 12
//                                       : 14,
//                                   fontWeight: FontWeight.bold),
//                               textAlign: TextAlign.start,
//                             ),
//                           ),
//                           Expanded(
//                             flex: 1,
//                             child: Text(
//                               AppLocalizations.of(context)!.days,
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: (AppLocalizations.of(context)!.id ==
//                                       "ஐடி" ||
//                                       AppLocalizations.of(context)!.id ==
//                                           "आयडी" ||
//                                       AppLocalizations.of(context)!.id ==
//                                           "ಐಡಿ")
//                                       ? 12
//                                       : 14,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                   Visibility(
//                     visible: dropdownvalue2 != null,
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: serviceDayDetails.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           // print('item count serviceDayDetails = ${serviceDayDetails[index]}');
//                           TextEditingController controller =
//                           TextEditingController();
//                           _controllers.add(controller);
//                           // });
//
//                           String? dropdownvalueone;
//                           String? dropdownvaluetwo;
//                           String? dropdownvaluethree;
//                           String? dropdownvaluefour;
//                           var arrayspilt5 =
//                           serviceDayDetails[index]["dropdownData"];
//                           List<String> array5 = [];
//                           List<String> sfidarray5 = [];
//                           String? dropdownvaluefive;
//                           // print(object)
//
//                           var arrayspilt1 =
//                           serviceDayDetails[index]["dateArray"];
//                           var arrayspilt2 =
//                           serviceDayDetails[index]["isAvailDropDown"];
//                           var arrayspilt3 =
//                           serviceDayDetails[index]["categoryData"];
//                           var arrayspilt4 =
//                           serviceDayDetails[index]["subCategoryData"];
//
//                           // String formFieldType =
//                           //     array[index][
//                           //             "formFieldType"]
//                           //         .toString();
//
//                           // if (dropdownvalueone == null) {
//                           //   dropdownvalueone = array[index]
//                           //           ["selectedDropDownValue"]
//                           //       .toString();
//
//                           //   print("noflow");
//                           // } else {
//                           //   print("flow");
//                           //   dropdownvalueone;
//                           // }
//
//                           dropdownvalueone = serviceDayDetails[index]
//                           ["selectedDate"]
//                               .toString();
//
//                           // print("sel dropdownvalueone = $dropdownvalueone");
//                           // dropdownvaluetwo =
//                           //     serviceDayDetails[index]["statusValue"].toString();
//                           // dropdownvaluethree =
//                           //     serviceDayDetails[index]["selectedCategory"].toString();
//                           // dropdownvaluefour = serviceDayDetails[index]
//                           //         ["selectedSubCategory"]
//                           //     .toString();
//                           // dropdownvaluefive = serviceDayDetails[index]
//                           //         ["selectedDrowdownValue"]
//                           //     .toString();
//
//                           List<String> array1 = [];
//                           List<String> array2 = [];
//                           List<String> array3 = [];
//                           List<String> array4 = [];
//
//                           List<String> sfidarray1 = [];
//                           List<String> sfidarray2 = [];
//                           List<String> sfidarray3 = [];
//                           List<String> sfidarray4 = [];
//
//                           for (int i = 0; i < arrayspilt1.length; i++) {
//                             if (serviceDayDetails[index]["name"].toString() ==
//                                 "Roster Start Time") {
//                               var value = (arrayspilt1[i]['name'].toString());
//
//                               array1.add(value);
//                             } else if (serviceDayDetails[index]["name"]
//                                 .toString() ==
//                                 "Late") {
//                               var value = (arrayspilt1[i]['name'].toString());
//                               // print(arrayspilt1[i]);
//
//                               array1.add(value);
//                             } else {
//                               var value = (arrayspilt1[i]['name'].toString());
//
//                               array1.add(value);
//                             }
//
//                             var value2 =
//                             (arrayspilt1[i]['roster_master__c'].toString() +
//                                 "," +
//                                 arrayspilt1[i]['roster_start_datetime']
//                                     .toString());
//                             sfidarray1.add(value2);
//                           }
//                           for (int i = 0; i < arrayspilt2.length; i++) {
//                             var value = (arrayspilt2[i]['name'].toString());
//                             array2.add(value);
//                             var value2 = (arrayspilt2[i]['sfid'].toString());
//                             sfidarray2.add(value2);
//                           }
//                           for (int i = 0; i < arrayspilt3.length; i++) {
//                             var value =
//                             (arrayspilt3[i]['showlangaugename'].toString());
//                             array3.add(value);
//                             var value2 = (arrayspilt3[i]['sfid'].toString());
//                             sfidarray3.add(value2);
//                           }
//
//                           var columnname =
//                           serviceDayDetails[index]["name"].toString();
//                           print("columnname = $columnname");
//                           if (columnname == "Service Provided Days") {
//                             columnname = AppLocalizations.of(context)!
//                                 .serviceProvidedDays;
//                           } else if (columnname == "Bench") {
//                             columnname = AppLocalizations.of(context)!.bench;
//                           } else if (columnname == "Training") {
//                             columnname = AppLocalizations.of(context)!.training;
//                           } else if (columnname == "Late") {
//                             columnname = AppLocalizations.of(context)!.late;
//                           } else if (columnname == "EOS") {
//                             columnname = AppLocalizations.of(context)!.eOS;
//                           } else if (columnname == "WEOS") {
//                             columnname = AppLocalizations.of(context)!.wEOS;
//                           } else if (columnname == "UEOS") {
//                             columnname = AppLocalizations.of(context)!.uEOS;
//                           } else if (columnname == "Additional Shift") {
//                             columnname =
//                                 AppLocalizations.of(context)!.additionalShift;
//                           }
//
//
//                           for (int i = 0; i < arrayspilt5.length; i++) {
//
//                             var value = arrayspilt5[i]['name'].toString();
//                             array5.add(value);
//                             var value2 =
//                             (arrayspilt5[i]['roster_master__c'].toString());
//                             sfidarray5.add(value2);
//                           }
//
//                           // print("array1$array1");
//                           // print("array2$array2");
//                           // print("array3$array3");
//                           // print("array4$array4");
//                           // print("sfidarray1$sfidarray1");
//                           // print("sfidarray2$sfidarray2");
//                           // print("sfidarray3$sfidarray3");
//                           // print("sfidarray4$sfidarray4");
//
//                           // List<String> array1 = [];
//                           // List<String> array2 = [];
//                           // List<String> array3 = [];
//                           // List<String> array4 = [];
//
//                           // List<String> sfidarray1 = [];
//                           // List<String> sfidarray2 = [];
//                           // List<String> sfidarray3 = [];
//                           // List<String> sfidarray4 = [];
//                           // }s
//                           var datearrylist = serviceDayDetails[index]
//                           ["dateArray"] as List<dynamic>;
//                           var isGrievence = serviceDayDetails[index]
//                           ["isGrievence"]
//                               .toString();
//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(5),
//                                 child: SizedBox(
//                                   // height: 80,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Expanded(
//                                         flex: 2,
//                                         child: ExpansionTile(
//                                           title: Row(
//                                             children: [
//                                               Text(
//                                                 columnname.toString(),
//                                                 textAlign: TextAlign.start,
//                                                 style: TextStyle(
//                                                     color: HexColor(Colorscommon
//                                                         .greenAppcolor),
//                                                     fontSize: (AppLocalizations.of(
//                                                         context)!
//                                                         .id ==
//                                                         "ஐடி" ||
//                                                         AppLocalizations.of(
//                                                             context)!
//                                                             .id ==
//                                                             "आयडी" ||
//                                                         AppLocalizations.of(
//                                                             context)!
//                                                             .id ==
//                                                             "ಐಡಿ")
//                                                         ? 12
//                                                         : 14,
//                                                     fontFamily:
//                                                     'Avenir LT Std 65 Medium',
//                                                     fontWeight:
//                                                     FontWeight.w500),
//                                               ),
//                                               const Expanded(
//                                                   flex: 1,
//                                                   child: Text("         ")),
//                                               Visibility(
//                                                 visible:
//                                                 serviceDayDetails[index]
//                                                 ["name"]
//                                                     .toString() ==
//                                                     "TDS" ||
//                                                     serviceDayDetails[index]
//                                                     ["name"]
//                                                         .toString() ==
//                                                         "Total" ||
//                                                     serviceDayDetails[index]
//                                                     ["name"]
//                                                         .toString() ==
//                                                         "Net Payable",
//                                                 child: Text(
//                                                   "₹ " +
//                                                       serviceDayDetails[index]
//                                                       ["days"]
//                                                           .toString(),
//                                                   textAlign: TextAlign.start,
//                                                   style: TextStyle(
//                                                       fontSize: (AppLocalizations.of(
//                                                           context)!
//                                                           .id ==
//                                                           "ஐடி" ||
//                                                           AppLocalizations.of(
//                                                               context)!
//                                                               .id ==
//                                                               "आयडी" ||
//                                                           AppLocalizations.of(
//                                                               context)!
//                                                               .id ==
//                                                               "ಐಡಿ")
//                                                           ? 12
//                                                           : 14,
//                                                       fontWeight:
//                                                       FontWeight.w500),
//                                                 ),
//                                                 replacement: Text(
//                                                   serviceDayDetails[index]
//                                                   ["days"]
//                                                       .toString(),
//                                                   textAlign: TextAlign.start,
//                                                   style: TextStyle(
//                                                       color: HexColor(
//                                                           Colorscommon
//                                                               .greydark2),
//                                                       fontSize: (AppLocalizations.of(
//                                                           context)!
//                                                           .id ==
//                                                           "ஐடி" ||
//                                                           AppLocalizations.of(
//                                                               context)!
//                                                               .id ==
//                                                               "आयडी" ||
//                                                           AppLocalizations.of(
//                                                               context)!
//                                                               .id ==
//                                                               "ಐಡಿ")
//                                                           ? 12
//                                                           : 14,
//                                                       fontFamily:
//                                                       'Avenir LT Std 65 Medium',
//                                                       fontWeight:
//                                                       FontWeight.w500),
//                                                 ),
//                                               ),
//                                               // Visibility(
//                                               //   visible: serviceDayDetails[index]
//                                               //                   ["name"]
//                                               //               .toString() !=
//                                               //           "TDS" ||
//                                               //       serviceDayDetails[index]["name"]
//                                               //               .toString() !=
//                                               //           "Total" ||
//                                               //       serviceDayDetails[index]["name"]
//                                               //               .toString() !=
//                                               //           "Net Payable",
//                                               //   child: Text(
//
//                                               //         serviceDayDetails[index]["days"]
//                                               //             .toString(),
//                                               //     textAlign: TextAlign.start,
//                                               //     style: const TextStyle(
//                                               //         fontSize: 14,
//                                               //         fontWeight: FontWeight.w500),
//                                               //   ),
//                                               // ),
//                                             ],
//                                           ),
//                                           children: [
//                                             Visibility(
//                                               visible: datearrylist != null,
//                                               child: ListView.builder(
//                                                   scrollDirection:
//                                                   Axis.vertical,
//                                                   shrinkWrap: true,
//                                                   itemCount:
//                                                   datearrylist.length,
//                                                   itemBuilder:
//                                                       (BuildContext context,
//                                                       int index2) {
//                                                     // dropdownvaluetwo =
//                                                     //     datearrylist[index2]
//                                                     //             ["statusValue"]
//                                                     //         .toString();
//                                                     // dropdownvaluethree =
//                                                     //     datearrylist[index2]
//                                                     //             ["selectedCategory"]
//                                                     //         .toString();
//                                                     // dropdownvaluefour = datearrylist[
//                                                     //             index]
//                                                     //         ["selectedSubCategory"]
//                                                     //     .toString();
//                                                     // dropdownvaluefive = datearrylist[
//                                                     //             index]
//                                                     //         ["selectedDrowdownValue"]
//                                                     //     .toString();
//
//                                                     // print(
//                                                     //     "dropdownvalueone$dropdownvalueone");
//                                                     // print(
//                                                     //     "dropdownvaluetwo$dropdownvaluetwo");
//                                                     // print(
//                                                     //     "dropdownvaluethree$dropdownvaluethree");
//                                                     // print(
//                                                     //     "dropdownvaluefour$dropdownvaluefour");
//                                                     // print(
//                                                     //     "dropdownvaluefive$dropdownvaluefive");
//                                                     // print(datearrylist[index2][
//                                                     // "selectedSubCategory"]);
//                                                     return Padding(
//                                                       padding:
//                                                       const EdgeInsets.only(
//                                                           top: 10,
//                                                           right: 10,
//                                                           left: 15,
//                                                           bottom: 5),
//                                                       child: GestureDetector(
//                                                         onTap: () {
//                                                           print(datearrylist[
//                                                           index2]);
//                                                           dropdownvaluetwo =
//                                                               datearrylist[
//                                                               index2]
//                                                               [
//                                                               "statusValue"]
//                                                                   .toString();
//                                                           dropdownvaluethree =
//                                                               datearrylist[
//                                                               index2]
//                                                               [
//                                                               "selectedCategory"]
//                                                                   .toString();
//                                                           dropdownvaluefour =
//                                                               datearrylist[
//                                                               index2]
//                                                               [
//                                                               "selectedSubCategory"]
//                                                                   .toString();
//                                                           dropdownvaluefive =
//                                                               datearrylist[
//                                                               index2]
//                                                               [
//                                                               "selectedDrowdownValue"]
//                                                                   .toString();
//                                                           // if (datearrylist[index2]
//                                                           //     ["selectedCategory"]) {
//                                                           // } else {}
//                                                           // datearrylist[index2]["selectedCategory"] =
//                                                           //  Visibility(
//                                                           //     visible:
//                                                           //         isgrivanceshowbymonth ==
//                                                           //             "true",
//                                                           //     child: Visibility(
//                                                           //       visible: isNoGrievanceExist == "false",
//                                                           if (isgrivanceshowbyweek ==
//                                                               "true") {
//                                                             if (isNoGrievanceExist ==
//                                                                 "false") {
//                                                               if (isGrievence ==
//                                                                   "true") {
//                                                                 if (isNoGrievanceExist ==
//                                                                     "false") {
//                                                                   if (datearrylist[index2]
//                                                                   [
//                                                                   'isGrievanceAlreadyExist']
//                                                                       .toString() ==
//                                                                       "false") {
//                                                                     _controllers[
//                                                                     index]
//                                                                         .text = "";
//                                                                     benchFileName =
//                                                                     "";
//                                                                     datearrylist[index2]
//                                                                     [
//                                                                     "selectedCategory"] =
//                                                                     "Select Category";
//                                                                     datearrylist[index2]
//                                                                     [
//                                                                     "selectedSubCategory"] =
//                                                                     "Select SubCategory";
//                                                                     imgname =
//                                                                     '';
//                                                                     showDialog(
//                                                                       context:
//                                                                       context,
//                                                                       builder:
//                                                                           (context) {
//                                                                         String
//                                                                         contentText =
//                                                                             "Content of Dialog";
//                                                                         return StatefulBuilder(
//                                                                           builder:
//                                                                               (context, setState) {
//                                                                             return AlertDialog(
//                                                                               insetPadding: const EdgeInsets.all(10),
//                                                                               contentPadding: EdgeInsets.zero,
//                                                                               clipBehavior: Clip.antiAliasWithSaveLayer,
//                                                                               title: Center(
//                                                                                 child: Text(
//                                                                                   columnname,
//                                                                                   style: TextStyle(fontSize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 15, color: HexColor(Colorscommon.greenAppcolor)),
//                                                                                 ),
//                                                                               ),
//                                                                               content: SingleChildScrollView(
//                                                                                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                                                                                   Container(
//                                                                                       margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
//                                                                                       child: Align(
//                                                                                         alignment: Alignment.centerRight,
//                                                                                         child: Avenirtextmedium(
//                                                                                           customfontweight: FontWeight.w500,
//                                                                                           fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14,
//                                                                                           text: datearrylist[index2]['name'],
//                                                                                           textcolor: HexColor(Colorscommon.greendark),
//                                                                                         ),
//                                                                                         // child: Text(
//                                                                                         //   "Reason",
//                                                                                         //   style: TextStyle(
//                                                                                         //       fontWeight: FontWeight.bold,
//                                                                                         //       color: HexColor(Colorscommon.greendark)),
//                                                                                         // ),
//                                                                                       )),
//                                                                                   Container(
//                                                                                       margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
//                                                                                       child: Align(
//                                                                                         alignment: Alignment.centerLeft,
//                                                                                         child: Avenirtextmedium(
//                                                                                           customfontweight: FontWeight.w500,
//                                                                                           fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14,
//                                                                                           text: "Category",
//                                                                                           textcolor: HexColor(Colorscommon.greendark),
//                                                                                         ),
//                                                                                         // child: Text(
//                                                                                         //   "Reason",
//                                                                                         //   style: TextStyle(
//                                                                                         //       fontWeight: FontWeight.bold,
//                                                                                         //       color: HexColor(Colorscommon.greendark)),
//                                                                                         // ),
//                                                                                       )),
//                                                                                   Container(
//                                                                                     margin: const EdgeInsets.only(left: 0),
//                                                                                     child: Row(
//                                                                                       children: [
//                                                                                         // Expanded(
//                                                                                         //     flex: 1,
//                                                                                         //     child: Text(
//                                                                                         //       'Reason *',
//                                                                                         //       style: TextStyle(
//                                                                                         //           fontWeight: FontWeight.bold,
//                                                                                         //           color: HexColor(Colorscommon.greencolor)),
//                                                                                         //     )),
//                                                                                         Expanded(
//                                                                                           flex: 2,
//                                                                                           child: Container(
//                                                                                             height: 40,
//                                                                                             margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
//                                                                                             padding: const EdgeInsets.all(3.0),
//                                                                                             decoration: const ShapeDecoration(
//                                                                                               shape: RoundedRectangleBorder(
//                                                                                                 side: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
//                                                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                                               ),
//                                                                                               color: Colors.white,
//                                                                                             ),
//                                                                                             child: Theme(
//                                                                                               data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                                               child: DropdownButtonHideUnderline(
//                                                                                                 child: DropdownButton(
//                                                                                                   hint: Row(children: [
//                                                                                                     Container(
//                                                                                                       width: 20,
//                                                                                                       height: 20,
//                                                                                                       decoration: const BoxDecoration(
//                                                                                                         image: DecorationImage(
//                                                                                                           image: AssetImage("assets/Reason.png"),
//                                                                                                           fit: BoxFit.fitHeight,
//                                                                                                         ),
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                     const SizedBox(
//                                                                                                       width: 5,
//                                                                                                     ),
//                                                                                                     const Text("Select Category")
//                                                                                                   ]),
//                                                                                                   //           \Avenirtextmedium(
//                                                                                                   //   customfontweight: FontWeight.normal,
//                                                                                                   //   fontsize: 14,
//                                                                                                   //   text: "Reason",
//                                                                                                   //   textcolor: HexColor(Colorscommon.greendark),
//                                                                                                   // ),
//
//                                                                                                   style: TextStyle(fontSize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
//                                                                                                   elevation: 0,
//                                                                                                   value: datearrylist[index2]["selectedCategory"].toString(),
//                                                                                                   items: array3.map((items) {
//                                                                                                     return DropdownMenuItem(
//                                                                                                         value: items,
//                                                                                                         child: Row(
//                                                                                                           children: [
//                                                                                                             Container(
//                                                                                                               width: 20,
//                                                                                                               height: 20,
//                                                                                                               decoration: const BoxDecoration(
//                                                                                                                 image: DecorationImage(
//                                                                                                                   image: AssetImage("assets/Reason.png"),
//                                                                                                                   fit: BoxFit.fitHeight,
//                                                                                                                 ),
//                                                                                                               ),
//                                                                                                             ),
//                                                                                                             const SizedBox(
//                                                                                                               width: 5,
//                                                                                                             ),
//                                                                                                             Text(
//                                                                                                               items.toString(),
//                                                                                                             ),
//                                                                                                           ],
//                                                                                                         ));
//                                                                                                   }).toList(),
//
//                                                                                                   icon: Icon(
//                                                                                                     Icons.keyboard_arrow_down,
//                                                                                                     color: HexColor(Colorscommon.greenlight2),
//                                                                                                   ),
//                                                                                                   onChanged: (value) {
//                                                                                                     setState(() {
//                                                                                                       datearrylist[index2]["selectedCategory"] = value.toString();
//                                                                                                       serviceDayDetails[index]["selectedCategory"] = value.toString();
//                                                                                                     });
//                                                                                                     // print("dropdownchangevalue$value");
//
//                                                                                                     // dropdownvalue = value.toString();
//                                                                                                     // for (int i = 0; i < array3.length; i++) {
//                                                                                                     //   // print(jsonInput['data'][i]);
//
//                                                                                                     // }
//
//                                                                                                     // setState(() {});
//
//                                                                                                     // setState(() {});
//
//                                                                                                     for (var i = 0; array3.length > i; i++) {
//                                                                                                       // print(
//                                                                                                       //     array3[i].toString());
//                                                                                                       // print(
//                                                                                                       //     value.toString());
//                                                                                                       if (value.toString() != "Select Category") {
//                                                                                                         if (array3[i].toString() == value.toString()) {
//                                                                                                           arrayspilt4 = [];
//                                                                                                           array4 = [];
//                                                                                                           sfidarray4 = [];
//                                                                                                           arrayspilt4 = arrayspilt3[i]['subcategoryData'];
//
//                                                                                                           String datevalue = sfidarray3[i];
//                                                                                                           // getSubCategoryByCategory(serviceDayDetails[index]["name"].toString(), datevalue, index, index2);
//                                                                                                           serviceDayDetails[index]["selectedCategoryId"] = datevalue.toString();
//                                                                                                           datearrylist[index2]["selectedCategoryId"] = datevalue.toString();
//                                                                                                           setState() {}
//                                                                                                           print("dataarrayspeed$arrayspilt4");
//                                                                                                           // print(serviceDayDetails[index]["selectedCategoryId"].toString());
//                                                                                                           // print(datearrylist[index2]["selectedCategoryId"].toString());
//                                                                                                           for (int i = 0; i < arrayspilt4.length; i++) {
//                                                                                                             var value = (arrayspilt4[i]['showlangaugename'].toString());
//                                                                                                             array4.add(value);
//                                                                                                             var value2 = (arrayspilt4[i]['sfid'].toString());
//                                                                                                             sfidarray4.add(value2);
//                                                                                                           }
//                                                                                                           break;
//                                                                                                         }
//                                                                                                       } else {
//                                                                                                         setState() {}
//                                                                                                       }
//                                                                                                     }
//
//                                                                                                     // for (int i = 0;
//                                                                                                     //     i < data["devliverypoints"].length;
//                                                                                                     //     i++) {
//                                                                                                     //   if (value ==
//                                                                                                     //       data["devliverypoints"][i]
//                                                                                                     //               ["warehouseName"]
//                                                                                                     //           .toString()) {
//                                                                                                     //     dropdownvalue = value.toString();
//                                                                                                     //     address = data["devliverypoints"][i]
//                                                                                                     //             ["warehouseAddress"]
//                                                                                                     //         .toString();
//                                                                                                     //     idwarehouse = data["devliverypoints"][i]
//                                                                                                     //             ["idWarehouse"]
//                                                                                                     //         .toString();
//                                                                                                     //     // print(data["devliverypoints"][i]
//                                                                                                     //     //         ["idWarehouse"]
//                                                                                                     //     //     .toString());
//                                                                                                     //   }
//                                                                                                     // }
//                                                                                                     // setState(() {});
//                                                                                                   },
//                                                                                                   // onChanged: (String? value) {
//                                                                                                   //   //  setState(() {
//                                                                                                   //   //   dropdownvalue = value!;
//                                                                                                   //   // });
//                                                                                                   //   },
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                   Visibility(
//                                                                                     visible: datearrylist[index2]["selectedCategory"].toString() != "Select Category",
//                                                                                     child: Container(
//                                                                                         margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
//                                                                                         child: Align(
//                                                                                           alignment: Alignment.centerLeft,
//                                                                                           child: Avenirtextmedium(
//                                                                                             customfontweight: FontWeight.w500,
//                                                                                             fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14,
//                                                                                             text: "SubCategory",
//                                                                                             textcolor: HexColor(Colorscommon.greendark),
//                                                                                           ),
//                                                                                           // child: Text(
//                                                                                           //   "Reason",
//                                                                                           //   style: TextStyle(
//                                                                                           //       fontWeight: FontWeight.bold,
//                                                                                           //       color: HexColor(Colorscommon.greendark)),
//                                                                                           // ),
//                                                                                         )),
//                                                                                   ),
//                                                                                   Visibility(
//                                                                                     visible: datearrylist[index2]["selectedCategory"].toString() != "Select Category",
//                                                                                     child: Container(
//                                                                                       margin: const EdgeInsets.only(left: 0),
//                                                                                       child: Row(
//                                                                                         children: [
//                                                                                           // Expanded(
//                                                                                           //     flex: 1,
//                                                                                           //     child: Text(
//                                                                                           //       'Reason *',
//                                                                                           //       style: TextStyle(
//                                                                                           //           fontWeight: FontWeight.bold,
//                                                                                           //           color: HexColor(Colorscommon.greencolor)),
//                                                                                           //     )),
//                                                                                           Expanded(
//                                                                                             flex: 2,
//                                                                                             child: Container(
//                                                                                               height: 40,
//                                                                                               margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
//                                                                                               padding: const EdgeInsets.all(3.0),
//                                                                                               decoration: const ShapeDecoration(
//                                                                                                 shape: RoundedRectangleBorder(
//                                                                                                   side: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
//                                                                                                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                                                 ),
//                                                                                                 color: Colors.white,
//                                                                                               ),
//                                                                                               child: Theme(
//                                                                                                 data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                                                 child: DropdownButtonHideUnderline(
//                                                                                                   child: DropdownButton(
//                                                                                                     hint: Row(children: [
//                                                                                                       Container(
//                                                                                                         width: 20,
//                                                                                                         height: 20,
//                                                                                                         decoration: const BoxDecoration(
//                                                                                                           image: DecorationImage(
//                                                                                                             image: AssetImage("assets/Reason.png"),
//                                                                                                             fit: BoxFit.fitHeight,
//                                                                                                           ),
//                                                                                                         ),
//                                                                                                       ),
//                                                                                                       const SizedBox(
//                                                                                                         width: 5,
//                                                                                                       ),
//                                                                                                       const Text("Select SubCategory")
//                                                                                                     ]),
//                                                                                                     //           \Avenirtextmedium(
//                                                                                                     //   customfontweight: FontWeight.normal,
//                                                                                                     //   fontsize: 14,
//                                                                                                     //   text: "Reason",
//                                                                                                     //   textcolor: HexColor(Colorscommon.greendark),
//                                                                                                     // ),
//
//                                                                                                     style: TextStyle(fontSize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
//                                                                                                     elevation: 0,
//                                                                                                     value: datearrylist[index2]["selectedSubCategory"].toString(),
//                                                                                                     items: array4.map((items) {
//                                                                                                       return DropdownMenuItem(
//                                                                                                           value: items,
//                                                                                                           child: Row(
//                                                                                                             children: [
//                                                                                                               Container(
//                                                                                                                 width: 20,
//                                                                                                                 height: 20,
//                                                                                                                 decoration: const BoxDecoration(
//                                                                                                                   image: DecorationImage(
//                                                                                                                     image: AssetImage("assets/Reason.png"),
//                                                                                                                     fit: BoxFit.fitHeight,
//                                                                                                                   ),
//                                                                                                                 ),
//                                                                                                               ),
//                                                                                                               const SizedBox(
//                                                                                                                 width: 5,
//                                                                                                               ),
//                                                                                                               Text(
//                                                                                                                 items.toString(),
//                                                                                                               ),
//                                                                                                             ],
//                                                                                                           ));
//                                                                                                     }).toList(),
//
//                                                                                                     icon: Icon(
//                                                                                                       Icons.keyboard_arrow_down,
//                                                                                                       color: HexColor(Colorscommon.greenlight2),
//                                                                                                     ),
//                                                                                                     onChanged: (value) {
//                                                                                                       // print("dropdownchangevalue$value");
//                                                                                                       datearrylist[index2]["selectedSubCategory"] = value.toString();
//                                                                                                       // for()
//                                                                                                       // selectedSubCategoryId
//                                                                                                       // dropdownvalue = value.toString();
//                                                                                                       // for (int i = 0; i < array3.length; i++) {
//                                                                                                       //   // print(jsonInput['data'][i]);
//
//                                                                                                       // }
//                                                                                                       setState;
//                                                                                                       setState(() {});
//                                                                                                       for (var i = 0; array4.length > i; i++) {
//                                                                                                         // print(
//                                                                                                         //     array3[i].toString());
//                                                                                                         // print(
//                                                                                                         //     value.toString());
//                                                                                                         if (value.toString() != "Select SubCategory") {
//                                                                                                           if (array4[i].toString() == value.toString()) {
//                                                                                                             datearrylist[index2]["selectedSubCategoryId"] = arrayspilt4[i]["sfid"].toString();
//
//                                                                                                             setState() {}
//
//                                                                                                             break;
//                                                                                                           }
//                                                                                                         } else {
//                                                                                                           setState() {}
//                                                                                                         }
//                                                                                                       }
//                                                                                                     },
//                                                                                                     // onChanged: (String? value) {
//                                                                                                     //   //  setState(() {
//                                                                                                     //   //   dropdownvalue = value!;
//                                                                                                     //   // });
//                                                                                                     //   },
//                                                                                                   ),
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ),
//                                                                                           ),
//                                                                                         ],
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Visibility(
//                                                                                     visible: datearrylist[index2]["selectedCategory"].toString() != "Select Category",
//                                                                                     child: Visibility(
//                                                                                       visible: datearrylist[index2]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                       child: Visibility(
//                                                                                         visible: datearrylist[index2]["selectedSubCategory"].toString() == "Wrong Roster",
//                                                                                         child: Container(
//                                                                                             margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
//                                                                                             child: Align(
//                                                                                               alignment: Alignment.centerLeft,
//                                                                                               child: Avenirtextmedium(
//                                                                                                 customfontweight: FontWeight.w500,
//                                                                                                 fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14,
//                                                                                                 text: "Select Roster",
//                                                                                                 textcolor: HexColor(Colorscommon.greendark),
//                                                                                               ),
//                                                                                               // child: Text(
//                                                                                               //   "Reason",
//                                                                                               //   style: TextStyle(
//                                                                                               //       fontWeight: FontWeight.bold,
//                                                                                               //       color: HexColor(Colorscommon.greendark)),
//                                                                                               // ),
//                                                                                             )),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Visibility(
//                                                                                     visible: datearrylist[index2]["selectedCategory"].toString() != "Select Category",
//                                                                                     child: Visibility(
//                                                                                       visible: datearrylist[index2]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                       child: Visibility(
//                                                                                         visible: datearrylist[index2]["selectedSubCategory"].toString() == "Wrong Roster",
//                                                                                         child: Container(
//                                                                                           margin: const EdgeInsets.only(left: 0),
//                                                                                           child: Row(
//                                                                                             children: [
//                                                                                               // Expanded(
//                                                                                               //     flex: 1,
//                                                                                               //     child: Text(
//                                                                                               //       'Reason *',
//                                                                                               //       style: TextStyle(
//                                                                                               //           fontWeight: FontWeight.bold,
//                                                                                               //           color: HexColor(Colorscommon.greencolor)),
//                                                                                               //     )),
//                                                                                               Expanded(
//                                                                                                 flex: 2,
//                                                                                                 child: Container(
//                                                                                                   height: 40,
//                                                                                                   margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
//                                                                                                   padding: const EdgeInsets.all(3.0),
//                                                                                                   decoration: const ShapeDecoration(
//                                                                                                     shape: RoundedRectangleBorder(
//                                                                                                       side: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
//                                                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                                                     ),
//                                                                                                     color: Colors.white,
//                                                                                                   ),
//                                                                                                   child: Theme(
//                                                                                                     data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                                                     child: DropdownButtonHideUnderline(
//                                                                                                       child: DropdownButton(
//                                                                                                         hint: Row(children: [
//                                                                                                           Container(
//                                                                                                             width: 20,
//                                                                                                             height: 20,
//                                                                                                             decoration: const BoxDecoration(
//                                                                                                               image: DecorationImage(
//                                                                                                                 image: AssetImage("assets/Reason.png"),
//                                                                                                                 fit: BoxFit.fitHeight,
//                                                                                                               ),
//                                                                                                             ),
//                                                                                                           ),
//                                                                                                           const SizedBox(
//                                                                                                             width: 5,
//                                                                                                           ),
//                                                                                                           const Text("Select Roster")
//                                                                                                         ]),
//                                                                                                         //           \Avenirtextmedium(
//                                                                                                         //   customfontweight: FontWeight.normal,
//                                                                                                         //   fontsize: 14,
//                                                                                                         //   text: "Reason",
//                                                                                                         //   textcolor: HexColor(Colorscommon.greendark),
//                                                                                                         // ),
//
//                                                                                                         style: TextStyle(fontSize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
//                                                                                                         elevation: 0,
//                                                                                                         value: (datearrylist[index2]["selectedDrowdownValue"].toString() == "") ? "Select Roster" : datearrylist[index2]["selectedDrowdownValue"].toString(),
//                                                                                                         items: array5.map((items) {
//                                                                                                           return DropdownMenuItem(
//                                                                                                               value: items,
//                                                                                                               child: Row(
//                                                                                                                 children: [
//                                                                                                                   Container(
//                                                                                                                     width: 20,
//                                                                                                                     height: 20,
//                                                                                                                     decoration: const BoxDecoration(
//                                                                                                                       image: DecorationImage(
//                                                                                                                         image: AssetImage("assets/Reason.png"),
//                                                                                                                         fit: BoxFit.fitHeight,
//                                                                                                                       ),
//                                                                                                                     ),
//                                                                                                                   ),
//                                                                                                                   const SizedBox(
//                                                                                                                     width: 5,
//                                                                                                                   ),
//                                                                                                                   Text(
//                                                                                                                     items.toString(),
//                                                                                                                   ),
//                                                                                                                 ],
//                                                                                                               ));
//                                                                                                         }).toList(),
//
//                                                                                                         icon: Icon(
//                                                                                                           Icons.keyboard_arrow_down,
//                                                                                                           color: HexColor(Colorscommon.greenlight2),
//                                                                                                         ),
//                                                                                                         onChanged: (value) {
//                                                                                                           datearrylist[index2]["selectedDrowdownValue"] = value.toString();
//
//                                                                                                           for (var i = 0; array5.length > i; i++) {
//                                                                                                             serviceDayDetails[index]["selectedDrowdownValue"] = value.toString();
//                                                                                                             setState(() {});
//                                                                                                             // print(array5[i].toString());
//                                                                                                             // print("value$value");
//                                                                                                             if (array5[i].toString() == value.toString()) {
//                                                                                                               var datevalue = sfidarray5[i];
//                                                                                                               // print("sucessdatevalue");
//                                                                                                               setState(() {
//                                                                                                                 datearrylist[index2]["selectedDrowdownId"] = datevalue.toString();
//                                                                                                               });
//                                                                                                               break;
//                                                                                                             }
//                                                                                                           }
//                                                                                                           setState(() {});
//                                                                                                         },
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ],
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Visibility(
//                                                                                     visible: datearrylist[index2]["selectedCategory"].toString() != "Select Category",
//                                                                                     child: Visibility(
//                                                                                       visible: datearrylist[index2]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                       child: Visibility(
//                                                                                         visible: serviceDayDetails[index]["selectedCategory"].toString() != "Training Present",
//                                                                                         child: Visibility(
//                                                                                           visible: datearrylist[index2]["selectedSubCategory"].toString().toUpperCase() != "WEOS",
//                                                                                           child: Visibility(
//                                                                                             visible: serviceDayDetails[index]["name"] != "Late",
//                                                                                             child: Container(
//                                                                                                 margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
//                                                                                                 child: Align(
//                                                                                                   alignment: Alignment.centerLeft,
//                                                                                                   child: Avenirtextmedium(
//                                                                                                     customfontweight: FontWeight.w500,
//                                                                                                     fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14,
//                                                                                                     text: "No of Trip",
//                                                                                                     textcolor: HexColor(Colorscommon.greendark),
//                                                                                                   ),
//                                                                                                   // child: Text(
//                                                                                                   //   "Reason",
//                                                                                                   //   style: TextStyle(
//                                                                                                   //       fontWeight: FontWeight.bold,
//                                                                                                   //       color: HexColor(Colorscommon.greendark)),
//                                                                                                   // ),
//                                                                                                 )),
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Visibility(
//                                                                                     visible: datearrylist[index2]["selectedCategory"].toString() != "Select Category",
//                                                                                     child: Visibility(
//                                                                                       visible: datearrylist[index2]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                       child: Visibility(
//                                                                                         visible: serviceDayDetails[index]["selectedCategory"].toString() != "Training Present",
//                                                                                         child: Visibility(
//                                                                                           visible: datearrylist[index2]["selectedSubCategory"].toString().toUpperCase() != "WEOS",
//                                                                                           child: Visibility(
//                                                                                             visible: serviceDayDetails[index]["name"] != "Late",
//                                                                                             child: Container(
//                                                                                               margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
//                                                                                               // margin: const EdgeInsets.all(10.0),
//                                                                                               height: 30,
//                                                                                               child: Theme(
//                                                                                                 data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                                                 child: TextField(
//                                                                                                   controller: _controllers[index],
//                                                                                                   onChanged: (valuestr) {
//                                                                                                     // print("valuestr$valuestr");
//                                                                                                     serviceDayDetails[index]["noOftripperformed"] = valuestr;
//                                                                                                     datearrylist[index]["noOftripperformed"] = valuestr;
//                                                                                                   },
//                                                                                                   onSubmitted: (valuestr) {
//                                                                                                     // array[index]["selectedDropDownId"] =
//                                                                                                     //     valuestr;
//                                                                                                     _controllers[index].text = valuestr;
//                                                                                                     // array[index]["selectedDropDownId"] =
//                                                                                                     //     valuestr;
//
//                                                                                                     // print("valuestr$valuestr");
//                                                                                                     setState(() {});
//                                                                                                   },
//                                                                                                   maxLength: 5,
//                                                                                                   keyboardType: TextInputType.number,
//                                                                                                   style: TextStyle(fontSize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2), fontWeight: FontWeight.w500),
//                                                                                                   decoration: const InputDecoration(
//                                                                                                       hintText: 'No of Trips Performed',
//                                                                                                       // labelText: array[index]["selectedDropDownId"].toString(),
//                                                                                                       counterText: ""),
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   Visibility(
//                                                                                     // visible:
//                                                                                     //     true,
//                                                                                     visible: isNoGrievanceExist == "false",
//                                                                                     child: Visibility(
//                                                                                       visible: true,
//                                                                                       // visible:
//                                                                                       //     isWeeklyEarningAlreadyExist == "false",
//                                                                                       child: Visibility(
//                                                                                         visible: true,
//                                                                                         // visible: dropdownvaluetwo == "Grievance",
//                                                                                         child: Visibility(
//                                                                                           visible: datearrylist[index2]["selectedCategory"].toString() != "Select Category",
//                                                                                           child: Visibility(
//                                                                                             // visible: true,
//                                                                                             visible: serviceDayDetails[index]["name"].toString().toUpperCase() == "Bench".toUpperCase(),
//                                                                                             child: Visibility(
//                                                                                               visible: datearrylist[index2]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                               child: Visibility(
//                                                                                                 visible: datearrylist[index2]["selectedSubCategory"] != "No Trip Sheet",
//                                                                                                 child: Row(
//                                                                                                   mainAxisAlignment: MainAxisAlignment.start,
//                                                                                                   children: [
//                                                                                                     Expanded(
//                                                                                                       flex: 1,
//                                                                                                       child: Container(
//                                                                                                           margin: const EdgeInsets.only(top: 5, right: 10, left: 20),
//                                                                                                           child: Align(
//                                                                                                               alignment: Alignment.centerLeft,
//                                                                                                               child: Avenirtextmedium(
//                                                                                                                 customfontweight: FontWeight.w500,
//                                                                                                                 fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 15,
//                                                                                                                 text: 'Upload Attachments',
//                                                                                                                 textcolor: HexColor(Colorscommon.greendark),
//                                                                                                               )
//                                                                                                             // child: Text(
//                                                                                                             //   "Upload Attachments",
//                                                                                                             //   style: TextStyle(
//                                                                                                             //       fontWeight: FontWeight.w400,
//                                                                                                             //       color: HexColor(Colorscommon.greendark2)),
//                                                                                                             // ),
//                                                                                                           )),
//                                                                                                     ),
//                                                                                                     Expanded(
//                                                                                                       flex: 1,
//                                                                                                       child: Row(
//                                                                                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                                                                         children: [
//                                                                                                           Bouncing(
//                                                                                                             onPress: () {
//                                                                                                               FocusManager.instance.primaryFocus?.unfocus();
//                                                                                                               _showPicker(context);
//                                                                                                               setState;
//                                                                                                             },
//                                                                                                             child: Container(
//                                                                                                               margin: const EdgeInsets.only(top: 10, right: 0, left: 10),
//                                                                                                               child: Align(
//                                                                                                                 alignment: Alignment.centerLeft,
//                                                                                                                 child: Container(
//                                                                                                                   width: MediaQuery.of(context).size.width / 3,
//                                                                                                                   height: 40,
//                                                                                                                   decoration: ShapeDecoration(
//                                                                                                                     shape: RoundedRectangleBorder(
//                                                                                                                       side: BorderSide(
//                                                                                                                         width: 0.0,
//                                                                                                                         style: BorderStyle.solid,
//                                                                                                                         color: HexColor(Colorscommon.greenlight2),
//                                                                                                                       ),
//                                                                                                                       borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                                                                                                                     ),
//                                                                                                                   ),
//                                                                                                                   child: Row(
//                                                                                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                                                                                     // ignore: prefer_const_literals_to_create_immutables
//                                                                                                                     children: [
//                                                                                                                       const SizedBox(
//                                                                                                                         width: 10,
//                                                                                                                       ),
//                                                                                                                       Container(
//                                                                                                                         width: 20,
//                                                                                                                         height: 20,
//                                                                                                                         decoration: const BoxDecoration(
//                                                                                                                           image: DecorationImage(
//                                                                                                                             image: AssetImage("assets/Upload.png"),
//                                                                                                                             fit: BoxFit.fitHeight,
//                                                                                                                           ),
//                                                                                                                         ),
//                                                                                                                       ),
//                                                                                                                       Expanded(
//                                                                                                                           flex: 1,
//                                                                                                                           child: Avenirtextmedium(
//                                                                                                                             customfontweight: FontWeight.w500,
//                                                                                                                             fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 15,
//                                                                                                                             text: imgname != '' ? ' File Attached' : ' Upload files',
//                                                                                                                             textcolor: HexColor(Colorscommon.greydark2),
//                                                                                                                           )
//                                                                                                                         // child: Text(
//                                                                                                                         //   imgname != ''
//                                                                                                                         //       ? ' File Attached'
//                                                                                                                         //       : ' Upload files',
//                                                                                                                         //   style: TextStyle(
//                                                                                                                         //       color: HexColor(
//                                                                                                                         //           Colorscommon.greydark2),
//                                                                                                                         //       fontFamily: "TomaSans-Regular"),
//                                                                                                                         // ),
//                                                                                                                       ),
//                                                                                                                     ],
//                                                                                                                   ),
//                                                                                                                 ),
//                                                                                                               ),
//                                                                                                             ),
//                                                                                                           ),
//                                                                                                           Visibility(
//                                                                                                             visible: imgname != '',
//                                                                                                             child: Padding(
//                                                                                                               padding: const EdgeInsets.only(top: 6.0),
//                                                                                                               child: IconButton(
//                                                                                                                 icon: const Icon(Icons.delete_forever),
//                                                                                                                 color: Colors.red,
//                                                                                                                 onPressed: () {
//                                                                                                                   setState(() {
//                                                                                                                     imgname = '';
//                                                                                                                     imagebool = false;
//                                                                                                                   });
//                                                                                                                 },
//                                                                                                               ),
//                                                                                                             ),
//                                                                                                           )
//                                                                                                         ],
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                   ],
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//
//                                                                                   //  //     true,
//                                                                                   //                                                                           visible:
//                                                                                   //                                                                               isNoGrievanceExist == "false",
//                                                                                   //                                                                           child:
//                                                                                   //                                                                               Visibility(
//                                                                                   //                                                                             visible: true,
//                                                                                   //                                                                             // visible:
//                                                                                   //                                                                             //     isWeeklyEarningAlreadyExist == "false",
//                                                                                   //                                                                             child: Visibility(
//                                                                                   //                                                                               visible: true,
//                                                                                   //                                                                               // visible: dropdownvaluetwo == "Grievance",
//                                                                                   //                                                                               child: Visibility(
//                                                                                   //                                                                                 // visible: true,
//                                                                                   //                                                                                 visible: serviceDayDetails[index]["name"].toString().toUpperCase() == "Bench".toUpperCase(),
//                                                                                   //                                                                                 child: Visibility(
//                                                                                   //                                                                                   visible: datearrylist[index2]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                   //                                                                                   child: Visibility(
//                                                                                   //                                                                                     visible: datearrylist[index2]["selectedSubCategory"] != "No Trip Sheet",
//
//                                                                                   Visibility(
//                                                                                     visible: datearrylist[index2]["selectedCategory"].toString() != "Select Category",
//                                                                                     child: Visibility(
//                                                                                       visible: datearrylist[index2]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                       child: Visibility(
//                                                                                         visible: true,
//                                                                                         child: Visibility(
//                                                                                           visible: true,
//                                                                                           // visible: _controllers[index].text != '',
//                                                                                           child: Visibility(
//                                                                                             visible: true,
//                                                                                             child: Bouncing(
//                                                                                               onPress: () async {
//                                                                                                 if (serviceDayDetails[index]["name"] == "Bench" || serviceDayDetails[index]["name"] == "EOS" || serviceDayDetails[index]["name"] == "UEOS" || serviceDayDetails[index]["name"] == "WEOS") {
//                                                                                                   if (serviceDayDetails[index]["selectedCategory"].toString() == "Training Present") {
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedCategoryId'] = datearrylist[index2]["selectedCategoryId"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedSubCategoryId'] = datearrylist[index2]["selectedSubCategoryId"].toString();
//
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownId'] = datearrylist[index2]["selectedDrowdownId"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownValue'] = datearrylist[index2]["selectedDrowdownValue"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['statusValue'] = 'Grievance';
//                                                                                                     serviceDayDetails[index]['statusValue'] = 'Grievance';
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['benchFileName'] = benchFileName;
//                                                                                                     Navigator.pop(context);
//                                                                                                   } else if (_controllers[index].text == "" || _controllers[index].text == "0") {
//                                                                                                     if (datearrylist[index2]["selectedSubCategory"].toString().toUpperCase() == "WEOS") {
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedCategoryId'] = datearrylist[index2]["selectedCategoryId"].toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedSubCategoryId'] = datearrylist[index2]["selectedSubCategoryId"].toString();
//
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownId'] = datearrylist[index2]["selectedDrowdownId"].toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownValue'] = datearrylist[index2]["selectedDrowdownValue"].toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['statusValue'] = 'Grievance';
//                                                                                                       serviceDayDetails[index]['statusValue'] = 'Grievance';
//                                                                                                       Navigator.pop(context);
//                                                                                                     } else {
//                                                                                                       Fluttertoast.showToast(
//                                                                                                         msg: AppLocalizations.of(context)!.entervaildtrip,
//                                                                                                         toastLength: Toast.LENGTH_SHORT,
//                                                                                                         gravity: ToastGravity.CENTER,
//                                                                                                       );
//                                                                                                     }
//
//                                                                                                     // print('validate date in flutter');
//                                                                                                   } else if (serviceDayDetails[index]["name"] == "Bench") {
//                                                                                                     if (datearrylist[index2]["selectedSubCategory"].toString() != "No Trip Sheet") {
//                                                                                                       if (imgname == "") {
//                                                                                                         Fluttertoast.showToast(
//                                                                                                           msg: "Please Upload " + serviceDayDetails[index]["name"].toString() + " File",
//                                                                                                           toastLength: Toast.LENGTH_SHORT,
//                                                                                                           gravity: ToastGravity.CENTER,
//                                                                                                         );
//                                                                                                       } else {
//                                                                                                         serviceDayDetails[index]["dateArray"][index2]['selectedCategoryId'] = datearrylist[index2]["selectedCategoryId"].toString();
//                                                                                                         serviceDayDetails[index]["dateArray"][index2]['selectedSubCategoryId'] = datearrylist[index2]["selectedSubCategoryId"].toString();
//
//                                                                                                         serviceDayDetails[index]["dateArray"][index2]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                                         serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownId'] = datearrylist[index2]["selectedDrowdownId"].toString();
//                                                                                                         serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownValue'] = datearrylist[index2]["selectedDrowdownValue"].toString();
//                                                                                                         serviceDayDetails[index]["dateArray"][index2]['statusValue'] = 'Grievance';
//                                                                                                         serviceDayDetails[index]['statusValue'] = 'Grievance';
//                                                                                                         serviceDayDetails[index]["dateArray"][index2]['benchFileName'] = benchFileName;
//                                                                                                         Navigator.pop(context);
//                                                                                                       }
//                                                                                                     } else {
//                                                                                                       // print('validate date2345 in flutter');
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedCategoryId'] = datearrylist[index2]["selectedCategoryId"].toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedSubCategoryId'] = datearrylist[index2]["selectedSubCategoryId"].toString();
//
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownId'] = datearrylist[index2]["selectedDrowdownId"].toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownValue'] = datearrylist[index2]["selectedDrowdownValue"].toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['statusValue'] = 'Grievance';
//                                                                                                       serviceDayDetails[index]['statusValue'] = 'Grievance';
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['benchFileName'] = benchFileName;
//                                                                                                       Navigator.pop(context);
//                                                                                                     }
//                                                                                                   } else {
//                                                                                                     // print('validate date2345 in flutter');
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedCategoryId'] = datearrylist[index2]["selectedCategoryId"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedSubCategoryId'] = datearrylist[index2]["selectedSubCategoryId"].toString();
//
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownId'] = datearrylist[index2]["selectedDrowdownId"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownValue'] = datearrylist[index2]["selectedDrowdownValue"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['statusValue'] = 'Grievance';
//                                                                                                     serviceDayDetails[index]['statusValue'] = 'Grievance';
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['benchFileName'] = benchFileName;
//                                                                                                     Navigator.pop(context);
//                                                                                                   }
//                                                                                                 } else if (serviceDayDetails[index]["name"] == "Late") {
//                                                                                                   if (datearrylist[index2]["selectedSubCategory"].toString() == "Adhoc Duty") {
//                                                                                                     // print('validate date2345 in flutter');
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedCategoryId'] = datearrylist[index2]["selectedCategoryId"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedSubCategoryId'] = datearrylist[index2]["selectedSubCategoryId"].toString();
//
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownId'] = datearrylist[index2]["selectedDrowdownId"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownValue'] = datearrylist[index2]["selectedDrowdownValue"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['statusValue'] = 'Grievance';
//                                                                                                     serviceDayDetails[index]['statusValue'] = 'Grievance';
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['benchFileName'] = benchFileName;
//                                                                                                     Navigator.pop(context);
//                                                                                                   } else if (datearrylist[index2]["selectedSubCategory"] == "Wrong Roster") {
//                                                                                                     print(datearrylist[index2]["selectedDrowdownValue"]);
//                                                                                                     if (datearrylist[index2]["selectedDrowdownValue"] == "Select Roster" || datearrylist[index2]["selectedDrowdownValue"] == "") {
//                                                                                                       Fluttertoast.showToast(
//                                                                                                         msg: AppLocalizations.of(context)!.pleaseslectroster,
//                                                                                                         toastLength: Toast.LENGTH_SHORT,
//                                                                                                         gravity: ToastGravity.CENTER,
//                                                                                                       );
//                                                                                                       // print('validate date2345 in flutter');
//
//                                                                                                     } else {
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedCategoryId'] = datearrylist[index2]["selectedCategoryId"].toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedSubCategoryId'] = datearrylist[index2]["selectedSubCategoryId"].toString();
//
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownId'] = datearrylist[index2]["selectedDrowdownId"].toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownValue'] = datearrylist[index2]["selectedDrowdownValue"].toString();
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['statusValue'] = 'Grievance';
//                                                                                                       serviceDayDetails[index]['statusValue'] = 'Grievance';
//                                                                                                       serviceDayDetails[index]["dateArray"][index2]['benchFileName'] = benchFileName;
//                                                                                                       Navigator.pop(context);
//                                                                                                     }
//                                                                                                   } else {
//                                                                                                     // print('validate date2345 in flutter');
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedCategoryId'] = datearrylist[index2]["selectedCategoryId"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedSubCategoryId'] = datearrylist[index2]["selectedSubCategoryId"].toString();
//
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownId'] = datearrylist[index2]["selectedDrowdownId"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['selectedDrowdownValue'] = datearrylist[index2]["selectedDrowdownValue"].toString();
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['statusValue'] = 'Grievance';
//                                                                                                     serviceDayDetails[index]['statusValue'] = 'Grievance';
//                                                                                                     serviceDayDetails[index]["dateArray"][index2]['benchFileName'] = benchFileName;
//                                                                                                     Navigator.pop(context);
//                                                                                                   }
//                                                                                                 }
//                                                                                                 // } else {
//                                                                                                 //   // print('$serviceDayDetails[$index]["name"]');
//                                                                                                 // }
//                                                                                                 //        visible: serviceDayDetails[index]["name"].toString().toUpperCase() == "Bench".toUpperCase(),
//                                                                                                 // child: Visibility(
//                                                                                                 //   visible: datearrylist[index2]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                                 //   child: Visibility(
//                                                                                                 // visible: datearrylist[index2]["selectedSubCategory"] != "No Trip Sheet",
//                                                                                                 //     child: Row(
//
//                                                                                                 // serviceDayDetails[index]["dateArray"][index2]
//                                                                                                 //     [
//                                                                                                 //     'selectedCategoryId'] = datearrylist[index2]
//                                                                                                 //         ["selectedCategoryId"]
//                                                                                                 //     .toString();
//                                                                                                 // serviceDayDetails[index]["dateArray"][index2]
//                                                                                                 //     [
//                                                                                                 //     'selectedCategoryId'] = datearrylist[index2]
//                                                                                                 //         ["selectedCategoryId"]
//                                                                                                 //     .toString();
//                                                                                                 //     .toString()
//                                                                                                 // print(datearrylist[index2]["selectedCategoryId"]
//                                                                                                 //     .toString());
//                                                                                                 // print(datearrylist[index2]["selectedSubCategoryId"]
//                                                                                                 //     .toString());
//                                                                                                 // datearrylist[index2]
//                                                                                                 //     [
//                                                                                                 //     "noOftripperformed"] = _controllers[
//                                                                                                 //         index]
//                                                                                                 //     .text;
//                                                                                                 // print(datearrylist[index2]
//                                                                                                 //     [
//                                                                                                 //     "noOftripperformed"]);
//                                                                                                 // print(datearrylist[index2]
//                                                                                                 //     [
//                                                                                                 //     "selectedDrowdownId"]);
//                                                                                                 // print(datearrylist[index2]
//                                                                                                 //     [
//                                                                                                 //     "selectedDrowdownValue"]);
//
//                                                                                                 // Raise_no_griveanceapi(
//                                                                                                 //     context);
//                                                                                               },
//                                                                                               child: Container(
//                                                                                                 margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
//                                                                                                 height: 40,
//                                                                                                 // width:
//                                                                                                 //     80,
//                                                                                                 decoration: BoxDecoration(
//                                                                                                     borderRadius: BorderRadius.circular(5),
//                                                                                                     gradient: LinearGradient(colors: [
//                                                                                                       HexColor(Colorscommon.greencolor),
//                                                                                                       HexColor(Colorscommon.greencolor),
//                                                                                                     ])),
//                                                                                                 child: Center(
//                                                                                                   child: Avenirtextblack(
//                                                                                                     customfontweight: FontWeight.normal,
//                                                                                                     fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14,
//                                                                                                     text: AppLocalizations.of(context)!.submit,
//                                                                                                     textcolor: Colors.white,
//                                                                                                   ),
//                                                                                                   //     child: Text(
//                                                                                                   //   "Submit",
//                                                                                                   //   style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
//                                                                                                   // )
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ),
//                                                                                           ),
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                   const SizedBox(
//                                                                                     height: 10,
//                                                                                   )
//                                                                                 ]),
//                                                                               ),
//                                                                               // actions: <
//                                                                               //     Widget>[
//
//                                                                               //   // IconButton(
//                                                                               //   //     icon: const Icon(Icons
//                                                                               //   //         .close),
//                                                                               //   //     onPressed:
//                                                                               //   //         () {
//                                                                               //   //       Navigator.pop(
//                                                                               //   //           context);
//                                                                               //   //     })
//                                                                               // ],
//                                                                             );
//                                                                           },
//                                                                         );
//                                                                       },
//                                                                     );
//                                                                   }
//                                                                 }
//                                                                 // if (isNoGrievanceExist ==
//                                                                 //             'false' ){}
//                                                                 //             else
//
//                                                               }
//                                                             }
//                                                           } else {}
//                                                         },
//                                                         child: Row(
//                                                           children: [
//                                                             Text(
//                                                               datearrylist[
//                                                               index2]
//                                                               ['name']
//                                                                   .toString(),
//                                                               style: TextStyle(
//                                                                   color: HexColor(
//                                                                       Colorscommon
//                                                                           .greydark2),
//                                                                   fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "आयडी" ||
//                                                                       AppLocalizations.of(context)!.id ==
//                                                                           "ಐಡಿ")
//                                                                       ? 12
//                                                                       : 14,
//                                                                   fontFamily:
//                                                                   'Avenir LT Std 65 Medium',
//                                                                   fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                             ),
//                                                             const SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             Visibility(
//                                                               visible:
//                                                               isgrivanceshowbyweek ==
//                                                                   "true",
//                                                               child: Visibility(
//                                                                 visible:
//                                                                 isNoGrievanceExist ==
//                                                                     "false",
//                                                                 child:
//                                                                 Visibility(
//                                                                   visible:
//                                                                   isGrievence ==
//                                                                       "true",
//                                                                   child:
//                                                                   Visibility(
//                                                                     visible:
//                                                                     isNoGrievanceExist ==
//                                                                         'false',
//                                                                     child:
//                                                                     Visibility(
//                                                                       visible: datearrylist[index2]['isGrievanceAlreadyExist']
//                                                                           .toString() ==
//                                                                           "false",
//                                                                       child:
//                                                                       const Icon(
//                                                                         Icons
//                                                                             .warning,
//                                                                         size:
//                                                                         15,
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   }),
//
//                                             )
//
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         }),
//                     replacement: Visibility(
//                         visible: listloadstatus == true,
//                         child: Center(
//                           child: SizedBox(
//                             width: 40,
//                             height: 40,
//                             child: CircularProgressIndicator(
//                               color: HexColor(Colorscommon.greencolor),
//                             ),
//                           ),
//                         )),
//                   ),
//                   Visibility(
//                     visible: dropdownvalue2 != null,
//                     child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: SizedBox(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: Avenirtextblack(
//                                     customfontweight: FontWeight.w500,
//                                     fontsize: (AppLocalizations.of(context)!
//                                         .id ==
//                                         "ஐடி" ||
//                                         AppLocalizations.of(context)!.id ==
//                                             "आयडी" ||
//                                         AppLocalizations
//                                             .of(context)!
//                                             .id ==
//                                             "ಐಡಿ")
//                                         ? 12
//                                         : 15,
//                                     text: AppLocalizations.of(context)!
//                                         .additionsdeletions,
//                                     textcolor:
//                                     HexColor(Colorscommon.greenAppcolor))
//                               // child: Text(
//                               //   ' Additions/Deletions',
//                               //   style: TextStyle(
//                               //       color: HexColor(Colorscommon.greencolor),
//                               //       fontWeight: FontWeight.bold),
//                               //   textAlign: TextAlign.start,
//                               // ),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             const Expanded(
//                                 flex: 1,
//                                 child: Text("            ")), //utility.Todaystr
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Visibility(
//                     visible: dropdownvalue2 != null,
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: additionDeletionData.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           var columnname =
//                           additionDeletionData[index]['name'].toString();
//                           print("columnname$columnname");
//                           if (columnname == "Extra Hours") {
//                             columnname =
//                                 AppLocalizations.of(context)!.extra_Hours;
//                           } else if (columnname == "Debit Data") {
//                             columnname =
//                                 AppLocalizations.of(context)!.debitdata;
//                           }
//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(10),
//                                 child: ExpansionTile(
//                                   title: Text(
//                                     columnname.toString(),
//                                     textAlign: TextAlign.start,
//                                     style: TextStyle(
//                                         color: HexColor(
//                                             Colorscommon.greenAppcolor),
//                                         fontSize: (AppLocalizations.of(context)!
//                                             .id ==
//                                             "ஐடி" ||
//                                             AppLocalizations.of(context)!
//                                                 .id ==
//                                                 "आयडी" ||
//                                             AppLocalizations.of(context)!
//                                                 .id ==
//                                                 "ಐಡಿ")
//                                             ? 12
//                                             : 14,
//                                         fontFamily: 'Avenir LT Std 65 Medium',
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                   children: [
//                                     Visibility(
//                                         visible: additionDeletionData[index]
//                                         ['data']
//                                             .length ==
//                                             0,
//                                         child: const SizedBox(
//                                             height: 30,
//                                             child: Text("No Data Available"))),
//                                     Card(
//                                       elevation: 5,
//                                       child: Column(
//                                         children: [
//                                           Visibility(
//                                             visible: additionDeletionData[index]
//                                             ['data']
//                                                 .length >
//                                                 0,
//                                             child: Container(
//                                               margin: const EdgeInsets.only(
//                                                   right: 10,
//                                                   left: 10,
//                                                   bottom: 10,
//                                                   top: 10),
//                                               child: Row(children: const [
//                                                 Expanded(
//                                                     flex: 2,
//                                                     child: Text(
//                                                       "Name",
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                           FontWeight.w500),
//                                                     )),
//                                                 Expanded(
//                                                     flex: 2,
//                                                     child: Text(
//                                                       "Invoice Type",
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                           FontWeight.w500),
//                                                     )),
//                                                 Expanded(
//                                                   flex: 1,
//                                                   child: Text(
//                                                     "Amount",
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                         FontWeight.w500),
//                                                     textAlign: TextAlign.right,
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   flex: 1,
//                                                   child: Text(
//                                                     "",
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                         FontWeight.w500),
//                                                     textAlign: TextAlign.right,
//                                                   ),
//                                                 ),
//                                               ]),
//                                             ),
//                                           ),
//                                           ListView.builder(
//                                               shrinkWrap: true,
//                                               physics:
//                                               const BouncingScrollPhysics(),
//                                               itemCount:
//                                               additionDeletionData[index]
//                                               ['data']
//                                                   .length,
//                                               itemBuilder:
//                                                   (BuildContext context,
//                                                   int index2) {
//                                                 return Container(
//                                                   margin: const EdgeInsets.only(
//                                                       right: 10,
//                                                       left: 10,
//                                                       bottom: 10,
//                                                       top: 10),
//                                                   child: Row(children: [
//                                                     Expanded(
//                                                         flex: 2,
//                                                         child: Text(
//                                                             additionDeletionData[
//                                                             index]
//                                                             ['data']
//                                                             [
//                                                             index2]['name']
//                                                                 .toString())),
//                                                     Expanded(
//                                                         flex: 2,
//                                                         child: Text(" " +
//                                                             additionDeletionData[index]
//                                                             [
//                                                             'data']
//                                                             [index2]
//                                                             [
//                                                             'invoice_type']
//                                                                 .toString())),
//                                                     Expanded(
//                                                         flex: 1,
//                                                         child: Text(
//                                                           (additionDeletionData[index]
//                                                           [
//                                                           'data']
//                                                           [
//                                                           index2]
//                                                           [
//                                                           'invoice_amount'] !=
//                                                               null
//                                                               ? additionDeletionData[index]
//                                                           [
//                                                           'data']
//                                                           [
//                                                           index2]
//                                                           [
//                                                           'invoice_amount']
//                                                               .toString()
//                                                               : '-'),
//                                                           textAlign:
//                                                           TextAlign.center,
//                                                         )),
//                                                     Expanded(
//                                                         flex: 1,
//                                                         child: Bouncing(
//                                                           onPress: () {
//                                                             if (isgrivanceshowbyweek ==
//                                                                 "true" &&
//                                                                 additionDeletionData[index]['data']
//                                                                 [index2]
//                                                                 [
//                                                                 'alreadyRise']
//                                                                     .toString() ==
//                                                                     "false" &&
//                                                                 isWeeklyEarningAlreadyExist ==
//                                                                     "false" &&
//                                                                 isNoGrievanceExist ==
//                                                                     "false") {
//                                                               contacthr(
//                                                                   additionDeletionData[index]['data']
//                                                                   [
//                                                                   index2]
//                                                                   [
//                                                                   'voucher__c']
//                                                                       .toString(),
//                                                                   additionDeletionData[index]
//                                                                   [
//                                                                   'data'][index2]
//                                                                   [
//                                                                   'voucher_item_date__c']
//                                                                       .toString(),
//                                                                   additionDeletionData[
//                                                                   index]
//                                                                   [
//                                                                   'name']
//                                                                       .toString(),
//                                                                   index,
//                                                                   index2);
//                                                               // if (additionDeletionData[index]['data']
//                                                               //                 [
//                                                               //                 index2]
//                                                               //             [
//                                                               //             'alreadyRise']
//                                                               //         .toString() ==
//                                                               //     "false") {
//
//                                                               //   }
//                                                             } else {}
//
//                                                             // print(
//                                                             //     isgrivanceshowbyweek);
//                                                             // print(additionDeletionData[index]
//                                                             //                 [
//                                                             //                 'data']
//                                                             //             [index2]
//                                                             //         [
//                                                             //         'alreadyRise']
//                                                             //     .toString());
//                                                           },
//                                                           child: IconButton(
//                                                               onPressed: () {},
//                                                               icon: Icon(
//                                                                 Icons
//                                                                     .back_hand_rounded,
//                                                                 color: isgrivanceshowbyweek == "true" &&
//                                                                     additionDeletionData[index]['data'][index2]['alreadyRise'].toString() ==
//                                                                         "false" &&
//                                                                     isWeeklyEarningAlreadyExist ==
//                                                                         "false" &&
//                                                                     isNoGrievanceExist ==
//                                                                         "false"
//                                                                     ? HexColor(
//                                                                     Colorscommon
//                                                                         .greencolor)
//                                                                     : HexColor(
//                                                                     Colorscommon
//                                                                         .grey_low),
//                                                               )),
//                                                         )),
//                                                   ]),
//                                                 );
//                                               }),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         }),
//                   ),
//                   Visibility(
//                     visible: dropdownvalue2 != null,
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: totalEarningArray.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(10),
//                                 child: ExpansionTile(
//                                   title: Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 1,
//                                         child: Text(
//                                           AppLocalizations.of(context)!
//                                               .todayEarnings,
//                                           textAlign: TextAlign.start,
//                                           style: TextStyle(
//                                               fontSize:
//                                               (AppLocalizations.of(context)!
//                                                   .id ==
//                                                   "ஐடி" ||
//                                                   AppLocalizations.of(
//                                                       context)!
//                                                       .id ==
//                                                       "आयडी" ||
//                                                   AppLocalizations.of(
//                                                       context)!
//                                                       .id ==
//                                                       "ಐಡಿ")
//                                                   ? 12
//                                                   : 14,
//                                               fontWeight: FontWeight.w500,
//                                               fontFamily:
//                                               "Avenir LT Std 65 Medium",
//                                               color: HexColor(
//                                                   Colorscommon.greenAppcolor)),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 1,
//                                         child: Text(
//                                           totalEarningArray[index]['amount']
//                                               .toString(),
//                                           textAlign: TextAlign.end,
//                                           style: TextStyle(
//                                               color: (totalEarningArray[index]
//                                               ['amount'] >
//                                                   0)
//                                                   ? HexColor(
//                                                   Colorscommon.greencolor)
//                                                   : HexColor(
//                                                   Colorscommon.redcolor),
//                                               fontSize:
//                                               (AppLocalizations.of(context)!
//                                                   .id ==
//                                                   "ஐடி" ||
//                                                   AppLocalizations.of(
//                                                       context)!
//                                                       .id ==
//                                                       "आयडी" ||
//                                                   AppLocalizations.of(
//                                                       context)!
//                                                       .id ==
//                                                       "ಐಡಿ")
//                                                   ? 12
//                                                   : 14,
//                                               fontWeight: FontWeight.w500),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   children: const [
//
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           );
//                         }),
//                   ),
//                   Visibility(
//                     visible: dropdownvalue2 != null,
//                     child: Visibility(
//                       visible: isNoGrievanceExist == "false",
//                       child: Visibility(
//                         visible: isWeeklyEarningAlreadyExist == "false",
//                         child: Visibility(
//                           visible: isgrivanceshowbyweek == "true",
//                           child: Bouncing(
//                             onPress: () {
//                               bool closestatus = true;
//                               bool noGrivence = true;
//                               sessionManager
//                                   .internetcheck()
//                                   .then((intenet) async {
//                                 if (intenet) {
//                                   for (int i = 0;
//                                   i < serviceDayDetails.length;
//                                   i++) {
//                                     print(serviceDayDetails[i]["statusValue"]
//                                         .toString());
//
//                                     if (serviceDayDetails[i]["statusValue"]
//                                         .toString() ==
//                                         "Grievance") {
//                                       noGrivence = false;
//                                       if (i == serviceDayDetails.length - 1) {
//                                         print("last index for delay");
//
//                                         utility.showYourpopupinternetstatus(
//                                             context);
//                                         WekklyearningSubmit();
//                                         //  }
//                                       }
//
//                                     } else {
//                                       // print(serviceDayDetails.length);
//                                       if (i == serviceDayDetails.length - 1) {
//                                         print("last index for delay");
//                                         // print("last index for delay bv");
//                                         // if (apicalling) {
//                                         //   apicalling = false;
//                                         //   setState(() {});
//                                         if (closestatus) {
//                                           if (noGrivence) {
//                                             // print("nogrivance selected");
//                                             utility.showYourpopupinternetstatus(
//                                                 context);
//                                             Raisenogriveance_func();
//                                           } else {
//                                             utility.showYourpopupinternetstatus(
//                                                 context);
//                                             WekklyearningSubmit();
//                                           }
//                                           // if (onegrivencesstatus = false) {
//
//                                           // } else {
//                                           //   Fluttertoast.showToast(
//                                           //     msg:
//                                           //         "Please select atleast one grievance",
//                                           //     toastLength: Toast.LENGTH_SHORT,
//                                           //     gravity: ToastGravity.CENTER,
//                                           //   );
//                                           // }
//                                         }
//                                         break;
//                                         // }
//                                       }
//                                     }
//                                   }
//                                   // checkupdate(_30minstr);,
//                                   // loading();
//                                   // Loginapi(serveruuid, serverstate);
//                                 } else {
//                                   showTopSnackBar(
//                                     context,
//                                     const CustomSnackBar.error(
//                                       // icon: Icon(Icons.interests),
//                                       message:
//                                       "Please Check Your Internet Connection",
//                                       // backgroundColor: Colors.white,
//                                       // textStyle: TextStyle(color: Colors.red),
//                                     ),
//                                   );
//                                 }
//                               });
//
//                               // }
//                             },
//                             child: Container(
//                               margin:
//                               const EdgeInsets.only(top: 20, bottom: 10),
//                               width: 200,
//                               height: 40,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: HexColor(Colorscommon.greenlight2),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5)),
//                                 ),
//                                 // RaisedButton(
//                                 // color: HexColor(Colorscommon.greenlight2),
//                                 // shape: RoundedRectangleBorder(
//                                 //     borderRadius: BorderRadius.circular(5)),
//                                 child: Avenirtextblack(
//                                   customfontweight: FontWeight.normal,
//                                   fontsize: (AppLocalizations.of(context)!.id ==
//                                       "ஐடி" ||
//                                       AppLocalizations.of(context)!.id ==
//                                           "आयडी" ||
//                                       AppLocalizations.of(context)!.id ==
//                                           "ಐಡಿ")
//                                       ? 12
//                                       : 14,
//                                   text: AppLocalizations.of(context)!.submit,
//                                   textcolor: Colors.white,
//                                 ),
//                                 onPressed: () {},
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void contacthr(String voucher, String voucherdate, String typename,
//       int indexvalue, int indexvalue2) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             insetPadding: const EdgeInsets.all(10),
//             contentPadding: EdgeInsets.zero,
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             titlePadding: EdgeInsets.zero,
//             title: Container(
//               height: 50,
//               color: HexColor(Colorscommon.greencolor),
//               child: Center(
//                 child: Text(
//                   "Raise Grievance",
//                   style: TextStyle(
//                       fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                           AppLocalizations.of(context)!.id == "आयडी" ||
//                           AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                           AppLocalizations.of(context)!.id == "ಐಡಿ")
//                           ? 15
//                           : 17,
//                       fontFamily: "Lato",
//                       fontWeight: FontWeight.bold,
//                       color: HexColor(Colorscommon.whitecolor)),
//                   textAlign: TextAlign.start,
//                 ),
//               ),
//             ),
//             titleTextStyle: TextStyle(color: Colors.grey[700]),
//             // titlePadding: const EdgeInsets.only(left: 5, top: 5),
//             content: Container(
//               width: MediaQuery.of(context).size.width,
//               margin: const EdgeInsets.only(top: 5),
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                     top: 20, bottom: 10, left: 10, right: 10),
//                 child: Text(
//                   "Do you want to raise grievance?",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'TomaSans-Regular',
//                     fontSize: 18,
//                     color: HexColor(Colorscommon.greycolor),
//                   ),
//                 ),
//               ),
//             ),
//             actions: <Widget>[
//               Bouncing(
//                 onPress: () {
//                   raisegrivenseforaddtiondeletion(context, voucher, voucherdate,
//                       typename, indexvalue, indexvalue2);
//                   // Navigator.of(context).pop();
//                   // Navigator.of(context, rootNavigator: true).pop();
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
//                   height: 30,
//                   width: 80,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       gradient: LinearGradient(colors: [
//                         HexColor(Colorscommon.greencolor),
//                         HexColor(Colorscommon.greencolor),
//                       ])),
//                   child: Center(
//                     child: Avenirtextblack(
//                         text: AppLocalizations.of(context)!.yes,
//                         fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                             AppLocalizations.of(context)!.id == "आयडी" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ")
//                             ? 12
//                             : 13,
//                         textcolor: Colors.white,
//                         customfontweight: FontWeight.w500),
//                     //     child: Text(
//                     //   "Yes",
//                     //   style: TextStyle(
//                     //       color: Colors.white,
//                     //       fontFamily: 'Montserrat',
//                     //       fontWeight: FontWeight.bold),
//                     // )
//                   ),
//                 ),
//               ),
//               Bouncing(
//                 onPress: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
//                   height: 30,
//                   width: 80,
//                   decoration: BoxDecoration(
//                       border:
//                       Border.all(color: HexColor(Colorscommon.greencolor)),
//                       borderRadius: BorderRadius.circular(5),
//                       gradient: const LinearGradient(colors: [
//                         Colors.white,
//                         Colors.white
//                         // HexColor(Colorscommon.greencolor),
//                         // HexColor(Colorscommon.greencolor),
//                       ])),
//                   child: Center(
//                     child: Avenirtextblack(
//                         text: AppLocalizations.of(context)!.no,
//                         fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
//                             AppLocalizations.of(context)!.id == "आयडी" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                             AppLocalizations.of(context)!.id == "ಐಡಿ")
//                             ? 12
//                             : 13,
//                         textcolor: HexColor(Colorscommon.greencolor),
//                         customfontweight: FontWeight.w500),
//                     //     child: Text(
//                     //   "No",
//                     //   style: TextStyle(
//                     //       color: HexColor(Colorscommon.greencolor),
//                     //       fontFamily: 'Montserrat',
//                     //       fontWeight: FontWeight.bold),
//                     // )
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   }
//
//   getSubCategoryByCategory(String title, String categoryC) async {
//     var url = Uri.parse(CommonURL.herokuurl);
//     // print("categoryC$categoryC");
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "getSubCategoryByCategory";
//     request.fields['service_provider_c'] = service_provider;
//     request.fields['category_c'] = categoryC;
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("jsonInput=$jsonInput");
//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//       if (status == 'true') {
//         for (int i = 0; i < serviceDayDetails.length; i++) {
//           var strinvalue = serviceDayDetails[i]["name"].toString();
//           print("strinvalue$strinvalue");
//           if (title == strinvalue) {
//             // print("strinvalue$strinvalue");
//             // dailyearnindetailslist[i]["data"][i2]["categoryArray"] =
//             //     jsonInput['categoryData'];
//             serviceDayDetails[i]["subCategoryData"] = jsonInput['data'];
//             setState(() {});
//             break;
//             // dailyearnindetailslist[i]["data"][i2]["selectedCategory"] =
//             //     jsonInput['categoryData'][0]["name"];
//             setState(() {});
//           }
//         }
//       }
//       // setState(() {
//       //   dailyearnindetailslist = jsonInput['data'] as List<dynamic>;
//       // });
//       // if (status == 'true') {
//       // } else {
//       //   Fluttertoast.showToast(
//       //     msg: message,
//       //     toastLength: Toast.LENGTH_SHORT,
//       //     gravity: ToastGravity.CENTER,
//       //   );
//       // }
//     } else {}
//   }
//
//   getearningweeksdetails() async {
//     var url = Uri.parse(CommonURL.herokuurl);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//     // print(utility.dateconverteryyyymmdd(fromdate ?? ""));
//     // print(utility.dateconverteryyyymmdd(todate ?? ""));
//     var fromdatestr = utility.dateconverteryyyymmdd(fromdate ?? "");
//
//     var todatestr = utility.dateconverteryyyymmdd(todate ?? "");
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "EarningWeeksDetails";
//     request.fields['idUser'] = utility.userid.toString();
//     request.fields['service_provider_c'] =
//         utility.service_provider_c.toString();
//     request.fields['lithiumID'] = utility.lithiumid.toString();
//     request.fields['fromDate'] = fromdatestr.toString();
//     request.fields['toDate'] = todatestr.toString();
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//
//     // request.fields['fromDate'] = "20-11-2022";
//     // request.fields['toDate'] = "26-11-2022";
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     print("EarningWeeksDetails = $url, ${request.fields}");
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       // log("responseformonthdetails = $jsonInput");
//       // print("get earningweeks response == $jsonInput");
//
//       String status = jsonInput['status'].toString();
//
//       if (status == 'true') {
//         // dropdownvalue2 = "paul";
//         // isgrivanceshowbyweek = 'true';
//         var rosterMaster = jsonInput['rosterMaster'];
//         var serviceDayDetails2 = jsonInput['serviceDayDetails'];
//         additionDeletionData = jsonInput['additionDeletionData'];
//         totalEarningArray = jsonInput['totalEarningArray'];
//         isWeeklyEarningAlreadyExist =
//             jsonInput['isWeeklyEarningAlreadyExist'].toString();
//         isNoGrievanceExist = jsonInput['isNoGrievanceExist'].toString();
//         // print("isNoGrievanceExist$isNoGrievanceExist");
//         // log("additionDeletionData$additionDeletionData");
//
//         serviceDayDetails = serviceDayDetails2;
//         log("serviceDayDetails2$serviceDayDetails2");
//         // additionDeletionData = additionDeletionData2;
//         // print("rosterMaster$rosterMaster");
//         // print("serviceDayDetails$serviceDayDetails");
//         // print("additionDeletionData = $additionDeletionData");
//         // print("serviceDayDetails$jsonInput['serviceDayDetails']");
//         tripTime = rosterMaster["tripTime"].toString();
//         // statusValue = rosterMaster["statusValue"].toString();
//         totalNoOfTripPerformed =
//             rosterMaster["totalNoOfTripPerformed"].toString();
//         setState(() {});
//       } else {}
//     }
//   }
//
//   getweekearningcontrolbydates(String selecteddate, int setindex) async {
//     var url = Uri.parse(CommonURL.herokuurl);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//     var fromdatestr = utility.dateconverteryyyymmdd(fromdate ?? "");
//     var statussendtoreturn;
//     var todatestr = utility.dateconverteryyyymmdd(todate ?? "");
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "isWeeklyEarningAlreadyExistByDateSP";
//     request.fields['idUser'] = utility.userid;
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     // request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['date'] = selecteddate;
//     request.fields['fromDate'] = fromdatestr;
//     request.fields['toDate'] = todatestr;
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("responsedetails$jsonInput");
//       // log("$jsonInput");
//       String status = jsonInput['status'].toString();
//
//       if (status == 'true') {
//         String message = jsonInput['message'].toString();
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//
//         serviceDayDetails[setindex]["isGrievanceDate"] = true;
//         // var dataarray = jsonInput['data'] as List;
//         // for (int i = 0; i < dataarray.length; i++) {
//         //   if (i == 0) {
//         //     dropdownvalue = dataarray[i]['showname'].toString();
//         //     getweekearningsdetailsbymonth(dataarray[i]['sfid'].toString());
//         //     print("dataarray$dataarray");
//         //     // getdailyearningdetailsbydate();
//         //   }
//         //   var changeTodate = (dataarray[i]['showname']).toString();
//         //   var dropsfidarray = (dataarray[i]['sfid']).toString();
//         //   items.add(changeTodate);
//         //   firstsfidarray.add(dropsfidarray);
//         // }
//         // dropdownvalue = jsonInput['data'][0];
//         // getweekearningsdetailsbymonth();
//
//       } else {
//         serviceDayDetails[setindex]["isGrievanceDate"] = false;
//       }
//     } else {
//       // serviceDayDetails[setindex]["isGrievanceDate"] = false;
//     }
//     setState(() {});
//   }
//
//   getweekearnings() async {
//     var url = Uri.parse(CommonURL.herokuurl);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "getEarningMonthDropdown";
//     request.fields['idUser'] = utility.userid;
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       // print("responsedetails$jsonInput");
//       log("responsedetails$jsonInput");
//       String status = jsonInput['status'].toString();
//
//       if (status == 'true') {
//         var dataarray = jsonInput['data'] as List;
//         for (int i = 0; i < dataarray.length; i++) {
//           if (i == 0) {
//             dropdownvalue = dataarray[i]['showname'].toString();
//             getweekearningsdetailsbymonth(dataarray[i]['sfid'].toString());
//             print("dataarray$dataarray");
//             // getdailyearningdetailsbydate();
//           }
//           var changeTodate = (dataarray[i]['showname']).toString();
//           var dropsfidarray = (dataarray[i]['sfid']).toString();
//           items.add(changeTodate);
//           firstsfidarray.add(dropsfidarray);
//         }
//         // dropdownvalue = jsonInput['data'][0];
//         // getweekearningsdetailsbymonth();
//         if(mounted)setState(() {});
//       } else {}
//     }
//   }
//
//   void loading() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         // dialogContext = context;
//         return Dialog(
//           child: Padding(
//             padding: const EdgeInsets.all(25.0),
//             // ignore: unnecessary_new
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset(
//                   'assets/lithiugif.gif',
//                   width: 50,
//                   // color: HexColor(Colorscommon.greencolor),
//                 ),
//                 Container(
//                     margin: const EdgeInsets.only(left: 10),
//                     child: const Text("Loading")),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   WekklyearningSubmit() async {
//     loading();
//     var url = Uri.parse(CommonURL.herokuurl);
//     // String url = CommonURL.URL;
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//     // var uri = Uri.parse(url);
//     // print(utility.lithiumid);
//     // print(utility.service_provider_c);
//     // for (int i = 0; i < dailyearnindetailslist.length; i++) {
//     // print(jsonEncode(serviceDayDetails));
//     // }
//     var fromdatestr = utility.dateconverteryyyymmdd(fromdate ?? "");
//
//     var todatestr = utility.dateconverteryyyymmdd(todate ?? "");
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "weeklyEarningAdd";
//     // change_date
//     // debugPrint('serviceDayDetails: $serviceDayDetails');
//     log("serviceDayDetails$serviceDayDetails");
//     // String str = jsonEncode(serviceDayDetails);
//     request.fields['data'] = jsonEncode(serviceDayDetails);
//     request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     request.fields['fromDate'] = fromdatestr;
//     request.fields['toDate'] = todatestr;
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//     // request.fields['fromDate'] = "20-11-2022";
//     // request.fields['toDate'] = "26-11-2022";
//
//     if (imagebool == true) {
//       request.files
//           .add(await http.MultipartFile.fromPath('benchFile', _image.path));
//     }
//
//     // request.files.add(await http.MultipartFile.fromPath('file', _image.path));
//
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       log("jsonInputjsonInputjsonInputjsonInput$jsonInput");
//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//       String sql = jsonInput['sql'];
//       log(message);
//       log(sql);
//       print("WekklyearningSubmit status$status");
//       if (status == 'true') {
//         // Navigator.pop(context);
//         // Navigator.pop(context);
//         Navigator.of(context, rootNavigator: true).pop();
//         // Navigator.pop(context, true);
//         // Navigator.pop(context);
//         // Navigator.push(context,
//         //     MaterialPageRoute(builder: (context) => const Dashboard2()));
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const MyTabPage(
//                   title: '', selectedtab: 0,
//                 )));
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//
//         // isdata = true;
//         // List array = jsonInput['data'];
//         // if (array.isNotEmpty) {
//         //   last5eoslistarray = array;
//         // }
//       } else {
//         Navigator.of(context, rootNavigator: true).pop();
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {}
//
//     // Navigator.pop(context);
//     setState(() {});
//     // Navigator.pop(context);
//   }
//
//   getweekearningsdetailsbymonth(String sfid) async {
//     var url = Uri.parse(CommonURL.herokuurl);
//
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//     // var uri = Uri.parse(url);
//     //print(utility.service_provider_c);
//
//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "getEarningWeeksDropdownBymonth";
//     request.fields['idUser'] = utility.userid;
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['monthYear'] = dropdownvalue!;
//     request.fields['sp_payment_c'] = sfid;
//     request.fields['languageType'] =
//         AppLocalizations.of(context)!.languagecode.toString();
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("lithiumIDdetails=$jsonInput");
//
//       String status = jsonInput['status'].toString();
//       items2 = [];
//       if (status == 'true') {
//         dropdownvaluebool = true;
//         var array = jsonInput['data'] as List;
//
//         if (array.isNotEmpty) {
//           weekdetailsarray = array;
//           // yearmonthlist = array;
//           for (int i = 0; i < array.length; i++) {
//             // print(jsonInput['data'][i]);
//             if (i == 0) {
//               isgrivanceshowbyweek = array[i]['isGrievance'].toString();
//             }
//             items2.add(array[i]['name'].toString());
//           }
//         }
//         getearningweeksdetails();
//         setState(() {});
//       } else {}
//     }
//   }
// }
//
