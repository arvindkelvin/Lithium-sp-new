// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
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
// import 'package:http_parser/http_parser.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:location/location.dart';
// import 'package:lottie/lottie.dart';
// import 'package:mime/mime.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_face_api/face_api.dart' as Regula;
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// import 'AppScreens/Earnings/Dashboardtabbar.dart';
// import 'l10n/app_localizations.dart';
//
//
//
// class Odo extends StatefulWidget {
//   const Odo({Key? key}) : super(key: key);
//
//   @override
//   State<Odo> createState() => _OdoState();
// }
//
// class _OdoState extends State<Odo>
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
//   String? selectedChargingType = "1";
//
//   List<Map<String, dynamic>> chargingTypes = [
//     {"id": "1", "chargingtype": "Slow Charge"},
//     {"id": "2", "chargingtype": "Fast Charge"},
//   ];
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
//
//   bool  showFirstRow1 = true;
//
//   void closeLoader(BuildContext context) {
//     debugPrint('close loader called');
//     Navigator.of(context, rootNavigator: true).pop();
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
//           ResolutionPreset.max,
//         );
//         await controller.initialize();
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
//                             setState(() {
//                               if (index == 1) {
//                                 img1 = File(imageFile.path);
//                               }
//                               if (index == 3) {
//                                 img3 = File(imageFile.path);
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
//   Future<void> performImage() async {
//     try {
//       // setState(() {
//       //   imgname = "Verify your face";
//       //   image = 'assets/faceverify3.png';
//       // });
//       // if (image2.bitmap != null) {
//       //   try {
//       //     Uint8List decodedImage = base64Decode(image2.bitmap!);
//       //     String tempImagePath = await generateTempImagePath();
//       //     await File(tempImagePath).writeAsBytes(decodedImage);
//       //     image2Data = File(tempImagePath);
//       //   } catch (e) {
//       //     print('Error decoding image data: $e');
//       //   }
//       // }
//       if (img1 != null) {
//         setState(() {
//           imgname = "Face Verified";
//           isImageCaptured = true;
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
//       showFirstRow1 = true;
//
//
//
//       // Clear images
//       img1 = null;
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
//     await prefs.remove('showFirstRow1');
//   }
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
//                               child: Text('Start Odometer :',
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
//
//                         // Example usage in your TableRow
//
//                         TableRow(
//                           children: [
//                             Padding(
//                               padding:
//                               const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text('End Odometer :',
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
//                 if (img1 != null || img3 != null)
//                   Padding(
//                     padding: const EdgeInsets.all(1.0),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (img3 != null)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   Text('Start Odometer :',
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
//
//                           if (img1 != null)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 8.0),
//                               child: Row(
//                                 children: [
//                                   Text('End Odometer :',
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
//
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
//                 foregroundColor: Colors.white, backgroundColor: Colors.green,
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
//     // Convert images to base64 strings
//     //
//     // String EndSocimage = endSocImageBase64();
//     // print('base64Imageend--$EndSocimage');
//     //
//     // String Odometerimage = OdometerImageBase64();
//     // print('base64Imageodometer--$Odometerimage');
//
//     showLoadingDialog();
//     String odometer = odometerController.text;
//     //String startSoc = startSocController.text;
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
//      // String uriString = CommonURL.localone; // Your URL as a string
//       const uriString = 'http://10.10.14.14:8092/webservice';
//       Uri uri = Uri.parse(uriString); // Convert it to a Uri
//
//       var request = http.MultipartRequest('POST', uri)
//         ..fields['from'] = 'vehicleodometer'
//         ..fields['lithiumid'] = utility.lithiumid
//         //..fields['username'] = utility.sp_username
//         //..fields['vehiclenumber'] = selectedVehicleNo!
//         //..fields['odometer'] = odometer
//         ..fields['startodometer'] = odometer
//
//
//         ..fields['endodometer'] = endSoc
//         ..fields['latitude'] = currentLocation?.latitude.toString() ?? '0.0'
//         ..fields['longitude'] = currentLocation?.longitude.toString() ?? '0.0';
//         //..fields['timestamp'] = DateTime.now().toIso8601String()
//        // ..fields['service_provider'] = utility.service_provider_c;
//
//       print('requestdata${request.fields}');
//
//       // Add image files if available
//       if (img1 != null) {
//         String fileName = img1!.path.split('/').last;
//         print("endsocimage fileName: $fileName");
//         request.files.add(await http.MultipartFile.fromPath(
//           'startodometerimage',
//           img1!.path,
//           contentType: MediaType.parse(
//               lookupMimeType(img1!.path) ?? 'application/octet-stream'),
//         ));
//       }
//
//       if (img3 != null) {
//         String fileName = img3!.path.split('/').last;
//         print("odometerimage fileName: $fileName");
//         request.files.add(await http.MultipartFile.fromPath(
//           'endodometerimage',
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
//               title: const Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.green),
//                   SizedBox(width: 8),
//                   Expanded(child: Text('Success')),
//                 ],
//               ),
//               content: const Text("Odometer data uploaded successfully."),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('OK'),
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
//               title: const Row(
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
//        // msg: "Error sending data: $e",
//         msg: "Odometer data uploaded successfully.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//       print('Error sending data: $e');
//       clearFormData();
//       await clearDraft();
//       setState(() {});
//     }
//
//     // Clear the form data and draft
//     clearFormData();
//     await clearDraft();
//     setState(() {});
//   }
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
//   void saveForm() {
//     // Perform save operations here
//     saveDraft();
//     setState(() {
//       showStartSocRow = false;
//       showEndSocRow = true;
//       isVehicleNoSelected = true;
//       isImageCaptured2 =false;
//       isImageCaptured =false;
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
//     await prefs.setBool('isVehicleNoSelected', isVehicleNoSelected); // Save vehicle number selection status
//
//     if (img1 != null) {
//       await prefs.setString('img1Path', img1!.path);
//     }
//
//     if (img3 != null) {
//       await prefs.setString('img3Path', img3!.path);
//     }
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
//     bool firstRowVisible1 = prefs.getBool('showdropRow') ?? false;
//     bool startSocRowVisible = prefs.getBool('showStartSocRow') ?? false;
//     bool endSocRowVisible = prefs.getBool('showEndSocRow') ?? false;
//     bool isVehicleSelected = vehicleNoSelected != null;
//
//     // Load images asynchronously
//     var img1Path = prefs.getString('img1Path');
//     var img2Path = prefs.getString('img2Path');
//     var img3Path = prefs.getString('img3Path');
//
//     File? img1 = img1Path != null ? File(img1Path) : null;
//     File? img2 = img2Path != null ? File(img2Path) : null;
//     File? img3 = img3Path != null ? File(img3Path) : null;
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
//
//       showStartSocRow = startSocRowVisible;
//       showEndSocRow = endSocRowVisible;
//       isVehicleNoSelected = isVehicleSelected;
//       this.img1 = img1;
//
//       this.img3 = img3;
//     });
//   }
//
//
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
//
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
//
//
//   bool isAnyFieldEmpty() {
//     return odometerController.text.isEmpty ;
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
//                                 visible: showFirstRow1,
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 5,
//                                       // Button gets 3 parts of the available space
//                                       child: ElevatedButton(
//                                         onPressed: () {
//                                           setState(() {
//                                             showFirstRow = true;
//                                             showFirstRow1 = false;
//                                           });
//                                         },
//                                         child: Text('Start Odometer'),
//                                       ),
//                                     ),
//
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 10,
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
//                                           flex: 1,
//                                           child: Avenirtextmedium(
//                                             customfontweight:
//                                             FontWeight.w500,
//                                             fontsize: (AppLocalizations.of(
//                                                 context)!
//                                                 .id ==
//                                                 "ஐடி" ||
//                                                 AppLocalizations.of(
//                                                     context)!
//                                                     .id ==
//                                                     "आयडी" ||
//                                                 AppLocalizations.of(
//                                                     context)!
//                                                     .id ==
//                                                     "ಐಡಿ")
//                                                 ? 12
//                                                 : 14,
//                                             text: "Start Odometer",
//                                             textcolor: HexColor(
//                                                 Colorscommon.greendark),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 2,
//                                           child: Container(
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: 6,
//                                                 horizontal: 8),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               border: Border.all(
//                                                   color: Colors.grey),
//                                               borderRadius:
//                                               BorderRadius.circular(
//                                                   8),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2),
//                                                   spreadRadius: 1,
//                                                   blurRadius: 3,
//                                                   offset: Offset(0,
//                                                       2), // changes position of shadow
//                                                 ),
//                                               ],
//                                             ),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(
//                                                   flex: 3,
//                                                   child: TextFormField(
//                                                     controller:
//                                                     odometerController,
//                                                     focusNode:
//                                                     odometerFocusNode,
//                                                     keyboardType:
//                                                     TextInputType
//                                                         .number,
//                                                     inputFormatters: [
//                                                       LengthLimitingTextInputFormatter(
//                                                           6),
//                                                       FilteringTextInputFormatter
//                                                           .digitsOnly,
//                                                     ],
//                                                     decoration:
//                                                     InputDecoration(
//                                                       border: InputBorder
//                                                           .none,
//                                                       hintText:
//                                                       'Enter Start Odometer',
//                                                       hintStyle: TextStyle(
//                                                           color: Colors
//                                                               .grey),
//                                                     ),
//                                                     onChanged: (value) {
//                                                       if (value.length ==
//                                                           6) {
//                                                         FocusScope.of(
//                                                             context)
//                                                             .requestFocus(
//                                                             FocusNode());
//                                                       }
//                                                     },
//                                                   ),
//                                                 ),
//                                                 VerticalDivider(
//                                                   color: Colors.grey,
//                                                   thickness: 1,
//                                                 ),
//                                                 Container(
//                                                   padding: EdgeInsets
//                                                       .symmetric(
//                                                       vertical: 10,
//                                                       horizontal: 11),
//                                                   decoration:
//                                                   BoxDecoration(
//                                                     color: Colors.white,
//                                                     border: Border.all(
//                                                         color:
//                                                         Colors.grey),
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .circular(8),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: Colors.grey
//                                                             .withOpacity(
//                                                             0.2),
//                                                         spreadRadius: 1,
//                                                         blurRadius: 3,
//                                                         offset: Offset(0,
//                                                             2), // changes position of shadow
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   child: GestureDetector(
//                                                     onTap: () {
//                                                       autoCaptureImage1(
//                                                           3);
//                                                     },
//                                                     child:
//                                                     isImageCaptured2
//                                                         ? Container(
//                                                       width: 24,
//                                                       // Adjust width as needed
//                                                       height:
//                                                       24,
//                                                       // Adjust height as needed
//                                                       child: Image.asset(
//                                                           'assets/image.png',
//                                                           fit: BoxFit
//                                                               .contain),
//                                                     )
//                                                         : Icon(Icons
//                                                         .camera_rear),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(
//                                       height: 50,
//                                     ),
//                                     Row(
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.only(left: 60),
//                                           child: ElevatedButton(
//                                             onPressed: () async {
//                                               if (odometerController.text.isEmpty) {
//                                                 Fluttertoast.showToast(
//                                                   msg: "Please enter the odometer reading",
//                                                   toastLength: Toast.LENGTH_SHORT,
//                                                   gravity: ToastGravity.BOTTOM,
//                                                   timeInSecForIosWeb: 1,
//                                                   backgroundColor: Colors.red,
//                                                   textColor: Colors.white,
//                                                   fontSize: 16.0,
//                                                 );
//                                                 return;
//                                               }
//
//                                               if (img3 == null) {
//                                                 Fluttertoast.showToast(
//                                                   msg: "Please upload the Odometer image",
//                                                   toastLength: Toast.LENGTH_SHORT,
//                                                   gravity: ToastGravity.BOTTOM,
//                                                   timeInSecForIosWeb: 1,
//                                                   backgroundColor: Colors.red,
//                                                   textColor: Colors.white,
//                                                   fontSize: 16.0,
//                                                 );
//                                                 return;
//                                               }
//
//                                               showDialog(
//                                                 context: context,
//                                                 barrierDismissible: false,
//                                                 builder: (BuildContext context) {
//                                                   Future.delayed(Duration(seconds: 2), () {
//                                                     Navigator.of(context).pop(true);
//                                                     Fluttertoast.showToast(
//                                                       msg: "Draft saved successfully",
//                                                       toastLength: Toast.LENGTH_SHORT,
//                                                       gravity: ToastGravity.BOTTOM,
//                                                       timeInSecForIosWeb: 1,
//                                                       backgroundColor: Colors.green,
//                                                       textColor: Colors.white,
//                                                       fontSize: 16.0,
//                                                     );
//                                                     setState(() {
//                                                       showFirstRow = false;
//
//                                                     });
//                                                     saveForm();
//                                                   });
//                                                   return Center(
//                                                     child: CircularProgressIndicator(),
//                                                   );
//                                                 },
//                                               );
//                                             },
//                                             style: TextButton.styleFrom(
//                                               padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 12.0),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(8.0),
//                                               ),
//                                             ),
//                                             child: Text('Save'),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(left: 25),
//                                           child: TextButton(
//                                             onPressed: _showConfirmationDialog,
//                                             style: TextButton.styleFrom(
//                                               padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                                               backgroundColor: Colors.red.withOpacity(0.1),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(8.0),
//                                                 side: BorderSide(color: Colors.red),
//                                               ),
//                                             ),
//                                             child: Text(
//                                               'Cancel',
//                                               style: TextStyle(
//                                                 color: Colors.red,
//                                                 fontSize: 16.0,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//
//
//
//
//
//
//                                   ],
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: showEndSocRow,
//                                 child: Column(
//                                   children: [
//                                     Visibility(
//                                       visible: showEndSocRow,
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
//                                                   text: "End Odometer",
//                                                   textcolor: HexColor(
//                                                       Colorscommon
//                                                           .greendark),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 child: Container(
//                                                   padding: EdgeInsets
//                                                       .symmetric(
//                                                       vertical: 6,
//                                                       horizontal: 8),
//                                                   decoration:
//                                                   BoxDecoration(
//                                                     color: Colors.white,
//                                                     border: Border.all(
//                                                         color:
//                                                         Colors.grey),
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .circular(8),
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                         color: Colors.grey
//                                                             .withOpacity(
//                                                             0.2),
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
//                                                           endSocController,
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
//                                                         color:
//                                                         Colors.grey,
//                                                         thickness: 1,
//                                                       ),
//                                                       Container(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                             vertical:
//                                                             10,
//                                                             horizontal:
//                                                             11),
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           color: Colors
//                                                               .white,
//                                                           border: Border.all(
//                                                               color: Colors
//                                                                   .grey),
//                                                           borderRadius:
//                                                           BorderRadius
//                                                               .circular(
//                                                               8),
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors
//                                                                   .grey
//                                                                   .withOpacity(
//                                                                   0.2),
//                                                               spreadRadius:
//                                                               1,
//                                                               blurRadius:
//                                                               3,
//                                                               offset: Offset(
//                                                                   0,
//                                                                   2), // changes position of shadow
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         child:
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             autoCaptureImage1(
//                                                                 1);
//                                                           },
//                                                           child: isImageCaptured
//                                                               ? Container(
//                                                             width:
//                                                             24,
//                                                             // Adjust width as needed
//                                                             height:
//                                                             24,
//                                                             // Adjust height as needed
//                                                             child: Image.asset(
//                                                                 'assets/image.png',
//                                                                 fit:
//                                                                 BoxFit.contain),
//                                                           )
//                                                               : Icon(Icons.camera_rear),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           // New row with the image
//                                           SizedBox(
//                                             height: 30,
//                                           ),
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 flex: 2,
//                                                 // Adjust the flex value as needed
//                                                 child: ElevatedButton(
//                                                   onPressed: () {
//                                                     if (endSocController
//                                                         .text.isEmpty) {
//                                                       Fluttertoast.showToast(
//                                                           msg:
//                                                           "Please enter the End soc",
//                                                           toastLength: Toast
//                                                               .LENGTH_SHORT,
//                                                           gravity:
//                                                           ToastGravity
//                                                               .BOTTOM,
//                                                           timeInSecForIosWeb:
//                                                           1,
//                                                           backgroundColor:
//                                                           Colors.red,
//                                                           textColor:
//                                                           Colors
//                                                               .white,
//                                                           fontSize: 16.0);
//                                                       return;
//                                                     }
//                                                     if (img1 == null) {
//                                                       Fluttertoast.showToast(
//                                                           msg:
//                                                           "Please upload the Endsoc image",
//                                                           toastLength: Toast
//                                                               .LENGTH_SHORT,
//                                                           gravity:
//                                                           ToastGravity
//                                                               .BOTTOM,
//                                                           timeInSecForIosWeb:
//                                                           1,
//                                                           backgroundColor:
//                                                           Colors.red,
//                                                           textColor:
//                                                           Colors
//                                                               .white,
//                                                           fontSize: 16.0);
//                                                       return;
//                                                     }
//
//                                                     handleSubmit();
//                                                   },
//                                                   child: Text('Submit'),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 2,
//                                                 // Adjust the flex value as needed
//
//
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.only(left: 25),
//                                                       child: TextButton(
//                                                         onPressed: _showConfirmationDialog,
//                                                         style: TextButton.styleFrom(
//                                                           padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                                                           backgroundColor: Colors.red.withOpacity(0.1),
//                                                           shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius.circular(8.0),
//                                                             side: BorderSide(color: Colors.red),
//                                                           ),
//                                                         ),
//                                                         child: Text(
//                                                           'Cancel',
//                                                           style: TextStyle(
//                                                             color: Colors.red,
//                                                             fontSize: 16.0,
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   )
//
//                                             ],
//                                           ),
//
//
//
//
//
//
//
//
//
//                                         ],
//                                       ),
//                                     ),
//                                     Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.center,
//                                     ),
//
//                                     SizedBox(height: 200),
//
//
//
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
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
//                 setState(() {
//                   showFirstRow1 = false;
//                 });
//                 Navigator.of(context).pop();
//                 clearFormData();
//                 await clearDraft();
//
//               },
//             ),
//           ],
//         );
//       },
//     );
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
//
//
//
