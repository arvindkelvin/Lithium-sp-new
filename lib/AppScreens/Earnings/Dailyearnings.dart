// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_sfdc_idp/AppScreens/Dashboard2.dart';
// import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
// import 'package:flutter_application_sfdc_idp/Bouncing.dart';
// import 'package:flutter_application_sfdc_idp/Colors.dart';
// import 'package:flutter_application_sfdc_idp/CommonColor.dart';
// import 'package:flutter_application_sfdc_idp/CommonText.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_application_sfdc_idp/URL.dart';
// import 'package:flutter_application_sfdc_idp/Utility.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';

// class Dailyearnings extends StatefulWidget {
//   const Dailyearnings({Key? key}) : super(key: key);

//   @override
//   State<Dailyearnings> createState() => _DailyearningsState();
// }

// class _DailyearningsState extends State<Dailyearnings> {
//   Utility utility = Utility();
//   String service_provider = '';
//   var username = "";
//   final List<TextEditingController> _controllers = [];
//   bool imagebool = false;
//   bool showbtnbool = false;
//   late File _image;
//   String imgname = '';
//   bool isloading = true;
//   bool apicalling = true;
//   List<String> changetypelist = [];
//   List<dynamic> dailyearnindetailslist = [];
//   TextEditingController tripidcontroller = TextEditingController();
//   //  TextEditingController tripidcontroller = TextEditingController();
//   List<dynamic> dailyearnindetailssublist = [];
//   List<dynamic> datedroplist = [];
//   String rosterstartTime = '';
//   String rosterendTime = '';
//   String checkintime = '';
//   String checkouttime = '';
//   String datedetail = '-';
//   String tripdetails = '';
//   String debitdetails = '';
//   String totearnings = '';
//   String? dropdownvalue1;
//   String? dropdownvalue2;
//   String? tripdropdown;
//   String? totearndropdown;
//   String? change_date;
//   final List<TextEditingController> _controller = [];

//   @override
//   void initState() {
//     super.initState();
//     Future<String> Serviceprovider = sessionManager.getspid();
//     Serviceprovider.then((value) {
//       service_provider = value.toString();
//     });
//     setState(() {
//       utility.GetUserdata().then((value) => {
//             username = utility.lithiumid,
//             getdailyearning(),
//           });
//     });
//   }

//   getdailyearning() async {
//     var url = Uri.parse(CommonURL.herokuurl);

//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };

//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "getDailyEarningDateDropDown";
//     request.fields['service_provider_c'] = service_provider;

//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("daily earn = $jsonInput");

//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];

//       if (status == 'true') {
//         datedroplist = jsonInput['dateArray'];

//         for (int i = 0; i < datedroplist.length; i++) {
//           if (i == 0) {
//             change_date = (datedroplist[i]['name']).toString();
//             getdailyearningdetailsbydate();
//           }
//           var changeTodate = (datedroplist[i]['name']).toString();
//           changetypelist.add(changeTodate);
//         }
//         setState(() {});
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {}
//   }

//   Raise_no_griveanceapi(BuildContext context) async {
//     loading();
//     var url = Uri.parse(CommonURL.herokuurl);

//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };

//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "noGrievanceDailyUpdate";
//     request.fields['service_provider_c'] = service_provider;
//     request.fields['lithiumID'] = username;
//     request.fields['date'] = change_date ?? "";

//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("daily earn = $jsonInput");

//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];

//       if (status == 'true') {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//         Navigator.of(context).pop();
//         Navigator.of(context).pop();
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const Dashboard2()));
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {}
//     setState(() {});
//   }

//   void _showPicker(context) {
//     FocusScope.of(context).requestFocus(FocusNode());

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

//   Future getImageGallery(BuildContext context, var type) async {
//     final pickedFile =
//         await ImagePicker().getImage(source: type, imageQuality: 50);
//     final bytesdata = await pickedFile!.readAsBytes();
//     final bytes = bytesdata.buffer.lengthInBytes;

//     setState(() {
//       if (pickedFile != null) {
//         if (bytes <= 512000) {
//           setState(() {
//             _image = File(pickedFile.path);
//             imgname = _image.path.split('/').last;
//             imagebool = true;
//             print('sel img = $_image');
//           });
//         } else {
//           Fluttertoast.showToast(
//               msg:
//                   "Maximum File Size Exceeds,Please Select a File Less Than 500kb",
//               gravity: ToastGravity.CENTER);
//         }
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   getdailyearningdetails() async {
//     var url = Uri.parse(CommonURL.herokuurl);

//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };

//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "getDailyEarningDateDropDown";
//     request.fields['service_provider_c'] = service_provider;

//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       // print("daily earn = $jsonInput");

//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];

//       setState(() {
//         dailyearnindetailslist = jsonInput['data'] as List<dynamic>;
//         // print("dailyearnindetailslist$dailyearnindetailslist");
//       });
//       if (status == 'true') {
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {}
//   }

//   getSubCategoryByCategory(String title, String categoryC) async {
//     var url = Uri.parse(CommonURL.herokuurl);
//     print("categoryC$categoryC");
//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };

//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "getSubCategoryByCategory";
//     request.fields['service_provider_c'] = service_provider;
//     request.fields['category_c'] = categoryC;

//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("jsonInput=$jsonInput");
//       String status = jsonInput['status'].toString();
//       // String message = jsonInput['message'];
//       if (status == 'true') {
//         for (int i = 0; i < dailyearnindetailslist.length; i++) {
//           for (int i2 = 0;
//               i2 < dailyearnindetailslist[i]["data"].length;
//               i2++) {
//             var strinvalue =
//                 dailyearnindetailslist[i]["data"][i2]["name"].toString();
//             print("strinvalue$strinvalue");
//             if (title == strinvalue) {
//               // print("strinvalue$strinvalue");
//               // dailyearnindetailslist[i]["data"][i2]["categoryArray"] =
//               //     jsonInput['categoryData'];
//               dailyearnindetailslist[i]["data"][i2]["subcategoryArray"] =
//                   jsonInput['data'];
//               setState(() {});
//               break;
//               // dailyearnindetailslist[i]["data"][i2]["selectedCategory"] =
//               //     jsonInput['categoryData'][0]["name"];
//               setState(() {});
//             }
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

//   getdailyearningdetailsbycategory(String title, String index) async {
//     // print("dailyindex$index");
//     // print("title$title");
//     var url = Uri.parse(CommonURL.herokuurl);

//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };

//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "isAvailableChangeGetCategoryDropDown";
//     request.fields['title'] = title;
//     request.fields['service_provider_c'] = service_provider;

//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       print("category= $jsonInput");
//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//       if (status == 'true') {
//         // for (int i = 0; i < dailyearnindetailslist.length; i++) {
//         //   for (int i2 = 0; i2 < dailyearnindetailslist[i]["data"].length; i++) {
//         //     var strinvalue =
//         //         dailyearnindetailslist[i]["data"][i2]["name"].toString();
//         //     if (title == strinvalue) {
//         //       // print("strinvalue$strinvalue");
//         //       dailyearnindetailslist[i]["data"][i2]["categoryArray"] =
//         //           jsonInput['categoryData'];
//         //       // dailyearnindetailslist[i]["data"][i2]["subcategoryArray"] =
//         //       //     jsonInput['subCategoryData'];
//         //       dailyearnindetailslist[i]["data"][i2]["selectedCategory"] =
//         //           jsonInput['categoryData'][0]["name"];
//         //       setState(() {});
//         //     }
//         //   }
//         // }
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {}
//     setState(() {});
//   }

//   getdailyearningdetailsbydate() async {
//     var url = Uri.parse(CommonURL.herokuurl);

//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };

//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "getDailyEOSSPDataBYDate";
//     request.fields['selectedDate'] = change_date.toString();
//     request.fields['service_provider_c'] = service_provider;

//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);
//       // print("getdailyearningdetails= $jsonInput");

//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];

//       if (status == 'true') {
//         dailyearnindetailslist = jsonInput['data'] as List<dynamic>;
//         // print(dailyearnindetailslist[0]['name']);
//         // print(dailyearnindetailslist[1]['name']);
//         // print(dailyearnindetailslist[2]['name']);
//         // print(dailyearnindetailslist[3]['name']);
//         showbtnbool = jsonInput['isGrievanceAlreadyExist'] as bool;
//         print("showbtnbool$showbtnbool");
//         isloading = false;
//         // print(dailyearnindetailslist.length);

//         // if (status == 'true') {
//         // print(object)
//         // datedroplist = jsonInput['dateArray'];

//         // for (int i = 0; i < datedroplist.length; i++) {
//         //   var changeTodate = (datedroplist[i]['name']);
//         //   // change_date = (changetyperesult[i]['fromDate'] +
//         //   //     ' to ' +
//         //   //     changetyperesult[i]['toDate']);

//         //   changetypelist.add(changeTodate);
//         // }

//         // // datedroplist = jsonInput['dateArray'];
//         // // print("object");
//         // // print("object");
//         // setState(() {});
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {}
//     setState(() {});
//   }

//   DailyearningSubmit() async {
//     loading();
//     var url = Uri.parse(CommonURL.herokuurl);
//     // String url = CommonURL.URL;

//     Map<String, String> headers = {
//       "Accept": "application/json",
//       "Content-Type": "application/x-www-form-urlencoded"
//     };
//     // var uri = Uri.parse(url);
//     // print(utility.lithiumid);
//     // print(utility.service_provider_c);
//     // for (int i = 0; i < dailyearnindetailslist.length; i++) {
//     print(dailyearnindetailslist);
//     // }

//     var request = http.MultipartRequest("POST", url);
//     request.headers.addAll(headers);
//     request.fields['from'] = "dailyEarningAdd";
//     // change_date
//     request.fields['date'] = change_date ?? "";
//     request.fields['data'] = jsonEncode(dailyearnindetailslist);
//     request.fields['lithiumID'] = utility.lithiumid;
//     request.fields['service_provider_c'] = utility.service_provider_c;
//     if (imagebool == true) {
//       request.files
//           .add(await http.MultipartFile.fromPath('benchFile', _image.path));
//     }

//     // request.files.add(await http.MultipartFile.fromPath('file', _image.path));

//     var streamResponse = await request.send();
//     var response = await http.Response.fromStream(streamResponse);

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       Map<String, dynamic> jsonInput = jsonDecode(response.body);

//       String status = jsonInput['status'].toString();
//       String message = jsonInput['message'];
//       print("jsonInput$jsonInput");
//       if (status == 'true') {
//         // Navigator.pop(context);
//         // Navigator.pop(context);
//         Navigator.of(context, rootNavigator: true).pop();
//         // Navigator.pop(context, true);
//         // Navigator.pop(context);
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const Dashboard2()));
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );

//         // isdata = true;
//         // List array = jsonInput['data'];
//         // if (array.isNotEmpty) {
//         //   last5eoslistarray = array;
//         // }
//       } else {
//         Fluttertoast.showToast(
//           msg: message,
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//       }
//     } else {}

//     // Navigator.pop(context);
//     setState(() {});
//     // Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: CommonAppbar(
//       //   title: 'Daily Earnings',
//       //   appBar: AppBar(),
//       //   widgets: const [],
//       // ),
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Visibility(
//           visible: !isloading,
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   const Text(
//                     "Date",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Container(
//                     // width: MediaQuery.of(context).size.width - 15,
//                     height: 30,
//                     margin: const EdgeInsets.all(15.0),
//                     padding: const EdgeInsets.all(3.0),
//                     decoration: const ShapeDecoration(
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(width: 1.0, style: BorderStyle.solid),
//                         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                       ),
//                     ),
//                     child: Theme(
//                       data: Theme.of(context)
//                           .copyWith(canvasColor: Colors.grey.shade100),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton(
//                           hint: const Text("-- Select Date -- "),
//                           elevation: 0,
//                           value: change_date,
//                           items: changetypelist.map((items) {
//                             return DropdownMenuItem(
//                                 value: items,
//                                 child: Text(
//                                   " " + items.toString(),
//                                 ));
//                           }).toList(),
//                           icon: Icon(
//                             Icons.keyboard_arrow_down,
//                             color: HexColor(Colorscommon.greencolor),
//                           ),
//                           onChanged: (value) {
//                             // print("DropdownMenuItem$DropdownMenuItem");
//                             change_date = value.toString();
//                             setState(() {
//                               getdailyearningdetailsbydate();
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: SizedBox(
//                   // color: Colors.red,
//                   // height: MediaQuery.of(context).size.height - 100,
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       // itemExtent: 225.0,
//                       // the number of items in the list
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: dailyearnindetailslist.length,

//                       // padding: const EdgeInsets.all(0),
//                       // display each item of the product list
//                       itemBuilder: (context, index2) {
//                         print("indexindexindex$index2");
//                         // ignore: deprecated_member_use

//                         //debugPrint('Indexvalue' + index.toString());
//                         // debugPrint('modellength' +
//                         //     permissionModel.detail.length.toString());
//                         // print(dailyearnindetailslist[index]['data']);
//                         var array = dailyearnindetailslist[index2]['data']
//                             as List<dynamic>;
//                         // print(array);

//                         var name =
//                             dailyearnindetailslist[index2]['name'].toString();
//                         print("namenamename$name");

//                         return Container(
//                           // color: Colors.red,
//                           // height: 100,
//                           padding: const EdgeInsets.all(10),
//                           // padding: const EdgeInsets.only(
//                           //     left: 10, right: 10, top: 0, bottom: 0),
//                           child: Column(
//                             children: [
//                               Visibility(
//                                 visible: true,
//                                 child: Row(
//                                   // ignore: prefer_const_literals_to_create_immutables
//                                   children: [
//                                     // const Expanded(
//                                     //   flex: 1,
//                                     //   child: CommonText(
//                                     //     text: "GrievanceDate",
//                                     //   ),
//                                     // ),
//                                     // Expanded(
//                                     //   flex: 1,
//                                     //   child: CommonText(
//                                     //     text: dailyearnindetailslist[index]
//                                     //             ['name']
//                                     //         .toString(),
//                                     //   ),
//                                     // ),
//                                     Expanded(
//                                         child: Text(
//                                       dailyearnindetailslist[index2]['name']
//                                           .toString(),
//                                       style: TextStyle(
//                                           color:
//                                               HexColor(Colorscommon.greencolor),
//                                           fontWeight: FontWeight.w900,
//                                           fontSize: 18),
//                                     )),
//                                   ],
//                                 ),
//                               ),
//                               // Visibility(
//                               //     visible: index == 0,
//                               //     child: Column(
//                               //       children: [
//                               //         Row(
//                               //           children: [
//                               //             Expanded(
//                               //                 flex: 2,
//                               //                 child: Text(
//                               //                     array[0]['name'].toString())),
//                               //             Expanded(
//                               //               flex: 1,
//                               //               child: Text(utility.datetimetotime2(
//                               //                   array[0]['viewLabelName']
//                               //                       .toString())),
//                               //             ),
//                               //             Expanded(
//                               //                 flex: 2,
//                               //                 child: Text(
//                               //                     array[1]['name'].toString())),
//                               //             Expanded(
//                               //               flex: 1,
//                               //               child: Text(utility.datetimetotime(
//                               //                   array[1]['viewLabelName']
//                               //                       .toString())),
//                               //             )
//                               //           ],
//                               //         ),
//                               //         const SizedBox(
//                               //           height: 10,
//                               //         ),
//                               //         Row(
//                               //           children: [
//                               //             Expanded(
//                               //                 flex: 2,
//                               //                 child: Text(
//                               //                     array[2]['name'].toString())),
//                               //             Expanded(
//                               //               flex: 1,
//                               //               child: Text(utility.datetimetotime2(
//                               //                   array[2]['viewLabelName']
//                               //                       .toString())),
//                               //             ),
//                               //             Expanded(
//                               //                 flex: 2,
//                               //                 child: Text(
//                               //                     array[3]['name'].toString())),
//                               //             Expanded(
//                               //               flex: 1,
//                               //               child: Text(utility.datetimetotime(
//                               //                   array[3]['viewLabelName']
//                               //                       .toString())),
//                               //             )
//                               //           ],
//                               //         ),
//                               //       ],
//                               //     )),
//                               ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: const BouncingScrollPhysics(),
//                                   itemCount: array.length,
//                                   itemBuilder: (context, index) {
//                                     // setState(() {
//                                     TextEditingController controller =
//                                         TextEditingController();
//                                     _controllers.add(controller);
//                                     // });

//                                     // print(_controllers[index]);
//                                     // print("controllerindex$index");
//                                     // if (_controllers[index] == index) {}
//                                     String? dropdownvalueone;
//                                     String? dropdownvaluetwo;
//                                     String? dropdownvaluethree;
//                                     String? dropdownvaluefour;
//                                     // print(index);

//                                     var arrayspilt1 =
//                                         array[index]["dropdownArray"];
//                                     var arrayspilt2 =
//                                         array[index]["isAvailDropDown"];
//                                     var arrayspilt3 =
//                                         array[index]["categoryArray"];
//                                     var arrayspilt4 =
//                                         array[index]["subcategoryArray"];
//                                     String formFieldType = array[index]
//                                             ["formFieldType"]
//                                         .toString();

//                                     // if (dropdownvalueone == null) {
//                                     //   dropdownvalueone = array[index]
//                                     //           ["selectedDropDownValue"]
//                                     //       .toString();

//                                     //   print("noflow");
//                                     // } else {
//                                     //   print("flow");
//                                     //   dropdownvalueone;
//                                     // }

//                                     dropdownvalueone = array[index]
//                                             ["selectedDropDownValue"]
//                                         .toString();

//                                     // print("dropdownvalueone$dropdownvalueone");
//                                     dropdownvaluetwo = array[index]
//                                             ["selectedIsAvailValue"]
//                                         .toString();
//                                     dropdownvaluethree = array[index]
//                                             ["selectedCategory"]
//                                         .toString();
//                                     dropdownvaluefour = array[index]
//                                             ["selectedSubCategory"]
//                                         .toString();
//                                     List debitdetailarray =
//                                         array[index]['debitList'] as List;

//                                     List<String> array1 = [];
//                                     List<String> array2 = [];
//                                     List<String> array3 = [];
//                                     List<String> array4 = [];

//                                     List<String> sfidarray1 = [];
//                                     List<String> sfidarray2 = [];
//                                     List<String> sfidarray3 = [];
//                                     List<String> sfidarray4 = [];

//                                     for (int i = 0;
//                                         i < arrayspilt1.length;
//                                         i++) {
//                                       if (array[index]["name"].toString() ==
//                                           "Roster Start Time") {
//                                         String value;
//                                         if (i == 0) {
//                                           value = (arrayspilt1[i]['name']
//                                               .toString());
//                                         } else {
//                                           value = (arrayspilt1[i]['name']
//                                                   .toString() +
//                                               "( " +
//                                               arrayspilt1[i]['id'].toString() +
//                                               " )");
//                                         }

//                                         array1.add(value);
//                                       } else if (array[index]["name"]
//                                               .toString() ==
//                                           "Late") {
//                                         // print(array[index]["name"].toString());
//                                         // print("formFieldType$formFieldType");
//                                         var value = (arrayspilt1[i]
//                                                 ['start_time__c']
//                                             .toString());

//                                         array1.add(value);
//                                       } else {
//                                         var value =
//                                             (arrayspilt1[i]['name'].toString());

//                                         array1.add(value);
//                                       }
//                                       if (array[index]["name"].toString() ==
//                                           "Roster Start Time") {
//                                         var value2 = (arrayspilt1[i]
//                                                     ['roster_master__c']
//                                                 .toString() +
//                                             "," +
//                                             arrayspilt1[i]['start_time__c']
//                                                 .toString());
//                                         sfidarray1.add(value2);
//                                       } else {
//                                         var value2 = (arrayspilt1[i]
//                                                     ['roster_master__c']
//                                                 .toString() +
//                                             "," +
//                                             arrayspilt1[i]
//                                                     ['roster_start_datetime']
//                                                 .toString());
//                                         sfidarray1.add(value2);
//                                       }
//                                     }
//                                     for (int i = 0;
//                                         i < arrayspilt2.length;
//                                         i++) {
//                                       var value =
//                                           (arrayspilt2[i]['name'].toString());
//                                       array2.add(value);
//                                       var value2 =
//                                           (arrayspilt2[i]['sfid'].toString());
//                                       sfidarray2.add(value2);
//                                     }
//                                     for (int i = 0;
//                                         i < arrayspilt3.length;
//                                         i++) {
//                                       var value =
//                                           (arrayspilt3[i]['name'].toString());
//                                       array3.add(value);
//                                       var value2 =
//                                           (arrayspilt3[i]['sfid'].toString());
//                                       sfidarray3.add(value2);
//                                     }
//                                     for (int i = 0;
//                                         i < arrayspilt4.length;
//                                         i++) {
//                                       var value =
//                                           (arrayspilt4[i]['name'].toString());
//                                       array4.add(value);
//                                       var value2 =
//                                           (arrayspilt4[i]['sfid'].toString());
//                                       sfidarray4.add(value2);
//                                     }
//                                     // print(array[index]["name"].toString());
//                                     // print(array[index]["viewLabelName"]
//                                     //     .toString());
//                                     // print(
//                                     //     dailyearnindetailslist[index]['name']);

//                                     return Container(
//                                       // height: 40,
//                                       padding: const EdgeInsets.only(
//                                           top: 0,
//                                           left: 0,
//                                           right: 10,
//                                           bottom: 10),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Visibility(
//                                                 visible: dailyearnindetailslist[
//                                                             index]['id'] ==
//                                                         1 ||
//                                                     dailyearnindetailslist[
//                                                             index]['id'] ==
//                                                         2 ||
//                                                     dailyearnindetailslist[
//                                                             index]['id'] ==
//                                                         3,
//                                                 child: Expanded(
//                                                   child: GestureDetector(
//                                                     onTap: () {
//                                                       showDialog(
//                                                         context: context,
//                                                         builder: (context) {
//                                                           String contentText =
//                                                               "Content of Dialog";
//                                                           return StatefulBuilder(
//                                                             builder: (context,
//                                                                 setState) {
//                                                               return AlertDialog(
//                                                                 insetPadding:
//                                                                     const EdgeInsets
//                                                                         .all(10),
//                                                                 contentPadding:
//                                                                     EdgeInsets
//                                                                         .zero,
//                                                                 clipBehavior: Clip
//                                                                     .antiAliasWithSaveLayer,
//                                                                 title: Center(
//                                                                   child: Text(
//                                                                     dailyearnindetailslist[
//                                                                             index]
//                                                                         [
//                                                                         'name'],
//                                                                     style: TextStyle(
//                                                                         fontSize:
//                                                                             15,
//                                                                         color: HexColor(
//                                                                             Colorscommon.greenAppcolor)),
//                                                                   ),
//                                                                 ),
//                                                                 content:
//                                                                     SingleChildScrollView(
//                                                                   child: Column(
//                                                                       mainAxisSize:
//                                                                           MainAxisSize
//                                                                               .min,
//                                                                       children: [
//                                                                         Container(
//                                                                             margin: const EdgeInsets.only(
//                                                                                 top: 20,
//                                                                                 right: 10,
//                                                                                 left: 10),
//                                                                             child: Align(
//                                                                               alignment: Alignment.centerRight,
//                                                                               child: Avenirtextmedium(
//                                                                                 customfontweight: FontWeight.w500,
//                                                                                 fontsize: 14,
//                                                                                 text: dailyearnindetailslist[index]['name'],
//                                                                                 textcolor: HexColor(Colorscommon.greendark),
//                                                                               ),
//                                                                               // child: Text(
//                                                                               //   "Reason",
//                                                                               //   style: TextStyle(
//                                                                               //       fontWeight: FontWeight.bold,
//                                                                               //       color: HexColor(Colorscommon.greendark)),
//                                                                               // ),
//                                                                             )),
//                                                                         Container(
//                                                                             margin: const EdgeInsets.only(
//                                                                                 top: 10,
//                                                                                 right: 10,
//                                                                                 left: 20),
//                                                                             child: Align(
//                                                                               alignment: Alignment.centerLeft,
//                                                                               child: Avenirtextmedium(
//                                                                                 customfontweight: FontWeight.w500,
//                                                                                 fontsize: 14,
//                                                                                 text: "Category",
//                                                                                 textcolor: HexColor(Colorscommon.greendark),
//                                                                               ),
//                                                                               // child: Text(
//                                                                               //   "Reason",
//                                                                               //   style: TextStyle(
//                                                                               //       fontWeight: FontWeight.bold,
//                                                                               //       color: HexColor(Colorscommon.greendark)),
//                                                                               // ),
//                                                                             )),
//                                                                         Container(
//                                                                           margin:
//                                                                               const EdgeInsets.only(left: 0),
//                                                                           child:
//                                                                               Row(
//                                                                             children: [
//                                                                               // Expanded(
//                                                                               //     flex: 1,
//                                                                               //     child: Text(
//                                                                               //       'Reason *',
//                                                                               //       style: TextStyle(
//                                                                               //           fontWeight: FontWeight.bold,
//                                                                               //           color: HexColor(Colorscommon.greencolor)),
//                                                                               //     )),
//                                                                               Expanded(
//                                                                                 flex: 2,
//                                                                                 child: Container(
//                                                                                   height: 40,
//                                                                                   margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
//                                                                                   padding: const EdgeInsets.all(3.0),
//                                                                                   decoration: const ShapeDecoration(
//                                                                                     shape: RoundedRectangleBorder(
//                                                                                       side: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
//                                                                                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                                     ),
//                                                                                     color: Colors.white,
//                                                                                   ),
//                                                                                   child: Theme(
//                                                                                     data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                                     child: DropdownButtonHideUnderline(
//                                                                                       child: DropdownButton(
//                                                                                         hint: Row(children: [
//                                                                                           Container(
//                                                                                             width: 20,
//                                                                                             height: 20,
//                                                                                             decoration: const BoxDecoration(
//                                                                                               image: DecorationImage(
//                                                                                                 image: AssetImage("assets/Reason.png"),
//                                                                                                 fit: BoxFit.fitHeight,
//                                                                                               ),
//                                                                                             ),
//                                                                                           ),
//                                                                                           const SizedBox(
//                                                                                             width: 5,
//                                                                                           ),
//                                                                                           const Text("Select Category")
//                                                                                         ]),
//                                                                                         //           \Avenirtextmedium(
//                                                                                         //   customfontweight: FontWeight.normal,
//                                                                                         //   fontsize: 14,
//                                                                                         //   text: "Reason",
//                                                                                         //   textcolor: HexColor(Colorscommon.greendark),
//                                                                                         // ),

//                                                                                         style: TextStyle(fontSize: 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
//                                                                                         elevation: 0,
//                                                                                         value: dailyearnindetailslist[index]["selectedCategory"].toString(),
//                                                                                         items: array3.map((items) {
//                                                                                           return DropdownMenuItem(
//                                                                                               value: items,
//                                                                                               child: Row(
//                                                                                                 children: [
//                                                                                                   Container(
//                                                                                                     width: 20,
//                                                                                                     height: 20,
//                                                                                                     decoration: const BoxDecoration(
//                                                                                                       image: DecorationImage(
//                                                                                                         image: AssetImage("assets/Reason.png"),
//                                                                                                         fit: BoxFit.fitHeight,
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                   const SizedBox(
//                                                                                                     width: 5,
//                                                                                                   ),
//                                                                                                   Text(
//                                                                                                     items.toString(),
//                                                                                                   ),
//                                                                                                 ],
//                                                                                               ));
//                                                                                         }).toList(),

//                                                                                         icon: Icon(
//                                                                                           Icons.keyboard_arrow_down,
//                                                                                           color: HexColor(Colorscommon.greenlight2),
//                                                                                         ),
//                                                                                         onChanged: (value) {
//                                                                                           setState(() {
//                                                                                             dailyearnindetailslist[index]["selectedCategory"] = value.toString();
//                                                                                             // dailyearnindetailslist[index]["selectedCategory"] = value.toString();
//                                                                                           });
//                                                                                           // print("dropdownchangevalue$value");

//                                                                                           // dropdownvalue = value.toString();
//                                                                                           // for (int i = 0; i < array3.length; i++) {
//                                                                                           //   // print(jsonInput['data'][i]);

//                                                                                           // }

//                                                                                           // setState(() {});

//                                                                                           // setState(() {});

//                                                                                           // for (var i = 0; array3.length > i; i++) {
//                                                                                           //   // print(
//                                                                                           //   //     array3[i].toString());
//                                                                                           //   // print(
//                                                                                           //   //     value.toString());
//                                                                                           //   if (value.toString() != "Select Category") {
//                                                                                           //     if (array3[i].toString() == value.toString()) {
//                                                                                           //       arrayspilt4 = [];
//                                                                                           //       array4 = [];
//                                                                                           //       sfidarray4 = [];
//                                                                                           //       arrayspilt4 = arrayspilt3[i]['subcategoryData'];

//                                                                                           //       String datevalue = sfidarray3[i];
//                                                                                           //       // getSubCategoryByCategory(dailyearnindetailslist[index]["name"].toString(), datevalue, index, index);
//                                                                                           //       // dailyearnindetailslist[index]["selectedCategoryId"] = datevalue.toString();
//                                                                                           //       dailyearnindetailslist[index]["selectedCategoryId"] = datevalue.toString();
//                                                                                           //       setState() {}
//                                                                                           //       print("dataarrayspeed$arrayspilt4");
//                                                                                           //       print(dailyearnindetailslist[index]["selectedCategoryId"].toString());
//                                                                                           //       print(dailyearnindetailslist[index]["selectedCategoryId"].toString());
//                                                                                           //       for (int i = 0; i < arrayspilt4.length; i++) {
//                                                                                           //         var value = (arrayspilt4[i]['name'].toString());
//                                                                                           //         array4.add(value);
//                                                                                           //         var value2 = (arrayspilt4[i]['sfid'].toString());
//                                                                                           //         sfidarray4.add(value2);
//                                                                                           //       }
//                                                                                           //       break;
//                                                                                           //     }
//                                                                                           //   } else {
//                                                                                           //     setState() {}
//                                                                                           //   }
//                                                                                           // }

//                                                                                           // for (int i = 0;
//                                                                                           //     i < data["devliverypoints"].length;
//                                                                                           //     i++) {
//                                                                                           //   if (value ==
//                                                                                           //       data["devliverypoints"][i]
//                                                                                           //               ["warehouseName"]
//                                                                                           //           .toString()) {
//                                                                                           //     dropdownvalue = value.toString();
//                                                                                           //     address = data["devliverypoints"][i]
//                                                                                           //             ["warehouseAddress"]
//                                                                                           //         .toString();
//                                                                                           //     idwarehouse = data["devliverypoints"][i]
//                                                                                           //             ["idWarehouse"]
//                                                                                           //         .toString();
//                                                                                           //     // print(data["devliverypoints"][i]
//                                                                                           //     //         ["idWarehouse"]
//                                                                                           //     //     .toString());
//                                                                                           //   }
//                                                                                           // }
//                                                                                           // setState(() {});
//                                                                                         },
//                                                                                         // onChanged: (String? value) {
//                                                                                         //   //  setState(() {
//                                                                                         //   //   dropdownvalue = value!;
//                                                                                         //   // });
//                                                                                         //   },
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                         Visibility(
//                                                                           visible:
//                                                                               dailyearnindetailslist[index]["selectedCategory"].toString() != "Select Category",
//                                                                           child: Container(
//                                                                               margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
//                                                                               child: Align(
//                                                                                 alignment: Alignment.centerLeft,
//                                                                                 child: Avenirtextmedium(
//                                                                                   customfontweight: FontWeight.w500,
//                                                                                   fontsize: 14,
//                                                                                   text: "SubCategory",
//                                                                                   textcolor: HexColor(Colorscommon.greendark),
//                                                                                 ),
//                                                                                 // child: Text(
//                                                                                 //   "Reason",
//                                                                                 //   style: TextStyle(
//                                                                                 //       fontWeight: FontWeight.bold,
//                                                                                 //       color: HexColor(Colorscommon.greendark)),
//                                                                                 // ),
//                                                                               )),
//                                                                         ),
//                                                                         Visibility(
//                                                                           visible:
//                                                                               dailyearnindetailslist[index]["selectedCategory"].toString() != "Select Category",
//                                                                           child:
//                                                                               Container(
//                                                                             margin:
//                                                                                 const EdgeInsets.only(left: 0),
//                                                                             child:
//                                                                                 Row(
//                                                                               children: [
//                                                                                 // Expanded(
//                                                                                 //     flex: 1,
//                                                                                 //     child: Text(
//                                                                                 //       'Reason *',
//                                                                                 //       style: TextStyle(
//                                                                                 //           fontWeight: FontWeight.bold,
//                                                                                 //           color: HexColor(Colorscommon.greencolor)),
//                                                                                 //     )),
//                                                                                 Expanded(
//                                                                                   flex: 2,
//                                                                                   child: Container(
//                                                                                     height: 40,
//                                                                                     margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
//                                                                                     padding: const EdgeInsets.all(3.0),
//                                                                                     decoration: const ShapeDecoration(
//                                                                                       shape: RoundedRectangleBorder(
//                                                                                         side: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
//                                                                                         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                                       ),
//                                                                                       color: Colors.white,
//                                                                                     ),
//                                                                                     child: Theme(
//                                                                                       data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                                       child: DropdownButtonHideUnderline(
//                                                                                         child: DropdownButton(
//                                                                                           hint: Row(children: [
//                                                                                             Container(
//                                                                                               width: 20,
//                                                                                               height: 20,
//                                                                                               decoration: const BoxDecoration(
//                                                                                                 image: DecorationImage(
//                                                                                                   image: AssetImage("assets/Reason.png"),
//                                                                                                   fit: BoxFit.fitHeight,
//                                                                                                 ),
//                                                                                               ),
//                                                                                             ),
//                                                                                             const SizedBox(
//                                                                                               width: 5,
//                                                                                             ),
//                                                                                             const Text("Select SubCategory")
//                                                                                           ]),
//                                                                                           //           \Avenirtextmedium(
//                                                                                           //   customfontweight: FontWeight.normal,
//                                                                                           //   fontsize: 14,
//                                                                                           //   text: "Reason",
//                                                                                           //   textcolor: HexColor(Colorscommon.greendark),
//                                                                                           // ),

//                                                                                           style: TextStyle(fontSize: 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
//                                                                                           elevation: 0,
//                                                                                           value: dailyearnindetailslist[index]["selectedSubCategory"].toString(),
//                                                                                           items: array4.map((items) {
//                                                                                             return DropdownMenuItem(
//                                                                                                 value: items,
//                                                                                                 child: Row(
//                                                                                                   children: [
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
//                                                                                                     Text(
//                                                                                                       items.toString(),
//                                                                                                     ),
//                                                                                                   ],
//                                                                                                 ));
//                                                                                           }).toList(),

//                                                                                           icon: Icon(
//                                                                                             Icons.keyboard_arrow_down,
//                                                                                             color: HexColor(Colorscommon.greenlight2),
//                                                                                           ),
//                                                                                           onChanged: (value) {
//                                                                                             // print("dropdownchangevalue$value");
//                                                                                             dailyearnindetailslist[index]["selectedSubCategory"] = value.toString();
//                                                                                             // for()
//                                                                                             // selectedSubCategoryId
//                                                                                             // dropdownvalue = value.toString();
//                                                                                             // for (int i = 0; i < array3.length; i++) {
//                                                                                             //   // print(jsonInput['data'][i]);

//                                                                                             // }
//                                                                                             setState;
//                                                                                             setState(() {});
//                                                                                             // for (var i = 0; array4.length > i; i++) {
//                                                                                             //   // print(
//                                                                                             //   //     array3[i].toString());
//                                                                                             //   // print(
//                                                                                             //   //     value.toString());
//                                                                                             //   if (value.toString() != "Select SubCategory") {
//                                                                                             //     if (array4[i].toString() == value.toString()) {
//                                                                                             //       dailyearnindetailslist[index]["selectedSubCategoryId"] = arrayspilt4[i]["sfid"].toString();

//                                                                                             //       setState() {}

//                                                                                             //       break;
//                                                                                             //     }
//                                                                                             //   } else {
//                                                                                             //     setState() {}
//                                                                                             //   }
//                                                                                             // }
//                                                                                           },
//                                                                                           // onChanged: (String? value) {
//                                                                                           //   //  setState(() {
//                                                                                           //   //   dropdownvalue = value!;
//                                                                                           //   // });
//                                                                                           //   },
//                                                                                         ),
//                                                                                       ),
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         Visibility(
//                                                                           visible:
//                                                                               dailyearnindetailslist[index]["selectedCategory"].toString() != "Select Category",
//                                                                           child:
//                                                                               Visibility(
//                                                                             visible:
//                                                                                 dailyearnindetailslist[index]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                             child:
//                                                                                 Visibility(
//                                                                               visible: dailyearnindetailslist[index]["selectedSubCategory"].toString() == "Wrong Roster",
//                                                                               child: Container(
//                                                                                   margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
//                                                                                   child: Align(
//                                                                                     alignment: Alignment.centerLeft,
//                                                                                     child: Avenirtextmedium(
//                                                                                       customfontweight: FontWeight.w500,
//                                                                                       fontsize: 14,
//                                                                                       text: "Select Roster",
//                                                                                       textcolor: HexColor(Colorscommon.greendark),
//                                                                                     ),
//                                                                                     // child: Text(
//                                                                                     //   "Reason",
//                                                                                     //   style: TextStyle(
//                                                                                     //       fontWeight: FontWeight.bold,
//                                                                                     //       color: HexColor(Colorscommon.greendark)),
//                                                                                     // ),
//                                                                                   )),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         Visibility(
//                                                                           visible:
//                                                                               dailyearnindetailslist[index]["selectedCategory"].toString() != "Select Category",
//                                                                           child:
//                                                                               Visibility(
//                                                                             visible:
//                                                                                 dailyearnindetailslist[index]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                             child:
//                                                                                 Visibility(
//                                                                               visible: dailyearnindetailslist[index]["selectedSubCategory"].toString() == "Wrong Roster",
//                                                                               child: Container(
//                                                                                 margin: const EdgeInsets.only(left: 0),
//                                                                                 child: Row(
//                                                                                   children: const [
//                                                                                     // Expanded(
//                                                                                     //     flex: 1,
//                                                                                     //     child: Text(
//                                                                                     //       'Reason *',
//                                                                                     //       style: TextStyle(
//                                                                                     //           fontWeight: FontWeight.bold,
//                                                                                     //           color: HexColor(Colorscommon.greencolor)),
//                                                                                     //     )),
//                                                                                     // Expanded(
//                                                                                     //   flex: 2,
//                                                                                     //   child: Container(
//                                                                                     //     height: 40,
//                                                                                     //     margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
//                                                                                     //     padding: const EdgeInsets.all(3.0),
//                                                                                     //     decoration: const ShapeDecoration(
//                                                                                     //       shape: RoundedRectangleBorder(
//                                                                                     //         side: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
//                                                                                     //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                                     //       ),
//                                                                                     //       color: Colors.white,
//                                                                                     //     ),
//                                                                                     //     child: Theme(
//                                                                                     //       data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                                     //       child: DropdownButtonHideUnderline(
//                                                                                     //         child: DropdownButton(
//                                                                                     //           hint: Row(children: [
//                                                                                     //             Container(
//                                                                                     //               width: 20,
//                                                                                     //               height: 20,
//                                                                                     //               decoration: const BoxDecoration(
//                                                                                     //                 image: DecorationImage(
//                                                                                     //                   image: AssetImage("assets/Reason.png"),
//                                                                                     //                   fit: BoxFit.fitHeight,
//                                                                                     //                 ),
//                                                                                     //               ),
//                                                                                     //             ),
//                                                                                     //             const SizedBox(
//                                                                                     //               width: 5,
//                                                                                     //             ),
//                                                                                     //             const Text("Select Roster")
//                                                                                     //           ]),
//                                                                                     //           //           \Avenirtextmedium(
//                                                                                     //           //   customfontweight: FontWeight.normal,
//                                                                                     //           //   fontsize: 14,
//                                                                                     //           //   text: "Reason",
//                                                                                     //           //   textcolor: HexColor(Colorscommon.greendark),
//                                                                                     //           // ),

//                                                                                     //           style: TextStyle(fontSize: 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
//                                                                                     //           elevation: 0,
//                                                                                     //           value: (dailyearnindetailslist[index]["selectedDrowdownValue"].toString() == "") ? "Select Roster" : dailyearnindetailslist[index]["selectedDrowdownValue"].toString(),
//                                                                                     //           items: array5.map((items) {
//                                                                                     //             return DropdownMenuItem(
//                                                                                     //                 value: items,
//                                                                                     //                 child: Row(
//                                                                                     //                   children: [
//                                                                                     //                     Container(
//                                                                                     //                       width: 20,
//                                                                                     //                       height: 20,
//                                                                                     //                       decoration: const BoxDecoration(
//                                                                                     //                         image: DecorationImage(
//                                                                                     //                           image: AssetImage("assets/Reason.png"),
//                                                                                     //                           fit: BoxFit.fitHeight,
//                                                                                     //                         ),
//                                                                                     //                       ),
//                                                                                     //                     ),
//                                                                                     //                     const SizedBox(
//                                                                                     //                       width: 5,
//                                                                                     //                     ),
//                                                                                     //                     Text(
//                                                                                     //                       items.toString(),
//                                                                                     //                     ),
//                                                                                     //                   ],
//                                                                                     //                 ));
//                                                                                     //           }).toList(),

//                                                                                     //           icon: Icon(
//                                                                                     //             Icons.keyboard_arrow_down,
//                                                                                     //             color: HexColor(Colorscommon.greenlight2),
//                                                                                     //           ),
//                                                                                     //           onChanged: (value) {
//                                                                                     //             dailyearnindetailslist[index]["selectedDrowdownValue"] = value.toString();

//                                                                                     //             for (var i = 0; array5.length > i; i++) {
//                                                                                     //               dailyearnindetailslist[index]["selectedDrowdownValue"] = value.toString();
//                                                                                     //               setState(() {});
//                                                                                     //               print(array5[i].toString());
//                                                                                     //               print("value$value");
//                                                                                     //               if (array5[i].toString() == value.toString()) {
//                                                                                     //                 var datevalue = sfidarray5[i];
//                                                                                     //                 print("sucessdatevalue");
//                                                                                     //                 setState(() {
//                                                                                     //                   dailyearnindetailslist[index]["selectedDrowdownId"] = datevalue.toString();
//                                                                                     //                 });
//                                                                                     //                 break;
//                                                                                     //               }
//                                                                                     //             }
//                                                                                     //             setState(() {});
//                                                                                     //           },
//                                                                                     //         ),
//                                                                                     //       ),
//                                                                                     //     ),
//                                                                                     //   ),
//                                                                                     // ),
//                                                                                   ],
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         Visibility(
//                                                                           visible:
//                                                                               dailyearnindetailslist[index]["selectedCategory"].toString() != "Select Category",
//                                                                           child:
//                                                                               Visibility(
//                                                                             visible:
//                                                                                 dailyearnindetailslist[index]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                             child:
//                                                                                 Visibility(
//                                                                               visible: dailyearnindetailslist[index]["name"] != "Total No of Late Days",
//                                                                               child: Container(
//                                                                                   margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
//                                                                                   child: Align(
//                                                                                     alignment: Alignment.centerLeft,
//                                                                                     child: Avenirtextmedium(
//                                                                                       customfontweight: FontWeight.w500,
//                                                                                       fontsize: 14,
//                                                                                       text: "No of Trip",
//                                                                                       textcolor: HexColor(Colorscommon.greendark),
//                                                                                     ),
//                                                                                     // child: Text(
//                                                                                     //   "Reason",
//                                                                                     //   style: TextStyle(
//                                                                                     //       fontWeight: FontWeight.bold,
//                                                                                     //       color: HexColor(Colorscommon.greendark)),
//                                                                                     // ),
//                                                                                   )),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         Visibility(
//                                                                           visible:
//                                                                               dailyearnindetailslist[index]["selectedCategory"].toString() != "Select Category",
//                                                                           child:
//                                                                               Visibility(
//                                                                             visible:
//                                                                                 dailyearnindetailslist[index]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                             child:
//                                                                                 Visibility(
//                                                                               visible: dailyearnindetailslist[index]["name"] != "Total No of Late Days",
//                                                                               child: Container(
//                                                                                 margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
//                                                                                 // margin: const EdgeInsets.all(10.0),
//                                                                                 height: 30,
//                                                                                 child: Theme(
//                                                                                   data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                                   child: TextField(
//                                                                                     controller: _controllers[index],
//                                                                                     onChanged: (valuestr) {
//                                                                                       // print("valuestr$valuestr");
//                                                                                       dailyearnindetailslist[index]["noOftripperformed"] = valuestr;
//                                                                                       dailyearnindetailslist[index]["noOftripperformed"] = valuestr;
//                                                                                     },
//                                                                                     onSubmitted: (valuestr) {
//                                                                                       // array[index]["selectedDropDownId"] =
//                                                                                       //     valuestr;
//                                                                                       _controllers[index].text = valuestr;
//                                                                                       // array[index]["selectedDropDownId"] =
//                                                                                       //     valuestr;

//                                                                                       // print("valuestr$valuestr");
//                                                                                       setState(() {});
//                                                                                     },
//                                                                                     maxLength: 5,
//                                                                                     keyboardType: TextInputType.number,
//                                                                                     decoration: const InputDecoration(
//                                                                                         hintText: 'No of Trips Performed',
//                                                                                         // labelText: array[index]["selectedDropDownId"].toString(),
//                                                                                         counterText: ""),
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         Visibility(
//                                                                           visible:
//                                                                               true,
//                                                                           // visible:
//                                                                           //     isWeeklyEarningAlreadyExist == "false",
//                                                                           child:
//                                                                               Visibility(
//                                                                             visible:
//                                                                                 true,
//                                                                             // visible: dropdownvaluetwo == "Grievance",
//                                                                             child:
//                                                                                 Visibility(
//                                                                               visible: dailyearnindetailslist[index]["selectedCategory"].toString() != "Select Category",
//                                                                               child: Visibility(
//                                                                                 // visible: true,
//                                                                                 visible: dailyearnindetailslist[index]["name"].toString().toUpperCase() == "Total no of Bench days".toUpperCase(),
//                                                                                 child: Visibility(
//                                                                                   visible: dailyearnindetailslist[index]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                   child: Visibility(
//                                                                                     visible: dailyearnindetailslist[index]["selectedSubCategory"] != "No Trip Sheet",
//                                                                                     child: Row(
//                                                                                       mainAxisAlignment: MainAxisAlignment.start,
//                                                                                       children: [
//                                                                                         Expanded(
//                                                                                           flex: 1,
//                                                                                           child: Container(
//                                                                                               margin: const EdgeInsets.only(top: 5, right: 10, left: 20),
//                                                                                               child: Align(
//                                                                                                   alignment: Alignment.centerLeft,
//                                                                                                   child: Avenirtextmedium(
//                                                                                                     customfontweight: FontWeight.w500,
//                                                                                                     fontsize: 15,
//                                                                                                     text: 'Upload Attachments',
//                                                                                                     textcolor: HexColor(Colorscommon.greendark),
//                                                                                                   )
//                                                                                                   // child: Text(
//                                                                                                   //   "Upload Attachments",
//                                                                                                   //   style: TextStyle(
//                                                                                                   //       fontWeight: FontWeight.w400,
//                                                                                                   //       color: HexColor(Colorscommon.greendark2)),
//                                                                                                   // ),
//                                                                                                   )),
//                                                                                         ),
//                                                                                         Expanded(
//                                                                                           flex: 1,
//                                                                                           child: Row(
//                                                                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                                                             children: [
//                                                                                               Bouncing(
//                                                                                                 onPress: () {
//                                                                                                   FocusManager.instance.primaryFocus?.unfocus();
//                                                                                                   _showPicker(context);
//                                                                                                   setState;
//                                                                                                 },
//                                                                                                 child: Container(
//                                                                                                   margin: const EdgeInsets.only(top: 10, right: 0, left: 10),
//                                                                                                   child: Align(
//                                                                                                     alignment: Alignment.centerLeft,
//                                                                                                     child: Container(
//                                                                                                       width: MediaQuery.of(context).size.width / 3,
//                                                                                                       height: 40,
//                                                                                                       decoration: ShapeDecoration(
//                                                                                                         shape: RoundedRectangleBorder(
//                                                                                                           side: BorderSide(
//                                                                                                             width: 0.0,
//                                                                                                             style: BorderStyle.solid,
//                                                                                                             color: HexColor(Colorscommon.greenlight2),
//                                                                                                           ),
//                                                                                                           borderRadius: const BorderRadius.all(Radius.circular(5.0)),
//                                                                                                         ),
//                                                                                                       ),
//                                                                                                       child: Row(
//                                                                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                                                                         // ignore: prefer_const_literals_to_create_immutables
//                                                                                                         children: [
//                                                                                                           Container(
//                                                                                                             width: 20,
//                                                                                                             height: 20,
//                                                                                                             decoration: const BoxDecoration(
//                                                                                                               image: DecorationImage(
//                                                                                                                 image: AssetImage("assets/Upload.png"),
//                                                                                                                 fit: BoxFit.fitHeight,
//                                                                                                               ),
//                                                                                                             ),
//                                                                                                           ),
//                                                                                                           Flexible(
//                                                                                                               flex: 1,
//                                                                                                               child: Avenirtextmedium(
//                                                                                                                 customfontweight: FontWeight.w500,
//                                                                                                                 fontsize: 15,
//                                                                                                                 text: imgname != '' ? ' File Attached' : ' Upload files',
//                                                                                                                 textcolor: HexColor(Colorscommon.greydark2),
//                                                                                                               )
//                                                                                                               // child: Text(
//                                                                                                               //   imgname != ''
//                                                                                                               //       ? ' File Attached'
//                                                                                                               //       : ' Upload files',
//                                                                                                               //   style: TextStyle(
//                                                                                                               //       color: HexColor(
//                                                                                                               //           Colorscommon.greydark2),
//                                                                                                               //       fontFamily: "TomaSans-Regular"),
//                                                                                                               // ),
//                                                                                                               ),
//                                                                                                         ],
//                                                                                                       ),
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                 ),
//                                                                                               ),
//                                                                                               Visibility(
//                                                                                                 visible: imgname != '',
//                                                                                                 child: Padding(
//                                                                                                   padding: const EdgeInsets.only(top: 6.0),
//                                                                                                   child: IconButton(
//                                                                                                     icon: const Icon(Icons.delete_forever),
//                                                                                                     color: Colors.red,
//                                                                                                     onPressed: () {
//                                                                                                       setState(() {
//                                                                                                         imgname = '';
//                                                                                                         imagebool = false;
//                                                                                                       });
//                                                                                                     },
//                                                                                                   ),
//                                                                                                 ),
//                                                                                               )
//                                                                                             ],
//                                                                                           ),
//                                                                                         ),
//                                                                                       ],
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),

//                                                                         //  //     true,
//                                                                         //                                                                           visible:
//                                                                         //                                                                               isNoGrievanceExist == "false",
//                                                                         //                                                                           child:
//                                                                         //                                                                               Visibility(
//                                                                         //                                                                             visible: true,
//                                                                         //                                                                             // visible:
//                                                                         //                                                                             //     isWeeklyEarningAlreadyExist == "false",
//                                                                         //                                                                             child: Visibility(
//                                                                         //                                                                               visible: true,
//                                                                         //                                                                               // visible: dropdownvaluetwo == "Grievance",
//                                                                         //                                                                               child: Visibility(
//                                                                         //                                                                                 // visible: true,
//                                                                         //                                                                                 visible: dailyearnindetailslist[index]["name"].toString().toUpperCase() == "Total no of Bench days".toUpperCase(),
//                                                                         //                                                                                 child: Visibility(
//                                                                         //                                                                                   visible: dailyearnindetailslist[index]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                         //                                                                                   child: Visibility(
//                                                                         //                                                                                     visible: dailyearnindetailslist[index]["selectedSubCategory"] != "No Trip Sheet",

//                                                                         Visibility(
//                                                                           visible:
//                                                                               dailyearnindetailslist[index]["selectedCategory"].toString() != "Select Category",
//                                                                           child:
//                                                                               Visibility(
//                                                                             visible:
//                                                                                 dailyearnindetailslist[index]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                             child:
//                                                                                 Visibility(
//                                                                               visible: true,
//                                                                               child: Visibility(
//                                                                                 visible: true,
//                                                                                 // visible: _controllers[index].text != '',
//                                                                                 child: Visibility(
//                                                                                   visible: true,
//                                                                                   child: Bouncing(
//                                                                                     onPress: () async {
//                                                                                       if (dailyearnindetailslist[index]["name"] == "Total No of Bench Days" || dailyearnindetailslist[index]["name"] == "Total No of EOS Days" || dailyearnindetailslist[index]["name"] == "Total No of UEOS Days") {
//                                                                                         if (_controllers[index].text == "" || _controllers[index].text == "0") {
//                                                                                           Fluttertoast.showToast(
//                                                                                             msg: "Please Enter Vaild No of Trip",
//                                                                                             toastLength: Toast.LENGTH_SHORT,
//                                                                                             gravity: ToastGravity.CENTER,
//                                                                                           );
//                                                                                           // print('validate date in flutter');
//                                                                                         } else if (dailyearnindetailslist[index]["name"] == "Total No of Bench Days") {
//                                                                                           if (dailyearnindetailslist[index]["selectedSubCategory"].toString() != "No Trip Sheet") {
//                                                                                             if (imgname == "") {
//                                                                                               Fluttertoast.showToast(
//                                                                                                 msg: "Please Upload " + dailyearnindetailslist[index]["name"].toString() + " File",
//                                                                                                 toastLength: Toast.LENGTH_SHORT,
//                                                                                                 gravity: ToastGravity.CENTER,
//                                                                                               );
//                                                                                             } else {
//                                                                                               dailyearnindetailslist[index]["dateArray"][index]['selectedCategoryId'] = dailyearnindetailslist[index]["selectedCategoryId"].toString();
//                                                                                               dailyearnindetailslist[index]["dateArray"][index]['selectedSubCategoryId'] = dailyearnindetailslist[index]["selectedSubCategoryId"].toString();

//                                                                                               dailyearnindetailslist[index]["dateArray"][index]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                               dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownId'] = dailyearnindetailslist[index]["selectedDrowdownId"].toString();
//                                                                                               dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownValue'] = dailyearnindetailslist[index]["selectedDrowdownValue"].toString();
//                                                                                               dailyearnindetailslist[index]["dateArray"][index]['statusValue'] = 'Grievance';
//                                                                                               dailyearnindetailslist[index]['statusValue'] = 'Grievance';
//                                                                                               // dailyearnindetailslist[index]["dateArray"][index]['benchFileName'] = benchFileName;
//                                                                                               Navigator.pop(context);
//                                                                                             }
//                                                                                           } else {
//                                                                                             // print('validate date2345 in flutter');
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['selectedCategoryId'] = dailyearnindetailslist[index]["selectedCategoryId"].toString();
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['selectedSubCategoryId'] = dailyearnindetailslist[index]["selectedSubCategoryId"].toString();

//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownId'] = dailyearnindetailslist[index]["selectedDrowdownId"].toString();
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownValue'] = dailyearnindetailslist[index]["selectedDrowdownValue"].toString();
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['statusValue'] = 'Grievance';
//                                                                                             dailyearnindetailslist[index]['statusValue'] = 'Grievance';
//                                                                                             // dailyearnindetailslist[index]["dateArray"][index]['benchFileName'] = benchFileName;
//                                                                                             Navigator.pop(context);
//                                                                                           }
//                                                                                         } else {
//                                                                                           // print('validate date2345 in flutter');
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedCategoryId'] = dailyearnindetailslist[index]["selectedCategoryId"].toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedSubCategoryId'] = dailyearnindetailslist[index]["selectedSubCategoryId"].toString();

//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownId'] = dailyearnindetailslist[index]["selectedDrowdownId"].toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownValue'] = dailyearnindetailslist[index]["selectedDrowdownValue"].toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['statusValue'] = 'Grievance';
//                                                                                           dailyearnindetailslist[index]['statusValue'] = 'Grievance';
//                                                                                           // dailyearnindetailslist[index]["dateArray"][index]['benchFileName'] = benchFileName;
//                                                                                           Navigator.pop(context);
//                                                                                         }
//                                                                                       } else if (dailyearnindetailslist[index]["name"] == "Total No of Late Days") {
//                                                                                         if (dailyearnindetailslist[index]["selectedSubCategory"].toString() == "Adhoc Duty") {
//                                                                                           // print('validate date2345 in flutter');
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedCategoryId'] = dailyearnindetailslist[index]["selectedCategoryId"].toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedSubCategoryId'] = dailyearnindetailslist[index]["selectedSubCategoryId"].toString();

//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownId'] = dailyearnindetailslist[index]["selectedDrowdownId"].toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownValue'] = dailyearnindetailslist[index]["selectedDrowdownValue"].toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['statusValue'] = 'Grievance';
//                                                                                           dailyearnindetailslist[index]['statusValue'] = 'Grievance';
//                                                                                           // dailyearnindetailslist[index]["dateArray"][index]['benchFileName'] = benchFileName;
//                                                                                           Navigator.pop(context);
//                                                                                         } else if (dailyearnindetailslist[index]["selectedSubCategory"] == "Wrong Roster") {
//                                                                                           print(dailyearnindetailslist[index]["selectedDrowdownValue"]);
//                                                                                           if (dailyearnindetailslist[index]["selectedDrowdownValue"] == "Select Roster" || dailyearnindetailslist[index]["selectedDrowdownValue"] == "") {
//                                                                                             Fluttertoast.showToast(
//                                                                                               msg: "Please Select Roster",
//                                                                                               toastLength: Toast.LENGTH_SHORT,
//                                                                                               gravity: ToastGravity.CENTER,
//                                                                                             );
//                                                                                             // print('validate date2345 in flutter');

//                                                                                           } else {
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['selectedCategoryId'] = dailyearnindetailslist[index]["selectedCategoryId"].toString();
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['selectedSubCategoryId'] = dailyearnindetailslist[index]["selectedSubCategoryId"].toString();

//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownId'] = dailyearnindetailslist[index]["selectedDrowdownId"].toString();
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownValue'] = dailyearnindetailslist[index]["selectedDrowdownValue"].toString();
//                                                                                             dailyearnindetailslist[index]["dateArray"][index]['statusValue'] = 'Grievance';
//                                                                                             dailyearnindetailslist[index]['statusValue'] = 'Grievance';
//                                                                                             // dailyearnindetailslist[index]["dateArray"][index]['benchFileName'] = benchFileName;
//                                                                                             Navigator.pop(context);
//                                                                                           }
//                                                                                         } else {
//                                                                                           // print('validate date2345 in flutter');
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedCategoryId'] = dailyearnindetailslist[index]["selectedCategoryId"].toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedSubCategoryId'] = dailyearnindetailslist[index]["selectedSubCategoryId"].toString();

//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['noOftripperformed'] = _controllers[index].text.toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownId'] = dailyearnindetailslist[index]["selectedDrowdownId"].toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['selectedDrowdownValue'] = dailyearnindetailslist[index]["selectedDrowdownValue"].toString();
//                                                                                           dailyearnindetailslist[index]["dateArray"][index]['statusValue'] = 'Grievance';
//                                                                                           dailyearnindetailslist[index]['statusValue'] = 'Grievance';
//                                                                                           // dailyearnindetailslist[index]["dateArray"][index]['benchFileName'] = benchFileName;
//                                                                                           Navigator.pop(context);
//                                                                                         }
//                                                                                       }
//                                                                                       // } else {
//                                                                                       //   // print('$dailyearnindetailslist[$index]["name"]');
//                                                                                       // }
//                                                                                       //        visible: dailyearnindetailslist[index]["name"].toString().toUpperCase() == "Total no of Bench days".toUpperCase(),
//                                                                                       // child: Visibility(
//                                                                                       //   visible: dailyearnindetailslist[index]["selectedSubCategory"].toString() != "Select SubCategory",
//                                                                                       //   child: Visibility(
//                                                                                       // visible: dailyearnindetailslist[index]["selectedSubCategory"] != "No Trip Sheet",
//                                                                                       //     child: Row(

//                                                                                       // dailyearnindetailslist[index]["dateArray"][index]
//                                                                                       //     [
//                                                                                       //     'selectedCategoryId'] = dailyearnindetailslist[index]
//                                                                                       //         ["selectedCategoryId"]
//                                                                                       //     .toString();
//                                                                                       // dailyearnindetailslist[index]["dateArray"][index]
//                                                                                       //     [
//                                                                                       //     'selectedCategoryId'] = dailyearnindetailslist[index]
//                                                                                       //         ["selectedCategoryId"]
//                                                                                       //     .toString();
//                                                                                       //     .toString()
//                                                                                       // print(dailyearnindetailslist[index]["selectedCategoryId"]
//                                                                                       //     .toString());
//                                                                                       // print(dailyearnindetailslist[index]["selectedSubCategoryId"]
//                                                                                       //     .toString());
//                                                                                       // dailyearnindetailslist[index]
//                                                                                       //     [
//                                                                                       //     "noOftripperformed"] = _controllers[
//                                                                                       //         index]
//                                                                                       //     .text;
//                                                                                       // print(dailyearnindetailslist[index]
//                                                                                       //     [
//                                                                                       //     "noOftripperformed"]);
//                                                                                       // print(dailyearnindetailslist[index]
//                                                                                       //     [
//                                                                                       //     "selectedDrowdownId"]);
//                                                                                       // print(dailyearnindetailslist[index]
//                                                                                       //     [
//                                                                                       //     "selectedDrowdownValue"]);

//                                                                                       // Raise_no_griveanceapi(
//                                                                                       //     context);
//                                                                                     },
//                                                                                     child: Container(
//                                                                                       margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
//                                                                                       height: 40,
//                                                                                       // width:
//                                                                                       //     80,
//                                                                                       decoration: BoxDecoration(
//                                                                                           borderRadius: BorderRadius.circular(5),
//                                                                                           gradient: LinearGradient(colors: [
//                                                                                             HexColor(Colorscommon.greencolor),
//                                                                                             HexColor(Colorscommon.greencolor),
//                                                                                           ])),
//                                                                                       child: const Center(
//                                                                                           child: Text(
//                                                                                         "Submit",
//                                                                                         style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
//                                                                                       )),
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         const SizedBox(
//                                                                           height:
//                                                                               10,
//                                                                         )
//                                                                       ]),
//                                                                 ),
//                                                                 // actions: <
//                                                                 //     Widget>[

//                                                                 //   // IconButton(
//                                                                 //   //     icon: const Icon(Icons
//                                                                 //   //         .close),
//                                                                 //   //     onPressed:
//                                                                 //   //         () {
//                                                                 //   //       Navigator.pop(
//                                                                 //   //           context);
//                                                                 //   //     })
//                                                                 // ],
//                                                               );
//                                                             },
//                                                           );
//                                                         },
//                                                       );
//                                                     },
//                                                     child: Row(
//                                                       children: [
//                                                         Text(
//                                                           array[index]["name"]
//                                                               .toString(),
//                                                           textAlign:
//                                                               TextAlign.start,
//                                                           style: const TextStyle(
//                                                               fontSize: 14,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                         ),
//                                                         const Expanded(
//                                                             child: Text(
//                                                                 "         ")),
//                                                         Container(
//                                                           width: 100,
//                                                           height: 30,
//                                                           color: Colors.red,
//                                                           child: Center(
//                                                             child: Text(
//                                                               array[index][
//                                                                       "viewLabelName"]
//                                                                   .toString(),
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .start,
//                                                               style: const TextStyle(
//                                                                   fontSize: 14,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Visibility(
//                                                 // visible: true,
//                                                 visible: dailyearnindetailslist[
//                                                             index]['id'] !=
//                                                         1 &&
//                                                     dailyearnindetailslist[
//                                                             index]['id'] !=
//                                                         2 &&
//                                                     dailyearnindetailslist[
//                                                             index]['id'] !=
//                                                         3,
//                                                 child: Expanded(
//                                                   flex: 2,
//                                                   child: ExpansionTile(
//                                                     // initiallyExpanded: true,

//                                                     // trailing: Container(
//                                                     //   width: 100,
//                                                     //   height: 30,
//                                                     //   color: Colors.red,
//                                                     //   child: Text(
//                                                     //     array[index][
//                                                     //             "viewLabelName"]
//                                                     //         .toString(),
//                                                     //     textAlign:
//                                                     //         TextAlign.start,
//                                                     //     style: const TextStyle(
//                                                     //         fontSize: 14,
//                                                     //         fontWeight:
//                                                     //             FontWeight
//                                                     //                 .w500),
//                                                     //   ),
//                                                     // ),
//                                                     title: Row(
//                                                       children: [
//                                                         Text(
//                                                           array[index]["name"]
//                                                               .toString(),
//                                                           textAlign:
//                                                               TextAlign.start,
//                                                           style: const TextStyle(
//                                                               fontSize: 14,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                         ),
//                                                         const Expanded(
//                                                             child: Text(
//                                                                 "         ")),
//                                                       ],
//                                                     ),
//                                                     children: [
//                                                       Visibility(
//                                                         visible: array[index][
//                                                                     "isGrievence"]
//                                                                 .toString() ==
//                                                             "true",
//                                                         child: Column(
//                                                           children: [
//                                                             Row(
//                                                               children: [
//                                                                 // Visibility(
//                                                                 //   visible:
//                                                                 //       formFieldType,
//                                                                 //   child: Expanded(
//                                                                 //     flex: 2,
//                                                                 //     child:
//                                                                 //         Container(
//                                                                 //       height: 30,
//                                                                 //       margin:
//                                                                 //           const EdgeInsets
//                                                                 //                   .all(
//                                                                 //               15.0),
//                                                                 //       padding:
//                                                                 //           const EdgeInsets
//                                                                 //                   .all(
//                                                                 //               3.0),
//                                                                 //       decoration:
//                                                                 //           const ShapeDecoration(
//                                                                 //         shape:
//                                                                 //             RoundedRectangleBorder(
//                                                                 //           side: BorderSide(
//                                                                 //               width:
//                                                                 //                   1.0,
//                                                                 //               style:
//                                                                 //                   BorderStyle.solid),
//                                                                 //           borderRadius:
//                                                                 //               BorderRadius.all(
//                                                                 //                   Radius.circular(5.0)),
//                                                                 //         ),
//                                                                 //       ),
//                                                                 //       child: Theme(
//                                                                 //         data: Theme.of(
//                                                                 //                 context)
//                                                                 //             .copyWith(
//                                                                 //                 canvasColor:
//                                                                 //                     Colors.grey.shade100),
//                                                                 //         child:
//                                                                 //             DropdownButtonHideUnderline(
//                                                                 //           child:
//                                                                 //               DropdownButton(
//                                                                 //             hint: const Text(
//                                                                 //                 "Select Reason"),
//                                                                 //             elevation:
//                                                                 //                 0,
//                                                                 //             value:
//                                                                 //                 dropdownvalueone,
//                                                                 //             items: array1
//                                                                 //                 .map((items) {
//                                                                 //               return DropdownMenuItem(
//                                                                 //                   value: items,
//                                                                 //                   child: Text(
//                                                                 //                     " " + items.toString(),
//                                                                 //                   ));
//                                                                 //             }).toList(),
//                                                                 //             icon:
//                                                                 //                 Icon(
//                                                                 //               Icons
//                                                                 //                   .keyboard_arrow_down,
//                                                                 //               color:
//                                                                 //                   HexColor(Colorscommon.greencolor),
//                                                                 //             ),
//                                                                 //             onChanged:
//                                                                 //                 (value) {
//                                                                 //               print(
//                                                                 //                   value);
//                                                                 //               // dropdownvalueone =
//                                                                 //               //     value.toString();
//                                                                 //               array[index]["selectedDropDownValue"] =
//                                                                 //                   value;
//                                                                 //               setState(
//                                                                 //                   () {});
//                                                                 //             },
//                                                                 //           ),
//                                                                 //         ),
//                                                                 //       ),
//                                                                 //     ),
//                                                                 //   ),
//                                                                 // ),
//                                                                 // Visibility(
//                                                                 //   visible:
//                                                                 //       !formFieldType,
//                                                                 //   child: Expanded(
//                                                                 //       flex: 1,
//                                                                 //       child:
//                                                                 //           Bouncing(
//                                                                 //         onPress:
//                                                                 //             () {
//                                                                 //           FocusManager
//                                                                 //               .instance
//                                                                 //               .primaryFocus
//                                                                 //               ?.unfocus();
//                                                                 //           Future<String>
//                                                                 //               fromdatee =
//                                                                 //               utility
//                                                                 //                   .selectTimeto(context);

//                                                                 //           fromdatee
//                                                                 //               .then(
//                                                                 //                   (value) {
//                                                                 //             setState(
//                                                                 //                 () {
//                                                                 //               debugPrint('selectedvalue' +
//                                                                 //                   value.toString());

//                                                                 //               if (value !=
//                                                                 //                   "null") {
//                                                                 //                 setState(() {});
//                                                                 //                 var starttime =
//                                                                 //                     value.substring(0, value.indexOf('.'));
//                                                                 //                 var pos =
//                                                                 //                     value.lastIndexOf('.');
//                                                                 //                 var starttimesend =
//                                                                 //                     value.substring(pos + 1);
//                                                                 //                 print("starttimesend$starttimesend");
//                                                                 //                 print("starttime$starttime");
//                                                                 //                 array[index]["selectedDropDownValue"] =
//                                                                 //                     starttimesend;
//                                                                 //                 // vailddata();
//                                                                 //               }
//                                                                 //             });
//                                                                 //           });
//                                                                 //           // print("startdate$fromdatesend");
//                                                                 //         },
//                                                                 //         child:
//                                                                 //             Container(
//                                                                 //           margin: const EdgeInsets
//                                                                 //                   .all(
//                                                                 //               10.0),
//                                                                 //           height:
//                                                                 //               30,
//                                                                 //           decoration:
//                                                                 //               const ShapeDecoration(
//                                                                 //             shape:
//                                                                 //                 RoundedRectangleBorder(
//                                                                 //               side: BorderSide(
//                                                                 //                   width: 1.0,
//                                                                 //                   style: BorderStyle.solid),
//                                                                 //               borderRadius:
//                                                                 //                   BorderRadius.all(Radius.circular(5.0)),
//                                                                 //             ),
//                                                                 //           ),
//                                                                 //           child:
//                                                                 //               Row(
//                                                                 //             mainAxisAlignment:
//                                                                 //                 MainAxisAlignment.spaceEvenly,
//                                                                 //             children: [
//                                                                 //               Expanded(
//                                                                 //                 flex:
//                                                                 //                     2,
//                                                                 //                 child:
//                                                                 //                     Text(
//                                                                 //                   " " + array[index]["selectedDropDownValue"].toString() == " " || array[index]["selectedDropDownValue"].toString() == "0:0" ? " HH : MM" : array[index]["selectedDropDownValue"].toString(),
//                                                                 //                   // textAlign: TextAlign.center,
//                                                                 //                   style: TextStyle(color: HexColor(Colorscommon.greycolor)),
//                                                                 //                 ),
//                                                                 //               ),
//                                                                 //               Icon(
//                                                                 //                 Icons.access_time,
//                                                                 //                 color:
//                                                                 //                     HexColor(Colorscommon.greencolor),
//                                                                 //               )
//                                                                 //             ],
//                                                                 //           ),
//                                                                 //         ),
//                                                                 //       )),
//                                                                 // ),
//                                                                 Expanded(
//                                                                   flex: 1,
//                                                                   child:
//                                                                       Container(
//                                                                     // width: MediaQuery.of(context).size.width - 15,
//                                                                     height: 30,
//                                                                     margin: const EdgeInsets
//                                                                             .all(
//                                                                         10.0),
//                                                                     padding:
//                                                                         const EdgeInsets.all(
//                                                                             3.0),
//                                                                     decoration:
//                                                                         const ShapeDecoration(
//                                                                       shape:
//                                                                           RoundedRectangleBorder(
//                                                                         side: BorderSide(
//                                                                             width:
//                                                                                 1.0,
//                                                                             style:
//                                                                                 BorderStyle.solid),
//                                                                         borderRadius:
//                                                                             BorderRadius.all(Radius.circular(5.0)),
//                                                                       ),
//                                                                     ),
//                                                                     child:
//                                                                         Theme(
//                                                                       data: Theme.of(context).copyWith(
//                                                                           canvasColor: Colors
//                                                                               .grey
//                                                                               .shade100),
//                                                                       child:
//                                                                           DropdownButtonHideUnderline(
//                                                                         child:
//                                                                             DropdownButton(
//                                                                           // isExpanded: true,
//                                                                           // isDense: ,
//                                                                           hint:
//                                                                               const Text("None"),
//                                                                           elevation:
//                                                                               0,
//                                                                           value:
//                                                                               dropdownvaluetwo,
//                                                                           items:
//                                                                               array2.map((items) {
//                                                                             return DropdownMenuItem(
//                                                                                 value: items,
//                                                                                 child: Text(
//                                                                                   " " + items.toString(),
//                                                                                 ));
//                                                                           }).toList(),
//                                                                           icon:
//                                                                               Icon(
//                                                                             Icons.keyboard_arrow_down,
//                                                                             color:
//                                                                                 HexColor(Colorscommon.greencolor),
//                                                                           ),
//                                                                           onChanged:
//                                                                               (value) {
//                                                                             // print("DropdownMenuItem$DropdownMenuItem");
//                                                                             // dropdownvaluetwo =
//                                                                             //     value
//                                                                             //         .toString();
//                                                                             print("value121242$value");
//                                                                             print("indexstr$index");
//                                                                             // if (value.toString() ==
//                                                                             //     "Grievance") {
//                                                                             //   getdailyearningdetailsbycategory(array[index]["name"].toString(),
//                                                                             //       index.toString());
//                                                                             // }
//                                                                             array[index]["selectedIsAvailValue"] =
//                                                                                 value.toString();

//                                                                             setState(() {
//                                                                               // getdailyearningdetailsbydate();
//                                                                             });
//                                                                           },
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             Visibility(
//                                                               visible:
//                                                                   dropdownvaluetwo ==
//                                                                       "Grievance",
//                                                               child: Row(
//                                                                 children: [
//                                                                   Expanded(
//                                                                     flex: 1,
//                                                                     child:
//                                                                         Container(
//                                                                       // width: MediaQuery.of(context).size.width - 15,
//                                                                       height:
//                                                                           30,
//                                                                       margin: const EdgeInsets
//                                                                               .all(
//                                                                           10.0),
//                                                                       padding:
//                                                                           const EdgeInsets.all(
//                                                                               3.0),
//                                                                       decoration:
//                                                                           const ShapeDecoration(
//                                                                         shape:
//                                                                             RoundedRectangleBorder(
//                                                                           side: BorderSide(
//                                                                               width: 1.0,
//                                                                               style: BorderStyle.solid),
//                                                                           borderRadius:
//                                                                               BorderRadius.all(Radius.circular(5.0)),
//                                                                         ),
//                                                                       ),
//                                                                       child:
//                                                                           Theme(
//                                                                         data: Theme.of(context).copyWith(
//                                                                             canvasColor:
//                                                                                 Colors.grey.shade100),
//                                                                         child:
//                                                                             DropdownButtonHideUnderline(
//                                                                           child:
//                                                                               DropdownButton(
//                                                                             hint:
//                                                                                 const Text("Select Category"),
//                                                                             elevation:
//                                                                                 0,
//                                                                             value:
//                                                                                 dropdownvaluethree,
//                                                                             items:
//                                                                                 array3.map((items) {
//                                                                               return DropdownMenuItem(
//                                                                                   value: items,
//                                                                                   child: Text(
//                                                                                     " " + items.toString(),
//                                                                                   ));
//                                                                             }).toList(),
//                                                                             icon:
//                                                                                 Icon(
//                                                                               Icons.keyboard_arrow_down,
//                                                                               color: HexColor(Colorscommon.greencolor),
//                                                                             ),
//                                                                             onChanged:
//                                                                                 (value) {
//                                                                               array[index]["selectedCategory"] = value.toString();
//                                                                               setState(() {});

//                                                                               for (var i = 0; array3.length > i; i++) {
//                                                                                 print(array3[i].toString());
//                                                                                 print(value.toString());
//                                                                                 if (array3[i].toString() == value.toString()) {
//                                                                                   String datevalue = sfidarray3[i];
//                                                                                   getSubCategoryByCategory(array[index]["name"].toString(), datevalue);

//                                                                                   array[index]["selectedCategoryId"] = datevalue.toString();
//                                                                                   break;
//                                                                                 }
//                                                                               }
//                                                                             },
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),

//                                                                   // Expanded(
//                                                                   //   flex: 1,
//                                                                   //   child: Container(
//                                                                   //     // width: MediaQuery.of(context).size.width - 15,
//                                                                   //     height: 30,
//                                                                   //     margin:
//                                                                   //         const EdgeInsets
//                                                                   //                 .all(
//                                                                   //             15.0),
//                                                                   //     padding:
//                                                                   //         const EdgeInsets
//                                                                   //             .all(3.0),
//                                                                   //     decoration:
//                                                                   //         const ShapeDecoration(
//                                                                   //       shape:
//                                                                   //           RoundedRectangleBorder(
//                                                                   //         side: BorderSide(
//                                                                   //             width:
//                                                                   //                 1.0,
//                                                                   //             style: BorderStyle
//                                                                   //                 .solid),
//                                                                   //         borderRadius:
//                                                                   //             BorderRadius.all(
//                                                                   //                 Radius.circular(
//                                                                   //                     5.0)),
//                                                                   //       ),
//                                                                   //     ),
//                                                                   //     child: Theme(
//                                                                   //       data: Theme.of(
//                                                                   //               context)
//                                                                   //           .copyWith(
//                                                                   //               canvasColor: Colors
//                                                                   //                   .grey
//                                                                   //                   .shade100),
//                                                                   //       child:
//                                                                   //           DropdownButtonHideUnderline(
//                                                                   //         child:
//                                                                   //             DropdownButton(
//                                                                   //           // isExpanded: true,
//                                                                   //           // isDense: ,
//                                                                   //           hint: const Text(
//                                                                   //               "-- Select Date -- "),
//                                                                   //           elevation:
//                                                                   //               0,
//                                                                   //           value:
//                                                                   //               dropdownvaluefour,
//                                                                   //           items: changetypelist
//                                                                   //               .map(
//                                                                   //                   (items) {
//                                                                   //             return DropdownMenuItem(
//                                                                   //                 value:
//                                                                   //                     items,
//                                                                   //                 child:
//                                                                   //                     Text(
//                                                                   //                   " " +
//                                                                   //                       items.toString(),
//                                                                   //                 ));
//                                                                   //           }).toList(),
//                                                                   //           icon: Icon(
//                                                                   //             Icons
//                                                                   //                 .keyboard_arrow_down,
//                                                                   //             color: HexColor(
//                                                                   //                 Colorscommon
//                                                                   //                     .greencolor),
//                                                                   //           ),
//                                                                   //           onChanged:
//                                                                   //               (value) {
//                                                                   //             // print("DropdownMenuItem$DropdownMenuItem");
//                                                                   //             change_date =
//                                                                   //                 value
//                                                                   //                     .toString();
//                                                                   //             setState(
//                                                                   //                 () {
//                                                                   //               getdailyearningdetailsbydate();
//                                                                   //             });
//                                                                   //           },
//                                                                   //         ),
//                                                                   //       ),
//                                                                   //     ),
//                                                                   //   ),
//                                                                   // ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                             Visibility(
//                                                                 visible:
//                                                                     dropdownvaluetwo ==
//                                                                         "Grievance",
//                                                                 child: Row(
//                                                                   children: [
//                                                                     Expanded(
//                                                                       flex: 5,
//                                                                       child:
//                                                                           Container(
//                                                                         // width: MediaQuery.of(context).size.width - 15,
//                                                                         height:
//                                                                             30,
//                                                                         margin:
//                                                                             const EdgeInsets.all(10.0),
//                                                                         padding:
//                                                                             const EdgeInsets.all(3.0),
//                                                                         decoration:
//                                                                             const ShapeDecoration(
//                                                                           shape:
//                                                                               RoundedRectangleBorder(
//                                                                             side:
//                                                                                 BorderSide(width: 1.0, style: BorderStyle.solid),
//                                                                             borderRadius:
//                                                                                 BorderRadius.all(Radius.circular(5.0)),
//                                                                           ),
//                                                                         ),
//                                                                         child:
//                                                                             Theme(
//                                                                           data:
//                                                                               Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                           child:
//                                                                               DropdownButtonHideUnderline(
//                                                                             child:
//                                                                                 DropdownButton(
//                                                                               // isExpanded: true,
//                                                                               // isDense: ,
//                                                                               hint: const Text("Select SubCategory"),
//                                                                               elevation: 0,
//                                                                               value: dropdownvaluefour,
//                                                                               items: array4.map((items) {
//                                                                                 return DropdownMenuItem(
//                                                                                     value: items,
//                                                                                     child: Text(
//                                                                                       " " + items.toString(),
//                                                                                     ));
//                                                                               }).toList(),
//                                                                               icon: Icon(
//                                                                                 Icons.keyboard_arrow_down,
//                                                                                 color: HexColor(Colorscommon.greencolor),
//                                                                               ),
//                                                                               onChanged: (value) {
//                                                                                 for (var i = 0; array4.length > i; i++) {
//                                                                                   array[index]["selectedSubCategory"] = value.toString();
//                                                                                   if (array4[i].toString() == value.toString()) {
//                                                                                     var datevalue = sfidarray4[i];
//                                                                                     print("datevalue$datevalue");
//                                                                                     setState(() {
//                                                                                       array[index]["selectedSubCategoryId"] = datevalue.toString();
//                                                                                     });
//                                                                                     break;
//                                                                                   }
//                                                                                 }
//                                                                                 // print("DropdownMenuItem$DropdownMenuItem");
//                                                                                 // array[index]["selectedSubcategoryId"] = datevalue.toString();

//                                                                                 //     value.toString();
//                                                                                 setState(() {});
//                                                                               },
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 )),
//                                                             Visibility(
//                                                               visible:
//                                                                   dropdownvaluetwo ==
//                                                                       "Grievance",
//                                                               child: Row(
//                                                                 children: [
//                                                                   Visibility(
//                                                                     visible:
//                                                                         formFieldType ==
//                                                                             "1",
//                                                                     child:
//                                                                         Visibility(
//                                                                       visible: array[index]
//                                                                               [
//                                                                               "name"] !=
//                                                                           "Late",
//                                                                       child:
//                                                                           Visibility(
//                                                                         visible:
//                                                                             array[index]["selectedSubCategory"].toString().toLowerCase() !=
//                                                                                 "adhoc duty",
//                                                                         child:
//                                                                             Expanded(
//                                                                           flex:
//                                                                               2,
//                                                                           child:
//                                                                               Container(
//                                                                             height:
//                                                                                 30,
//                                                                             margin:
//                                                                                 const EdgeInsets.all(10.0),
//                                                                             padding:
//                                                                                 const EdgeInsets.all(3.0),
//                                                                             decoration:
//                                                                                 const ShapeDecoration(
//                                                                               shape: RoundedRectangleBorder(
//                                                                                 side: BorderSide(width: 1.0, style: BorderStyle.solid),
//                                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                               ),
//                                                                             ),
//                                                                             child:
//                                                                                 Theme(
//                                                                               data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                               child: DropdownButtonHideUnderline(
//                                                                                 child: DropdownButton(
//                                                                                   hint: const Text("Select Reason"),
//                                                                                   elevation: 0,
//                                                                                   value: dropdownvalueone,
//                                                                                   items: array1.map((items) {
//                                                                                     return DropdownMenuItem(
//                                                                                         value: items,
//                                                                                         child: Text(
//                                                                                           " " + items.toString(),
//                                                                                         ));
//                                                                                   }).toList(),
//                                                                                   icon: Icon(
//                                                                                     Icons.keyboard_arrow_down,
//                                                                                     color: HexColor(Colorscommon.greencolor),
//                                                                                   ),
//                                                                                   onChanged: (value) {
//                                                                                     // print(value);
//                                                                                     // dropdownvalueone =
//                                                                                     //     value.toString();
//                                                                                     var sampledata = array[index]["selectedDropDownValue"];
//                                                                                     print("sampledata$sampledata");
//                                                                                     array[index]["selectedDropDownValue"] = value;
//                                                                                     for (int i = 0; i < array1.length; i++) {
//                                                                                       if (array1[i].toString() == value) {
//                                                                                         String setvalue = sfidarray1[i].toString();
//                                                                                         print("setvalue11234=$setvalue");
//                                                                                         array[index]["selectedDropDownId"] = setvalue;
//                                                                                       }
//                                                                                     }
//                                                                                     setState(() {});
//                                                                                   },
//                                                                                 ),
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   Visibility(
//                                                                     visible:
//                                                                         formFieldType ==
//                                                                             "3",
//                                                                     child:
//                                                                         Visibility(
//                                                                       visible: array[index]["selectedCategory"]
//                                                                               .toString() !=
//                                                                           "Training Present",
//                                                                       child:
//                                                                           Expanded(
//                                                                         flex: 1,
//                                                                         child:
//                                                                             Container(
//                                                                           margin:
//                                                                               const EdgeInsets.all(10.0),
//                                                                           height:
//                                                                               30,
//                                                                           child:
//                                                                               Theme(
//                                                                             data:
//                                                                                 Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
//                                                                             child:
//                                                                                 TextField(
//                                                                               controller: _controllers[index],
//                                                                               onChanged: (valuestr) {
//                                                                                 array[index]["selectedDropDownId"] = valuestr;
//                                                                               },
//                                                                               onSubmitted: (valuestr) {
//                                                                                 // array[index]["selectedDropDownId"] =
//                                                                                 //     valuestr;
//                                                                                 _controllers[index].text = valuestr;
//                                                                                 // array[index]["selectedDropDownId"] =
//                                                                                 //     valuestr;

//                                                                                 // print("valuestr$valuestr");
//                                                                                 setState(() {});
//                                                                               },
//                                                                               maxLength: 5,
//                                                                               keyboardType: TextInputType.number,
//                                                                               decoration: const InputDecoration(
//                                                                                   hintText: 'No of Trips Performed',
//                                                                                   // labelText: array[index]["selectedDropDownId"].toString(),
//                                                                                   counterText: ""),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                   Visibility(
//                                                                     visible:
//                                                                         formFieldType ==
//                                                                             "2",
//                                                                     child: Expanded(
//                                                                         flex: 1,
//                                                                         child: Bouncing(
//                                                                           onPress:
//                                                                               () {
//                                                                             FocusManager.instance.primaryFocus?.unfocus();
//                                                                             Future<String>
//                                                                                 fromdatee =
//                                                                                 utility.selectTimeto(context);

//                                                                             fromdatee.then((value) {
//                                                                               setState(() {
//                                                                                 // debugPrint('selectedvalue' + value.toString());

//                                                                                 if (value != "null") {
//                                                                                   var starttime = value.substring(0, value.indexOf('.'));
//                                                                                   var pos = value.lastIndexOf('.');
//                                                                                   var starttimesend = value.substring(pos + 1);
//                                                                                   print("starttimesend$starttimesend");
//                                                                                   // print("starttimesend$starttimesend");
//                                                                                   // print("starttime$starttime");
//                                                                                   array[index]["selectedDropDownId"] = starttimesend;
//                                                                                   // array[index]["selectedDropDownValue"] = starttimesend;
//                                                                                   // // vailddata();
//                                                                                   // setState(() {});
//                                                                                 }
//                                                                               });
//                                                                             });
//                                                                           },
//                                                                           child:
//                                                                               Container(
//                                                                             margin:
//                                                                                 const EdgeInsets.all(10.0),
//                                                                             height:
//                                                                                 30,
//                                                                             decoration:
//                                                                                 const ShapeDecoration(
//                                                                               shape: RoundedRectangleBorder(
//                                                                                 side: BorderSide(width: 1.0, style: BorderStyle.solid),
//                                                                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                                                               ),
//                                                                             ),
//                                                                             child:
//                                                                                 Row(
//                                                                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                                                               children: [
//                                                                                 Expanded(
//                                                                                   flex: 2,
//                                                                                   child: Text(
//                                                                                     " " + array[index]["selectedDropDownId"].toString() == " " || array[index]["selectedDropDownId"].toString() == "0:0" ? " HH : MM" : array[index]["selectedDropDownId"].toString(),
//                                                                                     // textAlign: TextAlign.center,
//                                                                                     style: TextStyle(color: HexColor(Colorscommon.greycolor)),
//                                                                                   ),
//                                                                                 ),
//                                                                                 Icon(
//                                                                                   Icons.access_time,
//                                                                                   color: HexColor(Colorscommon.greencolor),
//                                                                                 )
//                                                                               ],
//                                                                             ),
//                                                                           ),
//                                                                         )),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Visibility(
//                                                         visible:
//                                                             dropdownvaluetwo ==
//                                                                 "Grievance",
//                                                         child: Visibility(
//                                                           visible: array[index]
//                                                                       ['name']
//                                                                   .toString() ==
//                                                               "Trip Count",
//                                                           child: Visibility(
//                                                             visible: array[index]
//                                                                         [
//                                                                         'viewLabelName']
//                                                                     .toString() ==
//                                                                 "0",
//                                                             child: Row(
//                                                               children: [
//                                                                 Bouncing(
//                                                                   onPress: () {
//                                                                     FocusManager
//                                                                         .instance
//                                                                         .primaryFocus
//                                                                         ?.unfocus();
//                                                                     _showPicker(
//                                                                         context);
//                                                                   },
//                                                                   child:
//                                                                       Container(
//                                                                     margin: const EdgeInsets
//                                                                             .only(
//                                                                         top: 10,
//                                                                         right:
//                                                                             10,
//                                                                         left:
//                                                                             10),
//                                                                     child:
//                                                                         Align(
//                                                                       alignment:
//                                                                           Alignment
//                                                                               .centerLeft,
//                                                                       child:
//                                                                           Container(
//                                                                         width:
//                                                                             MediaQuery.of(context).size.width /
//                                                                                 3,
//                                                                         height:
//                                                                             40,
//                                                                         decoration:
//                                                                             const ShapeDecoration(
//                                                                           shape:
//                                                                               RoundedRectangleBorder(
//                                                                             side:
//                                                                                 BorderSide(width: 1.0, style: BorderStyle.solid),
//                                                                             borderRadius:
//                                                                                 BorderRadius.all(Radius.circular(5.0)),
//                                                                           ),
//                                                                         ),
//                                                                         child:
//                                                                             Row(
//                                                                           mainAxisAlignment:
//                                                                               MainAxisAlignment.center,
//                                                                           // ignore: prefer_const_literals_to_create_immutables
//                                                                           children: [
//                                                                             Icon(
//                                                                               Icons.upload_file,
//                                                                               color: HexColor(Colorscommon.greencolor),
//                                                                             ),
//                                                                             Flexible(
//                                                                               flex: 1,
//                                                                               child: Text(
//                                                                                 imgname != '' ? 'File Attached' : 'Select File',
//                                                                                 style: TextStyle(color: HexColor(Colorscommon.greycolor), fontFamily: "TomaSans-Regular"),
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 Visibility(
//                                                                   visible:
//                                                                       imgname !=
//                                                                           '',
//                                                                   child:
//                                                                       Padding(
//                                                                     padding: const EdgeInsets
//                                                                             .only(
//                                                                         top:
//                                                                             6.0),
//                                                                     child:
//                                                                         IconButton(
//                                                                       icon: const Icon(
//                                                                           Icons
//                                                                               .delete_forever),
//                                                                       color: Colors
//                                                                           .red,
//                                                                       onPressed:
//                                                                           () {
//                                                                         setState(
//                                                                             () {
//                                                                           imgname =
//                                                                               '';
//                                                                           imagebool =
//                                                                               false;
//                                                                         });
//                                                                       },
//                                                                     ),
//                                                                   ),
//                                                                 )
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Visibility(
//                                                         visible: array[index]
//                                                                     ['name']
//                                                                 .toString() ==
//                                                             "Trip Count",
//                                                         child: Visibility(
//                                                           visible: array[index][
//                                                                       'viewLabelName']
//                                                                   .toString() ==
//                                                               "0",
//                                                           child: const SizedBox(
//                                                             height: 20,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Visibility(
//                                                           visible: array[index]
//                                                                       ['name']
//                                                                   .toString() ==
//                                                               "Debit Details",
//                                                           child: Visibility(
//                                                             visible:
//                                                                 debitdetailarray
//                                                                     .isNotEmpty,
//                                                             child: Card(
//                                                               elevation: 5,
//                                                               child: Container(
//                                                                 margin:
//                                                                     const EdgeInsets
//                                                                         .all(10),
//                                                                 child: Column(
//                                                                   children: [
//                                                                     Container(
//                                                                       margin: const EdgeInsets
//                                                                               .only(
//                                                                           right:
//                                                                               10,
//                                                                           left:
//                                                                               10,
//                                                                           bottom:
//                                                                               10,
//                                                                           top:
//                                                                               10),
//                                                                       child: Row(
//                                                                           children: const [
//                                                                             Expanded(
//                                                                                 flex: 1,
//                                                                                 child: Text(
//                                                                                   "Name",
//                                                                                   style: TextStyle(fontWeight: FontWeight.w500),
//                                                                                 )),
//                                                                             Expanded(
//                                                                                 flex: 1,
//                                                                                 child: Text(
//                                                                                   "Voucher Type",
//                                                                                   style: TextStyle(fontWeight: FontWeight.w500),
//                                                                                 )),
//                                                                             Expanded(
//                                                                               flex: 1,
//                                                                               child: Text(
//                                                                                 "Amount",
//                                                                                 style: TextStyle(fontWeight: FontWeight.w500),
//                                                                                 textAlign: TextAlign.right,
//                                                                               ),
//                                                                             ),
//                                                                           ]),
//                                                                     ),
//                                                                     ListView.builder(
//                                                                         shrinkWrap: true,
//                                                                         physics: const BouncingScrollPhysics(),
//                                                                         itemCount: debitdetailarray.length,
//                                                                         itemBuilder: (BuildContext context, int index) {
//                                                                           return Container(
//                                                                             margin: const EdgeInsets.only(
//                                                                                 right: 10,
//                                                                                 left: 10,
//                                                                                 bottom: 10,
//                                                                                 top: 10),
//                                                                             child:
//                                                                                 Row(children: [
//                                                                               Expanded(flex: 1, child: Text(debitdetailarray[index]['name'].toString())),
//                                                                               Expanded(flex: 1, child: Text(debitdetailarray[index]['voucher_type'].toString())),
//                                                                               Expanded(
//                                                                                   flex: 1,
//                                                                                   child: Text(
//                                                                                     (debitdetailarray[index]['amount'].toString()),
//                                                                                     textAlign: TextAlign.right,
//                                                                                   )),
//                                                                             ]),
//                                                                           );
//                                                                           // return Column(
//                                                                           //   children: [
//                                                                           //     Padding(
//                                                                           //       padding:
//                                                                           //           const EdgeInsets.all(10),
//                                                                           //       child:
//                                                                           //           SizedBox(
//                                                                           //         height:
//                                                                           //             40,
//                                                                           //         child:
//                                                                           //             Row(
//                                                                           //           mainAxisAlignment: MainAxisAlignment.start,
//                                                                           //           children: const [
//                                                                           //             Expanded(
//                                                                           //               flex: 2,
//                                                                           //               child: Text(
//                                                                           //                 'Extra Hours',
//                                                                           //                 textAlign: TextAlign.start,
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //                 // style: TextStyle(
//                                                                           //                 //     // color: Colors.white,
//                                                                           //                 //     fontWeight: FontWeight.bold),
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //           ],
//                                                                           //         ),
//                                                                           //       ),
//                                                                           //     ),
//                                                                           //     Padding(
//                                                                           //       padding:
//                                                                           //           const EdgeInsets.all(10),
//                                                                           //       child:
//                                                                           //           SizedBox(
//                                                                           //         height:
//                                                                           //             40,
//                                                                           //         child:
//                                                                           //             Row(
//                                                                           //           mainAxisAlignment: MainAxisAlignment.start,
//                                                                           //           children: const [
//                                                                           //             Expanded(
//                                                                           //               flex: 2,
//                                                                           //               child: Text(
//                                                                           //                 'Debit',
//                                                                           //                 textAlign: TextAlign.start,
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 ' ',
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //                 // style: TextStyle(
//                                                                           //                 //     // color: Colors.white,
//                                                                           //                 //     fontWeight: FontWeight.bold),
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //           ],
//                                                                           //         ),
//                                                                           //       ),
//                                                                           //     ),
//                                                                           //     Padding(
//                                                                           //       padding:
//                                                                           //           const EdgeInsets.all(10),
//                                                                           //       child:
//                                                                           //           SizedBox(
//                                                                           //         height:
//                                                                           //             40,
//                                                                           //         child:
//                                                                           //             Row(
//                                                                           //           mainAxisAlignment: MainAxisAlignment.start,
//                                                                           //           children: const [
//                                                                           //             Expanded(
//                                                                           //               flex: 2,
//                                                                           //               child: Text(
//                                                                           //                 'Accident Recovery',
//                                                                           //                 textAlign: TextAlign.start,
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //                 // style: TextStyle(
//                                                                           //                 //     // color: Colors.white,
//                                                                           //                 //     fontWeight: FontWeight.bold),
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //             Expanded(
//                                                                           //               flex: 1,
//                                                                           //               child: Text(
//                                                                           //                 '',
//                                                                           //               ),
//                                                                           //             ),
//                                                                           //           ],
//                                                                           //         ),
//                                                                           //       ),
//                                                                           //     ),
//                                                                           //   ],
//                                                                           // );
//                                                                         }),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             replacement:
//                                                                 const SizedBox(
//                                                               height: 40,
//                                                               child: Center(
//                                                                 child: Text(
//                                                                     ("No Data Available ")),
//                                                               ),
//                                                             ),
//                                                           ))
//                                                     ],
//                                                     // text: array[index]["name"]
//                                                     //     .toString(),
//                                                   ),
//                                                 ),
//                                               ),
//                                               //
//                                             ],
//                                           ),
//                                           // const SizedBox(
//                                           //   height: 5,
//                                           // ),
//                                         ],
//                                       ),
//                                     );
//                                   }),
//                             ],
//                           ),
//                         );
//                       }),
//                 ),
//               ),
//               Visibility(
//                 visible: !showbtnbool,
//                 child: Container(
//                   margin: const EdgeInsets.only(
//                     bottom: 10,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width / 2,
//                         height: 40,
//                         margin: const EdgeInsets.only(top: 10),
//                         child: RaisedButton(
//                           color: HexColor(Colorscommon.greencolor),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5)),
//                           child: const Text(
//                             "Submit",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           onPressed: () async {
//                             bool closestatus = true;
//                             bool noGrivence = true;
//                             for (int i = 0;
//                                 i < dailyearnindetailslist.length;
//                                 i++) {
//                               if (!closestatus) {
//                                 break;
//                               }
//                               for (int i2 = 0;
//                                   i2 < dailyearnindetailslist[i]["data"].length;
//                                   i2++) {
//                                 if (dailyearnindetailslist[i]["data"][i2]
//                                             ["selectedIsAvailValue"]
//                                         .toString() ==
//                                     "Grievance") {
//                                   noGrivence = false;
//                                   if (dailyearnindetailslist[i]["data"][i2]
//                                               ["selectedCategoryId"]
//                                           .toString() ==
//                                       "") {
//                                     // print("Category");
//                                     Fluttertoast.showToast(
//                                       msg: "Please Select " +
//                                           dailyearnindetailslist[i]["data"][i2]
//                                                   ["name"]
//                                               .toString() +
//                                           "  Category",
//                                       toastLength: Toast.LENGTH_SHORT,
//                                       gravity: ToastGravity.CENTER,
//                                     );
//                                     closestatus = false;
//                                     break;
//                                   }
//                                   // else if (dailyearnindetailslist[i]["data"]
//                                   //             [i2]["selectedSubCategory"]
//                                   //         .toString()
//                                   //         .toLowerCase() !=
//                                   //     "adhoc duty") {
//                                   else if (dailyearnindetailslist[i]["data"][i2]
//                                               ["selectedSubCategoryId"]
//                                           .toString() ==
//                                       "") {
//                                     Fluttertoast.showToast(
//                                       msg: "Please Select " +
//                                           dailyearnindetailslist[i]["data"][i2]
//                                                   ["name"]
//                                               .toString() +
//                                           "  SubCategory",
//                                       toastLength: Toast.LENGTH_SHORT,
//                                       gravity: ToastGravity.CENTER,
//                                     );
//                                     closestatus = false;
//                                     break;
//                                   }
//                                   // }
//                                   else if (dailyearnindetailslist[i]["data"][i2]
//                                               ["selectedCategory"]
//                                           .toString() !=
//                                       "Training Present") {
//                                     if (dailyearnindetailslist[i]["data"][i2]
//                                                 ["name"]
//                                             .toString() !=
//                                         "Late") {
//                                       if (dailyearnindetailslist[i]["data"][i2]
//                                                   ["selectedSubCategory"]
//                                               .toString()
//                                               .toLowerCase() !=
//                                           "adhoc duty") {
//                                         if (dailyearnindetailslist[i]["data"]
//                                                     [i2]["selectedDropDownId"]
//                                                 .toString() ==
//                                             "") {
//                                           Fluttertoast.showToast(
//                                             msg: "Please Select " +
//                                                 dailyearnindetailslist[i]
//                                                         ["data"][i2]["name"]
//                                                     .toString() +
//                                                 " Dropdown",
//                                             toastLength: Toast.LENGTH_SHORT,
//                                             gravity: ToastGravity.CENTER,
//                                           );
//                                           closestatus = false;
//                                           break;
//                                         }
//                                       }
//                                     }
//                                   }

//                                   // else {
//                                   //   // if (i == dailyearnindetailslist.length) {
//                                   //   //   print("last index ");
//                                   //   //   DailyearningSubmit();
//                                   //   // }
//                                   // }
//                                 } else {
//                                   print("last index for delay");
//                                   if (i == dailyearnindetailslist.length - 1) {
//                                     // print("last index for delay bv");
//                                     // if (apicalling) {
//                                     //   apicalling = false;
//                                     //   setState(() {});
//                                     if (closestatus) {
//                                       if (noGrivence) {
//                                         // print("nogrivance selected");
//                                         Raisenogriveance_func();
//                                       } else {
//                                         DailyearningSubmit();
//                                       }
//                                     }
//                                     break;
//                                     // }
//                                   }
//                                 }
//                               }
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // RaisedButton(
//               //   onPressed: () {

//               //   },
//               //   child: const Text("Submit"),
//               // ),
//             ],
//           ),
//           replacement: Center(
//             child: CircularProgressIndicator(
//               color: HexColor(Colorscommon.greencolor),
//             ),
//           ),
//         ),
//         // child: DropdownButton(
//         //     value: Dropdownvalue, icon: const Icon(Icons.keyboard)),
//       ),
//     );
//   }

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
//                       fontSize: 17,
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
//                   "Do you want to raise no grievance?",
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
//                 onPress: () async {
//                   Raise_no_griveanceapi(context);
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
//                   height: 40,
//                   width: 80,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       gradient: LinearGradient(colors: [
//                         HexColor(Colorscommon.greencolor),
//                         HexColor(Colorscommon.greencolor),
//                       ])),
//                   child: const Center(
//                       child: Text(
//                     "Yes",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Montserrat',
//                         fontWeight: FontWeight.bold),
//                   )),
//                 ),
//               ),
//               Bouncing(
//                 onPress: () async {
//                   Navigator.of(context, rootNavigator: true).pop();
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
//                   height: 40,
//                   width: 80,
//                   decoration: BoxDecoration(
//                       border:
//                           Border.all(color: HexColor(Colorscommon.greencolor)),
//                       borderRadius: BorderRadius.circular(5),
//                       gradient: const LinearGradient(colors: [
//                         Colors.white,
//                         Colors.white
//                         // HexColor(Colorscommon.greencolor),
//                         // HexColor(Colorscommon.greencolor),
//                       ])),
//                   child: Center(
//                       child: Text(
//                     "No",
//                     style: TextStyle(
//                         color: HexColor(Colorscommon.greencolor),
//                         fontFamily: 'Montserrat',
//                         fontWeight: FontWeight.bold),
//                   )),
//                 ),
//               ),
//             ],
//           );
//         });
//   }

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

//   @override
//   void dispose() {
//     for (final controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Dashboard2.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings/Dashboardtabbar.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Dailyearnings extends StatefulWidget {
  const Dailyearnings({Key? key}) : super(key: key);

  @override
  State<Dailyearnings> createState() => _DailyearningsState();
}

class _DailyearningsState extends State<Dailyearnings> {
  Utility utility = Utility();
  String service_provider = '';
  var username = "";
  final List<TextEditingController> _controllers = [];
  bool imagebool = false;
  bool showbtnbool = false;
  late File _image;
  String imgname = '';
  bool isloading = true;
  bool apicalling = true;
  List<String> changetypelist = [];
  List<dynamic> dailyearnindetailslist = [];
  TextEditingController tripidcontroller = TextEditingController();
  //  TextEditingController tripidcontroller = TextEditingController();
  List<dynamic> dailyearnindetailssublist = [];
  List<dynamic> datedroplist = [];
  String rosterstartTime = '';
  String rosterendTime = '';
  String checkintime = '';
  String checkouttime = '';
  String datedetail = '-';
  String tripdetails = '';
  String debitdetails = '';
  String totearnings = '';
  String? dropdownvalue1;
  String? dropdownvalue2;
  String? tripdropdown;
  String? totearndropdown;
  String? change_date;
  final List<TextEditingController> _controller = [];

  @override
  void initState() {
    super.initState();
    Future<String> Serviceprovider = sessionManager.getspid();
    Serviceprovider.then((value) {
      service_provider = value.toString();
    });
    setState(() {
      utility.GetUserdata().then((value) => {
        username = utility.lithiumid,
        getdailyearning(),
      });
    });
  }

  getdailyearning() async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getDailyEarningDateDropDown";
    request.fields['service_provider_c'] = service_provider;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("daily earn = $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (status == 'true') {
        datedroplist = jsonInput['dateArray'];

        for (int i = 0; i < datedroplist.length; i++) {
          if (i == 0) {
            change_date = (datedroplist[i]['name']).toString();
            getdailyearningdetailsbydate();
          }
          var changeTodate = (datedroplist[i]['name']).toString();
          changetypelist.add(changeTodate);
        }
        setState(() {});
      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
  }

  Raise_no_griveanceapi(BuildContext context) async {
    loading();
    var url = Uri.parse(CommonURL.herokuurl);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "noGrievanceDailyUpdate";
    request.fields['service_provider_c'] = service_provider;
    request.fields['lithiumID'] = username;
    request.fields['date'] = change_date ?? "";

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("daily earn = $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (status == 'true') {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyTabPage(
                  title: '',selectedtab: 0,
                )));
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
              msg:
              "Maximum File Size Exceeds,Please Select a File Less Than 500kb",
              gravity: ToastGravity.CENTER);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  getdailyearningdetails() async {
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getDailyEarningDateDropDown";
    request.fields['service_provider_c'] = service_provider;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      // print("daily earn = $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      setState(() {
        dailyearnindetailslist = jsonInput['data'] as List<dynamic>;
      });
      if (status == 'true') {
      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
  }

  getSubCategoryByCategory(String title, String categoryC) async {
    var url = Uri.parse(CommonURL.herokuurl);
    print("categoryC$categoryC");
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getSubCategoryByCategory";
    request.fields['service_provider_c'] = service_provider;
    request.fields['category_c'] = categoryC;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("jsonInput=$jsonInput");
      String status = jsonInput['status'].toString();
      // String message = jsonInput['message'];
      if (status == 'true') {
        for (int i = 0; i < dailyearnindetailslist.length; i++) {
          for (int i2 = 0;
          i2 < dailyearnindetailslist[i]["data"].length;
          i2++) {
            var strinvalue =
            dailyearnindetailslist[i]["data"][i2]["name"].toString();
            print("strinvalue$strinvalue");
            if (title == strinvalue) {
              // print("strinvalue$strinvalue");
              // dailyearnindetailslist[i]["data"][i2]["categoryArray"] =
              //     jsonInput['categoryData'];
              dailyearnindetailslist[i]["data"][i2]["subcategoryArray"] =
              jsonInput['data'];
              setState(() {});
              break;
              // dailyearnindetailslist[i]["data"][i2]["selectedCategory"] =
              //     jsonInput['categoryData'][0]["name"];
              setState(() {});
            }
          }
        }
      }
      // setState(() {
      //   dailyearnindetailslist = jsonInput['data'] as List<dynamic>;
      // });
      // if (status == 'true') {
      // } else {
      //   Fluttertoast.showToast(
      //     msg: message,
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //   );
      // }
    } else {}
  }

  getdailyearningdetailsbycategory(String title, String index) async {
    // print("dailyindex$index");
    // print("title$title");
    var url = Uri.parse(CommonURL.herokuurl);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "isAvailableChangeGetCategoryDropDown";
    request.fields['title'] = title;
    request.fields['service_provider_c'] = service_provider;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("category= $jsonInput");
      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];
      if (status == 'true') {
        // for (int i = 0; i < dailyearnindetailslist.length; i++) {
        //   for (int i2 = 0; i2 < dailyearnindetailslist[i]["data"].length; i++) {
        //     var strinvalue =
        //         dailyearnindetailslist[i]["data"][i2]["name"].toString();
        //     if (title == strinvalue) {
        //       // print("strinvalue$strinvalue");
        //       dailyearnindetailslist[i]["data"][i2]["categoryArray"] =
        //           jsonInput['categoryData'];
        //       // dailyearnindetailslist[i]["data"][i2]["subcategoryArray"] =
        //       //     jsonInput['subCategoryData'];
        //       dailyearnindetailslist[i]["data"][i2]["selectedCategory"] =
        //           jsonInput['categoryData'][0]["name"];
        //       setState(() {});
        //     }
        //   }
        // }
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

  getdailyearningdetailsbydate() async {
    var url = Uri.parse(CommonURL.herokuurl);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getDailyEOSSPDataBYDate";
    request.fields['selectedDate'] = change_date.toString();
    request.fields['service_provider_c'] = service_provider;

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      // print("getdailyearningdetails= $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (status == 'true') {
        dailyearnindetailslist = jsonInput['data'] as List<dynamic>;
        showbtnbool = jsonInput['isGrievanceAlreadyExist'] as bool;
        print("showbtnbool$showbtnbool");
        isloading = false;
        // print(dailyearnindetailslist.length);

        // if (status == 'true') {
        // print(object)
        // datedroplist = jsonInput['dateArray'];

        // for (int i = 0; i < datedroplist.length; i++) {
        //   var changeTodate = (datedroplist[i]['name']);
        //   // change_date = (changetyperesult[i]['fromDate'] +
        //   //     ' to ' +
        //   //     changetyperesult[i]['toDate']);

        //   changetypelist.add(changeTodate);
        // }

        // // datedroplist = jsonInput['dateArray'];
        // // print("object");
        // // print("object");
        // setState(() {});
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

  DailyearningSubmit() async {
    loading();
    var url = Uri.parse(CommonURL.herokuurl);
    // String url = CommonURL.URL;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    // var uri = Uri.parse(url);
    // print(utility.lithiumid);
    // print(utility.service_provider_c);
    // for (int i = 0; i < dailyearnindetailslist.length; i++) {
    print(dailyearnindetailslist);
    // }

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "dailyEarningAdd";
    // change_date
    request.fields['date'] = change_date ?? "";
    request.fields['data'] = jsonEncode(dailyearnindetailslist);
    request.fields['lithiumID'] = utility.lithiumid;
    request.fields['service_provider_c'] = utility.service_provider_c;
    if (imagebool == true) {
      request.files
          .add(await http.MultipartFile.fromPath('benchFile', _image.path));
    }

    // request.files.add(await http.MultipartFile.fromPath('file', _image.path));

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];
      print("jsonInput$jsonInput");
      if (status == 'true') {
        // Navigator.pop(context);
        // Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).pop();
        // Navigator.pop(context, true);
        // Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Dashboard2()));
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );

        // isdata = true;
        // List array = jsonInput['data'];
        // if (array.isNotEmpty) {
        //   last5eoslistarray = array;
        // }
      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}

    // Navigator.pop(context);
    setState(() {});
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CommonAppbar(
      //   title: 'Daily Earnings',
      //   appBar: AppBar(),
      //   widgets: const [],
      // ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: !isloading,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width - 15,
                    height: 30,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(canvasColor: Colors.grey.shade100),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: const Text("-- Select Date -- "),
                          elevation: 0,
                          value: change_date,
                          items: changetypelist.map((items) {
                            return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  " " + items.toString(),
                                ));
                          }).toList(),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: HexColor(Colorscommon.greencolor),
                          ),
                          onChanged: (value) {
                            // print("DropdownMenuItem$DropdownMenuItem");
                            change_date = value.toString();
                            setState(() {
                              getdailyearningdetailsbydate();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SizedBox(
                  // color: Colors.red,
                  // height: MediaQuery.of(context).size.height - 100,
                  child: ListView.builder(
                      shrinkWrap: true,
                      // itemExtent: 225.0,
                      // the number of items in the list
                      physics: const BouncingScrollPhysics(),
                      itemCount: dailyearnindetailslist.length,

                      // padding: const EdgeInsets.all(0),
                      // display each item of the product list
                      itemBuilder: (context, index) {
                        // ignore: deprecated_member_use

                        //debugPrint('Indexvalue' + index.toString());
                        // debugPrint('modellength' +
                        //     permissionModel.detail.length.toString());
                        // print(dailyearnindetailslist[index]['data']);
                        var array = dailyearnindetailslist[index]['data']
                        as List<dynamic>;
                        // print("array$array");
                        // var name =
                        //     dailyearnindetailslist[index]['name'].toString();
                        // print(index);

                        return Container(
                          // color: Colors.red,
                          // height: 100,
                          padding: const EdgeInsets.all(10),
                          // padding: const EdgeInsets.only(
                          //     left: 10, right: 10, top: 0, bottom: 0),
                          child: Column(
                            children: [
                              Row(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  // const Expanded(
                                  //   flex: 1,
                                  //   child: CommonText(
                                  //     text: "GrievanceDate",
                                  //   ),
                                  // ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: CommonText(
                                  //     text: dailyearnindetailslist[index]
                                  //             ['name']
                                  //         .toString(),
                                  //   ),
                                  // ),
                                  Expanded(
                                      child: Text(
                                        dailyearnindetailslist[index]['name']
                                            .toString(),
                                        style: TextStyle(
                                            color:
                                            HexColor(Colorscommon.greencolor),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18),
                                      )),
                                ],
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: array.length,
                                  itemBuilder: (context, index) {
                                    // setState(() {
                                    TextEditingController controller =
                                    TextEditingController();
                                    _controllers.add(controller);
                                    // });

                                    // print(_controllers[index]);
                                    // print("controllerindex$index");
                                    // if (_controllers[index] == index) {}
                                    String? dropdownvalueone;
                                    String? dropdownvaluetwo;
                                    String? dropdownvaluethree;
                                    String? dropdownvaluefour;
                                    // print(index);

                                    var arrayspilt1 =
                                    array[index]["dropdownArray"];
                                    var arrayspilt2 =
                                    array[index]["isAvailDropDown"];
                                    var arrayspilt3 =
                                    array[index]["categoryArray"];
                                    var arrayspilt4 =
                                    array[index]["subcategoryArray"];
                                    String formFieldType = array[index]
                                    ["formFieldType"]
                                        .toString();

                                    // if (dropdownvalueone == null) {
                                    //   dropdownvalueone = array[index]
                                    //           ["selectedDropDownValue"]
                                    //       .toString();

                                    //   print("noflow");
                                    // } else {
                                    //   print("flow");
                                    //   dropdownvalueone;
                                    // }

                                    dropdownvalueone = array[index]
                                    ["selectedDropDownValue"]
                                        .toString();

                                    // print("dropdownvalueone$dropdownvalueone");
                                    dropdownvaluetwo = array[index]
                                    ["selectedIsAvailValue"]
                                        .toString();
                                    dropdownvaluethree = array[index]
                                    ["selectedCategory"]
                                        .toString();
                                    dropdownvaluefour = array[index]
                                    ["selectedSubCategory"]
                                        .toString();
                                    List debitdetailarray =
                                    array[index]['debitList'] as List;

                                    List<String> array1 = [];
                                    List<String> array2 = [];
                                    List<String> array3 = [];
                                    List<String> array4 = [];

                                    List<String> sfidarray1 = [];
                                    List<String> sfidarray2 = [];
                                    List<String> sfidarray3 = [];
                                    List<String> sfidarray4 = [];

                                    for (int i = 0;
                                    i < arrayspilt1.length;
                                    i++) {
                                      if (array[index]["name"].toString() ==
                                          "Roster Start Time") {
                                        String value;
                                        if (i == 0) {
                                          value = (arrayspilt1[i]['name']
                                              .toString());
                                        } else {
                                          value = (arrayspilt1[i]['name']
                                              .toString() +
                                              "( " +
                                              arrayspilt1[i]['id'].toString() +
                                              " )");
                                        }

                                        array1.add(value);
                                      } else if (array[index]["name"]
                                          .toString() ==
                                          "Late") {
                                        // print(array[index]["name"].toString());
                                        // print("formFieldType$formFieldType");
                                        var value = (arrayspilt1[i]
                                        ['start_time__c']
                                            .toString());

                                        array1.add(value);
                                      } else {
                                        var value =
                                        (arrayspilt1[i]['name'].toString());

                                        array1.add(value);
                                      }
                                      if (array[index]["name"].toString() ==
                                          "Roster Start Time") {
                                        var value2 = (arrayspilt1[i]
                                        ['roster_master__c']
                                            .toString() +
                                            "," +
                                            arrayspilt1[i]['start_time__c']
                                                .toString());
                                        sfidarray1.add(value2);
                                      } else {
                                        var value2 = (arrayspilt1[i]
                                        ['roster_master__c']
                                            .toString() +
                                            "," +
                                            arrayspilt1[i]
                                            ['roster_start_datetime']
                                                .toString());
                                        sfidarray1.add(value2);
                                      }
                                    }
                                    for (int i = 0;
                                    i < arrayspilt2.length;
                                    i++) {
                                      var value =
                                      (arrayspilt2[i]['name'].toString());
                                      array2.add(value);
                                      var value2 =
                                      (arrayspilt2[i]['sfid'].toString());
                                      sfidarray2.add(value2);
                                    }
                                    for (int i = 0;
                                    i < arrayspilt3.length;
                                    i++) {
                                      var value =
                                      (arrayspilt3[i]['name'].toString());
                                      array3.add(value);
                                      var value2 =
                                      (arrayspilt3[i]['sfid'].toString());
                                      sfidarray3.add(value2);
                                    }
                                    for (int i = 0;
                                    i < arrayspilt4.length;
                                    i++) {
                                      var value =
                                      (arrayspilt4[i]['name'].toString());
                                      array4.add(value);
                                      var value2 =
                                      (arrayspilt4[i]['sfid'].toString());
                                      sfidarray4.add(value2);
                                    }
                                    print(array[index]["name"].toString());
                                    print(array[index]["viewLabelName"]
                                        .toString());

                                    return Container(
                                      // height: 40,
                                      padding: const EdgeInsets.only(
                                          top: 0,
                                          left: 0,
                                          right: 10,
                                          bottom: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: ExpansionTile(
                                                  title: Row(
                                                    children: [
                                                      Text(
                                                        array[index]["name"]
                                                            .toString(),
                                                        textAlign:
                                                        TextAlign.start,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                      const Expanded(
                                                          child: Text(
                                                              "         ")),
                                                      Text(
                                                        array[index][
                                                        "viewLabelName"]
                                                            .toString(),
                                                        textAlign:
                                                        TextAlign.start,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  children: [
                                                    Visibility(
                                                      visible: array[index][
                                                      "isGrievence"]
                                                          .toString() ==
                                                          "true",
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              // Visibility(
                                                              //   visible:
                                                              //       formFieldType,
                                                              //   child: Expanded(
                                                              //     flex: 2,
                                                              //     child:
                                                              //         Container(
                                                              //       height: 30,
                                                              //       margin:
                                                              //           const EdgeInsets
                                                              //                   .all(
                                                              //               15.0),
                                                              //       padding:
                                                              //           const EdgeInsets
                                                              //                   .all(
                                                              //               3.0),
                                                              //       decoration:
                                                              //           const ShapeDecoration(
                                                              //         shape:
                                                              //             RoundedRectangleBorder(
                                                              //           side: BorderSide(
                                                              //               width:
                                                              //                   1.0,
                                                              //               style:
                                                              //                   BorderStyle.solid),
                                                              //           borderRadius:
                                                              //               BorderRadius.all(
                                                              //                   Radius.circular(5.0)),
                                                              //         ),
                                                              //       ),
                                                              //       child: Theme(
                                                              //         data: Theme.of(
                                                              //                 context)
                                                              //             .copyWith(
                                                              //                 canvasColor:
                                                              //                     Colors.grey.shade100),
                                                              //         child:
                                                              //             DropdownButtonHideUnderline(
                                                              //           child:
                                                              //               DropdownButton(
                                                              //             hint: const Text(
                                                              //                 "Select Reason"),
                                                              //             elevation:
                                                              //                 0,
                                                              //             value:
                                                              //                 dropdownvalueone,
                                                              //             items: array1
                                                              //                 .map((items) {
                                                              //               return DropdownMenuItem(
                                                              //                   value: items,
                                                              //                   child: Text(
                                                              //                     " " + items.toString(),
                                                              //                   ));
                                                              //             }).toList(),
                                                              //             icon:
                                                              //                 Icon(
                                                              //               Icons
                                                              //                   .keyboard_arrow_down,
                                                              //               color:
                                                              //                   HexColor(Colorscommon.greencolor),
                                                              //             ),
                                                              //             onChanged:
                                                              //                 (value) {
                                                              //               print(
                                                              //                   value);
                                                              //               // dropdownvalueone =
                                                              //               //     value.toString();
                                                              //               array[index]["selectedDropDownValue"] =
                                                              //                   value;
                                                              //               setState(
                                                              //                   () {});
                                                              //             },
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              // Visibility(
                                                              //   visible:
                                                              //       !formFieldType,
                                                              //   child: Expanded(
                                                              //       flex: 1,
                                                              //       child:
                                                              //           Bouncing(
                                                              //         onPress:
                                                              //             () {
                                                              //           FocusManager
                                                              //               .instance
                                                              //               .primaryFocus
                                                              //               ?.unfocus();
                                                              //           Future<String>
                                                              //               fromdatee =
                                                              //               utility
                                                              //                   .selectTimeto(context);

                                                              //           fromdatee
                                                              //               .then(
                                                              //                   (value) {
                                                              //             setState(
                                                              //                 () {
                                                              //               debugPrint('selectedvalue' +
                                                              //                   value.toString());

                                                              //               if (value !=
                                                              //                   "null") {
                                                              //                 setState(() {});
                                                              //                 var starttime =
                                                              //                     value.substring(0, value.indexOf('.'));
                                                              //                 var pos =
                                                              //                     value.lastIndexOf('.');
                                                              //                 var starttimesend =
                                                              //                     value.substring(pos + 1);
                                                              //                 print("starttimesend$starttimesend");
                                                              //                 print("starttime$starttime");
                                                              //                 array[index]["selectedDropDownValue"] =
                                                              //                     starttimesend;
                                                              //                 // vailddata();
                                                              //               }
                                                              //             });
                                                              //           });
                                                              //           // print("startdate$fromdatesend");
                                                              //         },
                                                              //         child:
                                                              //             Container(
                                                              //           margin: const EdgeInsets
                                                              //                   .all(
                                                              //               10.0),
                                                              //           height:
                                                              //               30,
                                                              //           decoration:
                                                              //               const ShapeDecoration(
                                                              //             shape:
                                                              //                 RoundedRectangleBorder(
                                                              //               side: BorderSide(
                                                              //                   width: 1.0,
                                                              //                   style: BorderStyle.solid),
                                                              //               borderRadius:
                                                              //                   BorderRadius.all(Radius.circular(5.0)),
                                                              //             ),
                                                              //           ),
                                                              //           child:
                                                              //               Row(
                                                              //             mainAxisAlignment:
                                                              //                 MainAxisAlignment.spaceEvenly,
                                                              //             children: [
                                                              //               Expanded(
                                                              //                 flex:
                                                              //                     2,
                                                              //                 child:
                                                              //                     Text(
                                                              //                   " " + array[index]["selectedDropDownValue"].toString() == " " || array[index]["selectedDropDownValue"].toString() == "0:0" ? " HH : MM" : array[index]["selectedDropDownValue"].toString(),
                                                              //                   // textAlign: TextAlign.center,
                                                              //                   style: TextStyle(color: HexColor(Colorscommon.greycolor)),
                                                              //                 ),
                                                              //               ),
                                                              //               Icon(
                                                              //                 Icons.access_time,
                                                              //                 color:
                                                              //                     HexColor(Colorscommon.greencolor),
                                                              //               )
                                                              //             ],
                                                              //           ),
                                                              //         ),
                                                              //       )),
                                                              // ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                Container(
                                                                  // width: MediaQuery.of(context).size.width - 15,
                                                                  height: 30,
                                                                  margin:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      3.0),
                                                                  decoration:
                                                                  const ShapeDecoration(
                                                                    shape:
                                                                    RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          width:
                                                                          1.0,
                                                                          style:
                                                                          BorderStyle.solid),
                                                                      borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(5.0)),
                                                                    ),
                                                                  ),
                                                                  child: Theme(
                                                                    data: Theme.of(
                                                                        context)
                                                                        .copyWith(
                                                                        canvasColor:
                                                                        Colors.grey.shade100),
                                                                    child:
                                                                    DropdownButtonHideUnderline(
                                                                      child:
                                                                      DropdownButton(
                                                                        // isExpanded: true,
                                                                        // isDense: ,
                                                                        hint: const Text(
                                                                            "None"),
                                                                        elevation:
                                                                        0,
                                                                        value:
                                                                        dropdownvaluetwo,
                                                                        items: array2
                                                                            .map((items) {
                                                                          return DropdownMenuItem(
                                                                              value: items,
                                                                              child: Text(
                                                                                " " + items.toString(),
                                                                              ));
                                                                        }).toList(),
                                                                        icon:
                                                                        Icon(
                                                                          Icons
                                                                              .keyboard_arrow_down,
                                                                          color:
                                                                          HexColor(Colorscommon.greencolor),
                                                                        ),
                                                                        onChanged:
                                                                            (value) {
                                                                          // print("DropdownMenuItem$DropdownMenuItem");
                                                                          // dropdownvaluetwo =
                                                                          //     value
                                                                          //         .toString();
                                                                          print(
                                                                              "value121242$value");
                                                                          print(
                                                                              "indexstr$index");
                                                                          // if (value.toString() ==
                                                                          //     "Grievance") {
                                                                          //   getdailyearningdetailsbycategory(array[index]["name"].toString(),
                                                                          //       index.toString());
                                                                          // }
                                                                          array[index]["selectedIsAvailValue"] =
                                                                              value.toString();

                                                                          setState(
                                                                                  () {
                                                                                // getdailyearningdetailsbydate();
                                                                              });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Visibility(
                                                            visible:
                                                            dropdownvaluetwo ==
                                                                "Grievance",
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                  Container(
                                                                    // width: MediaQuery.of(context).size.width - 15,
                                                                    height: 30,
                                                                    margin: const EdgeInsets
                                                                        .all(
                                                                        10.0),
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        3.0),
                                                                    decoration:
                                                                    const ShapeDecoration(
                                                                      shape:
                                                                      RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            width:
                                                                            1.0,
                                                                            style:
                                                                            BorderStyle.solid),
                                                                        borderRadius:
                                                                        BorderRadius.all(Radius.circular(5.0)),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                    Theme(
                                                                      data: Theme.of(context).copyWith(
                                                                          canvasColor: Colors
                                                                              .grey
                                                                              .shade100),
                                                                      child:
                                                                      DropdownButtonHideUnderline(
                                                                        child:
                                                                        DropdownButton(
                                                                          hint:
                                                                          const Text("Select Category"),
                                                                          elevation:
                                                                          0,
                                                                          value:
                                                                          dropdownvaluethree,
                                                                          items:
                                                                          array3.map((items) {
                                                                            return DropdownMenuItem(
                                                                                value: items,
                                                                                child: Text(
                                                                                  " " + items.toString(),
                                                                                ));
                                                                          }).toList(),
                                                                          icon:
                                                                          Icon(
                                                                            Icons.keyboard_arrow_down,
                                                                            color:
                                                                            HexColor(Colorscommon.greencolor),
                                                                          ),
                                                                          onChanged:
                                                                              (value) {
                                                                            array[index]["selectedCategory"] =
                                                                                value.toString();
                                                                            setState(() {});

                                                                            for (var i = 0;
                                                                            array3.length > i;
                                                                            i++) {
                                                                              print(array3[i].toString());
                                                                              print(value.toString());
                                                                              if (array3[i].toString() == value.toString()) {
                                                                                String datevalue = sfidarray3[i];
                                                                                getSubCategoryByCategory(array[index]["name"].toString(), datevalue);

                                                                                array[index]["selectedCategoryId"] = datevalue.toString();
                                                                                break;
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                                // Expanded(
                                                                //   flex: 1,
                                                                //   child: Container(
                                                                //     // width: MediaQuery.of(context).size.width - 15,
                                                                //     height: 30,
                                                                //     margin:
                                                                //         const EdgeInsets
                                                                //                 .all(
                                                                //             15.0),
                                                                //     padding:
                                                                //         const EdgeInsets
                                                                //             .all(3.0),
                                                                //     decoration:
                                                                //         const ShapeDecoration(
                                                                //       shape:
                                                                //           RoundedRectangleBorder(
                                                                //         side: BorderSide(
                                                                //             width:
                                                                //                 1.0,
                                                                //             style: BorderStyle
                                                                //                 .solid),
                                                                //         borderRadius:
                                                                //             BorderRadius.all(
                                                                //                 Radius.circular(
                                                                //                     5.0)),
                                                                //       ),
                                                                //     ),
                                                                //     child: Theme(
                                                                //       data: Theme.of(
                                                                //               context)
                                                                //           .copyWith(
                                                                //               canvasColor: Colors
                                                                //                   .grey
                                                                //                   .shade100),
                                                                //       child:
                                                                //           DropdownButtonHideUnderline(
                                                                //         child:
                                                                //             DropdownButton(
                                                                //           // isExpanded: true,
                                                                //           // isDense: ,
                                                                //           hint: const Text(
                                                                //               "-- Select Date -- "),
                                                                //           elevation:
                                                                //               0,
                                                                //           value:
                                                                //               dropdownvaluefour,
                                                                //           items: changetypelist
                                                                //               .map(
                                                                //                   (items) {
                                                                //             return DropdownMenuItem(
                                                                //                 value:
                                                                //                     items,
                                                                //                 child:
                                                                //                     Text(
                                                                //                   " " +
                                                                //                       items.toString(),
                                                                //                 ));
                                                                //           }).toList(),
                                                                //           icon: Icon(
                                                                //             Icons
                                                                //                 .keyboard_arrow_down,
                                                                //             color: HexColor(
                                                                //                 Colorscommon
                                                                //                     .greencolor),
                                                                //           ),
                                                                //           onChanged:
                                                                //               (value) {
                                                                //             // print("DropdownMenuItem$DropdownMenuItem");
                                                                //             change_date =
                                                                //                 value
                                                                //                     .toString();
                                                                //             setState(
                                                                //                 () {
                                                                //               getdailyearningdetailsbydate();
                                                                //             });
                                                                //           },
                                                                //         ),
                                                                //       ),
                                                                //     ),
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                          Visibility(
                                                              visible:
                                                              dropdownvaluetwo ==
                                                                  "Grievance",
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child:
                                                                    Container(
                                                                      // width: MediaQuery.of(context).size.width - 15,
                                                                      height:
                                                                      30,
                                                                      margin: const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                      padding:
                                                                      const EdgeInsets.all(
                                                                          3.0),
                                                                      decoration:
                                                                      const ShapeDecoration(
                                                                        shape:
                                                                        RoundedRectangleBorder(
                                                                          side: BorderSide(
                                                                              width: 1.0,
                                                                              style: BorderStyle.solid),
                                                                          borderRadius:
                                                                          BorderRadius.all(Radius.circular(5.0)),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                      Theme(
                                                                        data: Theme.of(context).copyWith(
                                                                            canvasColor:
                                                                            Colors.grey.shade100),
                                                                        child:
                                                                        DropdownButtonHideUnderline(
                                                                          child:
                                                                          DropdownButton(
                                                                            // isExpanded: true,
                                                                            // isDense: ,
                                                                            hint:
                                                                            const Text("Select SubCategory"),
                                                                            elevation:
                                                                            0,
                                                                            value:
                                                                            dropdownvaluefour,
                                                                            items:
                                                                            array4.map((items) {
                                                                              return DropdownMenuItem(
                                                                                  value: items,
                                                                                  child: Text(
                                                                                    " " + items.toString(),
                                                                                  ));
                                                                            }).toList(),
                                                                            icon:
                                                                            Icon(
                                                                              Icons.keyboard_arrow_down,
                                                                              color: HexColor(Colorscommon.greencolor),
                                                                            ),
                                                                            onChanged:
                                                                                (value) {
                                                                              for (var i = 0; array4.length > i; i++) {
                                                                                array[index]["selectedSubCategory"] = value.toString();
                                                                                if (array4[i].toString() == value.toString()) {
                                                                                  var datevalue = sfidarray4[i];
                                                                                  print("datevalue$datevalue");
                                                                                  setState(() {
                                                                                    array[index]["selectedSubCategoryId"] = datevalue.toString();
                                                                                  });
                                                                                  break;
                                                                                }
                                                                              }
                                                                              // print("DropdownMenuItem$DropdownMenuItem");
                                                                              // array[index]["selectedSubcategoryId"] = datevalue.toString();

                                                                              //     value.toString();
                                                                              setState(() {});
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                          Visibility(
                                                            visible:
                                                            dropdownvaluetwo ==
                                                                "Grievance",
                                                            child: Row(
                                                              children: [
                                                                Visibility(
                                                                  visible:
                                                                  formFieldType ==
                                                                      "1",
                                                                  child:
                                                                  Visibility(
                                                                    visible: array[index]
                                                                    [
                                                                    "name"] !=
                                                                        "Late",
                                                                    child:
                                                                    Visibility(
                                                                      visible: array[index]["selectedSubCategory"]
                                                                          .toString()
                                                                          .toLowerCase() !=
                                                                          "adhoc duty",
                                                                      child:
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                        Container(
                                                                          height:
                                                                          30,
                                                                          margin:
                                                                          const EdgeInsets.all(10.0),
                                                                          padding:
                                                                          const EdgeInsets.all(3.0),
                                                                          decoration:
                                                                          const ShapeDecoration(
                                                                            shape:
                                                                            RoundedRectangleBorder(
                                                                              side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                          Theme(
                                                                            data:
                                                                            Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
                                                                            child:
                                                                            DropdownButtonHideUnderline(
                                                                              child: DropdownButton(
                                                                                hint: const Text("Select Reason"),
                                                                                elevation: 0,
                                                                                value: dropdownvalueone,
                                                                                items: array1.map((items) {
                                                                                  return DropdownMenuItem(
                                                                                      value: items,
                                                                                      child: Text(
                                                                                        " " + items.toString(),
                                                                                      ));
                                                                                }).toList(),
                                                                                icon: Icon(
                                                                                  Icons.keyboard_arrow_down,
                                                                                  color: HexColor(Colorscommon.greencolor),
                                                                                ),
                                                                                onChanged: (value) {
                                                                                  // print(value);
                                                                                  // dropdownvalueone =
                                                                                  //     value.toString();
                                                                                  var sampledata = array[index]["selectedDropDownValue"];
                                                                                  print("sampledata$sampledata");
                                                                                  array[index]["selectedDropDownValue"] = value;
                                                                                  for (int i = 0; i < array1.length; i++) {
                                                                                    if (array1[i].toString() == value) {
                                                                                      String setvalue = sfidarray1[i].toString();
                                                                                      print("setvalue11234=$setvalue");
                                                                                      array[index]["selectedDropDownId"] = setvalue;
                                                                                    }
                                                                                  }
                                                                                  setState(() {});
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible:
                                                                  formFieldType ==
                                                                      "3",
                                                                  child:
                                                                  Visibility(
                                                                    visible: array[index]["selectedCategory"]
                                                                        .toString() !=
                                                                        "Training Present",
                                                                    child:
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                      Container(
                                                                        margin:
                                                                        const EdgeInsets.all(10.0),
                                                                        height:
                                                                        30,
                                                                        child:
                                                                        Theme(
                                                                          data:
                                                                          Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
                                                                          child:
                                                                          TextField(
                                                                            controller:
                                                                            _controllers[index],
                                                                            onChanged:
                                                                                (valuestr) {
                                                                              array[index]["selectedDropDownId"] = valuestr;
                                                                            },
                                                                            onSubmitted:
                                                                                (valuestr) {
                                                                              // array[index]["selectedDropDownId"] =
                                                                              //     valuestr;
                                                                              _controllers[index].text = valuestr;
                                                                              // array[index]["selectedDropDownId"] =
                                                                              //     valuestr;

                                                                              // print("valuestr$valuestr");
                                                                              setState(() {});
                                                                            },
                                                                            maxLength:
                                                                            5,
                                                                            keyboardType:
                                                                            TextInputType.number,
                                                                            decoration: const InputDecoration(
                                                                                hintText: 'No of Trips Performed',
                                                                                // labelText: array[index]["selectedDropDownId"].toString(),
                                                                                counterText: ""),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible:
                                                                  formFieldType ==
                                                                      "2",
                                                                  child:
                                                                  Expanded(
                                                                      flex:
                                                                      1,
                                                                      child:
                                                                      Bouncing(
                                                                        onPress:
                                                                            () {
                                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                                          Future<String> fromdatee = utility.selectTimeto(context);

                                                                          fromdatee.then((value) {
                                                                            setState(() {
                                                                              // debugPrint('selectedvalue' + value.toString());

                                                                              if (value != "null") {
                                                                                var starttime = value.substring(0, value.indexOf('.'));
                                                                                var pos = value.lastIndexOf('.');
                                                                                var starttimesend = value.substring(pos + 1);
                                                                                print("starttimesend$starttimesend");
                                                                                // print("starttimesend$starttimesend");
                                                                                // print("starttime$starttime");
                                                                                array[index]["selectedDropDownId"] = starttimesend;
                                                                                // array[index]["selectedDropDownValue"] = starttimesend;
                                                                                // // vailddata();
                                                                                // setState(() {});
                                                                              }
                                                                            });
                                                                          });
                                                                        },
                                                                        child:
                                                                        Container(
                                                                          margin: const EdgeInsets.all(10.0),
                                                                          height: 30,
                                                                          decoration: const ShapeDecoration(
                                                                            shape: RoundedRectangleBorder(
                                                                              side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                            ),
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 2,
                                                                                child: Text(
                                                                                  " " + array[index]["selectedDropDownId"].toString() == " " || array[index]["selectedDropDownId"].toString() == "0:0" ? " HH : MM" : array[index]["selectedDropDownId"].toString(),
                                                                                  // textAlign: TextAlign.center,
                                                                                  style: TextStyle(color: HexColor(Colorscommon.greycolor)),
                                                                                ),
                                                                              ),
                                                                              Icon(
                                                                                Icons.access_time,
                                                                                color: HexColor(Colorscommon.greencolor),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible:
                                                      dropdownvaluetwo ==
                                                          "Grievance",
                                                      child: Visibility(
                                                        visible: array[index]
                                                        ['name']
                                                            .toString() ==
                                                            "Trip Count",
                                                        child: Visibility(
                                                          visible: array[index][
                                                          'viewLabelName']
                                                              .toString() ==
                                                              "0",
                                                          child: Row(
                                                            children: [
                                                              Bouncing(
                                                                onPress: () {
                                                                  FocusManager
                                                                      .instance
                                                                      .primaryFocus
                                                                      ?.unfocus();
                                                                  _showPicker(
                                                                      context);
                                                                },
                                                                child:
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      top: 10,
                                                                      right: 10,
                                                                      left: 10),
                                                                  child: Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .centerLeft,
                                                                    child:
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                          .size
                                                                          .width /
                                                                          3,
                                                                      height:
                                                                      40,
                                                                      decoration:
                                                                      const ShapeDecoration(
                                                                        shape:
                                                                        RoundedRectangleBorder(
                                                                          side: BorderSide(
                                                                              width: 1.0,
                                                                              style: BorderStyle.solid),
                                                                          borderRadius:
                                                                          BorderRadius.all(Radius.circular(5.0)),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.center,
                                                                        // ignore: prefer_const_literals_to_create_immutables
                                                                        children: [
                                                                          Icon(
                                                                            Icons.upload_file,
                                                                            color:
                                                                            HexColor(Colorscommon.greencolor),
                                                                          ),
                                                                          Flexible(
                                                                            flex:
                                                                            1,
                                                                            child:
                                                                            Text(
                                                                              imgname != '' ? 'File Attached' : 'Select File',
                                                                              style: TextStyle(color: HexColor(Colorscommon.greycolor), fontFamily: "TomaSans-Regular"),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                imgname !=
                                                                    '',
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 6.0),
                                                                  child:
                                                                  IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .delete_forever),
                                                                    color: Colors
                                                                        .red,
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                              () {
                                                                            imgname =
                                                                            '';
                                                                            imagebool =
                                                                            false;
                                                                          });
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: array[index]
                                                      ['name']
                                                          .toString() ==
                                                          "Trip Count",
                                                      child: Visibility(
                                                        visible: array[index][
                                                        'viewLabelName']
                                                            .toString() ==
                                                            "0",
                                                        child: const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                        visible: array[index]
                                                        ['name']
                                                            .toString() ==
                                                            "Debit Details",
                                                        child: Visibility(
                                                          visible:
                                                          debitdetailarray
                                                              .isNotEmpty,
                                                          child: Card(
                                                            elevation: 5,
                                                            child: Container(
                                                              margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                        10,
                                                                        left:
                                                                        10,
                                                                        bottom:
                                                                        10,
                                                                        top:
                                                                        10),
                                                                    child: Row(
                                                                        children: const [
                                                                          Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                "Name",
                                                                                style: TextStyle(fontWeight: FontWeight.w500),
                                                                              )),
                                                                          Expanded(
                                                                              flex: 1,
                                                                              child: Text(
                                                                                "Voucher Type",
                                                                                style: TextStyle(fontWeight: FontWeight.w500),
                                                                              )),
                                                                          Expanded(
                                                                            flex:
                                                                            1,
                                                                            child:
                                                                            Text(
                                                                              "Amount",
                                                                              style: TextStyle(fontWeight: FontWeight.w500),
                                                                              textAlign: TextAlign.right,
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: const BouncingScrollPhysics(),
                                                                      itemCount: debitdetailarray.length,
                                                                      itemBuilder: (BuildContext context, int index) {
                                                                        return Container(
                                                                          margin: const EdgeInsets.only(
                                                                              right: 10,
                                                                              left: 10,
                                                                              bottom: 10,
                                                                              top: 10),
                                                                          child:
                                                                          Row(children: [
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: Text(debitdetailarray[index]['name'].toString())),
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: Text(debitdetailarray[index]['voucher_type'].toString())),
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: Text(
                                                                                  (debitdetailarray[index]['amount'].toString()),
                                                                                  textAlign: TextAlign.right,
                                                                                )),
                                                                          ]),
                                                                        );
                                                                        // return Column(
                                                                        //   children: [
                                                                        //     Padding(
                                                                        //       padding:
                                                                        //           const EdgeInsets.all(10),
                                                                        //       child:
                                                                        //           SizedBox(
                                                                        //         height:
                                                                        //             40,
                                                                        //         child:
                                                                        //             Row(
                                                                        //           mainAxisAlignment: MainAxisAlignment.start,
                                                                        //           children: const [
                                                                        //             Expanded(
                                                                        //               flex: 2,
                                                                        //               child: Text(
                                                                        //                 'Extra Hours',
                                                                        //                 textAlign: TextAlign.start,
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //                 // style: TextStyle(
                                                                        //                 //     // color: Colors.white,
                                                                        //                 //     fontWeight: FontWeight.bold),
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //               ),
                                                                        //             ),
                                                                        //           ],
                                                                        //         ),
                                                                        //       ),
                                                                        //     ),
                                                                        //     Padding(
                                                                        //       padding:
                                                                        //           const EdgeInsets.all(10),
                                                                        //       child:
                                                                        //           SizedBox(
                                                                        //         height:
                                                                        //             40,
                                                                        //         child:
                                                                        //             Row(
                                                                        //           mainAxisAlignment: MainAxisAlignment.start,
                                                                        //           children: const [
                                                                        //             Expanded(
                                                                        //               flex: 2,
                                                                        //               child: Text(
                                                                        //                 'Debit',
                                                                        //                 textAlign: TextAlign.start,
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 ' ',
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //                 // style: TextStyle(
                                                                        //                 //     // color: Colors.white,
                                                                        //                 //     fontWeight: FontWeight.bold),
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //               ),
                                                                        //             ),
                                                                        //           ],
                                                                        //         ),
                                                                        //       ),
                                                                        //     ),
                                                                        //     Padding(
                                                                        //       padding:
                                                                        //           const EdgeInsets.all(10),
                                                                        //       child:
                                                                        //           SizedBox(
                                                                        //         height:
                                                                        //             40,
                                                                        //         child:
                                                                        //             Row(
                                                                        //           mainAxisAlignment: MainAxisAlignment.start,
                                                                        //           children: const [
                                                                        //             Expanded(
                                                                        //               flex: 2,
                                                                        //               child: Text(
                                                                        //                 'Accident Recovery',
                                                                        //                 textAlign: TextAlign.start,
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //                 // style: TextStyle(
                                                                        //                 //     // color: Colors.white,
                                                                        //                 //     fontWeight: FontWeight.bold),
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //               ),
                                                                        //             ),
                                                                        //             Expanded(
                                                                        //               flex: 1,
                                                                        //               child: Text(
                                                                        //                 '',
                                                                        //               ),
                                                                        //             ),
                                                                        //           ],
                                                                        //         ),
                                                                        //       ),
                                                                        //     ),
                                                                        //   ],
                                                                        // );
                                                                      }),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          replacement:
                                                          const SizedBox(
                                                            height: 40,
                                                            child: Center(
                                                              child: Text(
                                                                  ("No Data Available ")),
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                  // text: array[index]["name"]
                                                  //     .toString(),
                                                ),
                                              ),
                                              //
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 5,
                                          // ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        );
                      }),
                ),
              ),
              Visibility(
                visible: !showbtnbool,
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 40,
                        margin: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor(Colorscommon.greencolor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          // RaisedButton(
                          //   color: HexColor(Colorscommon.greencolor),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            bool closestatus = true;
                            bool noGrivence = true;
                            for (int i = 0;
                            i < dailyearnindetailslist.length;
                            i++) {
                              if (!closestatus) {
                                break;
                              }
                              for (int i2 = 0;
                              i2 < dailyearnindetailslist[i]["data"].length;
                              i2++) {
                                if (dailyearnindetailslist[i]["data"][i2]
                                ["selectedIsAvailValue"]
                                    .toString() ==
                                    "Grievance") {
                                  noGrivence = false;
                                  if (dailyearnindetailslist[i]["data"][i2]
                                  ["selectedCategoryId"]
                                      .toString() ==
                                      "") {
                                    // print("Category");
                                    Fluttertoast.showToast(
                                      msg: "Please Select " +
                                          dailyearnindetailslist[i]["data"][i2]
                                          ["name"]
                                              .toString() +
                                          "  Category",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                    );
                                    closestatus = false;
                                    break;
                                  }
                                  // else if (dailyearnindetailslist[i]["data"]
                                  //             [i2]["selectedSubCategory"]
                                  //         .toString()
                                  //         .toLowerCase() !=
                                  //     "adhoc duty") {
                                  else if (dailyearnindetailslist[i]["data"][i2]
                                  ["selectedSubCategoryId"]
                                      .toString() ==
                                      "") {
                                    Fluttertoast.showToast(
                                      msg: "Please Select " +
                                          dailyearnindetailslist[i]["data"][i2]
                                          ["name"]
                                              .toString() +
                                          "  SubCategory",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                    );
                                    closestatus = false;
                                    break;
                                  }
                                  // }
                                  else if (dailyearnindetailslist[i]["data"][i2]
                                  ["selectedCategory"]
                                      .toString() !=
                                      "Training Present") {
                                    if (dailyearnindetailslist[i]["data"][i2]
                                    ["name"]
                                        .toString() !=
                                        "Late") {
                                      if (dailyearnindetailslist[i]["data"][i2]
                                      ["selectedSubCategory"]
                                          .toString()
                                          .toLowerCase() !=
                                          "adhoc duty") {
                                        if (dailyearnindetailslist[i]["data"]
                                        [i2]["selectedDropDownId"]
                                            .toString() ==
                                            "") {
                                          Fluttertoast.showToast(
                                            msg: "Please Select " +
                                                dailyearnindetailslist[i]
                                                ["data"][i2]["name"]
                                                    .toString() +
                                                " Dropdown",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                          closestatus = false;
                                          break;
                                        }
                                      }
                                    }
                                  }

                                  // else {
                                  //   // if (i == dailyearnindetailslist.length) {
                                  //   //   print("last index ");
                                  //   //   DailyearningSubmit();
                                  //   // }
                                  // }
                                } else {
                                  print("last index for delay");
                                  if (i == dailyearnindetailslist.length - 1) {
                                    // print("last index for delay bv");
                                    // if (apicalling) {
                                    //   apicalling = false;
                                    //   setState(() {});
                                    if (closestatus) {
                                      if (noGrivence) {
                                        // print("nogrivance selected");
                                        Raisenogriveance_func();
                                      } else {
                                        DailyearningSubmit();
                                      }
                                    }
                                    break;
                                    // }
                                  }
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // RaisedButton(
              //   onPressed: () {

              //   },
              //   child: const Text("Submit"),
              // ),
            ],
          ),
          replacement: Center(
            child: CircularProgressIndicator(
              color: HexColor(Colorscommon.greencolor),
            ),
          ),
        ),
        // child: DropdownButton(
        //     value: Dropdownvalue, icon: const Icon(Icons.keyboard)),
      ),
    );
  }

  void Raisenogriveance_func() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            titlePadding: EdgeInsets.zero,
            title: Container(
              height: 50,
              color: HexColor(Colorscommon.greencolor),
              child: Center(
                child: Text(
                  "No Grievance",
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                      color: HexColor(Colorscommon.whitecolor)),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            titleTextStyle: TextStyle(color: Colors.grey[700]),
            // titlePadding: const EdgeInsets.only(left: 5, top: 5),
            content: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 5),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 10, right: 10),
                child: Text(
                  "Do you want to raise no grievance?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'TomaSans-Regular',
                    fontSize: 18,
                    color: HexColor(Colorscommon.greycolor),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Bouncing(
                onPress: () async {
                  Raise_no_griveanceapi(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(colors: [
                        HexColor(Colorscommon.greencolor),
                        HexColor(Colorscommon.greencolor),
                      ])),
                  child: const Center(
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              Bouncing(
                onPress: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: HexColor(Colorscommon.greencolor)),
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(colors: [
                        Colors.white,
                        Colors.white
                        // HexColor(Colorscommon.greencolor),
                        // HexColor(Colorscommon.greencolor),
                      ])),
                  child: Center(
                      child: Text(
                        "No",
                        style: TextStyle(
                            color: HexColor(Colorscommon.greencolor),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ),
            ],
          );
        });
  }

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

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
