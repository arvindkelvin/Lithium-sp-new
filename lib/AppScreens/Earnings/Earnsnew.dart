// import 'dart:convert';
// import 'package:flutter_application_sfdc_idp/Colors.dart';
// import 'package:flutter_application_sfdc_idp/CommonColor.dart';
// import 'package:flutter_application_sfdc_idp/URL.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_application_sfdc_idp/Bouncing.dart';
// import 'package:flutter_application_sfdc_idp/Utility.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class Earningsnew123 extends StatefulWidget {
//   const Earningsnew123({Key? key}) : super(key: key);
//
//   @override
//   State<Earningsnew123> createState() => _Earningsnew123State();
// }
//
// class _Earningsnew123State extends State<Earningsnew123> {
//   Utility utility = Utility();
//   String? dropdownvalue;
//   String? dropdownvalue2;
//   String? fromdate;
//   String? tripTime;
//   String? statusValue;
//   String? totalNoOfTripPerformed;
//   String? todate;
//   List items = [];
//   List items2 = [];
//   List weekdetailsarray = [];
//   List serviceDayDetails = [];
//   List additionDeletionData = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     utility.GetUserdata().then((value) => {getweekearnings()});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: CommonAppbar(
//       //   title: 'Weekly Earnings',
//       //   appBar: AppBar(),
//       //   widgets: const [],
//       // ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//                 width: MediaQuery.of(context).size.width - 15,
//                 margin: const EdgeInsets.only(top: 8, right: 10, left: 10),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Select Month",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: HexColor(Colorscommon.greencolor)),
//                   ),
//                 )),
//             Container(
//               width: MediaQuery.of(context).size.width - 15,
//               height: 40,
//               margin: const EdgeInsets.all(15.0),
//               padding: const EdgeInsets.all(3.0),
//               decoration: const ShapeDecoration(
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(width: 1.0, style: BorderStyle.solid),
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 ),
//               ),
//               child: Theme(
//                 data: Theme.of(context)
//                     .copyWith(canvasColor: Colors.grey.shade100),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton(
//                     hint: const Text("-- Select Month -- "),
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
//                       getweekearningsdetailsbymonth();
//                       //                 // showmonth = true;
//                       //                 items2 = [];
//                       dropdownvalue2 = null;
//
//                       setState(() {});
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//                 width: MediaQuery.of(context).size.width - 15,
//                 margin: const EdgeInsets.only(top: 8, right: 10, left: 10),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Select Week",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: HexColor(Colorscommon.greencolor)),
//                   ),
//                 )),
//             Container(
//               width: MediaQuery.of(context).size.width - 15,
//               height: 40,
//               margin: const EdgeInsets.all(15.0),
//               padding: const EdgeInsets.all(3.0),
//               decoration: const ShapeDecoration(
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(width: 1.0, style: BorderStyle.solid),
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 ),
//               ),
//               child: Theme(
//                 data: Theme.of(context)
//                     .copyWith(canvasColor: Colors.grey.shade100),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton(
//                     isExpanded: true,
//                     hint: const Text("-- Select Week -- "),
//                     elevation: 0,
//                     value: dropdownvalue2,
//                     items: items2.map((items) {
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
//                       dropdownvalue2 = value.toString();
//                       for (int i = 0; i < weekdetailsarray.length; i++) {
//                         if (weekdetailsarray[i]['name'].toString() == value) {
//                           // print(weekdetailsarray[i]);
//                           fromdate = weekdetailsarray[i]["fromdate"].toString();
//                           todate = weekdetailsarray[i]["todate"].toString();
//                         }
//                       }
//                       setState(() {
//                         getearningweeksdetails();
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(5),
//               child: Card(
//                 color: Colors.white.withOpacity(.9),
//                 elevation: 4,
//                 child: Column(
//                   children: [
//                     Visibility(
//                       visible: dropdownvalue2 != null,
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: Text(
//                                 'Roster Master',
//                                 style: TextStyle(
//                                     color: HexColor(Colorscommon.greencolor),
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Text(
//                                   tripTime ?? "-",
//                                   textAlign: TextAlign.center,
//                                 )), //utility.Todaystr
//                           ],
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: dropdownvalue2 != null,
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: Text(
//                                 'Total No of Trips Performed',
//                                 style: TextStyle(
//                                     color: HexColor(Colorscommon.greencolor),
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Text(
//                                   totalNoOfTripPerformed ?? "0",
//                                   textAlign: TextAlign.center,
//                                 )), //utility.Todaystr
//                           ],
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: dropdownvalue2 != null,
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: Text(
//                                 'Service Days Details',
//                                 style: TextStyle(
//                                     color: HexColor(Colorscommon.greencolor),
//                                     fontWeight: FontWeight.bold),
//                               ),
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
//                     // Visibility(
//                     //   visible: dropdownvalue2 != null,
//                     //   child: Container(
//                     //     color: HexColor(Colorscommon.greencolor),
//                     //     height: 40,
//                     //     child: Row(
//                     //       mainAxisAlignment: MainAxisAlignment.start,
//                     //       children: const [
//                     //         Expanded(
//                     //           flex: 2,
//                     //           child: Text(
//                     //             '   Description',
//                     //             style: TextStyle(
//                     //                 color: Colors.white,
//                     //                 fontWeight: FontWeight.bold),
//                     //             textAlign: TextAlign.start,
//                     //           ),
//                     //         ),
//                     //         Expanded(
//                     //           flex: 1,
//                     //           child: Text(
//                     //             'Days',
//                     //             style: TextStyle(
//                     //                 color: Colors.white,
//                     //                 fontWeight: FontWeight.bold),
//                     //           ),
//                     //         ),
//                     //         Expanded(
//                     //           flex: 1,
//                     //           child: Text(
//                     //             'Date',
//                     //             style: TextStyle(
//                     //                 color: Colors.white,
//                     //                 fontWeight: FontWeight.bold),
//                     //           ),
//                     //         ),
//                     //         Expanded(
//                     //           flex: 1,
//                     //           child: Text(
//                     //             'Amount',
//                     //             style: TextStyle(
//                     //                 color: Colors.white,
//                     //                 fontWeight: FontWeight.bold),
//                     //           ),
//                     //         ),
//                     //         Expanded(
//                     //           flex: 1,
//                     //           child: Text(
//                     //             'Agree',
//                     //             style: TextStyle(
//                     //                 color: Colors.white,
//                     //                 fontWeight: FontWeight.bold),
//                     //           ),
//                     //         ),
//                     //       ],
//                     //     ),
//                     //   ),
//                     // ),
//                     Visibility(
//                       visible: dropdownvalue2 != null,
//                       child: ListView.builder(
//                           shrinkWrap: true,
//                           physics: const BouncingScrollPhysics(),
//                           itemCount: serviceDayDetails.length,
//                           itemBuilder: (context, index) {
//                             print(index);
//                             String? dropdownvalueone;
//                             String? dropdownvaluetwo;
//                             String? dropdownvaluethree;
//                             String? dropdownvaluefour;
//                             // print(index);
//
//                             var arrayspilt1 =
//                                 serviceDayDetails[index]["dateArray"];
//                             var arrayspilt2 =
//                                 serviceDayDetails[index]["isAvailDropDown"];
//                             var arrayspilt3 =
//                                 serviceDayDetails[index]["categoryData"];
//                             var arrayspilt4 =
//                                 serviceDayDetails[index]["subCategoryData"];
//                             // bool isdropdown =
//                             //     serviceDayDetails[index]["isDropDown"] as bool;
//                             // if (dropdownvalueone == null) {
//                             //   dropdownvalueone = array[index]
//                             //           ["selectedDropDownValue"]
//                             //       .toString();
//
//                             //   print("noflow");
//                             // } else {
//                             //   print("flow");
//                             //   dropdownvalueone;
//                             // }
//
//                             dropdownvalueone = serviceDayDetails[index]
//                                     ["selectedDate"]
//                                 .toString();
//                             dropdownvaluetwo = serviceDayDetails[index]
//                                     ["selectedIsAvailValue"]
//                                 .toString();
//                             dropdownvaluethree = serviceDayDetails[index]
//                                     ["selectedCategory"]
//                                 .toString();
//                             dropdownvaluefour = serviceDayDetails[index]
//                                     ["selectedSubCategory"]
//                                 .toString();
//
//                             List<String> array1 = [];
//                             List<String> array2 = [];
//                             List<String> array3 = [];
//                             List<String> array4 = [];
//
//                             for (int i = 0; i < arrayspilt1.length; i++) {
//                               var value = (arrayspilt1[i]['name'].toString());
//                               array1.add(value);
//                             }
//                             for (int i = 0; i < arrayspilt2.length; i++) {
//                               var value = (arrayspilt2[i]['name'].toString());
//                               array2.add(value);
//                             }
//                             for (int i = 0; i < arrayspilt3.length; i++) {
//                               var value = (arrayspilt3[i]['name'].toString());
//                               array3.add(value);
//                             }
//                             for (int i = 0; i < arrayspilt4.length; i++) {
//                               var value = (arrayspilt4[i]['name'].toString());
//                               array4.add(value);
//                             }
//                             return Container(
//                               // height: 100,
//                               padding: const EdgeInsets.only(
//                                   top: 0, left: 0, right: 10, bottom: 10),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Expanded(
//                                         flex: 2,
//                                         child: ExpansionTile(
//                                           title: Text(
//                                             serviceDayDetails[index]["name"]
//                                                 .toString(),
//                                             textAlign: TextAlign.start,
//                                             style: const TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Visibility(
//                                                       visible: true,
//                                                       child: Expanded(
//                                                         flex: 2,
//                                                         child: Container(
//                                                           height: 30,
//                                                           margin:
//                                                               const EdgeInsets
//                                                                   .all(15.0),
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(3.0),
//                                                           decoration:
//                                                               const ShapeDecoration(
//                                                             shape:
//                                                                 RoundedRectangleBorder(
//                                                               side: BorderSide(
//                                                                   width: 1.0,
//                                                                   style:
//                                                                       BorderStyle
//                                                                           .solid),
//                                                               borderRadius: BorderRadius
//                                                                   .all(Radius
//                                                                       .circular(
//                                                                           5.0)),
//                                                             ),
//                                                           ),
//                                                           child: Theme(
//                                                             data: Theme.of(
//                                                                     context)
//                                                                 .copyWith(
//                                                                     canvasColor:
//                                                                         Colors
//                                                                             .grey
//                                                                             .shade100),
//                                                             child:
//                                                                 DropdownButtonHideUnderline(
//                                                               child:
//                                                                   DropdownButton(
//                                                                 hint: const Text(
//                                                                     "Select Reason"),
//                                                                 elevation: 0,
//                                                                 value:
//                                                                     dropdownvalueone,
//                                                                 items: array1
//                                                                     .map(
//                                                                         (items) {
//                                                                   return DropdownMenuItem(
//                                                                       value:
//                                                                           items,
//                                                                       child:
//                                                                           Text(
//                                                                         " " +
//                                                                             items.toString(),
//                                                                       ));
//                                                                 }).toList(),
//                                                                 icon: Icon(
//                                                                   Icons
//                                                                       .keyboard_arrow_down,
//                                                                   color: HexColor(
//                                                                       Colorscommon
//                                                                           .greencolor),
//                                                                 ),
//                                                                 onChanged:
//                                                                     (value) {
//                                                                   // dropdownvalueone =
//                                                                   //     value.toString();
//
//                                                                   serviceDayDetails[
//                                                                           index]
//                                                                       [
//                                                                       "selectedDate"] = value;
//                                                                   setState(
//                                                                       () {});
//                                                                 },
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     // Visibility(
//                                                     //   visible: !isdropdown,
//                                                     //   child: Expanded(
//                                                     //       flex: 1,
//                                                     //       child: Bouncing(
//                                                     //         onPress: () {
//                                                     //           FocusManager
//                                                     //               .instance
//                                                     //               .primaryFocus
//                                                     //               ?.unfocus();
//                                                     //           Future<String>
//                                                     //               fromdatee =
//                                                     //               utility.selectTimeto(
//                                                     //                   context);
//
//                                                     //           fromdatee.then(
//                                                     //               (value) {
//                                                     //             setState(() {
//                                                     //               debugPrint(
//                                                     //                   'selectedvalue' +
//                                                     //                       value
//                                                     //                           .toString());
//
//                                                     //               if (value !=
//                                                     //                   "null") {
//                                                     //                 // starttime = value.substring(0, value.indexOf('.'));
//                                                     //                 // var pos = value.lastIndexOf('.');
//                                                     //                 // starttimesend = value.substring(pos + 1);
//                                                     //                 // print("starttimesend$starttimesend");
//                                                     //                 // vailddata();
//                                                     //               }
//                                                     //             });
//                                                     //           });
//                                                     //           // print("startdate$fromdatesend");
//                                                     //         },
//                                                     //         child: Container(
//                                                     //           margin:
//                                                     //               const EdgeInsets
//                                                     //                       .all(
//                                                     //                   10.0),
//                                                     //           height: 30,
//                                                     //           decoration:
//                                                     //               const ShapeDecoration(
//                                                     //             shape:
//                                                     //                 RoundedRectangleBorder(
//                                                     //               side: BorderSide(
//                                                     //                   width:
//                                                     //                       1.0,
//                                                     //                   style: BorderStyle
//                                                     //                       .solid),
//                                                     //               borderRadius:
//                                                     //                   BorderRadius.all(
//                                                     //                       Radius.circular(
//                                                     //                           5.0)),
//                                                     //             ),
//                                                     //           ),
//                                                     //           child: Row(
//                                                     //             mainAxisAlignment:
//                                                     //                 MainAxisAlignment
//                                                     //                     .spaceEvenly,
//                                                     //             children: [
//                                                     //               Expanded(
//                                                     //                 flex: 2,
//                                                     //                 child: Text(
//                                                     //                   " " +
//                                                     //                       ("Select Time"),
//                                                     //                   // textAlign: TextAlign.center,
//                                                     //                   style: TextStyle(
//                                                     //                       color:
//                                                     //                           HexColor(Colorscommon.greycolor)),
//                                                     //                 ),
//                                                     //               ),
//                                                     //               Icon(
//                                                     //                 Icons
//                                                     //                     .access_time,
//                                                     //                 color: HexColor(
//                                                     //                     Colorscommon
//                                                     //                         .greencolor),
//                                                     //               )
//                                                     //             ],
//                                                     //           ),
//                                                     //         ),
//                                                     //       )),
//                                                     // ),
//                                                     Expanded(
//                                                       flex: 1,
//                                                       child: Container(
//                                                         // width: MediaQuery.of(context).size.width - 15,
//                                                         height: 30,
//                                                         margin: const EdgeInsets
//                                                             .all(15.0),
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(3.0),
//                                                         decoration:
//                                                             const ShapeDecoration(
//                                                           shape:
//                                                               RoundedRectangleBorder(
//                                                             side: BorderSide(
//                                                                 width: 1.0,
//                                                                 style:
//                                                                     BorderStyle
//                                                                         .solid),
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .all(Radius
//                                                                         .circular(
//                                                                             5.0)),
//                                                           ),
//                                                         ),
//                                                         child: Theme(
//                                                           data: Theme.of(
//                                                                   context)
//                                                               .copyWith(
//                                                                   canvasColor:
//                                                                       Colors
//                                                                           .grey
//                                                                           .shade100),
//                                                           child:
//                                                               DropdownButtonHideUnderline(
//                                                             child:
//                                                                 DropdownButton(
//                                                               // isExpanded: true,
//                                                               // isDense: ,
//                                                               hint: const Text(
//                                                                   "None"),
//                                                               elevation: 0,
//                                                               value:
//                                                                   dropdownvaluetwo,
//                                                               items: array2
//                                                                   .map((items) {
//                                                                 return DropdownMenuItem(
//                                                                     value:
//                                                                         items,
//                                                                     child: Text(
//                                                                       " " +
//                                                                           items
//                                                                               .toString(),
//                                                                     ));
//                                                               }).toList(),
//                                                               icon: Icon(
//                                                                 Icons
//                                                                     .keyboard_arrow_down,
//                                                                 color: HexColor(
//                                                                     Colorscommon
//                                                                         .greencolor),
//                                                               ),
//                                                               onChanged:
//                                                                   (value) {
//                                                                 // print("DropdownMenuItem$DropdownMenuItem");
//                                                                 // dropdownvaluetwo =
//                                                                 //     value
//                                                                 //         .toString();
//                                                                 print(
//                                                                     "value121242$value");
//                                                                 print(
//                                                                     "indexstr$index");
//                                                                 // if (value
//                                                                 //         .toString() ==
//                                                                 //     "Yes") {
//                                                                 //   getdailyearningdetailsbycategory(
//                                                                 //       serviceDayDetails[index]
//                                                                 //               [
//                                                                 //               "name"]
//                                                                 //           .toString(),
//                                                                 //       index
//                                                                 //           .toString());
//                                                                 // }
//                                                                 serviceDayDetails[
//                                                                             index]
//                                                                         [
//                                                                         "selectedIsAvailValue"] =
//                                                                     value
//                                                                         .toString();
//
//                                                                 setState(() {
//                                                                   // getdailyearningdetailsbydate();s
//                                                                 });
//                                                               },
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Visibility(
//                                                   visible:
//                                                       dropdownvaluetwo == "Yes",
//                                                   child: Row(
//                                                     children: [
//                                                       Expanded(
//                                                         flex: 1,
//                                                         child: Container(
//                                                           // width: MediaQuery.of(context).size.width - 15,
//                                                           height: 30,
//                                                           margin:
//                                                               const EdgeInsets
//                                                                   .all(10.0),
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(3.0),
//                                                           decoration:
//                                                               const ShapeDecoration(
//                                                             shape:
//                                                                 RoundedRectangleBorder(
//                                                               side: BorderSide(
//                                                                   width: 1.0,
//                                                                   style:
//                                                                       BorderStyle
//                                                                           .solid),
//                                                               borderRadius: BorderRadius
//                                                                   .all(Radius
//                                                                       .circular(
//                                                                           5.0)),
//                                                             ),
//                                                           ),
//                                                           child: Theme(
//                                                             data: Theme.of(
//                                                                     context)
//                                                                 .copyWith(
//                                                                     canvasColor:
//                                                                         Colors
//                                                                             .grey
//                                                                             .shade100),
//                                                             child:
//                                                                 DropdownButtonHideUnderline(
//                                                               child:
//                                                                   DropdownButton(
//                                                                 hint: const Text(
//                                                                     "Select Category"),
//                                                                 elevation: 0,
//                                                                 value:
//                                                                     dropdownvaluethree,
//                                                                 items: array3
//                                                                     .map(
//                                                                         (items) {
//                                                                   return DropdownMenuItem(
//                                                                       value:
//                                                                           items,
//                                                                       child:
//                                                                           Text(
//                                                                         " " +
//                                                                             items.toString(),
//                                                                       ));
//                                                                 }).toList(),
//                                                                 icon: Icon(
//                                                                   Icons
//                                                                       .keyboard_arrow_down,
//                                                                   color: HexColor(
//                                                                       Colorscommon
//                                                                           .greencolor),
//                                                                 ),
//                                                                 onChanged:
//                                                                     (value) {
//                                                                   // print("DropdownMenuItem$DropdownMenuItem");
//                                                                   serviceDayDetails[
//                                                                               index]
//                                                                           [
//                                                                           "selectedCategory"] =
//                                                                       value
//                                                                           .toString();
//
//                                                                   // dropdownvaluethree =
//                                                                   //     value.toString();
//                                                                   setState(() {
//                                                                     // getdailyearningdetailsbydate();
//                                                                   });
//                                                                 },
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//
//                                                       // Expanded(
//                                                       //   flex: 1,
//                                                       //   child: Container(
//                                                       //     // width: MediaQuery.of(context).size.width - 15,
//                                                       //     height: 30,
//                                                       //     margin:
//                                                       //         const EdgeInsets
//                                                       //                 .all(
//                                                       //             15.0),
//                                                       //     padding:
//                                                       //         const EdgeInsets
//                                                       //             .all(3.0),
//                                                       //     decoration:
//                                                       //         const ShapeDecoration(
//                                                       //       shape:
//                                                       //           RoundedRectangleBorder(
//                                                       //         side: BorderSide(
//                                                       //             width:
//                                                       //                 1.0,
//                                                       //             style: BorderStyle
//                                                       //                 .solid),
//                                                       //         borderRadius:
//                                                       //             BorderRadius.all(
//                                                       //                 Radius.circular(
//                                                       //                     5.0)),
//                                                       //       ),
//                                                       //     ),
//                                                       //     child: Theme(
//                                                       //       data: Theme.of(
//                                                       //               context)
//                                                       //           .copyWith(
//                                                       //               canvasColor: Colors
//                                                       //                   .grey
//                                                       //                   .shade100),
//                                                       //       child:
//                                                       //           DropdownButtonHideUnderline(
//                                                       //         child:
//                                                       //             DropdownButton(
//                                                       //           // isExpanded: true,
//                                                       //           // isDense: ,
//                                                       //           hint: const Text(
//                                                       //               "-- Select Date -- "),
//                                                       //           elevation:
//                                                       //               0,
//                                                       //           value:
//                                                       //               dropdownvaluefour,
//                                                       //           items: changetypelist
//                                                       //               .map(
//                                                       //                   (items) {
//                                                       //             return DropdownMenuItem(
//                                                       //                 value:
//                                                       //                     items,
//                                                       //                 child:
//                                                       //                     Text(
//                                                       //                   " " +
//                                                       //                       items.toString(),
//                                                       //                 ));
//                                                       //           }).toList(),
//                                                       //           icon: Icon(
//                                                       //             Icons
//                                                       //                 .keyboard_arrow_down,
//                                                       //             color: HexColor(
//                                                       //                 Colorscommon
//                                                       //                     .greencolor),
//                                                       //           ),
//                                                       //           onChanged:
//                                                       //               (value) {
//                                                       //             // print("DropdownMenuItem$DropdownMenuItem");
//                                                       //             change_date =
//                                                       //                 value
//                                                       //                     .toString();
//                                                       //             setState(
//                                                       //                 () {
//                                                       //               getdailyearningdetailsbydate();
//                                                       //             });
//                                                       //           },
//                                                       //         ),
//                                                       //       ),
//                                                       //     ),
//                                                       //   ),
//                                                       // ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Visibility(
//                                                     visible: dropdownvaluetwo ==
//                                                         "Yes",
//                                                     child: Row(
//                                                       children: [
//                                                         Expanded(
//                                                           flex: 5,
//                                                           child: Container(
//                                                             // width: MediaQuery.of(context).size.width - 15,
//                                                             height: 30,
//                                                             margin:
//                                                                 const EdgeInsets
//                                                                     .all(10.0),
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(3.0),
//                                                             decoration:
//                                                                 const ShapeDecoration(
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 side: BorderSide(
//                                                                     width: 1.0,
//                                                                     style: BorderStyle
//                                                                         .solid),
//                                                                 borderRadius: BorderRadius
//                                                                     .all(Radius
//                                                                         .circular(
//                                                                             5.0)),
//                                                               ),
//                                                             ),
//                                                             child: Theme(
//                                                               data: Theme.of(
//                                                                       context)
//                                                                   .copyWith(
//                                                                       canvasColor: Colors
//                                                                           .grey
//                                                                           .shade100),
//                                                               child:
//                                                                   DropdownButtonHideUnderline(
//                                                                 child:
//                                                                     DropdownButton(
//                                                                   // isExpanded: true,
//                                                                   // isDense: ,
//                                                                   hint: const Text(
//                                                                       "Select SubCategory"),
//                                                                   elevation: 0,
//                                                                   value:
//                                                                       dropdownvaluefour,
//                                                                   items: array4
//                                                                       .map(
//                                                                           (items) {
//                                                                     return DropdownMenuItem(
//                                                                         value:
//                                                                             items,
//                                                                         child:
//                                                                             Text(
//                                                                           " " +
//                                                                               items.toString(),
//                                                                         ));
//                                                                   }).toList(),
//                                                                   icon: Icon(
//                                                                     Icons
//                                                                         .keyboard_arrow_down,
//                                                                     color: HexColor(
//                                                                         Colorscommon
//                                                                             .greencolor),
//                                                                   ),
//                                                                   onChanged:
//                                                                       (value) {
//                                                                     // print("DropdownMenuItem$DropdownMenuItem");
//
//                                                                     serviceDayDetails[
//                                                                             index]
//                                                                         [
//                                                                         "selectedSubCategory"] = value;
//                                                                     //     value.toString();
//                                                                     setState(
//                                                                         () {
//                                                                       // getdailyearningdetailsbydate();
//                                                                     });
//                                                                   },
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ))
//                                               ],
//                                             )
//                                           ],
//                                           // text: array[index]["name"]
//                                           //     .toString(),
//                                         ),
//                                       ),
//                                       //
//                                     ],
//                                   ),
//                                   // const SizedBox(
//                                   //   height: 5,
//                                   // ),
//                                 ],
//                               ),
//                             );
//                           }),
//                       // child: ListView.builder(
//                       //     shrinkWrap: true,
//                       //     physics: const BouncingScrollPhysics(),
//                       //     itemCount: serviceDayDetails.length,
//                       //     itemBuilder: (BuildContext context, int index) {
//                       //       return Column(
//                       //         children: [
//                       //           Padding(
//                       //             padding: const EdgeInsets.all(10),
//                       //             child: Row(
//                       //               mainAxisAlignment: MainAxisAlignment.start,
//                       //               children: [
//                       //                 Expanded(
//                       //                   flex: 2,
//                       //                   child: ExpansionTile(
//                       //                     children: [
//                       //                       Row(
//                       //                         children: [
//                       //                           Expanded(
//                       //                             flex: 1,
//                       //                             child: Text(
//                       //                                 serviceDayDetails[index]
//                       //                                         ["days"]
//                       //                                     .toString()),
//                       //                           ),
//                       //                         ],
//                       //                       ),
//                       //                       Row(
//                       //                         children: [
//                       //                           Expanded(
//                       //                             flex: 1,
//                       //                             child: Text(
//                       //                                 serviceDayDetails[index]
//                       //                                         ["days"]
//                       //                                     .toString()),
//                       //                           ),
//                       //                         ],
//                       //                       ),
//                       //                       Row(
//                       //                         children: [
//                       //                           Expanded(
//                       //                             flex: 1,
//                       //                             child: Text(
//                       //                                 serviceDayDetails[index]
//                       //                                         ["days"]
//                       //                                     .toString()),
//                       //                           ),
//                       //                         ],
//                       //                       ),
//                       //                     ],
//                       //                     title: Text(
//                       //                       serviceDayDetails[index]["name"]
//                       //                           .toString(),
//                       //                       textAlign: TextAlign.start,
//                       //                     ),
//                       //                   ),
//                       //                 ),
//                       //               ],
//                       //             ),
//                       //           ),
//                       //         ],
//                       //       );
//                       //     }),
//                     ),
//                     Visibility(
//                       visible: dropdownvalue2 != null,
//                       child: Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: SizedBox(
//                           // height: 70,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 flex: 1,
//                                 child: Text(
//                                   ' Additions/Deletions',
//                                   style: TextStyle(
//                                       color: HexColor(Colorscommon.greencolor),
//                                       fontWeight: FontWeight.bold),
//                                   textAlign: TextAlign.start,
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 5,
//                               ),
//                               const Expanded(
//                                   flex: 1,
//                                   child:
//                                       Text("            ")), //utility.Todaystr
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: dropdownvalue2 != null,
//                       child: ListView.builder(
//                           shrinkWrap: true,
//                           physics: const BouncingScrollPhysics(),
//                           itemCount: 5,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: SizedBox(
//                                     height: 40,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: const [
//                                         Expanded(
//                                           flex: 2,
//                                           child: Text(
//                                             'Description',
//                                             textAlign: TextAlign.start,
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             'Days',
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             'Date',
//                                             // style: TextStyle(
//                                             //     // color: Colors.white,
//                                             //     fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             'Amount',
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             'Agree',
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }),
//                     ),
//                     Visibility(
//                       visible: dropdownvalue2 != null,
//                       child: Bouncing(
//                         onPress: () {},
//                         child: Container(
//                           margin: const EdgeInsets.only(top: 20, bottom: 10),
//                           width: 100,
//                           height: 40,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: HexColor(Colorscommon.greencolor),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5)),
//                             ),
//                             //                        RaisedButton(
//                             // color: HexColor(Colorscommon.greencolor),
//                             // shape: RoundedRectangleBorder(
//                             //     borderRadius: BorderRadius.circular(5)),
//                             child: const Text(
//                               "Submit",
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                             onPressed: () {},
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
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
//     request.fields['idUser'] = utility.userid;
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['fromDate'] = fromdatestr;
//     request.fields['toDate'] = todatestr;
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("getearningweeksdetailresponse$jsonInput");
//
//       String status = jsonInput['status'].toString();
//
//       if (status == 'true') {
//         var rosterMaster = jsonInput['rosterMaster'];
//         var serviceDayDetails2 = jsonInput['serviceDayDetails'];
//         serviceDayDetails = serviceDayDetails2;
//         print("rosterMaster$rosterMaster");
//         print("serviceDayDetails$serviceDayDetails");
//         // print("serviceDayDetails$jsonInput['serviceDayDetails']");
//         tripTime = rosterMaster["tripTime"].toString();
//         statusValue = rosterMaster["statusValue"].toString();
//         totalNoOfTripPerformed =
//             rosterMaster["totalNoOfTripPerformed"].toString();
//         setState(() {});
//       } else {}
//     }
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
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       //print("responsedetails$jsonInput");
//
//       String status = jsonInput['status'].toString();
//
//       if (status == 'true') {
//         items = jsonInput['data'] as List;
//         dropdownvalue = jsonInput['data'][0];
//         getweekearningsdetailsbymonth();
//         setState(() {});
//       } else {}
//     }
//   }
//
//   getweekearningsdetailsbymonth() async {
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
//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("lithiumIDdetails$jsonInput");
//
//       String status = jsonInput['status'].toString();
//       items2 = [];
//       if (status == 'true') {
//         var array = jsonInput['data'] as List;
//         if (array.isNotEmpty) {
//           weekdetailsarray = array;
//           // yearmonthlist = array;
//           for (int i = 0; i < array.length; i++) {
//             // print(jsonInput['data'][i]);
//             items2.add(array[i]['name'].toString());
//           }
//         }
//         // for (int i = 0; i < array.length; i++) {
//         //   // print(array[i]["name"]);
//         //   var dataraaay = array[i]["name"].toString();
//         //   items2.add(dataraaay);
//         //   // print(jsonInput['data'][i]);
//         //   // if (array[i]['year'].toString() == dropdownvalue) {
//         //   //   for (int y = 0; y < array[i]['monthdata'].length; y++) {
//         //   //     items2.add(array[i]['monthdata'][y]['month'].toString());
//         //   //   }
//         //   // }
//         //   // items.add(yearmonthlist[i]['year'].toString());
//         // }
//         // items2 = jsonInput['data'][0] as List;
//         // print("items2$items2");
//         setState(() {});
//       } else {}
//     }
//   }
// }
//
//
//
// //  Expanded(
// //                                           flex: 1,
// //                                           child: Text(serviceDayDetails[index]
// //                                                   ["days"]
// //                                               .toString()),
// //                                         ),
// //                                         const Expanded(
// //                                           flex: 1,
// //                                           child: Text("test"
// //                                               // serviceDayDetails[index]
// //                                               //             ["dateArray"][0]
// //                                               //         .toString() ??
// //                                               //     "",
// //                                               ),
// //                                         ),
// //                                         Expanded(
// //                                           flex: 1,
// //                                           child: Text(
// //                                             serviceDayDetails[index]["amount"]
// //                                                 .toString(),
// //                                           ),
// //                                         ),
// //                                         const Expanded(
// //                                           flex: 1,
// //                                           child: Text(
// //                                             'None',
// //                                           ),
// //                                         ),
//
//
//
//
//


//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/platform_interface.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'AuthScreen.dart';
// import 'BroadcastDetailScreen.dart';
// import 'BroadcastScreen.dart';
// import 'ChatScreen.dart';
// import 'GroupChatScreen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UserSelectionScreen extends StatefulWidget {
//   @override
//   _UserSelectionScreenState createState() => _UserSelectionScreenState();
// }
//
// class _UserSelectionScreenState extends State<UserSelectionScreen> {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   TextEditingController groupNameController = TextEditingController();
//   List<String> selectedUsers = [];
//   TextEditingController searchController = TextEditingController();
//   String searchQuery = '';
//   TextEditingController groupSearchController = TextEditingController();
//   String groupSearchQuery = '';
//
//   void _createGroupChat() async {
//     if (groupNameController.text.isEmpty || selectedUsers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Please enter a group name and select at least one member."),
//       ));
//       return;
//     }
//
//     selectedUsers.add(currentUser!.uid);
//
//     DocumentReference groupRef = await FirebaseFirestore.instance.collection('groups').add({
//       'groupName': groupNameController.text,
//       'members': selectedUsers,
//       'createdBy': currentUser!.uid,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     Navigator.pop(context);
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => GroupChatScreen(groupId: groupRef.id, groupName: groupNameController.text),
//       ),
//     );
//   }
//
//   void _showCreateGroupDialog() {
//     TextEditingController searchController = TextEditingController();
//     String searchQuery = "";
//     bool selectAll = false;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(builder: (context, setState) {
//           return AlertDialog(
//             title: Text("Create Group"),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: groupNameController,
//                   decoration: InputDecoration(labelText: "Enter Group Name"),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: searchController,
//                   decoration: InputDecoration(
//                     labelText: "Search Users",
//                     prefixIcon: Icon(Icons.search),
//                   ),
//                   onChanged: (value) {
//                     setState(() {
//                       searchQuery = value.toLowerCase();
//                     });
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child: StreamBuilder(
//                     stream: FirebaseFirestore.instance.collection('users').snapshots(),
//                     builder: (ctx, AsyncSnapshot snapshot) {
//                       if (!snapshot.hasData) return CircularProgressIndicator();
//                       var users = snapshot.data.docs;
//
//                       var filteredUsers = users.where((user) {
//                         var username = user.data()['username'].toString().toLowerCase();
//                         return username.contains(searchQuery);
//                       }).toList();
//
//                       return Column(
//                         children: [
//                           if (filteredUsers.isNotEmpty)
//                             CheckboxListTile(
//                               title: Text("Select All"),
//                               value: filteredUsers.every((user) => selectedUsers.contains(user.id)),
//                               onChanged: (bool? selected) {
//                                 setState(() {
//                                   if (selected == true) {
//                                     for (var user in filteredUsers) {
//                                       if (!selectedUsers.contains(user.id)) {
//                                         selectedUsers.add(user.id);
//                                       }
//                                     }
//                                   } else {
//                                     for (var user in filteredUsers) {
//                                       selectedUsers.remove(user.id);
//                                     }
//                                   }
//                                 });
//                               },
//                             ),
//                           Expanded(
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: filteredUsers.length,
//                               itemBuilder: (ctx, index) {
//                                 var userData = filteredUsers[index].data();
//                                 var userId = filteredUsers[index].id;
//
//                                 if (userId == currentUser!.uid) return Container();
//
//                                 return CheckboxListTile(
//                                   title: Text(userData['username']),
//                                   value: selectedUsers.contains(userId),
//                                   onChanged: (bool? selected) {
//                                     setState(() {
//                                       if (selected == true) {
//                                         selectedUsers.add(userId);
//                                       } else {
//                                         selectedUsers.remove(userId);
//                                       }
//                                     });
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
//               ElevatedButton(onPressed: _createGroupChat, child: Text("Create")),
//             ],
//           );
//         });
//       },
//     );
//   }
//
//   void _confirmDeleteGroup(String groupId, String groupName) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text("Delete Group"),
//         content: Text("Are you sure you want to delete the group '$groupName'?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(ctx);
//               await FirebaseFirestore.instance.collection('groups').doc(groupId).delete();
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Group deleted.")));
//             },
//             child: Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _confirmDeleteChat(String userId) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text("Delete Chat"),
//         content: Text("Are you sure you want to delete chat with this user?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(ctx);
//               await _deleteChatWithUser(userId);
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Chat deleted.")));
//             },
//             child: Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _deleteChatWithUser(String userId) async {
//     final messages = await FirebaseFirestore.instance
//         .collection('messages')
//         .where('participants', arrayContains: FirebaseAuth.instance.currentUser!.uid)
//         .get();
//
//     for (var doc in messages.docs) {
//       if (doc['participants'].contains(userId)) {
//         await FirebaseFirestore.instance.collection('messages').doc(doc.id).delete();
//       }
//     }
//   }
//
//
//   // Function to build media preview based on media type (image, video, etc.)
//   Widget _buildMediaPreview(String mediaUrl, String mediaType) {
//     if (mediaType.startsWith('image')) {
//       return ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Image.network(
//           mediaUrl,
//           height: 120,
//           width: 120,
//           fit: BoxFit.cover,
//           loadingBuilder: (context, child, loadingProgress) {
//             if (loadingProgress == null) {
//               return child; // Display the image once it's fully loaded
//             } else {
//               return Center(child: CircularProgressIndicator());
//             }
//           },
//           errorBuilder: (context, error, stackTrace) {
//             return Icon(Icons.error, color: Colors.red); // Fallback if image fails to load
//           },
//         ),
//       );
//     } else if (mediaType.startsWith('video')) {
//       return GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => VideoWebViewScreen(videoUrl: mediaUrl),
//             ),
//           );
//         },
//         child: Text(
//           '📹 Tap to view video',
//           style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
//         ),
//       );
//     }
//     else if (mediaType.startsWith('audio')) {
//       return Container(
//         height: 60,
//         width: double.infinity,
//         color: Colors.green[100],
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.audiotrack, size: 30, color: Colors.green),
//             SizedBox(width: 10),
//             Text('Audio: Tap to play', style: TextStyle(fontSize: 16)),
//           ],
//         ),
//       );
//     } else {
//       return Container(
//         height: 60,
//         width: double.infinity,
//         color: Colors.grey[200],
//         child: Center(
//           child: Icon(Icons.insert_drive_file, size: 32, color: Colors.grey),
//         ),
//       );
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final isAdmin = currentUser?.email == 'admin@gmail.com';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chats"),
//         actions: [
//           if (isAdmin)
//             IconButton(
//               icon: Icon(Icons.group_add),
//               onPressed: _showCreateGroupDialog,
//             ),
//           if (isAdmin)
//             IconButton(
//               icon: Icon(Icons.speaker_group),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => BroadcastScreen()),
//                 );
//               },
//             ),
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (_) => AuthScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Show Broadcast only for non-admins
//           if (!isAdmin)
//             StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('broadcasts')
//                   .orderBy('timestamp', descending: true)
//                   .limit(1)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot snapshot) {
//                 if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
//                   return Container(); // Return empty if no data is found
//                 }
//
//                 var broadcast = snapshot.data.docs.first;
//                 String mediaUrl = broadcast['mediaUrl'] ?? ''; // Fetch mediaUrl
//                 String mediaType = broadcast['mediaType'] ?? ''; // Fetch mediaType
//
//                 return GestureDetector(
//                   onTap: () {
//                     // On tap, show the BroadcastDetailScreen with dynamic mediaUrl and mediaType
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BroadcastDetailScreen(
//                           message: broadcast['message'] ?? "No message",
//                           timestamp: (broadcast['timestamp'] as Timestamp).toDate(),
//                           mediaUrl: mediaUrl,  // Pass the dynamic mediaUrl
//                           mediaType: mediaType,  // Pass the dynamic mediaType
//                         ),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     color: Colors.yellow[100],
//                     padding: EdgeInsets.all(8),
//                     child: Row(
//                       children: [
//                         Icon(Icons.campaign, color: Colors.orange),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Check if the broadcast message exists and display it
//                               if (broadcast['message'] != null && broadcast['message'].toString().trim().isNotEmpty)
//                                 Text(
//                                   "📢 Admin Broadcast: ${broadcast['message']}",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 18, // Adjust the font size
//                                     color: Colors.black, // Set text color to black for better contrast
//                                   ),
//                                 ),
//                               // Check if there is a media URL, and if so, display the media preview
//                               if (mediaUrl.isNotEmpty)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: _buildMediaPreview(mediaUrl, mediaType), // Display media preview
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//
//
//           // Show search and list of users for non-admins
//           if (isAdmin)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search Users...',
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     searchQuery = value.toLowerCase();
//                   });
//                 },
//               ),
//             ),
//
//           // List of users for non-admins
//           if (isAdmin)
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance.collection('users').snapshots(),
//                 builder: (ctx, AsyncSnapshot snapshot) {
//                   if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//
//                   var users = snapshot.data.docs;
//
//                   var filteredUsers = users.where((user) {
//                     var username = user['username'].toString().toLowerCase();
//                     return user.id != currentUser!.uid && username.contains(searchQuery);
//                   }).toList();
//
//                   return ListView.builder(
//                     itemCount: filteredUsers.length,
//                     itemBuilder: (ctx, index) {
//                       var userData = filteredUsers[index].data();
//                       var userId = filteredUsers[index].id;
//
//                       return ListTile(
//                         title: Text(userData['username']),
//                         subtitle: Text("Email: ${userData['email']}"),
//                         isThreeLine: true,
//                         onTap: () {
//                           String receiverFcmToken = userData.containsKey('fcmToken') ? userData['fcmToken'] : '';
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 senderId: currentUser!.uid,
//                                 receiverId: userId,
//                                 receiverName: userData['username'],
//                                 receiverFcmToken: receiverFcmToken,
//                               ),
//                             ),
//                           );
//                         },
//                         onLongPress: () => _confirmDeleteChat(userId),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//
//           Divider(),
//
//           // Show search and list of groups for non-admins
//           if (isAdmin)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: groupSearchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search Groups...',
//                   prefixIcon: Icon(Icons.search),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     groupSearchQuery = value.toLowerCase();
//                   });
//                 },
//               ),
//             ),
//
//           // List of groups for non-admins
//           if (isAdmin)
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance.collection('groups').snapshots(),
//                 builder: (ctx, AsyncSnapshot snapshot) {
//                   if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//
//                   var groups = snapshot.data.docs.where((group) {
//                     var groupName = group['groupName'].toString().toLowerCase();
//                     return groupName.contains(groupSearchQuery);
//                   }).toList();
//
//                   return ListView.builder(
//                     itemCount: groups.length,
//                     itemBuilder: (ctx, index) {
//                       var groupData = groups[index].data();
//                       var groupId = groups[index].id;
//
//                       return ListTile(
//                         title: Text(groupData['groupName']),
//                         subtitle: Text("Members: ${groupData['members'].length}"),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => GroupChatScreen(groupId: groupId, groupName: groupData['groupName']),
//                             ),
//                           );
//                         },
//                         onLongPress: () => _confirmDeleteGroup(groupId, groupData['groupName']),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
// }
//
//
//
//
// class VideoWebViewScreen extends StatelessWidget {
//   final String videoUrl;
//
//   const VideoWebViewScreen({Key? key, required this.videoUrl}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Video Player')),
//       body: WebView(
//         initialUrl: videoUrl,
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }
