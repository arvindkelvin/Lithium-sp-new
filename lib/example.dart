// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
// import 'package:flutter_application_sfdc_idp/Colors.dart';
// import 'package:flutter_application_sfdc_idp/CommonColor.dart';
// import 'package:flutter_application_sfdc_idp/CommonText.dart';
// import 'package:flutter_application_sfdc_idp/URL.dart';
// import 'package:flutter_application_sfdc_idp/Utility.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:lottie/lottie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_face_api/face_api.dart' as Regula;
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// import '../DB-Helper/Db-helper.dart';
// import '../Login.dart';
// import 'Dashboard2.dart';
// import 'Earnings/Dashboardtabbar.dart';
//
// import 'package:mime/mime.dart';
//
// import 'package:image/image.dart' as img;
// import 'package:location/location.dart';
//
// class ChargingCar extends StatefulWidget {
//   const ChargingCar({Key? key}) : super(key: key);
//
//   @override
//   State<ChargingCar> createState() => _ChargingCarState();
// }
//
// class _ChargingCarState extends State<ChargingCar>
//     with SingleTickerProviderStateMixin {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   Barcode? result;
//   QRViewController? controller;
//
//   Utility utility = Utility();
//   late AnimationController _controller;
//   var username = "";
//   var spusername = "";
//   var total_count = "0";
//
//   // Define TextEditingController for each text field to retrieve their values
//   TextEditingController vehicleNoController = TextEditingController();
//   TextEditingController odometerController = TextEditingController();
//   TextEditingController startSocController = TextEditingController();
//   TextEditingController chargingTypeController = TextEditingController();
//   TextEditingController endSocController = TextEditingController();
//
//   TextEditingController textEditingController = TextEditingController();
//
//   // Define variables to store selected values from dropdowns
//   String? selectedVehicleNo;
//
//   List<Map<String, dynamic>> chargingTypes = [
//     {"id": "1", "chargingtype": "Slow Charge"},
//     {"id": "2", "chargingtype": "Fast Charge"},
//   ];
//
//   String selectedChargingType = "1";
//   Map<String, dynamic> fields = {};
//
//   List<dynamic> vehicleNoData = [];
//
//   bool showFirstRow = false;
//   bool showStartSocRow = false;
//   bool showEndSocRow = false;
//
//   Uint8List? capturedImage;
//
//   File? img1;
//   File? img2;
//   File? img3;
//
//   var image2 = new Regula.MatchFacesImage();
//   String _similarity = "nil";
//   String _liveness = "nil";
//   bool isImageCaptureInProgress = false;
//   bool isCheckingSimilarity = false;
//   bool isCheckInButtonEnabled = false;
//
//   // Uint8List? capturedImage;
//   File? selectedImage1;
//   File? selectedImage;
//   File? image2Data;
//   String? imgname = 'Verify your face';
//   String? image = "assets/face2.png";
//   bool isImageCaptured = false;
//   bool isImageCaptured1 = false;
//   bool isImageCaptured2 = false;
//   final FocusNode odometerFocusNode = FocusNode();
//   bool isOdometerValid = true;
//   bool isVehicleNoSelected = false;
//
//   bool showQRScannerButton = true;
//   var db = DBHelper();
//
//   bool isLoading = false;
//
//   // bool isLoading = false;
//   bool isOnline = false;
//
//   void closeLoader(BuildContext context) {
//     debugPrint('close loader called');
//     Navigator.of(context, rootNavigator: true).pop();
//   }
//
//   Future<void> checkConnectivity() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     setState(() {
//       isOnline = connectivityResult != ConnectivityResult.none;
//     });
//   }
//
//   Widget loading1() {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(25.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               'assets/lithiugif.gif',
//               width: 50,
//             ),
//             Container(
//               margin: const EdgeInsets.only(left: 10),
//               child: const Text("Loading"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
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
//   // void offlinehandleSubmit() async {
//   //   bool? confirmed = await showDialog<bool>(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.circular(20),
//   //         ),
//   //         title: Container(
//   //           padding: EdgeInsets.all(2.0), // Add padding around the container
//   //           decoration: BoxDecoration(
//   //             color: Colors.white, // Background color
//   //             borderRadius: BorderRadius.circular(10), // Rounded corners
//   //           ),
//   //           child: Row(
//   //             children: [
//   //               Icon(Icons.directions_car,
//   //                   color: HexColor(Colorscommon.greenApp2color), size: 30),
//   //               SizedBox(width: 8),
//   //               Expanded(
//   //                 child: Text(
//   //                   'Confirm Details',
//   //                   style: TextStyle(
//   //                     fontWeight: FontWeight.bold,
//   //                     fontSize: 20, // Increased font size for better visibility
//   //                     color: HexColor(Colorscommon.greenApp2color), // Text color
//   //                   ),
//   //                   overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //         content: SingleChildScrollView(
//   //           child: Column(
//   //             children: <Widget>[
//   //               Column(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   Divider(
//   //                     color: Colors.grey, // Set the color of the divider
//   //                     thickness: 1.5, // Set the thickness of the divider
//   //                     indent: 16.0, // Add left padding
//   //                     endIndent: 16.0, // Add right padding
//   //                   ),
//   //                   Table(
//   //                     columnWidths: const {
//   //                       0: FlexColumnWidth(2),
//   //                       1: FlexColumnWidth(2),
//   //                     },
//   //                     children: [
//   //                       TableRow(
//   //                         children: [
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('Vehicle Number :',
//   //                                 style: TextStyle(
//   //                                     fontSize: 14,
//   //                                     fontWeight: FontWeight.w500)),
//   //                           ),
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('$selectedVehicleNo',
//   //                                 style: TextStyle(fontSize: 14)),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                       TableRow(
//   //                         children: [
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('Lithium ID :',
//   //                                 style: TextStyle(
//   //                                     fontSize: 14,
//   //                                     fontWeight: FontWeight.w500)),
//   //                           ),
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('${utility.lithiumid}',
//   //                                 style: TextStyle(fontSize: 14)),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                       TableRow(
//   //                         children: [
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('Odometer :',
//   //                                 style: TextStyle(
//   //                                     fontSize: 14,
//   //                                     fontWeight: FontWeight.w500)),
//   //                           ),
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('${odometerController.text}',
//   //                                 style: TextStyle(fontSize: 14)),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                       TableRow(
//   //                         children: [
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('Start SOC :',
//   //                                 style: TextStyle(
//   //                                     fontSize: 14,
//   //                                     fontWeight: FontWeight.w500)),
//   //                           ),
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('${startSocController.text}',
//   //                                 style: TextStyle(fontSize: 14)),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                       TableRow(
//   //                         children: [
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('Charging Type :',
//   //                                 style: TextStyle(
//   //                                     fontSize: 14,
//   //                                     fontWeight: FontWeight.w500)),
//   //                           ),
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text(
//   //                                 getChargingTypeLabel(selectedChargingType),
//   //                                 style: TextStyle(fontSize: 14)),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                       TableRow(
//   //                         children: [
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('End SOC :',
//   //                                 style: TextStyle(
//   //                                     fontSize: 14,
//   //                                     fontWeight: FontWeight.w500)),
//   //                           ),
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Text('${endSocController.text}',
//   //                                 style: TextStyle(fontSize: 14)),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 ],
//   //               ),
//   //               Divider(
//   //                 color: Colors.grey, // Set the color of the divider
//   //                 thickness: 1.0, // Set the thickness of the divider
//   //                 indent: 16.0, // Add left padding
//   //                 endIndent: 16.0, // Add right padding
//   //               ),
//   //               if (img1 != null || img2 != null || img3 != null)
//   //                 Padding(
//   //                   padding: const EdgeInsets.all(1.0),
//   //                   child: SingleChildScrollView(
//   //                     child: Column(
//   //                       crossAxisAlignment: CrossAxisAlignment.start,
//   //                       children: [
//   //                         if (img1 != null)
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Row(
//   //                               children: [
//   //                                 Text('End SOC Image:',
//   //                                     style: TextStyle(
//   //                                         fontSize: 16,
//   //                                         fontWeight: FontWeight.w500)),
//   //                                 SizedBox(width: 8),
//   //                                 Expanded(
//   //                                   child: Align(
//   //                                     alignment: Alignment.centerRight,
//   //                                     child: GestureDetector(
//   //                                       onTap: () {
//   //                                         showDialog(
//   //                                           context: context,
//   //                                           barrierDismissible: false,
//   //                                           builder: (BuildContext context) {
//   //                                             return Dialog(
//   //                                               child: Image.file(img1!),
//   //                                             );
//   //                                           },
//   //                                         );
//   //                                       },
//   //                                       child: Image.file(img1!,
//   //                                           height: 100, fit: BoxFit.cover),
//   //                                     ),
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                         if (img2 != null)
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Row(
//   //                               children: [
//   //                                 Text('Start SOC Image:',
//   //                                     style: TextStyle(
//   //                                         fontSize: 16,
//   //                                         fontWeight: FontWeight.w500)),
//   //                                 SizedBox(width: 8),
//   //                                 Expanded(
//   //                                   child: Align(
//   //                                     alignment: Alignment.centerRight,
//   //                                     child: GestureDetector(
//   //                                       onTap: () {
//   //                                         showDialog(
//   //                                           context: context,
//   //                                           barrierDismissible: false,
//   //                                           builder: (BuildContext context) {
//   //                                             return Dialog(
//   //                                               child: Image.file(img2!),
//   //                                             );
//   //                                           },
//   //                                         );
//   //                                       },
//   //                                       child: Image.file(img2!,
//   //                                           height: 100, fit: BoxFit.cover),
//   //                                     ),
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                         if (img3 != null)
//   //                           Padding(
//   //                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//   //                             child: Row(
//   //                               children: [
//   //                                 Text('Odometer Image:',
//   //                                     style: TextStyle(
//   //                                         fontSize: 16,
//   //                                         fontWeight: FontWeight.w500)),
//   //                                 SizedBox(width: 8),
//   //                                 Expanded(
//   //                                   child: Align(
//   //                                     alignment: Alignment.centerRight,
//   //                                     child: GestureDetector(
//   //                                       onTap: () {
//   //                                         showDialog(
//   //                                           context: context,
//   //                                           barrierDismissible: false,
//   //                                           builder: (BuildContext context) {
//   //                                             return Dialog(
//   //                                               child: Image.file(img3!),
//   //                                             );
//   //                                           },
//   //                                         );
//   //                                       },
//   //                                       child: Image.file(img3!,
//   //                                           height: 100, fit: BoxFit.cover),
//   //                                     ),
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                 )
//   //             ],
//   //           ),
//   //         ),
//   //         actions: <Widget>[
//   //           TextButton(
//   //             child: Text('Cancel', style: TextStyle(color: Colors.red)),
//   //             onPressed: () {
//   //               Navigator.of(context).pop(false);
//   //             },
//   //           ),
//   //           ElevatedButton(
//   //             child: Text('Confirm'),
//   //             style: ElevatedButton.styleFrom(
//   //               primary: Colors.green,
//   //               onPrimary: Colors.white,
//   //               shape: RoundedRectangleBorder(
//   //                 borderRadius: BorderRadius.circular(10),
//   //               ),
//   //             ),
//   //             onPressed: () {
//   //               Navigator.of(context).pop(true);
//   //             },
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   //
//   //   if (!confirmed!) {
//   //     return; // User canceled the upload
//   //   }
//   //
//   //   // Convert images to base64 strings
//   //   String StartSocimage = StartSocImageBase64();
//   //   print('base64Imagestart--$StartSocimage');
//   //
//   //   String EndSocimage = endSocImageBase64();
//   //   print('base64Imageend--$EndSocimage');
//   //
//   //   String Odometerimage = OdometerImageBase64();
//   //   print('base64Imageodometer--$Odometerimage');
//   //
//   //   String odometer = odometerController.text;
//   //   String startSoc = startSocController.text;
//   //   String endSoc = endSocController.text;
//   //
//   //   // Show a loading dialog
//   //   showLoadingDialog();
//   //
//   //   // Prepare data for offline storage
//   //   Map<String, dynamic> visitrow = {
//   //     db.lithiumid: utility.lithiumid,
//   //     db.name: utility.sp_username,
//   //     db.startsoc: startSoc.toString(),
//   //     db.endsoc: endSoc.toString(),
//   //     db.odometer: odometer.toString(),
//   //     db.vehiclenumber: selectedVehicleNo!,
//   //     db.Lattitude: '00.000',
//   //     db.Longtitude: '00.000',
//   //     db.charging: selectedChargingType,
//   //     db.startsocimage: StartSocimage,
//   //     db.endsocimage: EndSocimage,
//   //     db.ododometerimage: Odometerimage,
//   //   };
//   //
//   //   print('visitrow $visitrow');
//   //
//   //   // Insert visitrow data into the local database
//   //   await db.saveCharginList(visitrow);
//   //   print('Data inserted into local database');
//   //
//   //   // Dismiss the loading dialog
//   //   Navigator.of(context).pop();
//   //
//   //   // Display a success message
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(
//   //       content: Text('Data submitted offline successfully!'),
//   //       backgroundColor: Colors.green,
//   //     ),
//   //   );
//   // }
//
//
//   void offlinehandleSubmit() async {
//     // Convert images to base64 strings
//     String StartSocimage = StartSocImageBase64();
//     print('base64Imagestart--$StartSocimage');
//
//     String EndSocimage = endSocImageBase64();
//     print('base64Imageend--$EndSocimage');
//
//     String Odometerimage = OdometerImageBase64();
//     print('base64Imageodometer--$Odometerimage');
//
//     String odometer = odometerController.text;
//     String startSoc = startSocController.text;
//     String endSoc = endSocController.text;
//
//     // Show a loading dialog
//     showLoadingDialog();
//
//     // Prepare data for offline storage
//     Map<String, dynamic> visitrow = {
//       db.lithiumid: utility.lithiumid,
//       db.name: utility.sp_username,
//       db.startsoc: startSoc.toString(),
//       db.endsoc: endSoc.toString(),
//       db.odometer: odometer.toString(),
//       db.vehiclenumber: selectedVehicleNo!,
//       db.Lattitude: '00.000',
//       db.Longtitude: '00.000',
//       db.charging: selectedChargingType,
//       db.startsocimage: StartSocimage,
//       db.endsocimage: EndSocimage,
//       db.ododometerimage: Odometerimage,
//     };
//
//     // Save the data offline
//     await db.saveCharginList(visitrow);
//
//     // Close the loading dialog
//     closeLoader(context);
//
//     // Show a success dialog
//     showAnimatedDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             children: [
//               Icon(Icons.check_circle, color: Colors.green),
//               SizedBox(width: 8),
//               Expanded(child: Text('Success')),
//             ],
//           ),
//           content: Text("Charging data uploaded in offline mode."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//       animationType: DialogTransitionType.slideFromBottomFade,
//       curve: Curves.fastOutSlowIn,
//       duration: Duration(seconds: 1),
//     );
//
//     // Clear the form data and draft
//     clearFormData();
//     await clearDraft();
//     setState(() {});
//   }
//
//
//
//
//
//   autoCaptureImage1(int index) async {
//     try {
//       List<CameraDescription> cameras = await availableCameras();
//       CameraDescription? backCamera = cameras.firstWhere(
//             (camera) => camera.lensDirection == CameraLensDirection.back,
//       );
//
//       if (backCamera != null) {
//         final CameraController controller = CameraController(
//           backCamera,
//           ResolutionPreset.low,
//         );
//         await controller.initialize();
//         await controller.setFlashMode(FlashMode.off); // Turn off the flash
//
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.0),
//               ),
//               child: Container(
//                 padding: EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16.0),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         height: 400.0,
//                         width: double.infinity,
//                         child: CameraPreview(controller),
//                       ),
//                       SizedBox(height: 16.0),
//                       ElevatedButton(
//                         onPressed: () async {
//                           XFile? imageFile = await controller.takePicture();
//                           if (imageFile != null) {
//                             // Compress the image
//                             File compressedImage =
//                             await compressImage(File(imageFile.path));
//
//                             setState(() {
//                               if (index == 1) {
//                                 img1 = compressedImage;
//                               }
//                               if (index == 2) {
//                                 img2 = compressedImage;
//                               }
//                               if (index == 3) {
//                                 img3 = compressedImage;
//                               }
//                             });
//                             Navigator.pop(context);
//                             await performImage();
//                           } else {
//                             Fluttertoast.showToast(
//                                 msg: "Failed to capture image");
//                             print('Failed to capture image');
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                         ),
//                         child: Text('Capture Image',
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       } else {
//         Fluttertoast.showToast(msg: "No back camera available");
//         print('No back camera available');
//       }
//     } catch (e) {
//       print('Error initializing camera: $e');
//       Fluttertoast.showToast(msg: "Error initializing camera");
//     }
//   }
//
//   Future<File> compressImage(File imageFile) async {
//     Uint8List imageBytes = await imageFile.readAsBytes();
//     img.Image image = img.decodeImage(imageBytes)!;
//
//     int quality = 100;
//     List<int> encodedBytes = img.encodeJpg(image, quality: quality);
//
//     // Reduce quality incrementally until the image size is below 200 KB
//     while (encodedBytes.length > 200 * 1024 && quality > 0) {
//       quality -= 10;
//       encodedBytes = img.encodeJpg(image, quality: quality);
//     }
//
//     String tempDir = (await getTemporaryDirectory()).path;
//     File compressedImage = File('$tempDir/compressed_image.jpg');
//     await compressedImage.writeAsBytes(encodedBytes);
//
//     return compressedImage;
//   }
//
//   Future<void> performImage() async {
//     try {
//       if (img1 != null) {
//         setState(() {
//           imgname = "Face Verified";
//           isImageCaptured = true;
//         });
//       }
//       if (img2 != null) {
//         setState(() {
//           imgname = "Face Verified";
//           isImageCaptured1 = true;
//         });
//       }
//       if (img3 != null) {
//         setState(() {
//           imgname = "Face Verified";
//           isImageCaptured2 = true;
//         });
//       }
//     } catch (e) {
//       print('Error during face matching: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           isCheckingSimilarity = false;
//         });
//       }
//     }
//   }
//
//   Future<String> generateTempImagePath() async {
//     Directory tempDir = await getTemporaryDirectory();
//     return '${tempDir.path}/temp_image.jpg';
//   }
//
//
//   Future<void> fetchVehicleNumbers() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     var url = Uri.parse(CommonURL.herokuurl);
//     print("Fetching vehicle numbers...");
//
//     Timer? toastTimer;
//     bool hasCachedData = false;
//
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       // Check if there's cached data
//       if (prefs.containsKey('vehicleNoData')) {
//         hasCachedData = true;
//       }
//
//       // Check connectivity first
//       await checkConnectivity();
//
//       Map<String, String> headers = {
//         "Accept": "application/json",
//         "Content-Type": "application/x-www-form-urlencoded"
//       };
//       var request = http.MultipartRequest("POST", url);
//       request.headers.addAll(headers);
//       request.fields['from'] = "vehicledropdownindia";
//
//       // Show a toast if the request takes longer than 3 seconds
//       toastTimer = Timer(Duration(seconds: 10), () {
//         Fluttertoast.showToast(
//             msg: "Fetching data is taking longer than expected...",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.black,
//             textColor: Colors.white,
//             fontSize: 16.0
//         );
//       });
//
//       // Set a timeout for the request if there is cached data
//       final streamedResponse = hasCachedData
//           ? await request.send().timeout(Duration(seconds: 30))
//           : await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//
//       if (response.statusCode == 200) {
//         Map<String, dynamic> responseData = jsonDecode(response.body);
//         print("get daily earn = $responseData");
//
//         // Save the data locally
//         await prefs.setString('vehicleNoData', jsonEncode(responseData['data']));
//
//         setState(() {
//           vehicleNoData = responseData['data'];
//         });
//       } else {
//         throw Exception('Failed to load vehicle numbers');
//       }
//     } on TimeoutException catch (_) {
//       print('Request timed out');
//       if (hasCachedData) {
//         await loadCachedData();
//       } else {
//         throw Exception('Failed to load vehicle numbers');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//       if (hasCachedData) {
//         await loadCachedData();
//       } else {
//         throw Exception('Failed to load vehicle numbers');
//       }
//     } finally {
//       // Cancel the toast timer if the request finishes in less than 3 seconds
//       toastTimer?.cancel();
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//
//
//   Future<void> loadCachedData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? cachedData = prefs.getString('vehicleNoData');
//
//     if (cachedData != null) {
//       setState(() {
//         vehicleNoData = jsonDecode(cachedData);
//       });
//       print('Loaded vehicle numbers from cache');
//     } else {
//       print('No cached data available');
//     }
//   }
//
//   // Future<void> fetchVehicleNumbers() async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //
//   //   var url = Uri.parse(CommonURL.herokuurl);
//   //   print("Fetching vehicle numbers...");
//   //
//   //   try {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     Map<String, String> headers = {
//   //       "Accept": "application/json",
//   //       "Content-Type": "application/x-www-form-urlencoded"
//   //     };
//   //     var request = http.MultipartRequest("POST", url);
//   //     request.headers.addAll(headers);
//   //     request.fields['from'] = "vehicledropdownindia";
//   //     var streamResponse = await request.send();
//   //     var response = await http.Response.fromStream(streamResponse);
//   //
//   //     if (response.statusCode == 200) {
//   //       Map<String, dynamic> responseData = jsonDecode(response.body);
//   //       print("get daily earn = $responseData");
//   //
//   //       // Save the data locally
//   //       await prefs.setString(
//   //           'vehicleNoData', jsonEncode(responseData['data']));
//   //
//   //       setState(() {
//   //         vehicleNoData = responseData['data'];
//   //       });
//   //     } else {
//   //       throw Exception('Failed to load vehicle numbers');
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching data: $e');
//   //
//   //     // Attempt to load data from local storage
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? cachedData = prefs.getString('vehicleNoData');
//   //
//   //     if (cachedData != null) {
//   //       setState(() {
//   //         vehicleNoData = jsonDecode(cachedData);
//   //       });
//   //       print('Loaded vehicle numbers from cache');
//   //     } else {
//   //       print('No cached data available');
//   //     }
//   //   } finally {
//   //     setState(() {
//   //       isLoading = false;
//   //       checkConnectivity();
//   //     });
//   //   }
//   // }
//
//   void clearFormData() {
//     vehicleNoController.clear();
//     odometerController.clear();
//     startSocController.clear();
//     chargingTypeController.clear();
//     endSocController.clear();
//
//     setState(() {
//       selectedVehicleNo = null;
//       selectedChargingType = "1"; // Reset to default value
//       showFirstRow = false;
//       showStartSocRow = false;
//       showEndSocRow = false;
//       isVehicleNoSelected = false;
//       showQRScannerButton = true; // Show QR scanner button when form is cleared
//       isImageCaptured = false;
//       isImageCaptured1 = false;
//       isImageCaptured2 = false;
//
//       // Clear images
//       img1 = null;
//       img2 = null;
//       img3 = null;
//     });
//   }
//
//   String endSocImageBase64() {
//     if (img1 != null) {
//       List<int> imageBytes = img1!.readAsBytesSync();
//       return base64Encode(imageBytes);
//     }
//     return '';
//   }
//
//   String StartSocImageBase64() {
//     if (img2 != null) {
//       List<int> imageBytes = img1!.readAsBytesSync();
//       return base64Encode(imageBytes);
//     }
//     return '';
//   }
//
//   String OdometerImageBase64() {
//     if (img3 != null) {
//       List<int> imageBytes = img1!.readAsBytesSync();
//       return base64Encode(imageBytes);
//     }
//     return '';
//   }
//
//   Future<void> clearDraft() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('vehicleNo');
//     await prefs.remove('odometer');
//     await prefs.remove('startSoc');
//     await prefs.remove('chargingType');
//     await prefs.remove('endSoc');
//     await prefs.remove('selectedVehicleNo');
//     await prefs.remove('showFirstRow');
//     await prefs.remove('showStartSocRow');
//     await prefs.remove('showEndSocRow');
//     await prefs.remove('img1');
//     await prefs.remove('img2');
//     await prefs.remove('img3');
//   }
//
//   void showLoadingDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent dismissing by tapping outside
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text('Loading...'),
//                 SizedBox(height: 8),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void showCustomDialog({
//     required BuildContext context,
//     required String title,
//     required String message,
//     required IconData icon,
//     required Color iconColor,
//   }) {
//     showAnimatedDialog(
//       context: context,
//       barrierDismissible: false,
//       // Prevent dismissing by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             children: [
//               Icon(icon, color: iconColor),
//               SizedBox(
//                 width: 40,
//                 height: 40,
//               ),
//               SizedBox(width: 8),
//               Expanded(child: Text(title)),
//             ],
//           ),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//       animationType: DialogTransitionType.slideFromBottomFade,
//       curve: Curves.fastOutSlowIn,
//       duration: Duration(seconds: 1),
//     );
//   }
//
//   void handleSubmit() async {
//     // Show a confirmation dialog before proceeding with the upload
//     bool? confirmed = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Container(
//             padding: EdgeInsets.all(2.0), // Add padding around the container
//             decoration: BoxDecoration(
//               color: Colors.white, // Background color
//
//               borderRadius: BorderRadius.circular(10), // Rounded corners
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.directions_car,
//                     color: HexColor(Colorscommon.greenApp2color), size: 30),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Confirm Details',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20, // Increased font size for better visibility
//                       color:
//                       HexColor(Colorscommon.greenApp2color), // Text color
//                     ),
//                     overflow:
//                     TextOverflow.ellipsis, // Ensures text doesn't overflow
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Divider(
//                       color: Colors.grey, // Set the color of the divider
//                       thickness: 1.5, // Set the thickness of the divider
//                       indent: 16.0, // Add left padding
//                       endIndent: 16.0, // Add right padding
//                     ),
//                     Table(
//                       columnWidths: const {
//                         0: FlexColumnWidth(2),
//                         1: FlexColumnWidth(2),
//                       },
//                       children: [
//                         TableRow(
//                           children: [
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('Vehicle Number :',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500)),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('$selectedVehicleNo',
//                                   style: TextStyle(fontSize: 14)),
//                             ),
//                           ],
//                         ),
//                         TableRow(
//                           children: [
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('Lithium ID :',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500)),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('${utility.lithiumid}',
//                                   style: TextStyle(fontSize: 14)),
//                             ),
//                           ],
//                         ),
//                         TableRow(
//                           children: [
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('Odometer :',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500)),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('${odometerController.text}',
//                                   style: TextStyle(fontSize: 14)),
//                             ),
//                           ],
//                         ),
//                         TableRow(
//                           children: [
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('Start SOC :',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500)),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('${startSocController.text}',
//                                   style: TextStyle(fontSize: 14)),
//                             ),
//                           ],
//                         ),
//                         // Example usage in your TableRow
//                         TableRow(
//                           children: [
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('Charging Type :',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500)),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text(
//                                   getChargingTypeLabel(selectedChargingType),
//                                   style: TextStyle(fontSize: 14)),
//                             ),
//                           ],
//                         ),
//                         TableRow(
//                           children: [
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('End SOC :',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500)),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('${endSocController.text}',
//                                   style: TextStyle(fontSize: 14)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(
//                   color: Colors.grey, // Set the color of the divider
//                   thickness: 1.0, // Set the thickness of the divider
//                   indent: 16.0, // Add left padding
//                   endIndent: 16.0, // Add right padding
//                 ),
//                 if (img1 != null || img2 != null || img3 != null)
//                   Padding(
//                     padding: const EdgeInsets.all(1.0),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (img1 != null)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   Text('End SOC Image:',
//                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                   SizedBox(width: 8),
//                                   Expanded(
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           showDialog(
//                                             context: context,
//                                             barrierDismissible: false,
//                                             builder: (BuildContext context) {
//                                               return Dialog(
//                                                 child: Image.file(img1!),
//                                               );
//                                             },
//                                           );
//                                         },
//                                         child: Image.file(img1!, height: 100, fit: BoxFit.cover),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           if (img2 != null)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   Text('Start SOC Image:',
//                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                   SizedBox(width: 8),
//                                   Expanded(
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           showDialog(
//                                             context: context,
//                                             barrierDismissible: false,
//                                             builder: (BuildContext context) {
//                                               return Dialog(
//                                                 child: Image.file(img2!),
//                                               );
//                                             },
//                                           );
//                                         },
//                                         child: Image.file(img2!, height: 100, fit: BoxFit.cover),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           if (img3 != null)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   Text('Odometer Image:',
//                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                                   SizedBox(width: 8),
//                                   Expanded(
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           showDialog(
//                                             context: context,
//                                             barrierDismissible: false,
//                                             builder: (BuildContext context) {
//                                               return Dialog(
//                                                 child: Image.file(img3!),
//                                               );
//                                             },
//                                           );
//                                         },
//                                         child: Image.file(img3!, height: 100, fit: BoxFit.cover),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   )
//
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel', style: TextStyle(color: Colors.red)),
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//             ),
//             ElevatedButton(
//               child: Text('Confirm'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.green,
//                 onPrimary: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//             ),
//           ],
//         );
//       },
//     );
//
//     if (!confirmed!) {
//       return; // User canceled the upload
//     }
//
//     showLoadingDialog();
//     String odometer = odometerController.text;
//     String startSoc = startSocController.text;
//     String chargingType = selectedChargingType;
//     String endSoc = endSocController.text;
//
//     // Get current location
//     Location location = Location();
//     LocationData? currentLocation;
//     try {
//       currentLocation = await location.getLocation();
//     } catch (e) {
//       print('Error fetching location: $e');
//       Fluttertoast.showToast(msg: "Error fetching location.");
//     }
//
//     try {
//       String uriString = CommonURL.URL; // Your URL as a string
//       Uri uri = Uri.parse(uriString); // Convert it to a Uri
//
//       var request = http.MultipartRequest('POST', uri)
//         ..fields['from'] = 'vehiclechargingbattery'
//         ..fields['lithiumid'] = utility.lithiumid
//         ..fields['username'] = utility.sp_username
//         ..fields['vehiclenumber'] = selectedVehicleNo!
//         ..fields['odometer'] = odometer
//         ..fields['startsoc'] = startSoc
//         ..fields['charging'] = chargingType
//         ..fields['endsoc'] = endSoc
//         ..fields['latitude'] = currentLocation?.latitude.toString() ?? '0.0'
//         ..fields['longitude'] = currentLocation?.longitude.toString() ?? '0.0'
//         ..fields['timestamp'] = DateTime.now().toIso8601String();
//
//       // Add image files if available
//       if (img1 != null) {
//         String fileName = img1!.path.split('/').last;
//         print("endsocimage fileName: $fileName");
//         request.files.add(await http.MultipartFile.fromPath(
//           'endsocimage',
//           img1!.path,
//           contentType: MediaType.parse(
//               lookupMimeType(img1!.path) ?? 'application/octet-stream'),
//         ));
//       }
//       if (img2 != null) {
//         String fileName = img2!.path.split('/').last;
//         print("startsocimage fileName: $fileName");
//         request.files.add(await http.MultipartFile.fromPath(
//           'startsocimage',
//           img2!.path,
//           contentType: MediaType.parse(
//               lookupMimeType(img2!.path) ?? 'application/octet-stream'),
//         ));
//       }
//       if (img3 != null) {
//         String fileName = img3!.path.split('/').last;
//         print("odometerimage fileName: $fileName");
//         request.files.add(await http.MultipartFile.fromPath(
//           'odometerimage',
//           img3!.path,
//           contentType: MediaType.parse(
//               lookupMimeType(img3!.path) ?? 'application/octet-stream'),
//         ));
//       }
//
//       request.headers.addAll({
//         'Accept': 'application/json',
//         'Content-Type': 'multipart/form-data',
//       });
//
//       var response = await request.send();
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         closeLoader(context);
//
//         // Show success dialog
//         showAnimatedDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.green),
//                   SizedBox(width: 8),
//                   Expanded(child: Text('Success')),
//                 ],
//               ),
//               content: Text("Charging data uploaded successfully."),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//           animationType: DialogTransitionType.slideFromBottomFade,
//           curve: Curves.fastOutSlowIn,
//           duration: Duration(seconds: 1),
//         );
//       } else {
//         closeLoader(context);
//         Fluttertoast.showToast(
//           msg: "Failed to upload data. Status code: ${response.statusCode}",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//         );
//
//         // Show error dialog
//         showAnimatedDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Row(
//                 children: [
//                   Icon(Icons.error, color: Colors.red),
//                   SizedBox(width: 8),
//                   Expanded(child: Text('Error')),
//                 ],
//               ),
//               content: Text(
//                   "Failed to upload charging data. Status code: ${response.statusCode}"),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//           animationType: DialogTransitionType.slideFromBottomFade,
//           curve: Curves.fastOutSlowIn,
//           duration: Duration(seconds: 1),
//         );
//       }
//     } catch (e) {
//       closeLoader(context);
//       Fluttertoast.showToast(
//         msg: "Error sending data: $e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//       print('Error sending data: $e');
//     }
//
//     // Clear the form data and draft
//     clearFormData();
//     await clearDraft();
//     setState(() {});
//   }
//
//
//
//   void navigateToMyTabPage() {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => const MyTabPage(
//               title: '',
//               selectedtab: 0,
//             )));
//   }
//
//   void saveForm() {
//     // Perform save operations here
//     saveDraft();
//     setState(() {
//       showStartSocRow = false;
//       showEndSocRow = true;
//       isVehicleNoSelected = true;
//     });
//   }
//
//   Future<void> saveDraft() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('vehicleNo', vehicleNoController.text);
//     await prefs.setString('odometer', odometerController.text);
//     await prefs.setString('startSoc', startSocController.text);
//     await prefs.setString('selectedChargingType', selectedChargingType ?? '');
//     await prefs.setString('endSoc', endSocController.text);
//     await prefs.setString('selectedVehicleNo', selectedVehicleNo ?? '');
//     await prefs.setBool('showFirstRow', showFirstRow);
//     await prefs.setBool('showStartSocRow', showStartSocRow);
//     await prefs.setBool('showEndSocRow', showEndSocRow);
//     await prefs.setBool('isVehicleNoSelected',
//         isVehicleNoSelected); // Save vehicle number selection status
//     if (img1 != null) {
//       await saveImageToPrefs(img1!, 'image1');
//     }
//     if (img2 != null) {
//       await saveImageToPrefs(img2!, 'image2');
//     }
//
//     if (img3 != null) {
//       await saveImageToPrefs(img3!, 'image3');
//     }
//   }
//
//   Future<void> saveImageToPrefs(File image, String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final bytes = await image.readAsBytes();
//     final base64Image = base64Encode(bytes);
//     await prefs.setString(key, base64Image);
//   }
//
//   Future<void> loadDraft() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Perform async work outside of setState
//     String vehicleNo = prefs.getString('vehicleNo') ?? '';
//     String odometer = prefs.getString('odometer') ?? '';
//     String startSoc = prefs.getString('startSoc') ?? '';
//     String chargingType = prefs.getString('selectedChargingType') ?? '1';
//     String endSoc = prefs.getString('endSoc') ?? '';
//     String? vehicleNoSelected = prefs.getString('selectedVehicleNo');
//     bool firstRowVisible = prefs.getBool('showFirstRow') ?? false;
//     bool startSocRowVisible = prefs.getBool('showStartSocRow') ?? false;
//     bool endSocRowVisible = prefs.getBool('showEndSocRow') ?? false;
//     bool isVehicleSelected = vehicleNoSelected != null;
//
//     // Load images asynchronously
//     var img1 = await loadImageFromPrefs('image1');
//     var img2 = await loadImageFromPrefs('image2');
//     var img3 = await loadImageFromPrefs('image3');
//
//     // Now update the state synchronously
//     setState(() {
//       vehicleNoController.text = vehicleNo;
//       odometerController.text = odometer;
//       startSocController.text = startSoc;
//       selectedChargingType = chargingType;
//       endSocController.text = endSoc;
//       selectedVehicleNo = vehicleNoSelected;
//       showFirstRow = firstRowVisible;
//       showStartSocRow = startSocRowVisible;
//       showEndSocRow = endSocRowVisible;
//       isVehicleNoSelected = isVehicleSelected;
//       this.img1 = img1;
//       this.img2 = img2;
//       this.img3 = img3;
//     });
//   }
//
//
//   Future<File?> loadImageFromPrefs(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final base64Image = prefs.getString(key);
//     if (base64Image != null) {
//       final bytes = base64Decode(base64Image);
//       final tempDir = await getTemporaryDirectory();
//       final file = File('${tempDir.path}/$key');
//       await file.writeAsBytes(bytes);
//       return file;
//     }
//     return null;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     odometerController.addListener(() {
//       if (!odometerFocusNode.hasFocus) {
//         return;
//       }
//       setState(() {
//         isOdometerValid = odometerController.text.isNotEmpty;
//       });
//     });
//     checkConnectivity();
//     fetchVehicleNumbers();
//
//     _controller = AnimationController(vsync: this);
//
//     utility.GetUserdata().then((value) => {
//       print(utility.lithiumid.toString()),
//       username = utility.lithiumid,
//       spusername = utility.mobileuser,
//       setState(() {}),
//     });
//
//     // Load draft data when the widget is initialized
//     loadDraft();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     controller?.dispose();
//     odometerController.dispose();
//     odometerFocusNode.dispose();
//     super.dispose();
//   }
//
//   bool isAnyFieldEmpty() {
//     return odometerController.text.isEmpty ||
//         startSocController.text.isEmpty ||
//         selectedChargingType == null ||
//         selectedVehicleNo == null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         await saveDraft();
//
//         if (isAnyFieldEmpty()) {
//           clearFormData();
//           await clearDraft();
//         }
//
//         navigateToMyTabPage();
//
//         return true;
//       },
//       child: SafeArea(
//         top: false,
//         child: Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: HexColor(Colorscommon.greenAppcolor),
//             toolbarHeight: 0,
//           ),
//           body: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             color: HexColor('#F8F8F8'),
//             child: Column(
//               children: [
//                 ClipPath(
//                   clipper: CurveImage(),
//                   child: Container(
//                     height: 150,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           HexColor(Colorscommon.greencolor),
//                           HexColor(Colorscommon.greencolor)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 5,
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: <Widget>[
//                       Container(
//                         alignment: Alignment.topCenter,
//                         color: Colors.grey.shade200,
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               top: 20, right: 15, left: 15),
//                           child: ListView(
//                             shrinkWrap: true,
//                             padding: const EdgeInsets.all(8.0),
//                             children: [
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               //
//
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Visibility(
//                                 visible: showFirstRow == false,
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 5,
//                                       // Button gets 3 parts of the available space
//                                       child: ElevatedButton(
//                                         onPressed: () {
//                                           setState(() {
//                                             showFirstRow = true;
//                                           });
//                                         },
//                                         child: Text('Start Charging'),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       flex: 1,
//                                       // Image gets 1 part of the available space
//                                       child: Image.asset(
//                                         'assets/Animation - 1718274730674.gif',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Visibility(
//                                 visible: showFirstRow,
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           flex: 3,
//                                           child: Container(
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: 12, horizontal: 16),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               border: Border.all(
//                                                   color: Colors.grey),
//                                               borderRadius:
//                                               BorderRadius.circular(8),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2),
//                                                   spreadRadius: 2,
//                                                   blurRadius: 4,
//                                                   offset: Offset(0, 2),
//                                                 ),
//                                               ],
//                                             ),
//                                             child: isLoading
//                                                 ? loading1()
//                                                 : isVehicleNoSelected
//                                                 ? Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: Text(
//                                                     '$selectedVehicleNo / Lithium ID: ${utility.lithiumid}',
//                                                     style: TextStyle(
//                                                       fontSize: 14,
//                                                       color: Colors
//                                                           .black,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             )
//                                                 : Row(
//                                               children: [
//                                                 Expanded(
//                                                   child:
//                                                   DropdownButtonHideUnderline(
//                                                     child:
//                                                     DropdownButton2<
//                                                         String>(
//                                                       isExpanded:
//                                                       true,
//                                                       hint: Text(
//                                                         'Vehicle No',
//                                                         style:
//                                                         TextStyle(
//                                                           fontSize:
//                                                           14,
//                                                           color: Theme.of(
//                                                               context)
//                                                               .hintColor,
//                                                         ),
//                                                       ),
//                                                       items:
//                                                       vehicleNoData
//                                                           .map((vehicle) =>
//                                                           DropdownMenuItem<String>(
//                                                             value: vehicle['vehiclenumber'].toString(),
//                                                             child: Text(
//                                                               vehicle['vehiclenumber'].toString(),
//                                                               style: const TextStyle(
//                                                                 fontSize: 14,
//                                                               ),
//                                                             ),
//                                                           ))
//                                                           .toList(),
//                                                       value:
//                                                       selectedVehicleNo,
//                                                       onChanged:
//                                                           (value) {
//                                                         setState(() {
//                                                           selectedVehicleNo =
//                                                               value;
//                                                           showStartSocRow =
//                                                           true;
//                                                           isVehicleNoSelected =
//                                                           true;
//                                                           showQRScannerButton =
//                                                           false; // Hide QR scanner button after selection
//                                                         });
//                                                         saveDraft();
//                                                       },
//                                                       buttonStyleData:
//                                                       const ButtonStyleData(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                             horizontal:
//                                                             16),
//                                                         height: 40,
//                                                         width: 200,
//                                                       ),
//                                                       dropdownStyleData:
//                                                       const DropdownStyleData(
//                                                         maxHeight:
//                                                         200,
//                                                       ),
//                                                       menuItemStyleData:
//                                                       const MenuItemStyleData(
//                                                         height: 40,
//                                                       ),
//                                                       dropdownSearchData:
//                                                       DropdownSearchData(
//                                                         searchController:
//                                                         textEditingController,
//                                                         searchInnerWidgetHeight:
//                                                         50,
//                                                         searchInnerWidget:
//                                                         Container(
//                                                           height: 50,
//                                                           padding:
//                                                           const EdgeInsets
//                                                               .only(
//                                                             top: 8,
//                                                             bottom: 4,
//                                                             right: 8,
//                                                             left: 8,
//                                                           ),
//                                                           child:
//                                                           TextFormField(
//                                                             expands:
//                                                             true,
//                                                             maxLines:
//                                                             null,
//                                                             controller:
//                                                             textEditingController,
//                                                             decoration:
//                                                             InputDecoration(
//                                                               isDense:
//                                                               true,
//                                                               contentPadding:
//                                                               const EdgeInsets.symmetric(
//                                                                 horizontal:
//                                                                 10,
//                                                                 vertical:
//                                                                 8,
//                                                               ),
//                                                               hintText:
//                                                               'Search for a vehicle...',
//                                                               hintStyle:
//                                                               const TextStyle(fontSize: 12),
//                                                               border:
//                                                               OutlineInputBorder(
//                                                                 borderRadius:
//                                                                 BorderRadius.circular(8),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         searchMatchFn:
//                                                             (item,
//                                                             searchValue) {
//                                                           return item
//                                                               .value
//                                                               .toString()
//                                                               .toLowerCase()
//                                                               .contains(
//                                                               searchValue.toLowerCase());
//                                                         },
//                                                       ),
//                                                       onMenuStateChange:
//                                                           (isOpen) {
//                                                         if (!isOpen) {
//                                                           textEditingController
//                                                               .clear();
//                                                         }
//                                                       },
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 if (isOnline)
//                                                   IconButton(
//                                                     icon: Icon(Icons
//                                                         .refresh),
//                                                     onPressed:
//                                                     fetchVehicleNumbers,
//                                                   ),
//                                                 if (showQRScannerButton)
//                                                   IconButton(
//                                                     icon: Icon(Icons
//                                                         .qr_code_scanner),
//                                                     onPressed:
//                                                         () async {
//                                                       var qrValue =
//                                                       await showDialog<
//                                                           String>(
//                                                         context:
//                                                         context,
//                                                         builder:
//                                                             (BuildContext
//                                                         context) {
//                                                           return QrDialog(
//                                                             textfieldEditingController:
//                                                             textEditingController,
//                                                             dialogContext:
//                                                             context,
//                                                           );
//                                                         },
//                                                       );
//
//                                                       if (qrValue !=
//                                                           null &&
//                                                           qrValue
//                                                               .isNotEmpty) {
//                                                         // Define the regex pattern for car numbers (adjust the pattern as needed)
//                                                         final RegExp
//                                                         carNumberRegex =
//                                                         RegExp(
//                                                             r'^[A-Z]{2}\d{2}[A-Z]{1,2}\d{1,4}$');
//
//                                                         if (carNumberRegex
//                                                             .hasMatch(
//                                                             qrValue)) {
//                                                           setState(
//                                                                   () {
//                                                                 selectedVehicleNo =
//                                                                     qrValue;
//                                                                 isVehicleNoSelected =
//                                                                 true;
//                                                                 showStartSocRow =
//                                                                 true;
//                                                                 showQRScannerButton =
//                                                                 false; // Hide QR scanner button after selection
//                                                               });
//                                                           saveDraft();
//                                                         } else {
//                                                           Fluttertoast
//                                                               .showToast(
//                                                             msg:
//                                                             "Invalid car number format. Please scan a valid car number.",
//                                                             toastLength:
//                                                             Toast
//                                                                 .LENGTH_SHORT,
//                                                             gravity:
//                                                             ToastGravity
//                                                                 .BOTTOM,
//                                                             timeInSecForIosWeb:
//                                                             1,
//                                                             backgroundColor:
//                                                             Colors
//                                                                 .red,
//                                                             textColor:
//                                                             Colors
//                                                                 .white,
//                                                             fontSize:
//                                                             16.0,
//                                                           );
//                                                         }
//                                                       }
//                                                     },
//                                                   ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Visibility(
//                                       visible: showStartSocRow,
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Avenirtextmedium(
//                                                   customfontweight:
//                                                   FontWeight.w500,
//                                                   fontsize: (AppLocalizations.of(
//                                                       context)!
//                                                       .id ==
//                                                       "ஐடி" ||
//                                                       AppLocalizations.of(
//                                                           context)!
//                                                           .id ==
//                                                           "आयडी" ||
//                                                       AppLocalizations.of(
//                                                           context)!
//                                                           .id ==
//                                                           "ಐಡಿ")
//                                                       ? 12
//                                                       : 14,
//                                                   text: "Odometer",
//                                                   textcolor: HexColor(
//                                                       Colorscommon.greendark),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 6,
//                                                       horizontal: 8),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     border: Border.all(
//                                                         color: Colors.grey),
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         8),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: Colors.grey
//                                                             .withOpacity(0.2),
//                                                         spreadRadius: 1,
//                                                         blurRadius: 3,
//                                                         offset: Offset(0,
//                                                             2), // changes position of shadow
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   child: Row(
//                                                     children: [
//                                                       Expanded(
//                                                         flex: 3,
//                                                         child: TextFormField(
//                                                           controller:
//                                                           odometerController,
//                                                           focusNode:
//                                                           odometerFocusNode,
//                                                           keyboardType:
//                                                           TextInputType
//                                                               .number,
//                                                           inputFormatters: [
//                                                             LengthLimitingTextInputFormatter(
//                                                                 6),
//                                                             FilteringTextInputFormatter
//                                                                 .digitsOnly,
//                                                           ],
//                                                           decoration:
//                                                           InputDecoration(
//                                                             border: InputBorder
//                                                                 .none,
//                                                             hintText:
//                                                             'Enter Odometer',
//                                                             hintStyle: TextStyle(
//                                                                 color: Colors
//                                                                     .grey),
//                                                           ),
//                                                           onChanged: (value) {
//                                                             if (value.length ==
//                                                                 6) {
//                                                               FocusScope.of(
//                                                                   context)
//                                                                   .requestFocus(
//                                                                   FocusNode());
//                                                             }
//                                                           },
//                                                         ),
//                                                       ),
//                                                       VerticalDivider(
//                                                         color: Colors.grey,
//                                                         thickness: 1,
//                                                       ),
//                                                       Container(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                             vertical: 10,
//                                                             horizontal: 11),
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           color: Colors.white,
//                                                           border: Border.all(
//                                                               color:
//                                                               Colors.grey),
//                                                           borderRadius:
//                                                           BorderRadius
//                                                               .circular(8),
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors.grey
//                                                                   .withOpacity(
//                                                                   0.2),
//                                                               spreadRadius: 1,
//                                                               blurRadius: 3,
//                                                               offset: Offset(0,
//                                                                   2), // changes position of shadow
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         child: GestureDetector(
//                                                           onTap: () {
//                                                             autoCaptureImage1(
//                                                                 3);
//                                                           },
//                                                           child:
//                                                           isImageCaptured2
//                                                               ? Container(
//                                                             width: 24,
//                                                             // Adjust width as needed
//                                                             height:
//                                                             24,
//                                                             // Adjust height as needed
//                                                             child: Image.asset(
//                                                                 'assets/image.png',
//                                                                 fit: BoxFit
//                                                                     .contain),
//                                                           )
//                                                               : Icon(Icons
//                                                               .camera_rear),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Avenirtextmedium(
//                                                   customfontweight:
//                                                   FontWeight.w500,
//                                                   fontsize: (AppLocalizations.of(
//                                                       context)!
//                                                       .id ==
//                                                       "ஐடி" ||
//                                                       AppLocalizations.of(
//                                                           context)!
//                                                           .id ==
//                                                           "आयडी" ||
//                                                       AppLocalizations.of(
//                                                           context)!
//                                                           .id ==
//                                                           "ಐಡಿ")
//                                                       ? 12
//                                                       : 14,
//                                                   text: "Charging Type",
//                                                   textcolor: HexColor(
//                                                       Colorscommon.greendark),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 12,
//                                                       horizontal: 16),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     border: Border.all(
//                                                         color: Colors.grey),
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         8),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: Colors.grey
//                                                             .withOpacity(0.2),
//                                                         spreadRadius: 2,
//                                                         blurRadius: 4,
//                                                         offset: Offset(0,
//                                                             2), // changes position of shadow
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   child:
//                                                   DropdownButtonHideUnderline(
//                                                     child:
//                                                     DropdownButton<String>(
//                                                       isExpanded: true,
//                                                       hint: Text(
//                                                         'Select Charging Type',
//                                                         style: TextStyle(
//                                                           fontSize: 14,
//                                                           color:
//                                                           Theme.of(context)
//                                                               .hintColor,
//                                                         ),
//                                                       ),
//                                                       value:
//                                                       selectedChargingType,
//                                                       items: chargingTypes
//                                                           .map((chargingType) {
//                                                         return DropdownMenuItem<
//                                                             String>(
//                                                           value: chargingType[
//                                                           'id'],
//                                                           child: Text(
//                                                             chargingType[
//                                                             'chargingtype']
//                                                                 .toString(),
//                                                             style: TextStyle(
//                                                               fontSize: 14,
//                                                             ),
//                                                           ),
//                                                         );
//                                                       }).toList(),
//                                                       onChanged: (value) {
//                                                         setState(() {
//                                                           selectedChargingType =
//                                                           value!;
//                                                         });
//                                                         print(
//                                                             'Selected charging type: $selectedChargingType'); // Debug print
//
//                                                         saveDraft();
//                                                       },
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           color: Colors.black),
//                                                       dropdownColor:
//                                                       Colors.white,
//                                                       elevation: 5,
//                                                       icon: Icon(Icons
//                                                           .arrow_drop_down),
//                                                       iconSize: 36,
//                                                       isDense: true,
//                                                       underline: Container(
//                                                         height: 1,
//                                                         color: Colors
//                                                             .grey.shade400,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Avenirtextmedium(
//                                                   customfontweight:
//                                                   FontWeight.w500,
//                                                   fontsize: (AppLocalizations.of(
//                                                       context)!
//                                                       .id ==
//                                                       "ஐடி" ||
//                                                       AppLocalizations.of(
//                                                           context)!
//                                                           .id ==
//                                                           "आयडी" ||
//                                                       AppLocalizations.of(
//                                                           context)!
//                                                           .id ==
//                                                           "ಐಡಿ")
//                                                       ? 12
//                                                       : 14,
//                                                   text: "Start SOC",
//                                                   textcolor: HexColor(
//                                                       Colorscommon.greendark),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: 6,
//                                                       horizontal: 8),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     border: Border.all(
//                                                         color: Colors.grey),
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         8),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: Colors.grey
//                                                             .withOpacity(0.2),
//                                                         spreadRadius: 1,
//                                                         blurRadius: 3,
//                                                         offset: Offset(0,
//                                                             2), // changes position of shadow
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   child: Row(
//                                                     children: [
//                                                       Expanded(
//                                                         flex: 3,
//                                                         child: TextField(
//                                                           controller:
//                                                           startSocController,
//                                                           keyboardType:
//                                                           TextInputType
//                                                               .number,
//                                                           inputFormatters: [
//                                                             LengthLimitingTextInputFormatter(
//                                                                 2),
//                                                             // Limit input to 2 characters
//                                                             FilteringTextInputFormatter
//                                                                 .digitsOnly,
//                                                             // Allow only digits
//                                                           ],
//                                                           decoration:
//                                                           InputDecoration(
//                                                             border: InputBorder
//                                                                 .none,
//                                                             hintText:
//                                                             'Enter Start SOC',
//                                                             hintStyle: TextStyle(
//                                                                 color: Colors
//                                                                     .grey),
//                                                           ),
//                                                           onChanged: (value) {
//                                                             if (value
//                                                                 .isNotEmpty) {
//                                                               int parsedValue =
//                                                               int.parse(
//                                                                   value);
//                                                               if (parsedValue >
//                                                                   99) {
//                                                                 startSocController
//                                                                     .text =
//                                                                 '99';
//                                                                 startSocController
//                                                                     .selection =
//                                                                     TextSelection
//                                                                         .fromPosition(
//                                                                       TextPosition(
//                                                                           offset: startSocController
//                                                                               .text
//                                                                               .length),
//                                                                     );
//                                                               }
//                                                             }
//                                                             if (value.length ==
//                                                                 2) {
//                                                               FocusScope.of(
//                                                                   context)
//                                                                   .unfocus();
//                                                             }
//                                                           },
//                                                         ),
//                                                       ),
//                                                       VerticalDivider(
//                                                         color: Colors.grey,
//                                                         thickness: 1,
//                                                       ),
//                                                       Container(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                             vertical: 10,
//                                                             horizontal: 11),
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           color: Colors.white,
//                                                           border: Border.all(
//                                                               color:
//                                                               Colors.grey),
//                                                           borderRadius:
//                                                           BorderRadius
//                                                               .circular(8),
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors.grey
//                                                                   .withOpacity(
//                                                                   0.2),
//                                                               spreadRadius: 1,
//                                                               blurRadius: 3,
//                                                               offset: Offset(0,
//                                                                   2), // changes position of shadow
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         child: GestureDetector(
//                                                           onTap: () {
//                                                             autoCaptureImage1(
//                                                                 2);
//                                                           },
//                                                           child:
//                                                           isImageCaptured1
//                                                               ? Container(
//                                                             width: 24,
//                                                             // Adjust width as needed
//                                                             height:
//                                                             24,
//                                                             // Adjust height as needed
//                                                             child: Image.asset(
//                                                                 'assets/image.png',
//                                                                 fit: BoxFit
//                                                                     .contain),
//                                                           )
//                                                               : Icon(Icons
//                                                               .camera_rear),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 30,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                 EdgeInsets.only(left: 100),
//                                                 child: ElevatedButton(
//                                                   onPressed: () {
//                                                     if (selectedVehicleNo ==
//                                                         null) {
//                                                       Fluttertoast.showToast(
//                                                           msg:
//                                                           "Please select a vehicle number",
//                                                           toastLength: Toast
//                                                               .LENGTH_SHORT,
//                                                           gravity: ToastGravity
//                                                               .BOTTOM,
//                                                           timeInSecForIosWeb: 1,
//                                                           backgroundColor:
//                                                           Colors.red,
//                                                           textColor:
//                                                           Colors.white,
//                                                           fontSize: 16.0);
//                                                       return;
//                                                     }
//                                                     if (odometerController
//                                                         .text.isEmpty) {
//                                                       Fluttertoast.showToast(
//                                                           msg:
//                                                           "Please enter the odometer reading",
//                                                           toastLength: Toast
//                                                               .LENGTH_SHORT,
//                                                           gravity: ToastGravity
//                                                               .BOTTOM,
//                                                           timeInSecForIosWeb: 1,
//                                                           backgroundColor:
//                                                           Colors.red,
//                                                           textColor:
//                                                           Colors.white,
//                                                           fontSize: 16.0);
//                                                       return;
//                                                     }
//                                                     if (startSocController
//                                                         .text.isEmpty) {
//                                                       Fluttertoast.showToast(
//                                                           msg:
//                                                           "Please enter the start SOC",
//                                                           toastLength: Toast
//                                                               .LENGTH_SHORT,
//                                                           gravity: ToastGravity
//                                                               .BOTTOM,
//                                                           timeInSecForIosWeb: 1,
//                                                           backgroundColor:
//                                                           Colors.red,
//                                                           textColor:
//                                                           Colors.white,
//                                                           fontSize: 16.0);
//                                                       return;
//                                                     }
//                                                     if (selectedChargingType ==
//                                                         null) {
//                                                       Fluttertoast.showToast(
//                                                           msg:
//                                                           "Please select a charging type",
//                                                           toastLength: Toast
//                                                               .LENGTH_SHORT,
//                                                           gravity: ToastGravity
//                                                               .BOTTOM,
//                                                           timeInSecForIosWeb: 1,
//                                                           backgroundColor:
//                                                           Colors.red,
//                                                           textColor:
//                                                           Colors.white,
//                                                           fontSize: 16.0);
//                                                       return;
//                                                     }
//                                                     if (img3 == null) {
//                                                       Fluttertoast.showToast(
//                                                           msg:
//                                                           "Please upload the Odometer image",
//                                                           toastLength: Toast
//                                                               .LENGTH_SHORT,
//                                                           gravity: ToastGravity
//                                                               .BOTTOM,
//                                                           timeInSecForIosWeb: 1,
//                                                           backgroundColor:
//                                                           Colors.red,
//                                                           textColor:
//                                                           Colors.white,
//                                                           fontSize: 16.0);
//                                                       return;
//                                                     }
//                                                     if (img2 == null) {
//                                                       Fluttertoast.showToast(
//                                                           msg:
//                                                           "Please upload the StartSoc image",
//                                                           toastLength: Toast
//                                                               .LENGTH_SHORT,
//                                                           gravity: ToastGravity
//                                                               .BOTTOM,
//                                                           timeInSecForIosWeb: 1,
//                                                           backgroundColor:
//                                                           Colors.red,
//                                                           textColor:
//                                                           Colors.white,
//                                                           fontSize: 16.0);
//                                                       return;
//                                                     }
//                                                     print("Draft data added");
//                                                     // Fluttertoast.showToast(
//                                                     //     msg:
//                                                     //         "Draft saved successfully",
//                                                     //     toastLength:
//                                                     //         Toast.LENGTH_SHORT,
//                                                     //     gravity:
//                                                     //         ToastGravity.CENTER,
//                                                     //     timeInSecForIosWeb: 1,
//                                                     //     backgroundColor:
//                                                     //         Colors.green,
//                                                     //     textColor: Colors.white,
//                                                     //     fontSize: 16.0);
//
//                                                     saveForm();
//                                                   },
//                                                   child: Text('Save'),
//                                                 ),
//                                               ),
//                                               Align(
//                                                 alignment:
//                                                 Alignment.bottomRight,
//                                                 child: Padding(
//                                                   padding:
//                                                   const EdgeInsets.only(
//                                                       left: 25),
//                                                   child: TextButton(
//                                                     onPressed:
//                                                     _showConfirmationDialog,
//                                                     child: Text('Cancel'),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Visibility(
//                                       visible: showEndSocRow,
//                                       child: Column(
//                                         children: [
//                                           Visibility(
//                                             visible: showEndSocRow,
//                                             child: Column(
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Expanded(
//                                                       flex: 1,
//                                                       child: Avenirtextmedium(
//                                                         customfontweight:
//                                                         FontWeight.w500,
//                                                         fontsize: (AppLocalizations.of(
//                                                             context)!
//                                                             .id ==
//                                                             "ஐடி" ||
//                                                             AppLocalizations.of(
//                                                                 context)!
//                                                                 .id ==
//                                                                 "आयडी" ||
//                                                             AppLocalizations.of(
//                                                                 context)!
//                                                                 .id ==
//                                                                 "ಐಡಿ")
//                                                             ? 12
//                                                             : 14,
//                                                         text: "End SOC",
//                                                         textcolor: HexColor(
//                                                             Colorscommon
//                                                                 .greendark),
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       flex: 2,
//                                                       child: Container(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                             vertical: 6,
//                                                             horizontal: 8),
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           color: Colors.white,
//                                                           border: Border.all(
//                                                               color:
//                                                               Colors.grey),
//                                                           borderRadius:
//                                                           BorderRadius
//                                                               .circular(8),
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors.grey
//                                                                   .withOpacity(
//                                                                   0.2),
//                                                               spreadRadius: 1,
//                                                               blurRadius: 3,
//                                                               offset: Offset(0,
//                                                                   2), // changes position of shadow
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         child: Row(
//                                                           children: [
//                                                             Expanded(
//                                                               flex: 3,
//                                                               child: TextField(
//                                                                 controller:
//                                                                 endSocController,
//                                                                 keyboardType:
//                                                                 TextInputType
//                                                                     .number,
//                                                                 inputFormatters: [
//                                                                   LengthLimitingTextInputFormatter(
//                                                                       3),
//                                                                   // Limit input to 3 characters
//                                                                   FilteringTextInputFormatter
//                                                                       .digitsOnly,
//                                                                   // Allow only digits
//                                                                 ],
//                                                                 decoration:
//                                                                 InputDecoration(
//                                                                   border:
//                                                                   InputBorder
//                                                                       .none,
//                                                                   hintText:
//                                                                   'Enter End SOC',
//                                                                   hintStyle: TextStyle(
//                                                                       color: Colors
//                                                                           .grey),
//                                                                 ),
//                                                                 onChanged:
//                                                                     (value) {
//                                                                   if (value
//                                                                       .isNotEmpty) {
//                                                                     int parsedValue =
//                                                                     int.parse(
//                                                                         value);
//
//                                                                     if (parsedValue >
//                                                                         100) {
//                                                                       // Show a toast message
//                                                                       Fluttertoast
//                                                                           .showToast(
//                                                                         msg:
//                                                                         "End SOC cannot exceed 100",
//                                                                         toastLength:
//                                                                         Toast.LENGTH_SHORT,
//                                                                         gravity:
//                                                                         ToastGravity.BOTTOM,
//                                                                         timeInSecForIosWeb:
//                                                                         1,
//                                                                         backgroundColor:
//                                                                         Colors.red,
//                                                                         textColor:
//                                                                         Colors.white,
//                                                                         fontSize:
//                                                                         16.0,
//                                                                       );
//
//                                                                       // Reset the controller's text to 100
//                                                                       endSocController
//                                                                           .text =
//                                                                       '100';
//                                                                       endSocController
//                                                                           .selection =
//                                                                           TextSelection
//                                                                               .fromPosition(
//                                                                             TextPosition(
//                                                                                 offset:
//                                                                                 endSocController.text.length),
//                                                                           );
//                                                                     }
//                                                                   }
//
//                                                                   // Check if value is exactly 2 digits (excluding "10") or exactly 3 digits
//                                                                   if ((value.length ==
//                                                                       2 &&
//                                                                       value !=
//                                                                           "10") ||
//                                                                       value.length ==
//                                                                           3) {
//                                                                     FocusScope.of(
//                                                                         context)
//                                                                         .unfocus();
//                                                                   }
//                                                                 },
//                                                               ),
//                                                             ),
//                                                             VerticalDivider(
//                                                               color:
//                                                               Colors.grey,
//                                                               thickness: 1,
//                                                             ),
//                                                             Container(
//                                                               padding: EdgeInsets
//                                                                   .symmetric(
//                                                                   vertical:
//                                                                   10,
//                                                                   horizontal:
//                                                                   11),
//                                                               decoration:
//                                                               BoxDecoration(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 border: Border.all(
//                                                                     color: Colors
//                                                                         .grey),
//                                                                 borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                     8),
//                                                                 boxShadow: [
//                                                                   BoxShadow(
//                                                                     color: Colors
//                                                                         .grey
//                                                                         .withOpacity(
//                                                                         0.2),
//                                                                     spreadRadius:
//                                                                     1,
//                                                                     blurRadius:
//                                                                     3,
//                                                                     offset: Offset(
//                                                                         0,
//                                                                         2), // changes position of shadow
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               child:
//                                                               GestureDetector(
//                                                                 onTap: () {
//                                                                   autoCaptureImage1(
//                                                                       1);
//                                                                 },
//                                                                 child: isImageCaptured
//                                                                     ? Container(
//                                                                   width:
//                                                                   24,
//                                                                   // Adjust width as needed
//                                                                   height:
//                                                                   24,
//                                                                   // Adjust height as needed
//                                                                   child: Image.asset(
//                                                                       'assets/image.png',
//                                                                       fit:
//                                                                       BoxFit.contain),
//                                                                 )
//                                                                     : Icon(Icons.camera_rear),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 // New row with the image
//                                                 SizedBox(
//                                                   height: 30,
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Expanded(
//                                                       flex: 2,
//                                                       // Adjust the flex value as needed
//                                                       child: ElevatedButton(
//                                                         onPressed: () {
//                                                           sessionManager
//                                                               .internetcheck()
//                                                               .then(
//                                                                   (internet) async {
//                                                                 if (internet) {
//                                                                   if (endSocController
//                                                                       .text
//                                                                       .isEmpty) {
//                                                                     Fluttertoast
//                                                                         .showToast(
//                                                                       msg:
//                                                                       "Please enter the End soc",
//                                                                       toastLength: Toast
//                                                                           .LENGTH_SHORT,
//                                                                       gravity:
//                                                                       ToastGravity
//                                                                           .BOTTOM,
//                                                                       timeInSecForIosWeb:
//                                                                       1,
//                                                                       backgroundColor:
//                                                                       Colors
//                                                                           .red,
//                                                                       textColor:
//                                                                       Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                       16.0,
//                                                                     );
//                                                                     return;
//                                                                   }
//                                                                   if (img1 ==
//                                                                       null) {
//                                                                     Fluttertoast
//                                                                         .showToast(
//                                                                       msg:
//                                                                       "Please upload the Endsoc image",
//                                                                       toastLength: Toast
//                                                                           .LENGTH_SHORT,
//                                                                       gravity:
//                                                                       ToastGravity
//                                                                           .BOTTOM,
//                                                                       timeInSecForIosWeb:
//                                                                       1,
//                                                                       backgroundColor:
//                                                                       Colors
//                                                                           .red,
//                                                                       textColor:
//                                                                       Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                       16.0,
//                                                                     );
//                                                                     return;
//                                                                   }
//
//                                                                   double startSoc =
//                                                                       double.tryParse(
//                                                                           startSocController
//                                                                               .text) ??
//                                                                           0;
//                                                                   double endSoc =
//                                                                       double.tryParse(
//                                                                           endSocController
//                                                                               .text) ??
//                                                                           0;
//
//                                                                   if (startSoc ==
//                                                                       endSoc) {
//                                                                     Fluttertoast
//                                                                         .showToast(
//                                                                       msg:
//                                                                       "Start SOC and End SOC cannot be equal",
//                                                                       toastLength: Toast
//                                                                           .LENGTH_SHORT,
//                                                                       gravity:
//                                                                       ToastGravity
//                                                                           .BOTTOM,
//                                                                       timeInSecForIosWeb:
//                                                                       1,
//                                                                       backgroundColor:
//                                                                       Colors
//                                                                           .red,
//                                                                       textColor:
//                                                                       Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                       16.0,
//                                                                     );
//                                                                     return;
//                                                                   }
//                                                                   if (endSoc <
//                                                                       startSoc) {
//                                                                     Fluttertoast
//                                                                         .showToast(
//                                                                       msg:
//                                                                       "End SOC cannot be less than Start SOC",
//                                                                       toastLength: Toast
//                                                                           .LENGTH_SHORT,
//                                                                       gravity:
//                                                                       ToastGravity
//                                                                           .BOTTOM,
//                                                                       timeInSecForIosWeb:
//                                                                       1,
//                                                                       backgroundColor:
//                                                                       Colors
//                                                                           .red,
//                                                                       textColor:
//                                                                       Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                       16.0,
//                                                                     );
//                                                                     return;
//                                                                   }
//
//                                                                   handleSubmit();
//                                                                 } else {
//                                                                   if (endSocController
//                                                                       .text
//                                                                       .isEmpty) {
//                                                                     Fluttertoast
//                                                                         .showToast(
//                                                                       msg:
//                                                                       "Please enter the End soc",
//                                                                       toastLength: Toast
//                                                                           .LENGTH_SHORT,
//                                                                       gravity:
//                                                                       ToastGravity
//                                                                           .BOTTOM,
//                                                                       timeInSecForIosWeb:
//                                                                       1,
//                                                                       backgroundColor:
//                                                                       Colors
//                                                                           .red,
//                                                                       textColor:
//                                                                       Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                       16.0,
//                                                                     );
//                                                                     return;
//                                                                   }
//                                                                   if (img1 ==
//                                                                       null) {
//                                                                     Fluttertoast
//                                                                         .showToast(
//                                                                       msg:
//                                                                       "Please upload the Endsoc image",
//                                                                       toastLength: Toast
//                                                                           .LENGTH_SHORT,
//                                                                       gravity:
//                                                                       ToastGravity
//                                                                           .BOTTOM,
//                                                                       timeInSecForIosWeb:
//                                                                       1,
//                                                                       backgroundColor:
//                                                                       Colors
//                                                                           .red,
//                                                                       textColor:
//                                                                       Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                       16.0,
//                                                                     );
//                                                                     return;
//                                                                   }
//
//                                                                   double startSoc =
//                                                                       double.tryParse(
//                                                                           startSocController
//                                                                               .text) ??
//                                                                           0;
//                                                                   double endSoc =
//                                                                       double.tryParse(
//                                                                           endSocController
//                                                                               .text) ??
//                                                                           0;
//
//                                                                   if (startSoc ==
//                                                                       endSoc) {
//                                                                     Fluttertoast
//                                                                         .showToast(
//                                                                       msg:
//                                                                       "Start SOC and End SOC cannot be equal",
//                                                                       toastLength: Toast
//                                                                           .LENGTH_SHORT,
//                                                                       gravity:
//                                                                       ToastGravity
//                                                                           .BOTTOM,
//                                                                       timeInSecForIosWeb:
//                                                                       1,
//                                                                       backgroundColor:
//                                                                       Colors
//                                                                           .red,
//                                                                       textColor:
//                                                                       Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                       16.0,
//                                                                     );
//                                                                     return;
//                                                                   }
//                                                                   if (endSoc <
//                                                                       startSoc) {
//                                                                     Fluttertoast
//                                                                         .showToast(
//                                                                       msg:
//                                                                       "End SOC cannot be less than Start SOC",
//                                                                       toastLength: Toast
//                                                                           .LENGTH_SHORT,
//                                                                       gravity:
//                                                                       ToastGravity
//                                                                           .BOTTOM,
//                                                                       timeInSecForIosWeb:
//                                                                       1,
//                                                                       backgroundColor:
//                                                                       Colors
//                                                                           .red,
//                                                                       textColor:
//                                                                       Colors
//                                                                           .white,
//                                                                       fontSize:
//                                                                       16.0,
//                                                                     );
//                                                                     return;
//                                                                   }
//
//                                                                   print('offline');
//                                                                   offlinehandleSubmit();
//                                                                 }
//                                                               });
//                                                         },
//                                                         child: Text('Submit'),
//                                                       ),
//                                                     ),
//                                                     Expanded(
//                                                       flex: 1,
//                                                       // Adjust the flex value as needed
//                                                       child: Image.asset(
//                                                         'assets/Animation - 1718621606191.gif',
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                           ),
//                                           SizedBox(height: 200),
//                                           Align(
//                                             alignment: Alignment.bottomRight,
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 25),
//                                               child: TextButton(
//                                                 onPressed:
//                                                 _showConfirmationDialog,
//                                                 style: TextButton.styleFrom(
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: 20.0,
//                                                       vertical: 10.0),
//                                                   backgroundColor: Colors.red
//                                                       .withOpacity(0.1),
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                     BorderRadius.circular(
//                                                         8.0),
//                                                     side: BorderSide(
//                                                         color: Colors.red),
//                                                   ),
//                                                 ),
//                                                 child: Text(
//                                                   'Cancel',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 16.0,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: -100,
//                         right: 0,
//                         left: 0,
//                         child: Align(
//                           alignment: Alignment.topCenter,
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20.0),
//                               gradient: LinearGradient(
//                                 begin: Alignment.centerRight,
//                                 end: Alignment.centerLeft,
//                                 colors: [
//                                   HexColor("##358496"),
//                                   HexColor("#43C4AC"),
//                                 ],
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: HexColor(Colorscommon.greenApp2color),
//                                   blurRadius: 1.0,
//                                   spreadRadius: 0.0,
//                                   offset: const Offset(1.0, 1.0),
//                                 )
//                               ],
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Avenirtextblack(
//                                   text: spusername,
//                                   fontsize: 20,
//                                   textcolor: Colors.white,
//                                   customfontweight: FontWeight.w500,
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Avenirtextbook(
//                                   text: "Service Provider".toUpperCase(),
//                                   fontsize: 14,
//                                   textcolor: Colors.white,
//                                   customfontweight: FontWeight.w500,
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       const SizedBox(
//                                         height: 10,
//                                       ),
//                                       Center(
//                                         child: Avenirtextbook(
//                                           text: username.toUpperCase(),
//                                           fontsize: 15,
//                                           textcolor: Colors.white,
//                                           customfontweight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         height: 10,
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                             height: 110,
//                             margin: const EdgeInsets.all(20),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Confirm Cancel'),
//           content: Text('Do you want to cancel the charging?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('No'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Yes'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 clearFormData();
//                 await clearDraft();
//                 setState(() {});
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   String getChargingTypeLabel(String type) {
//     int? chargingType = int.tryParse(type);
//     if (chargingType != null) {
//       switch (chargingType) {
//         case 1:
//           return 'Slow Charge';
//         case 2:
//           return 'Fast Charge';
//         default:
//           return 'Unknown';
//       }
//     } else {
//       return 'Invalid Type';
//     }
//   }
// }
//
// class CurveImage extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0.0, size.height - 30);
//     path.quadraticBezierTo(
//         size.width / 4, size.height, size.width / 2, size.height);
//     path.quadraticBezierTo(size.width - (size.width / 4), size.height,
//         size.width, size.height - 30);
//     path.lineTo(size.width, 0.0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
//
// class QrDialog extends StatefulWidget {
//   final TextEditingController textfieldEditingController;
//   final BuildContext dialogContext;
//
//   const QrDialog({
//     Key? key,
//     required this.textfieldEditingController,
//     required this.dialogContext,
//   }) : super(key: key);
//
//   @override
//   State<QrDialog> createState() => _QrDialogState();
// }
//
// class _QrDialogState extends State<QrDialog> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   bool isScanned = false;
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller!.resumeCamera();
//     }
//   }
//
//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       if (!isScanned) {
//         setState(() {
//           widget.textfieldEditingController.text = scanData.code ?? '';
//           isScanned = true; // Mark as scanned
//         });
//         if (widget.textfieldEditingController.text.isNotEmpty) {
//           Navigator.of(widget.dialogContext)
//               .pop(widget.textfieldEditingController.text);
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//         MediaQuery.of(context).size.height < 400)
//         ? 150.0
//         : 300.0;
//     return AlertDialog(
//       content: SizedBox(
//         width: 300,
//         height: 300,
//         child: QRView(
//           key: qrKey,
//           onQRViewCreated: _onQRViewCreated,
//           formatsAllowed: const [
//             BarcodeFormat.qrcode,
//             BarcodeFormat.code128,
//             BarcodeFormat.code39,
//             BarcodeFormat.code93,
//             BarcodeFormat.ean13,
//             BarcodeFormat.ean8,
//             BarcodeFormat.upcA,
//             BarcodeFormat.upcE,
//             BarcodeFormat.pdf417,
//             BarcodeFormat.aztec,
//             BarcodeFormat.dataMatrix,
//           ],
//         ),
//       ),
//     );
//   }
// }
