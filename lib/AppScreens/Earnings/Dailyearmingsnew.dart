import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings/Dashboardtabbar.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../l10n/app_localizations.dart';

class Dailyearningsnew extends StatefulWidget {
  const Dailyearningsnew({Key? key}) : super(key: key);

  @override
  State<Dailyearningsnew> createState() => _DailyearningsnewState();
}

class _DailyearningsnewState extends State<Dailyearningsnew> {
  Utility utility = Utility();
  String service_provider = '';
  var username = "";
  final List<TextEditingController> _controllers = [];
  bool imagebool = false;
  bool showbtnbool = false;
  late File _image;
  String imgname = '';
  bool isloading = true;
  List<String> changetypelist = [];
  List<int> changetypelistid = [];
  List<dynamic> dailyearnindetailslist = [];
  List<dynamic> datedroplist = [];
  String rosterstartTime = '';
  String rosterendTime = '';
  String checkintime = '';
  String checkouttime = '';
  String debitdetails = '';
  String? change_date;
  int? change_dateid;
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
            sessionManager.internetcheck().then((intenet) async {
              if (intenet) {
                //utility.showYourpopupinternetstatus(context);
              } else {
                 WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;

                final overlay = Overlay.of(context);
                if (overlay == null) return;

                showTopSnackBar(
                  overlay,
                  const CustomSnackBar.error(
                    message: "Please Check Your Internet Connection",
                  ),
                );
                });
              }
            }), // spuser
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
    print("hello");
    request.fields['from'] = "getDailyEarningDateDropDown";
    request.fields['service_provider_c'] = service_provider;
    request.fields['languageType'] =
        AppLocalizations.of(context)!.languagecode.toString();
    print("fields = $url ${request.fields}");
    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("get daily earn = $jsonInput");

      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];
      print("111");
      if (status == 'true') {
        print("hello1111");
        datedroplist = jsonInput['dateArray'];

        for (int i = 0; i < datedroplist.length; i++) {
          if (i == 0) {
            change_date = (datedroplist[i]['name']).toString();
            change_dateid = (datedroplist[i]['id']);
            print("change_date====$change_date");
            getdailyearningdetailsbydate();
          }
          var changeTodate = (datedroplist[i]['name']).toString();
          int changeTodateid = (datedroplist[i]['id']);
          changetypelist.add(changeTodate);
          changetypelistid.add(changeTodateid);
        }
        if (mounted) {
          setState(() {});
        }
      } else {
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {}
  }

  // Raise_no_griveanceapi(BuildContext context) async {
  //   loading();
  //   var url = Uri.parse(CommonURL.herokuurl);
  //
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "noGrievanceDailyUpdate";
  //   request.fields['service_provider_c'] = service_provider;
  //   request.fields['lithiumID'] = username;
  //   request.fields['date'] = change_date ?? "";
  //   request.fields['languageType'] =
  //       AppLocalizations.of(context)!.languagecode.toString();
  //
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     print("daily earn = $jsonInput");
  //
  //     String status = jsonInput['status'].toString();
  //     String message = jsonInput['message'];
  //
  //     if (status == 'true') {
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //       Navigator.of(context).pop();
  //       Navigator.of(context).pop();
  //       // Navigator.push(context,
  //       //     MaterialPageRoute(builder: (context) => const Dashboard2()));
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const MyTabPage(
  //                     title: '',
  //                     selectedtab: 0,
  //                   )));
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //   } else {}
  //   setState(() {});
  // }

  void _showPicker(context) {
    FocusScope.of(context).requestFocus(FocusNode());

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
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

  getSubCategoryByCategory(String title, String categoryC) async {
    var url = Uri.parse(CommonURL.herokuurl);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "getSubCategoryByCategory";
    request.fields['service_provider_c'] = service_provider;
    request.fields['category_c'] = categoryC;
    request.fields['languageType'] =
        AppLocalizations.of(context)!.languagecode.toString();

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      // print("jsonInput=$jsonInput");
      String status = jsonInput['status'].toString();
      // String message = jsonInput['message'];
      if (status == 'true') {
        for (int i = 0; i < dailyearnindetailslist.length; i++) {
          for (int i2 = 0;
              i2 < dailyearnindetailslist[i]["data"].length;
              i2++) {
            var strinvalue =
                dailyearnindetailslist[i]["data"][i2]["name"].toString();
            // print("strinvalue$strinvalue");
            if (title == strinvalue) {
              dailyearnindetailslist[i]["data"][i2]["subcategoryArray"] =
                  jsonInput['data'];
              setState(() {});
              break;
            }
          }
        }
      }
    } else {}
  }
  //
  // getdailyearningdetailsbydate() async {
  //   var url = Uri.parse(CommonURL.herokuurl);
  //   print("hello22");
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/x-www-form-urlencoded"
  //   };
  //   print("hello22222");
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //   request.fields['from'] = "getDailyEOSSPDataBYDate";
  //   request.fields['selectedDate'] = change_date.toString();
  //   request.fields['service_provider_c'] = service_provider;
  //   request.fields['languageType'] =
  //       AppLocalizations.of(context)!.languagecode.toString();
  //
  //   var streamResponse = await request.send();
  //   var response = await http.Response.fromStream(streamResponse);
  //   print("response= $response");
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //     // print("getdailyearningdetails= $jsonInput");
  //     print("getdailyearningdetails new = $jsonInput");
  //     print("Response Body: ${response.body}");
  //     String status = jsonInput['status'].toString();
  //     String message = jsonInput['message'];
  //
  //     if (status == 'true') {
  //       dailyearnindetailslist = jsonInput['data'] as List<dynamic>;
  //       showbtnbool = jsonInput['isGrievanceAlreadyExist'] as bool;
  //       // print("showbtnbool$showbtnbool");
  //       isloading = false;
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //
  //   } else {}
  //   if (mounted) { // Check if the widget is still in the tree
  //     setState(() {
  //       // Update the widget state here
  //     });
  //   }
  // }
  getdailyearningdetailsbydate() async {
    var url = Uri.parse(CommonURL.localone);
    print("hello22");
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };
    print("hello22222");

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);

    // Construct the JSON payload
    String dataJson = jsonEncode([
      {
        "service_provider": utility.service_provider_c  ,
        "tripDate": change_date,
      }
    ]);
    print("change_date====$change_date");
    // Ensure that all fields are non-null
    request.fields['from'] = "getDailyEOSSPDataBYDate";
    request.fields['selectedDate'] = change_date?.toString() ?? '';
    request.fields['service_provider_c'] = service_provider ?? '';
    request.fields['languageType'] = AppLocalizations.of(context)?.languagecode?.toString() ?? '';
    request.fields['data'] = dataJson; // Send the JSON data here

    try {
      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);
      print("response= $response");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonInput = jsonDecode(response.body);
        print("getdailyearningdetails new = $jsonInput");
        print("Response Body: ${response.body}");

        String status = jsonInput['status']?.toString() ?? 'false';
        String message = jsonInput['message']?.toString() ?? '';

        if (status == 'true') {
          dailyearnindetailslist = jsonInput['data'] as List<dynamic>;
          showbtnbool = jsonInput['isGrievanceAlreadyExist'] as bool? ?? false;
          isloading = false;
        } else {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    if (mounted) {
      setState(() {
        // Update the widget state here
      });
    }
  }



  // getdailyearningdetailsbydate() async {
  //   var url = Uri.parse(CommonURL.localone);
  //   print("hello22");
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/json"
  //   };
  //   print("hello22222");
  //
  //   var request = http.MultipartRequest("POST", url);
  //   request.headers.addAll(headers);
  //
  //   // Construct the JSON payload
  //   String dataJson = jsonEncode([
  //     {
  //     "service_provider": "a14HE00000264Fx",
  //       "rosterDate":"2024-08-04",
  //     }
  //   ]);
  //
  //   // Replace the request.fields with a single key-value pair for JSON data
  //   request.fields['from'] = "getDailyEOSSPDataBYDate";
  //   request.fields['selectedDate'] = change_date.toString();
  //   request.fields['service_provider_c'] = service_provider;
  //   request.fields['languageType'] =
  //       AppLocalizations.of(context)!.languagecode.toString();
  //   request.fields['data'] = dataJson; // Send the JSON data here
  //
  //   try {
  //     var streamResponse = await request.send();
  //     var response = await http.Response.fromStream(streamResponse);
  //     print("response= $response");
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       Map<String, dynamic> jsonInput = jsonDecode(response.body);
  //       print("getdailyearningdetails new = $jsonInput");
  //       print("Response Body: ${response.body}");
  //
  //       String status = jsonInput['status'].toString();
  //       String message = jsonInput['message'];
  //
  //       if (status == true) {
  //         dailyearnindetailslist = jsonInput['data'] as List<dynamic>;
  //         showbtnbool = jsonInput['isGrievanceAlreadyExist'] as bool;
  //         isloading = false;
  //       } else {
  //         Fluttertoast.showToast(
  //           msg: message,
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //         );
  //       }
  //     } else {
  //       print("Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  //
  //   if (mounted) {
  //     setState(() {
  //       // Update the widget state here
  //     });
  //   }
  // }


  DailyearningSubmit() async {
    loading();
    var url = Uri.parse(CommonURL.localone);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields['from'] = "dailyEarningAdd";
    // change_date
    request.fields['date'] = change_date ?? "";
    request.fields['data'] = jsonEncode(dailyearnindetailslist);
    request.fields['lithiumID'] = utility.lithiumid;
    request.fields['service_provider_c'] = utility.service_provider_c;
    request.fields['languageType'] =
        AppLocalizations.of(context)!.languagecode.toString();
    if (imagebool == true) {
      request.files
          .add(await http.MultipartFile.fromPath('benchFile', _image.path));
    }

    // request.files.add(await http.MultipartFile.fromPath('file', _image.path));

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    // log(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);


      String status = jsonInput['status'].toString();
      String message = jsonInput['message'];

      if (status == 'true') {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyTabPage(
                      title: '',
                      selectedtab: 0,
                    )));
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
    } else {}

    // Navigator.pop(context);
    setState(() {});
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Avenirtextblack(
                      text: AppLocalizations.of(context)!.date,
                      fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                              AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                              AppLocalizations.of(context)!.id == "आयडी")
                          ? 12
                          : 14,
                      textcolor: HexColor(Colorscommon.greenAppcolor),
                      customfontweight: FontWeight.w500),
                  Container(
                    // width: MediaQuery.of(context).size.width - 15,
                    height: 30,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: HexColor(Colorscommon.greydark)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
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
                          style: TextStyle(
                              fontSize:
                              (AppLocalizations.of(context)!.id == "ஐடி" ||
                                  AppLocalizations.of(context)!.id ==
                                      "ಐಡಿ" ||
                                  AppLocalizations.of(context)!.id ==
                                      "आयडी")
                                  ? 12
                                  : 14,
                              fontFamily: 'AvenirLTStd-Book',
                              color: HexColor(Colorscommon.greydark2)),
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
                            print("DropdownMenuItem$DropdownMenuItem");
                            change_date = value.toString();
                            isloading = true;
                            setState(() {
                              getdailyearningdetailsbydate();
                            });
                            for(int i = 0; i < changetypelist.length; i++) {
                              if(change_date == changetypelist[i]) {
                                change_dateid = changetypelistid[i];
                              }
                              print("== change_dateid == $change_dateid ==");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: !isloading,
                child: Expanded(
                  child: SizedBox(
                      // height: MediaQuery.of(context).size.height - 100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: dailyearnindetailslist.length,
                        itemBuilder: (context, mainindex) {
                          var array = dailyearnindetailslist[mainindex]['data']
                              as List<dynamic>;
                          // var array = (dailyearnindetailslist[mainindex]['data'] as List<dynamic>?) ?? [];

                          print("array1 = $array");
                          var name = dailyearnindetailslist[mainindex]['name']
                              .toString();
                          // print("name$name");
                          if (name == "Check In/Out Details") {
                            name =
                                AppLocalizations.of(context)!.checkInOutDetails;
                          } else if (name == "Late & Leave Details ") {
                            name = AppLocalizations.of(context)!.lateLeaveDetails;
                          } else if (name == "Trip/Bench") {
                            name = AppLocalizations.of(context)!.tRIPBench;
                          } else if (name == "Debit/ Recovery") {
                            name = AppLocalizations.of(context)!.debitrecovery;
                          }

                          return Container(
                            padding: const EdgeInsets.all(10),
                            // padding: const EdgeInsets.only(
                            //     left: 10, right: 10, top: 0, bottom: 0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Avenirtextblack(
                                        customfontweight: FontWeight.w500,
                                        fontsize:
                                            (AppLocalizations.of(context)!.id ==
                                                        "ஐடி" ||
                                                    AppLocalizations.of(context)!
                                                            .id ==
                                                        "ಐಡಿ" ||
                                                    AppLocalizations.of(context)!
                                                            .id ==
                                                        "आयडी")
                                                ? 14
                                                : 17,
                                        text: name.toString(),
                                        textcolor:
                                            HexColor(Colorscommon.greendark),
                                      ),
                                    ),
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
                                      List<String> array5 = [];
                                      List<String> sfidarray5 = [];

                                      String? dropdownvalueone;
                                      String? dropdownvaluetwo;
                                      String? dropdownvaluethree;
                                      String? dropdownvaluefour;
                                      String? dropdownvaluefive;

                                      var arrayspilt1 =
                                          array[index]["dropdownArray"];
                                      var arrayspilt2 =
                                          array[index]["isAvailDropDown"];
                                      var arrayspilt3 =
                                          array[index]["categoryArray"];
                                      // print('arrayspilt3$arrayspilt3');
                                      var arrayspilt4 =
                                          array[index]["subcategoryArray"];
                                      var arrayspilt5 =
                                          array[index]["dropdownArray"];
                                      String formFieldType = array[index]
                                              ["formFieldType"]
                                          .toString();

                                      dropdownvalueone = array[index]
                                              ["selectedDropDownValue"]
                                          .toString();

                                      dropdownvaluetwo = array[index]
                                              ["selectedIsAvailValue"]
                                          .toString();
                                      dropdownvaluethree = array[index]
                                              ["selectedCategory"]
                                          .toString();
                                      dropdownvaluefour = array[index]
                                              ["selectedSubCategory"]
                                          .toString();
                                      dropdownvaluefive = array[index]
                                              ["selectedDropDownValue"]
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
                                      var subname =
                                          array[index]["name"].toString();
                                      // print("subname$subname");
                                      if (subname == "Roster Start Time") {
                                        subname = AppLocalizations.of(context)!
                                            .rosterStartTime;
                                      } else if (subname == "Check In Time") {
                                        subname = AppLocalizations.of(context)!
                                            .checkintime;
                                      } else if (subname == "Roster End Time") {
                                        subname = AppLocalizations.of(context)!
                                            .rosterendTime;
                                      } else if (subname == "Check Out Time") {
                                        subname = AppLocalizations.of(context)!
                                            .checkouttime;
                                      } else if (subname == "Late") {
                                        subname =
                                            AppLocalizations.of(context)!.late;
                                      } else if (subname.toUpperCase() == "EOS") {
                                        subname =
                                            AppLocalizations.of(context)!.eOS;
                                      } else if (subname == "UEOS") {
                                        subname =
                                            AppLocalizations.of(context)!.uEOS;
                                      } else if (subname == "WEOS") {
                                        subname =
                                            AppLocalizations.of(context)!.wEOS;
                                      } else if (subname == "Trip Count") {
                                        subname = AppLocalizations.of(context)!
                                            .tripcount;
                                      } else if (subname == "Debit Details") {
                                        subname = AppLocalizations.of(context)!
                                            .debitdetails;
                                      } /*else if (subname == "Today Earnings") {
                                        subname = AppLocalizations.of(context)!
                                            .todayEarnings;
                                      }*/
                                      // Check for null before using arrays
                                      if (arrayspilt1 != null) {
                                        for (int i = 0; i < arrayspilt1.length; i++) {
                                          if (array[index]["name"].toString() == "Roster Start Time") {
                                            String value;
                                            if (i == 0) {
                                              value = (arrayspilt1[i]['name'].toString());
                                            } else {
                                              value = (arrayspilt1[i]['name'].toString() +
                                                  "( " +
                                                  arrayspilt1[i]['id'].toString() +
                                                  " )");
                                            }
                                            array1.add(value);
                                          } else if (array[index]["name"].toString() == "Late") {
                                            var value = (arrayspilt1[i]['start_time__c'].toString());
                                            array1.add(value);
                                          } else {
                                            var value = (arrayspilt1[i]['name'].toString());
                                            array1.add(value);
                                          }
                                          if (array[index]["name"].toString() == "Roster Start Time") {
                                            var value2 = (arrayspilt1[i]['roster_master__c'].toString() +
                                                "," +
                                                arrayspilt1[i]['start_time__c'].toString());
                                            sfidarray1.add(value2);
                                          } else {
                                            var value2 = (arrayspilt1[i]['roster_master__c'].toString() +
                                                "," +
                                                arrayspilt1[i]['roster_start_datetime'].toString());
                                            sfidarray1.add(value2);
                                          }
                                        }
                                      }

                                      if (arrayspilt2 != null) {
                                        for (int i = 0; i < arrayspilt2.length; i++) {
                                          var value = (arrayspilt2[i]['name'].toString());
                                          array2.add(value);
                                          var value2 = (arrayspilt2[i]['sfid'].toString());
                                          sfidarray2.add(value2);
                                        }
                                      }

                                      if (arrayspilt3 != null) {
                                        for (int i = 0; i < arrayspilt3.length; i++) {
                                          var value = (arrayspilt3[i]['showlangaugename'].toString());
                                          array3.add(value);
                                          var value2 = (arrayspilt3[i]['sfid'].toString());
                                          sfidarray3.add(value2);
                                        }
                                      }

                                      if (arrayspilt4 != null) {
                                        for (int i = 0; i < arrayspilt4.length; i++) {
                                          var value = (arrayspilt4[i]['name'].toString());
                                          array4.add(value);
                                          var value2 = (arrayspilt4[i]['sfid'].toString());
                                          sfidarray4.add(value2);
                                        }
                                      }

                                      if (arrayspilt5 != null) {
                                        for (int i = 0; i < arrayspilt5.length; i++) {
                                          var value = arrayspilt5[i]['name'].toString();
                                          array5.add(value);
                                          var value2 = (arrayspilt5[i]['roster_master__c'].toString());
                                          sfidarray5.add(value2);
                                        }
                                      }


                                      return Container(
                                        // height: 40,
                                        padding: const EdgeInsets.only(
                                            top: 0,
                                            left: 0,
                                            right: 10,
                                            bottom: 10),
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible: dailyearnindetailslist[
                                                              mainindex]['name']
                                                          .toString() ==
                                                      "Check In/Out Details" ||
                                                  dailyearnindetailslist[
                                                              mainindex]['name']
                                                          .toString() ==
                                                      "Late & Leave Details " ||
                                                  dailyearnindetailslist[
                                                              mainindex]['name']
                                                          .toString() ==
                                                      "Trip/Bench",
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (!showbtnbool) {
                                                      dailyearnindetailslist[
                                                                      mainindex]
                                                                  ["data"][index][
                                                              'selectedCategory'] =
                                                          "Select Category";
                                                      dailyearnindetailslist[
                                                                      mainindex]
                                                                  ["data"][index][
                                                              'selectedIsAvailValue'] =
                                                          'No Grievance';
                                                      if (array[index]
                                                                  ["isGrievence"]
                                                              .toString() ==
                                                          "true") {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            String contentText =
                                                                "Content of Dialog";
                                                            return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                                return AlertDialog(
                                                                  insetPadding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  clipBehavior: Clip
                                                                      .antiAliasWithSaveLayer,
                                                                  title: Center(
                                                                    child: Avenirtextmedium(
                                                                        text: subname
                                                                            .toString(),
                                                                        fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                                AppLocalizations.of(context)!.id ==
                                                                                    "ಐಡಿ" ||
                                                                                AppLocalizations.of(context)!.id ==
                                                                                    "आयडी")
                                                                            ? 12
                                                                            : 14,
                                                                        textcolor:
                                                                            HexColor(Colorscommon
                                                                                .greenAppcolor),
                                                                        customfontweight:
                                                                            FontWeight
                                                                                .w500),
                                                                  ),
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    child: Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize
                                                                                .min,
                                                                        children: [
                                                                          Container(
                                                                              margin: const EdgeInsets.only(
                                                                                  top: 20,
                                                                                  right: 10,
                                                                                  left: 10),
                                                                              child: Align(
                                                                                alignment: Alignment.centerRight,
                                                                                child: Avenirtextmedium(
                                                                                  customfontweight: FontWeight.w500,
                                                                                  fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "आयडी") ? 12 : 14,
                                                                                  text: change_date.toString(),
                                                                                  textcolor: HexColor(Colorscommon.greendark),
                                                                                ),
                                                                              )),
                                                                          Container(
                                                                              margin: const EdgeInsets.only(
                                                                                  top: 10,
                                                                                  right: 10,
                                                                                  left: 20),
                                                                              child: Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Avenirtextmedium(
                                                                                  customfontweight: FontWeight.w500,
                                                                                  fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "आयडी") ? 12 : 14,
                                                                                  text: "Category",
                                                                                  textcolor: HexColor(Colorscommon.greendark),
                                                                                ),
                                                                              )),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(left: 0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 2,
                                                                                  child: Container(
                                                                                    height: 40,
                                                                                    margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
                                                                                    padding: const EdgeInsets.all(3.0),
                                                                                    decoration: const ShapeDecoration(
                                                                                      shape: RoundedRectangleBorder(
                                                                                        side: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
                                                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      ),
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    child: Theme(
                                                                                      data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
                                                                                      child: DropdownButtonHideUnderline(
                                                                                        child: DropdownButton<String>(
                                                                                          hint: Row(
                                                                                            children: [
                                                                                              Container(
                                                                                                width: 20,
                                                                                                height: 20,
                                                                                                decoration: const BoxDecoration(
                                                                                                  image: DecorationImage(
                                                                                                    image: AssetImage("assets/Reason.png"),
                                                                                                    fit: BoxFit.fitHeight,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              const SizedBox(width: 5),
                                                                                              const Text("Select Category"),
                                                                                            ],
                                                                                          ),
                                                                                          style: TextStyle(
                                                                                            fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                                                AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                                                                                AppLocalizations.of(context)!.id == "आयडी")
                                                                                                ? 12
                                                                                                : 14,
                                                                                            fontFamily: 'AvenirLTStd-Book',
                                                                                            color: HexColor(Colorscommon.greydark2),
                                                                                          ),
                                                                                          elevation: 0,
                                                                                          value: array[index]["selectedCategory"] != "Select Category"
                                                                                              ? array[index]["selectedCategory"]
                                                                                              : null, // Ensure that the value is correctly set
                                                                                          items: (array[index]["categoryArray"] ?? []).map<DropdownMenuItem<String>>((category) {
                                                                                            return DropdownMenuItem<String>(
                                                                                              value: category['name'],
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  Container(
                                                                                                    width: 20,
                                                                                                    height: 20,
                                                                                                    decoration: const BoxDecoration(
                                                                                                      image: DecorationImage(
                                                                                                        image: AssetImage("assets/Reason.png"),
                                                                                                        fit: BoxFit.fitHeight,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  const SizedBox(width: 5),
                                                                                                  Text(category['name'].toString()),
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          }).toList(),

                                                                                          icon: Icon(
                                                                                            Icons.keyboard_arrow_down,
                                                                                            color: HexColor(Colorscommon.greenlight2),
                                                                                          ),
                                                                                          onChanged: (String? value) {
                                                                                            setState(() {
                                                                                              array[index]["selectedCategory"] = value.toString();
                                                                                            });

                                                                                            for (var category in array[index]["categoryArray"]) {
                                                                                              if (category['name'] == value) {
                                                                                                arrayspilt4 = [];
                                                                                                array4 = [];
                                                                                                sfidarray4 = [];
                                                                                                arrayspilt4 = category['subcategoryData'];

                                                                                                array[index]["selectedCategoryId"] = category['sfid'].toString();

                                                                                                for (var subcategory in arrayspilt4) {
                                                                                                  var subcategoryValue = subcategory['showlangaugename'].toString();
                                                                                                  array4.add(subcategoryValue);
                                                                                                  var sfidValue = subcategory['sfid'].toString();
                                                                                                  sfidarray4.add(sfidValue);
                                                                                                }
                                                                                                break;
                                                                                              }
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                array[index]["selectedCategory"].toString() != "Select Category",
                                                                            child:
                                                                                Visibility(
                                                                              visible:
                                                                                  array[index]["name"].toString().toUpperCase() != "Trip Count".toUpperCase(),
                                                                              child: Container(
                                                                                  margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
                                                                                  child: Align(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Avenirtextmedium(
                                                                                      customfontweight: FontWeight.w500,
                                                                                      fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "आयडी") ? 12 : 14,
                                                                                      text: "SubCategory",
                                                                                      textcolor: HexColor(Colorscommon.greendark),
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                array[index]["selectedCategory"].toString() != "Select Category",
                                                                            child:
                                                                                Visibility(
                                                                              visible:
                                                                                  array[index]["name"].toString().toUpperCase() != "Trip Count".toUpperCase(),
                                                                              child:
                                                                                  Container(
                                                                                margin: const EdgeInsets.only(left: 0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      flex: 2,
                                                                                      child: Container(
                                                                                        height: 40,
                                                                                        margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
                                                                                        padding: const EdgeInsets.all(3.0),
                                                                                        decoration: const ShapeDecoration(
                                                                                          shape: RoundedRectangleBorder(
                                                                                            side: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
                                                                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                          ),
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                        child: Theme(
                                                                                          data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
                                                                                          child: DropdownButtonHideUnderline(
                                                                                            child: DropdownButton(
                                                                                              hint: Row(children: [
                                                                                                Container(
                                                                                                  width: 20,
                                                                                                  height: 20,
                                                                                                  decoration: const BoxDecoration(
                                                                                                    image: DecorationImage(
                                                                                                      image: AssetImage("assets/Reason.png"),
                                                                                                      fit: BoxFit.fitHeight,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                const SizedBox(
                                                                                                  width: 5,
                                                                                                ),
                                                                                                const Text("Select SubCategory")
                                                                                              ]),
                                                                                              style: TextStyle(fontSize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
                                                                                              elevation: 0,
                                                                                              value: array[index]["selectedSubCategory"].toString(),
                                                                                              items: array4.map((items) {
                                                                                                return DropdownMenuItem(
                                                                                                    value: items,
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          width: 20,
                                                                                                          height: 20,
                                                                                                          decoration: const BoxDecoration(
                                                                                                            image: DecorationImage(
                                                                                                              image: AssetImage("assets/Reason.png"),
                                                                                                              fit: BoxFit.fitHeight,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        const SizedBox(
                                                                                                          width: 5,
                                                                                                        ),
                                                                                                        Text(
                                                                                                          items.toString(),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ));
                                                                                              }).toList(),
                                                                                              icon: Icon(
                                                                                                Icons.keyboard_arrow_down,
                                                                                                color: HexColor(Colorscommon.greenlight2),
                                                                                              ),
                                                                                              onChanged: (value) {
                                                                                                // print("dropdownchangevalue$value");
                                                                                                array[index]["selectedSubCategory"] = value.toString();
                                                                                                setState;
                                                                                                setState(() {});
                                                                                                for (var i = 0; array4.length > i; i++) {
                                                                                                  if (value.toString() != "Select SubCategory") {
                                                                                                    if (array4[i].toString() == value.toString()) {
                                                                                                      array[index]["selectedSubCategoryId"] = arrayspilt4[i]["sfid"].toString();

                                                                                                      setState(() {});

                                                                                                      break;
                                                                                                    }
                                                                                                  } else {
                                                                                                    setState(() {});
                                                                                                  }
                                                                                                }
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                array[index]["selectedCategory"].toString() != "Select Category",
                                                                            child:
                                                                                Visibility(
                                                                              visible:
                                                                                  array[index]["selectedSubCategory"].toString() != "Select SubCategory",
                                                                              child:
                                                                                  Visibility(
                                                                                visible: array[index]["selectedSubCategory"].toString() == "Wrong Roster" || array[index]["selectedSubCategory"].toString() == "Wrong Shift Time",
                                                                                child: Container(
                                                                                    margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Avenirtextmedium(
                                                                                        customfontweight: FontWeight.w500,
                                                                                        fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "आयडी") ? 12 : 14,
                                                                                        text: "Select Roster",
                                                                                        textcolor: HexColor(Colorscommon.greendark),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                array[index]["selectedCategory"].toString() != "Select Category",
                                                                            child:
                                                                                Visibility(
                                                                              visible:
                                                                                  array[index]["selectedSubCategory"].toString() != "Select SubCategory",
                                                                              child:
                                                                                  Visibility(
                                                                                visible: array[index]["selectedSubCategory"].toString() == "Wrong Roster" || array[index]["selectedSubCategory"].toString() == "Wrong Shift Time",
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.only(left: 0),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        flex: 2,
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
                                                                                          padding: const EdgeInsets.all(3.0),
                                                                                          decoration: const ShapeDecoration(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              side: BorderSide(color: Colors.white, width: 1.0, style: BorderStyle.solid),
                                                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                            ),
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                          child: Theme(
                                                                                            data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
                                                                                            child: DropdownButtonHideUnderline(
                                                                                              child: DropdownButton(
                                                                                                hint: Row(children: [
                                                                                                  Container(
                                                                                                    width: 20,
                                                                                                    height: 20,
                                                                                                    decoration: const BoxDecoration(
                                                                                                      image: DecorationImage(
                                                                                                        image: AssetImage("assets/Reason.png"),
                                                                                                        fit: BoxFit.fitHeight,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  const SizedBox(
                                                                                                    width: 5,
                                                                                                  ),
                                                                                                  const Text("Select Roster")
                                                                                                ]),
                                                                                                style: TextStyle(fontSize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ") ? 12 : 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
                                                                                                elevation: 0,
                                                                                                value: dropdownvalueone,
                                                                                                items: array1.map((items) {
                                                                                                  return DropdownMenuItem(
                                                                                                      value: items,
                                                                                                      child: Row(
                                                                                                        children: [
                                                                                                          Container(
                                                                                                            width: 20,
                                                                                                            height: 20,
                                                                                                            decoration: const BoxDecoration(
                                                                                                              image: DecorationImage(
                                                                                                                image: AssetImage("assets/Reason.png"),
                                                                                                                fit: BoxFit.fitHeight,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            width: 5,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            items.toString(),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ));
                                                                                                }).toList(),
                                                                                                icon: Icon(
                                                                                                  Icons.keyboard_arrow_down,
                                                                                                  color: HexColor(Colorscommon.greenlight2),
                                                                                                ),
                                                                                                onChanged: (value) {
                                                                                                  array[index]["selectedDropDownValue"] = value.toString();
                                                                                                  dropdownvalueone = value.toString();
                                                                                                  for (var i = 0; array1.length > i; i++) {
                                                                                                    array[index]["selectedDropDownValue"] = value.toString();
                                                                                                    setState(() {});
                                                                                                    // print(array1[i].toString());
                                                                                                    if (array1[i].toString() == value.toString()) {
                                                                                                      var datevalue = sfidarray1[i];
                                                                                                      setState(() {
                                                                                                        array[index]["selectedDropDownId"] = datevalue.toString();
                                                                                                      });
                                                                                                      break;
                                                                                                    }
                                                                                                  }
                                                                                                  setState(() {});
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ),
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
                                                                                array[index]["selectedCategory"].toString() != "Select Category",
                                                                            child:
                                                                                Visibility(
                                                                              visible:
                                                                                  array[index]["selectedSubCategory"].toString() != "Select SubCategory" || array[index]["name"].toString().toUpperCase() == "Trip Count".toUpperCase(),
                                                                              child:
                                                                                  Visibility(
                                                                                visible: array[index]["selectedCategory"].toString() != "Training Present",
                                                                                child: Visibility(
                                                                                  visible: array[index]["name"] != "Late" && array[index]["name"] != "Roster Start Time",
                                                                                  child: Container(
                                                                                      margin: const EdgeInsets.only(top: 10, right: 10, left: 20),
                                                                                      child: Align(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: Avenirtextmedium(
                                                                                          customfontweight: FontWeight.w500,
                                                                                          fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "आयडी") ? 12 : 14,
                                                                                          text: "No of Trip",
                                                                                          textcolor: HexColor(Colorscommon.greendark),
                                                                                        ),
                                                                                      )),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                array[index]["selectedCategory"].toString() != "Select Category",
                                                                            child:
                                                                                Visibility(
                                                                              visible:
                                                                                  array[index]["selectedSubCategory"].toString() != "Select SubCategory" || array[index]["name"].toString().toUpperCase() == "Trip Count".toUpperCase(),
                                                                              child:
                                                                                  Visibility(
                                                                                visible: array[index]["selectedCategory"].toString() != "Training Present",
                                                                                child: Visibility(
                                                                                  visible: array[index]["name"] != "Late" && array[index]["name"] != "Roster Start Time",
                                                                                  child: Container(
                                                                                    margin: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
                                                                                    // margin: const EdgeInsets.all(10.0),
                                                                                    height: 30,
                                                                                    child: Theme(
                                                                                      data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
                                                                                      child: TextField(
                                                                                        controller: _controllers[index],
                                                                                        onChanged: (valuestr) {
                                                                                          // print("valuestr$valuestr");
                                                                                          array[index]["noOftripperformed"] = valuestr;
                                                                                          array[index]["noOftripperformed"] = valuestr;
                                                                                        },
                                                                                        onSubmitted: (valuestr) {
                                                                                          _controllers[index].text = valuestr;
                                                                                          setState(() {});
                                                                                        },
                                                                                        maxLength: 5,
                                                                                        keyboardType: TextInputType.number,
                                                                                        style: TextStyle(fontSize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "आयडी") ? 12 : 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2), fontWeight: FontWeight.w500),
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
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                array[index]["selectedCategory"].toString() != "Select Category",
                                                                            child:
                                                                                Visibility(
                                                                              visible:
                                                                                  array[index]["name"].toString().toUpperCase() == "Trip Count".toUpperCase(),
                                                                              child:
                                                                                  Visibility(
                                                                                visible: array[index]["selectedSubCategory"].toString() != "Select SubCategory",
                                                                                child: Visibility(
                                                                                  visible: array[index]["selectedSubCategory"] != "No Trip Sheet",
                                                                                  child: Visibility(
                                                                                    visible: array[index]["viewLabelName"].toString() == "0",
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          flex: 1,
                                                                                          child: Container(
                                                                                              margin: const EdgeInsets.only(top: 5, right: 10, left: 20),
                                                                                              child: Align(
                                                                                                  alignment: Alignment.centerLeft,
                                                                                                  child: Avenirtextmedium(
                                                                                                    customfontweight: FontWeight.w500,
                                                                                                    fontsize: 15,
                                                                                                    text: 'Upload Attachments',
                                                                                                    textcolor: HexColor(Colorscommon.greendark),
                                                                                                  ))),
                                                                                        ),
                                                                                        Expanded(
                                                                                          flex: 2,
                                                                                          child: Row(
                                                                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                            children: [
                                                                                              Bouncing(
                                                                                                onPress: () {
                                                                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                                                                  _showPicker(context);
                                                                                                  setState;
                                                                                                },
                                                                                                child: Container(
                                                                                                  margin: const EdgeInsets.only(top: 10, right: 0, left: 10),
                                                                                                  child: Align(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    child: Container(
                                                                                                      width: MediaQuery.of(context).size.width / 3,
                                                                                                      height: 40,
                                                                                                      decoration: ShapeDecoration(
                                                                                                        shape: RoundedRectangleBorder(
                                                                                                          side: BorderSide(
                                                                                                            width: 0.0,
                                                                                                            style: BorderStyle.solid,
                                                                                                            color: HexColor(Colorscommon.greenlight2),
                                                                                                          ),
                                                                                                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                                                                                        ),
                                                                                                      ),
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                                        children: [
                                                                                                          const SizedBox(
                                                                                                            width: 10,
                                                                                                          ),
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
                                                                                                          Expanded(
                                                                                                              flex: 1,
                                                                                                              child: Avenirtextmedium(
                                                                                                                customfontweight: FontWeight.w500,
                                                                                                                fontsize: 15,
                                                                                                                text: imgname != '' ? ' File Attached' : ' Upload files',
                                                                                                                textcolor: HexColor(Colorscommon.greydark2),
                                                                                                              )),
                                                                                                        ],
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
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                array[index]["selectedCategory"].toString() != "Select Category",
                                                                            child:
                                                                                Visibility(
                                                                              visible:
                                                                                  array[index]["selectedSubCategory"].toString() != "Select SubCategory" || array[index]["name"].toString().toUpperCase() == "Trip Count".toUpperCase(),
                                                                              child:
                                                                                  Bouncing(
                                                                                onPress: () async {
                                                                                  if (array[index]["name"] == "Trip Count" || array[index]["name"] == "EOS" || array[index]["name"] == "UEOS" || array[index]["name"] == "WEOS") {
                                                                                    // print('Training Present');
                                                                                    if (array[index]["selectedCategory"].toString() == "Training Present") {
                                                                                      // print('Training Present');
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedCategoryId'] = array[index]["selectedCategoryId"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedSubCategoryId'] = array[index]["selectedSubCategoryId"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                      //
                                                                                      Navigator.pop(context);
                                                                                    } else if (_controllers[index].text == "" || _controllers[index].text == "0") {
                                                                                      Fluttertoast.showToast(
                                                                                        msg: AppLocalizations.of(context)!.entervaildtrip,
                                                                                        toastLength: Toast.LENGTH_SHORT,
                                                                                        gravity: ToastGravity.CENTER,
                                                                                      );
                                                                                      // print('validate date in flutter');
                                                                                    } else if (array[index]["name"] == "Trip Count") {
                                                                                      if (array[index]["selectedSubCategory"].toString() != "No Trip Sheet") {
                                                                                        if (array[index]["viewLabelName"].toString() == "0") {
                                                                                          // print("viewLabelName");

                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedCategoryId'] = array[index]["selectedCategoryId"].toString();
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedSubCategoryId'] = array[index]["selectedSubCategoryId"].toString();
                                                                                          // dailyearnindetailslist[mainindex]["data"][index]['noOftripperformed'] = _controllers[index].text.toString();
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownId'] = _controllers[index].text.toString();
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownValue'] = array[index]["selectedDropDownValue"].toString();
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                          //
                                                                                          Navigator.pop(context);
                                                                                        } else {
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedCategoryId'] = array[index]["selectedCategoryId"].toString();
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedSubCategoryId'] = array[index]["selectedSubCategoryId"].toString();
                                                                                          // dailyearnindetailslist[mainindex]["data"][index]['noOftripperformed'] = _controllers[index].text.toString();
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownId'] = _controllers[index].text.toString();
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownValue'] = array[index]["selectedDropDownValue"].toString();
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                          dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                          //
                                                                                          Navigator.pop(context);
                                                                                        }
                                                                                      } else {
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedCategoryId'] = array[index]["selectedCategoryId"].toString();
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedSubCategoryId'] = array[index]["selectedSubCategoryId"].toString();

                                                                                        dailyearnindetailslist[mainindex]["data"][index]['noOftripperformed'] = _controllers[index].text.toString();
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownId'] = array[index]["selectedDropDownId"].toString();
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownValue'] = array[index]["selectedDropDownValue"].toString();
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';

                                                                                        Navigator.pop(context);
                                                                                      }
                                                                                    } else {
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedCategoryId'] = array[index]["selectedCategoryId"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedSubCategoryId'] = array[index]["selectedSubCategoryId"].toString();

                                                                                      // dailyearnindetailslist[mainindex]["data"][index]['noOftripperformed'] = _controllers[index].text.toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownId'] = _controllers[index].text.toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownValue'] = array[index]["selectedDropDownValue"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';

                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  } else if (array[index]["name"] == "Late" || array[index]["name"] == "Roster Start Time") {
                                                                                    if (array[index]["selectedSubCategory"].toString() == "Adhoc Duty") {
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedCategoryId'] = array[index]["selectedCategoryId"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedSubCategoryId'] = array[index]["selectedSubCategoryId"].toString();

                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownId'] = array[index]["selectedDropDownId"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownValue'] = array[index]["selectedDropDownValue"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';

                                                                                      Navigator.pop(context);
                                                                                    } else if (array[index]["selectedSubCategory"] == "Wrong Roster") {
                                                                                      // print(""Wrong Roster =" + array[index]["selectedDropDownValue"]);
                                                                                      if (array[index]["selectedDropDownValue"] == "Select Roster" || array[index]["selectedDropDownValue"] == "") {
                                                                                        Fluttertoast.showToast(
                                                                                          msg: AppLocalizations.of(context)!.pleaseslectroster,
                                                                                          toastLength: Toast.LENGTH_SHORT,
                                                                                          gravity: ToastGravity.CENTER,
                                                                                        );
                                                                                      } else {
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedCategoryId'] = array[index]["selectedCategoryId"].toString();
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedSubCategoryId'] = array[index]["selectedSubCategoryId"].toString();

                                                                                        dailyearnindetailslist[mainindex]["data"][index]['noOftripperformed'] = _controllers[index].text.toString();
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownId'] = array[index]["selectedDropDownId"].toString();
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownValue'] = array[index]["selectedDropDownValue"].toString();
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                        dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';

                                                                                        Navigator.pop(context);
                                                                                      }
                                                                                    } else {
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedCategoryId'] = array[index]["selectedCategoryId"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedSubCategoryId'] = array[index]["selectedSubCategoryId"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownId'] = array[index]["selectedDropDownId"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedDropDownValue'] = array[index]["selectedDropDownValue"].toString();
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';
                                                                                      dailyearnindetailslist[mainindex]["data"][index]['selectedIsAvailValue'] = 'Grievance';

                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                                                                                  height: 40,
                                                                                  decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                      gradient: LinearGradient(colors: [
                                                                                        HexColor(Colorscommon.greencolor),
                                                                                        HexColor(Colorscommon.greencolor),
                                                                                      ])),
                                                                                  child: Center(
                                                                                    child: Avenirtextblack(
                                                                                      customfontweight: FontWeight.normal,
                                                                                      fontsize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "आयडी") ? 12 : 14,
                                                                                      text: AppLocalizations.of(context)!.submit,
                                                                                      textcolor: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height:
                                                                                  10)
                                                                        ]),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Avenirtextmedium(
                                                          text:
                                                              subname.toString(),
                                                          fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                  AppLocalizations.of(
                                                                              context)!
                                                                          .id ==
                                                                      "ಐಡಿ" ||
                                                                  AppLocalizations.of(
                                                                              context)!
                                                                          .id ==
                                                                      "आयडी")
                                                              ? 12
                                                              : 14,
                                                          textcolor: HexColor(
                                                              Colorscommon
                                                                  .greenAppcolor),
                                                          customfontweight:
                                                              FontWeight.w500),

                                                      const Expanded(
                                                          child:
                                                              Text("         ")),
                                                      Visibility(
                                                        visible: subname != "Trip Count",
                                                        child: Container(
                                                          height: 30,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                            // shape: BoxShape.circle,
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                              )
                                                            ],
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            5.0),
                                                                    bottomRight: Radius
                                                                        .circular(
                                                                            5.0),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            5.0),
                                                                    bottomLeft: Radius
                                                                        .circular(
                                                                            5.0)),
                                                          ),
                                                          child: Center(
                                                            //  style: TextStyle(fontSize: 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
                                                            child: Avenirtextbook(
                                                              customfontweight:
                                                                  FontWeight.w500,
                                                              fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                      AppLocalizations.of(
                                                                                  context)!
                                                                              .id ==
                                                                          "ಐಡಿ" ||
                                                                      AppLocalizations.of(
                                                                                  context)!
                                                                              .id ==
                                                                          "आयडी")
                                                                  ? 12
                                                                  : 14,
                                                              text: array[index][
                                                                      "viewLabelName"]
                                                                  .toString(),
                                                              textcolor: HexColor(
                                                                  Colorscommon
                                                                      .greydark2),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: subname == "Trip Count",
                                                        child: change_dateid != 1 ? Container(
                                                          height: 30,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                            // shape: BoxShape.circle,
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                    0.5),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset:
                                                                const Offset(
                                                                    0, 1),
                                                              )
                                                            ],
                                                            borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                    5.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                    5.0)),
                                                          ),
                                                          child: Center(
                                                            //  style: TextStyle(fontSize: 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
                                                            child: Avenirtextbook(
                                                              customfontweight:
                                                              FontWeight.w500,
                                                              fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                  AppLocalizations.of(
                                                                      context)!
                                                                      .id ==
                                                                      "ಐಡಿ" ||
                                                                  AppLocalizations.of(
                                                                      context)!
                                                                      .id ==
                                                                      "आयडी")
                                                                  ? 12
                                                                  : 14,
                                                              text: array[index][
                                                              "viewLabelName"]
                                                                  .toString(),
                                                              textcolor: HexColor(
                                                                  Colorscommon
                                                                      .greydark2),
                                                            ),
                                                          ),
                                                        ) :
                                                        array[index]["viewLabelName"].toString() == "0" ?
                                                        Container(
                                                          height: 30,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                            // shape: BoxShape.circle,
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                    0.5),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset:
                                                                const Offset(
                                                                    0, 1),
                                                              )
                                                            ],
                                                            borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                    5.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                    5.0)),
                                                          ),
                                                          child: Center(
                                                            //  style: TextStyle(fontSize: 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
                                                            child: Avenirtextbook(
                                                              customfontweight:
                                                              FontWeight.w500,
                                                              fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                  AppLocalizations.of(
                                                                      context)!
                                                                      .id ==
                                                                      "ಐಡಿ" ||
                                                                  AppLocalizations.of(
                                                                      context)!
                                                                      .id ==
                                                                      "आयडी")
                                                                  ? 12
                                                                  : 14,
                                                              text: "Yet to be updated",
                                                              textcolor: HexColor(
                                                                  Colorscommon
                                                                      .greydark2),
                                                            ),
                                                          ),
                                                        ) :
                                                        Container(
                                                          height: 30,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                            // shape: BoxShape.circle,
                                                            color: Colors.white,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                    0.5),
                                                                spreadRadius: 1,
                                                                blurRadius: 1,
                                                                offset:
                                                                const Offset(
                                                                    0, 1),
                                                              )
                                                            ],
                                                            borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                    5.0),
                                                                topLeft: Radius
                                                                    .circular(
                                                                    5.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                    5.0)),
                                                          ),
                                                          child: Center(
                                                            //  style: TextStyle(fontSize: 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
                                                            child: Avenirtextbook(
                                                              customfontweight:
                                                              FontWeight.w500,
                                                              fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                  AppLocalizations.of(
                                                                      context)!
                                                                      .id ==
                                                                      "ಐಡಿ" ||
                                                                  AppLocalizations.of(
                                                                      context)!
                                                                      .id ==
                                                                      "आयडी")
                                                                  ? 12
                                                                  : 14,
                                                              text: array[index][
                                                              "viewLabelName"]
                                                                  .toString(),
                                                              textcolor: HexColor(
                                                                  Colorscommon
                                                                      .greydark2),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Text("         "),
                                                      Visibility(
                                                        visible: !showbtnbool,
                                                        child: Visibility(
                                                          visible: array[index][
                                                                      "isGrievence"]
                                                                  .toString() ==
                                                              "true",
                                                          child: Icon(
                                                            Icons.warning,
                                                            color: HexColor(
                                                                Colorscommon
                                                                    .greydark2),
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: !showbtnbool,
                                                        child: Visibility(
                                                          visible: array[index][
                                                                      "isGrievence"]
                                                                  .toString() ==
                                                              "false",
                                                          child: const SizedBox(
                                                            width: 15,
                                                          ),
                                                        ),
                                                      ),
                                                      //
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: dailyearnindetailslist[
                                                              mainindex]['name']
                                                          .toString() !=
                                                      "Check In/Out Details" &&
                                                  dailyearnindetailslist[
                                                              mainindex]['name']
                                                          .toString() !=
                                                      "Late & Leave Details " &&
                                                  dailyearnindetailslist[
                                                              mainindex]['name']
                                                          .toString() !=
                                                      "Trip/Bench",
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: ExpansionTile(
                                                      title: Row(
                                                        children: [
                                                          Avenirtextmedium(
                                                              text: subname
                                                                  .toString(),
                                                              fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                      AppLocalizations.of(context)!
                                                                              .id ==
                                                                          "ಐಡಿ" ||
                                                                      AppLocalizations.of(context)!
                                                                              .id ==
                                                                          "आयडी")
                                                                  ? 12
                                                                  : 14,
                                                              textcolor: HexColor(
                                                                  Colorscommon
                                                                      .greenAppcolor),
                                                              customfontweight:
                                                                  FontWeight
                                                                      .w500),
                                                          const Expanded(
                                                              child: Text(
                                                                  "         ")),
                                                          Text(
                                                            array[index][
                                                                    "viewLabelName"]
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                                                        AppLocalizations.of(context)!
                                                                                .id ==
                                                                            "ಐಡಿ" ||
                                                                        AppLocalizations.of(context)!
                                                                                .id ==
                                                                            "आयडी")
                                                                    ? 12
                                                                    : 14,
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
                                                                                const Text("None"),
                                                                            elevation:
                                                                                0,
                                                                            value:
                                                                                dropdownvaluetwo,
                                                                            items:
                                                                                array2.map((items) {
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
                                                                              array[index]["selectedIsAvailValue"] =
                                                                                  value.toString();

                                                                              setState(() {
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
                                                                              hint:
                                                                                  const Text("Select Category"),
                                                                              elevation:
                                                                                  0,
                                                                              // value:
                                                                              //     dropdownvaluethree,
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
                                                                                color: HexColor(Colorscommon.greencolor),
                                                                              ),
                                                                              onChanged:
                                                                                  (value) {
                                                                                array[index]["selectedCategory"] = value.toString();
                                                                                setState(() {});

                                                                                for (var i = 0; array3.length > i; i++) {
                                                                                  // print(array3[i].toString());
                                                                                  // print(value.toString());
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
                                                                          margin:
                                                                              const EdgeInsets.all(10.0),
                                                                          padding:
                                                                              const EdgeInsets.all(3.0),
                                                                          decoration:
                                                                              const ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side:
                                                                                  BorderSide(width: 1.0, style: BorderStyle.solid),
                                                                              borderRadius:
                                                                                  BorderRadius.all(Radius.circular(5.0)),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Theme(
                                                                            data:
                                                                                Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
                                                                            child:
                                                                                DropdownButtonHideUnderline(
                                                                              child:
                                                                                  DropdownButton(
                                                                                hint: const Text("Select SubCategory"),
                                                                                elevation: 0,
                                                                                value: dropdownvaluefour,
                                                                                items: array4.map((items) {
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
                                                                                  for (var i = 0; array4.length > i; i++) {
                                                                                    array[index]["selectedSubCategory"] = value.toString();
                                                                                    if (array4[i].toString() == value.toString()) {
                                                                                      var datevalue = sfidarray4[i];
                                                                                      // print("datevalue$datevalue");
                                                                                      setState(() {
                                                                                        array[index]["selectedSubCategoryId"] = datevalue.toString();
                                                                                      });
                                                                                      break;
                                                                                    }
                                                                                  }
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
                                                                          visible:
                                                                              array[index]["selectedSubCategory"].toString().toLowerCase() !=
                                                                                  "adhoc duty",
                                                                          child:
                                                                              Expanded(
                                                                            flex:
                                                                                2,
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
                                                                                shape: RoundedRectangleBorder(
                                                                                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                ),
                                                                              ),
                                                                              // child:
                                                                              //     Theme(
                                                                              //   data: Theme.of(context).copyWith(canvasColor: Colors.grey.shade100),
                                                                              //   child: DropdownButtonHideUnderline(
                                                                              //     child: DropdownButton(
                                                                              //       hint: const Text("Select Reason"),
                                                                              //       elevation: 0,
                                                                              //       value: dropdownvalueone,
                                                                              //       items: array1.map((items) {
                                                                              //         return DropdownMenuItem(
                                                                              //             value: items,
                                                                              //             child: Text(
                                                                              //               " " + items.toString(),
                                                                              //             ));
                                                                              //       }).toList(),
                                                                              //       icon: Icon(
                                                                              //         Icons.keyboard_arrow_down,
                                                                              //         color: HexColor(Colorscommon.greencolor),
                                                                              //       ),
                                                                              //       onChanged: (value) {
                                                                              //         var sampledata = array[index]["selectedDropDownValue"];
                                                                              //         // print("sampledata$sampledata");
                                                                              //         array[index]["selectedDropDownValue"] = value;
                                                                              //         for (int i = 0; i < array1.length; i++) {
                                                                              //           if (array1[i].toString() == value) {
                                                                              //             String setvalue = sfidarray1[i].toString();
                                                                              //             print("setvalue11234=$setvalue");
                                                                              //             array[index]["selectedDropDownId"] = setvalue;
                                                                              //           }
                                                                              //         }
                                                                              //         setState(() {});
                                                                              //       },
                                                                              //     ),
                                                                              //   ),
                                                                              // ),
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
                                                                                controller: _controllers[index],
                                                                                onChanged: (valuestr) {
                                                                                  array[index]["selectedDropDownId"] = valuestr;
                                                                                },
                                                                                onSubmitted: (valuestr) {
                                                                                  _controllers[index].text = valuestr;
                                                                                  setState(() {});
                                                                                },
                                                                                maxLength: 5,
                                                                                keyboardType: TextInputType.number,
                                                                                style: TextStyle(fontSize: (AppLocalizations.of(context)!.id == "ஐடி" || AppLocalizations.of(context)!.id == "ಐಡಿ" || AppLocalizations.of(context)!.id == "आयडी") ? 12 : 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2), fontWeight: FontWeight.w500),
                                                                                decoration: const InputDecoration(
                                                                                    //  style: TextStyle(fontSize: 14, fontFamily: 'AvenirLTStd-Book', color: HexColor(Colorscommon.greydark2)),
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
                                                                      child: Expanded(
                                                                          flex: 1,
                                                                          child: Bouncing(
                                                                            onPress:
                                                                                () {
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                              Future<String>
                                                                                  fromdatee =
                                                                                  utility.selectTimeto(context);

                                                                              fromdatee.then((value) {
                                                                                setState(() {
                                                                                  if (value != "null") {
                                                                                    var starttime = value.substring(0, value.indexOf('.'));
                                                                                    var pos = value.lastIndexOf('.');
                                                                                    var starttimesend = value.substring(pos + 1);
                                                                                    print("starttimesend = $starttimesend");
                                                                                    // print("starttimesend$starttimesend");
                                                                                    // print("starttime$starttime");
                                                                                    array[index]["selectedDropDownId"] = starttimesend;
                                                                                  }
                                                                                });
                                                                              });
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin:
                                                                                  const EdgeInsets.all(10.0),
                                                                              height:
                                                                                  30,
                                                                              decoration:
                                                                                  const ShapeDecoration(
                                                                                shape: RoundedRectangleBorder(
                                                                                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                                                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                ),
                                                                              ),
                                                                              child:
                                                                                  Row(
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
                                                              visible: array[index]
                                                                          [
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
                                                                          right:
                                                                              10,
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment
                                                                                .centerLeft,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width /
                                                                                  3,
                                                                          height:
                                                                              40,
                                                                          decoration:
                                                                              const ShapeDecoration(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              side:
                                                                                  BorderSide(width: 1.0, style: BorderStyle.solid),
                                                                              borderRadius:
                                                                                  BorderRadius.all(Radius.circular(5.0)),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.upload_file,
                                                                                color: HexColor(Colorscommon.greencolor),
                                                                              ),
                                                                              Flexible(
                                                                                flex: 1,
                                                                                child: Text(
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
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              6.0),
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
                                                                                flex: 1,
                                                                                child: Text(
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
                                                                                Expanded(flex: 1, child: Text(debitdetailarray[index]['name'].toString())),
                                                                                Expanded(flex: 1, child: Text(debitdetailarray[index]['voucher_type'].toString())),
                                                                                Expanded(
                                                                                    flex: 1,
                                                                                    child: Text(
                                                                                      (debitdetailarray[index]['amount'].toString()),
                                                                                      textAlign: TextAlign.right,
                                                                                    )),
                                                                              ]),
                                                                            );
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
              ),
              Visibility(
                visible: !isloading,
                child: Visibility(
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
                            child: Avenirtextblack(
                              customfontweight: FontWeight.normal,
                              fontsize: (AppLocalizations.of(context)!.id ==
                                          "ஐடி" ||
                                      AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                      AppLocalizations.of(context)!.id == "आयडी")
                                  ? 12
                                  : 14,
                              text: AppLocalizations.of(context)!.submit,
                              textcolor: Colors.white,
                            ),
                            onPressed: () async {
                              bool closestatus = true;
                              bool noGrivence = true;
                              sessionManager
                                  .internetcheck()
                                  .then((intenet) async {
                                if (intenet) {
                                  for (int i = 0;
                                      i < dailyearnindetailslist.length;
                                      i++) {
                                    if (!closestatus) {
                                      break;
                                    }
                                    for (int i2 = 0;
                                        i2 <
                                            dailyearnindetailslist[i]["data"]
                                                .length;
                                        i2++) {
                                      if (dailyearnindetailslist[i]["data"][i2]
                                                  ["selectedIsAvailValue"]
                                              .toString() ==
                                          "Grievance") {
                                        noGrivence = false;
                                        closestatus = true;
                                      } else {
                                        print("last index for delay");
                                        if (i ==
                                            dailyearnindetailslist.length - 1) {
                                          if (closestatus) {
                                            if (noGrivence) {
                                              Raisenogriveance_func();
                                            } else {
                                              DailyearningSubmit();
                                            }
                                          }
                                          break;
                                        }
                                      }
                                    }
                                  }
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
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isloading,
                child: Center(
                  child: CircularProgressIndicator(
                    color: HexColor(Colorscommon.greencolor),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }


  Future<void> dailyEarningAddnogrievance() async {
    loading();

    // Parse the URL as a Uri object
    var url = Uri.parse(CommonURL.localone);

    final Map<String, dynamic> payload = {
      "from": "dailyEarningAddnogrievance",
      "lithiumID": utility.lithiumid,
      "service_provider_c": utility.service_provider_c,
      "date": change_date,
      "submit": "false",
    };

    try {
      final response = await http.post(
        url, // Pass the Uri object directly
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context, rootNavigator: true).pop();
        final responseData = jsonDecode(response.body);
        print("Success: ${responseData['message']}");
        String message = responseData['message'].toString();
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        print("HTTP Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      print("An error occurred: $e");
    }
  }

  // Future<void> dailyEarningAddnogrievance() async {
  //   // Define the URL and payload
  //   const String url = "http://10.10.14.14:8092/webservice";
  //   final Map<String, dynamic> payload = {
  //     "from": "dailyEarningAddnogrievance",
  //     "lithiumID": "LITHBNG4784",
  //     "service_provider_c": "a14HE0000036F5t",
  //     "date": "2024-11-28",
  //     "submit": "false"
  //   };
  //
  //   try {
  //     // Send POST request
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json', // Define the content type
  //       },
  //       body: jsonEncode(payload),
  //     );
  //
  //     // Handle the response
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //
  //       if (responseData['status'] == true) {
  //         print("Success!");
  //         print("Sfdcid: ${responseData['sfdcid']}");
  //         print("Message: ${responseData['message']}");
  //       } else {
  //         print("Failed: ${responseData['message']}");
  //       }
  //     } else {
  //       print("HTTP Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("An error occurred: $e");
  //   }
  // }



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
                      fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                              AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                              AppLocalizations.of(context)!.id == "आयडी")
                          ? 14
                          : 17,
                      fontFamily: "AvenirLTStd-Black",
                      fontWeight: FontWeight.w500,
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
                    fontFamily: 'AvenirLTStd-Book',
                    fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                            AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                            AppLocalizations.of(context)!.id == "आयडी")
                        ? 13
                        : 15,
                    color: HexColor(Colorscommon.greydark2),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Bouncing(
                onPress: () async {
                  await dailyEarningAddnogrievance();
                  // Fluttertoast.showToast(
                  //             msg: "Data added successfully",
                  //             toastLength: Toast.LENGTH_SHORT,
                  //             gravity: ToastGravity.CENTER,
                  //           );
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => const Dashboard2()));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyTabPage(
                                          title: '',
                                          selectedtab: 0,
                                        )));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(colors: [
                        HexColor(Colorscommon.greencolor),
                        HexColor(Colorscommon.greencolor),
                      ])),
                  child: Center(
                    child: Avenirtextblack(
                        text: AppLocalizations.of(context)!.yes,
                        fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                AppLocalizations.of(context)!.id == "आयडी")
                            ? 12
                            : 13,
                        textcolor: Colors.white,
                        customfontweight: FontWeight.w500),
                  ),
                ),
              ),
              Bouncing(
                onPress: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 20, left: 0, right: 0),
                  height: 30,
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
                    child: Avenirtextblack(
                        text: AppLocalizations.of(context)!.no,
                        fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                                AppLocalizations.of(context)!.id == "ಐಡಿ" ||
                                AppLocalizations.of(context)!.id == "आयडी")
                            ? 12
                            : 13,
                        textcolor: HexColor(Colorscommon.greencolor),
                        customfontweight: FontWeight.w500),
                  ),
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
