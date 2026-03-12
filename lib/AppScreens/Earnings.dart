import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Bouncing.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/SessionManager.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

SessionManager sessionManager = SessionManager();
StreamController<String> streamController =
    StreamController<String>.broadcast();

class Earnings extends StatefulWidget {
  const Earnings({Key? key}) : super(key: key);

  @override
  State<Earnings> createState() => _EarningsState(streamController.stream);
}

class _EarningsState extends State<Earnings> {
  bool showmonth = false;
  bool showpaycycle = false;
  bool raisestaus = true;
  bool noraisestaus = true;

  late File _image;
  // ignore: prefer_final_fields
  ImagePicker _picker = ImagePicker();
  XFile? pickedFile;
  late StreamSubscription streamSubscription;
  _EarningsState(this.stream);
  List<dynamic> raisegrievancesendarray = [];
  Utility utility = Utility();
  late final Stream<String> stream;
  String spusername = "";
  String lithiumid = "";
  // String change_date = '';
  String? change_date;
  String? change_fromdate;
  String? change_todate;
  List<String> changetypelist = [];
  List<dynamic> changetyperesult = [];
  int selectID = 0;
  int dropdownid = 0;
  late String selectedid;
  List<EarningsData> Listdata = [];
  bool selectcontent = false;
  List<dynamic> selectedlist = [];
  List<dynamic> componetiddatearray = [];
  TextEditingController commentcontroller = TextEditingController();

  @override
  void initState() {
    streamSubscription = stream.listen((index) {
      reload(index);
    });
    setState(() {
      utility.GetUserdata().then((_) => {
            spusername = utility.sp_username.toString(),
            lithiumid = utility.lithiumid.toString(),
            dropdowndates(context)
          });
    });
    super.initState();
  }

  void reload(String reloadcheck) {
    setState(() {
      utility.GetUserdata().then((value) => {weekearndetails(context)});
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
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
/*
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageGallery(context,ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
*/
                ],
              ),
            ),
          );
        });
  }

  Future getImageGallery(BuildContext context, var type) async {
    pickedFile = await _picker.pickImage(source: type, imageQuality: 50);
    if (pickedFile == null) return;
    final bytesdata = await pickedFile?.readAsBytes();
    final bytes = bytesdata?.buffer.lengthInBytes;

    setState(() {
      if (pickedFile != null) {
        if (bytes! <= 512000) {
          setState(() {
            _image = File(pickedFile!.path);
            //boolimage = true;
            //uploadimage(context, editid);
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

  dropdowndates(BuildContext context) async {
    String url = CommonURL.URL;

    Map<String, String> postdata = {
      "from": 'getRoasterWeeksDetails',
      "idUser": "8",
      "idRoaster": '1',
      // "token": utility.accessTokken,
      // "refresh": utility.refreshTokken,
    };
    Map<String, String> headers = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      /*if(jsonInput.containsKey('accessToken')){
        var accessToken=jsonInput['accessToken'];
        sessionManager.SetAccessTokken(accessToken);
      }
      if(jsonInput.containsKey('refreshToken')){
        var refreshToken=jsonInput['refreshToken'];
        sessionManager.SetRefreshTokken(refreshToken);
      }*/
      print('dropdown = $jsonInput');

      List loantypelist = jsonInput['data'];
      int id = jsonInput['id'];

      if (loantypelist.isNotEmpty) {
        changetyperesult = loantypelist;
        changetypelist = [];
        for (int i = 0; i < changetyperesult.length; i++) {
          // if (i == 0) {
          //   change_date = (changetyperesult[i]['fromDate'] +
          //       ' to ' +
          //       changetyperesult[i]['toDate']);
          // }
          change_fromdate = changetyperesult[i]['fromDate'];
          change_todate = changetyperesult[i]['toDate'];
          // change_date = (changetyperesult[i]['fromDate'] +
          //     ' to ' +
          //     changetyperesult[i]['toDate']);

          changetypelist.add(change_fromdate! + ' to ' + change_todate!);

          if (dropdownid == changetyperesult[i]['id']) {
            setState(() {
              setState(() {
                change_fromdate = changetyperesult[i]['fromDate'];
                change_todate = changetyperesult[i]['toDate'];
                selectID = changetyperesult[i]['id'];
                change_date = (changetyperesult[i]['fromDate'] +
                    ' to ' +
                    changetyperesult[i]['toDate']);
              });
            });
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Dropdown value is empty', gravity: ToastGravity.BOTTOM);
      }
    }
    setState(() {});
  }

  weekearndetails(BuildContext context) async {
    String url = CommonURL.URL;

    Map<String, String> postdata = {
      "from": 'weeklyEarningDetails',
      "idUser": '8',
      "idRoaster": '1',
      // "token": utility.accessTokken,
      // "refresh": utility.refreshTokken,
    };
    Map<String, String> headers = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('weekearndetails = ${response.body}');

      Map<String, dynamic> jsonvalue = jsonDecode(response.body);
      raisestaus = jsonvalue['isAlreadyRaiseGrievance'] as bool;
      noraisestaus = jsonvalue['isNoGrievance'] as bool;
      var array = jsonvalue['needToRaiseGrievanceData'] as List;
      print("raisestaus$raisestaus");
      print("noraisestaus$noraisestaus");
      Listdata = [];
      raisegrievancesendarray = [];
      if (array.isNotEmpty) {
        raisegrievancesendarray = array;
        print("raisegrievancesendarray$raisegrievancesendarray");
      }

      for (int i = 0; i < jsonvalue['data'].length; i++) {
        Listdata.add(EarningsData(
            earnComponentId:
                jsonvalue['data'][i]['earn_componentId'].toString(),
            earnComponentName:
                jsonvalue['data'][i]['earn_componentName'].toString(),
            data: jsonvalue['data'][i]['data'].toString(),
            noDays: jsonvalue['data'][i]['noDays'].toString(),
            arrayData: jsonvalue['data'][i]['arrayData'] as List,
            columns: jsonvalue['data'][i]['columns'],
            select: false,
            status: jsonvalue['data'][i]['status'].toString(),
            statusData: jsonvalue['data'][i]['statusData'] as List));
      }
      setState(() {});
    }
    /*if(jsonInput.containsKey('accessToken')){
        var accessToken=jsonInput['accessToken'];
        sessionManager.SetAccessTokken(accessToken);
      }
      if(jsonInput.containsKey('refreshToken')){
        var refreshToken=jsonInput['refreshToken'];
        sessionManager.SetRefreshTokken(refreshToken);
      }*/
  }

  /// add grivance all
  ///
  ///
  ///
  ///no
  nogrievance(BuildContext context) async {
    String url = CommonURL.URL;
    loading();
    Map<String, String> postdata = {
      "from": 'noGrievanceAdd',
      "idUser": utility.userid,
      "idRoaster": '1',

      // "token": utility.accessTokken,
      // "refresh": utility.refreshTokken,
    };
    Map<String, String> headers = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      //utility.closeLoader(context);
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("$jsonInput");
      var status = jsonInput["status"] as bool;
      String message = jsonInput["message"].toString();
      if (status) {
        Fluttertoast.showToast(
            msg: message,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.green.shade100);
      } else {
        Fluttertoast.showToast(msg: message, gravity: ToastGravity.BOTTOM);
      }
    } else if (response.statusCode == 500) {
      //utility.closeLoader(context);
      Fluttertoast.showToast(
          msg: 'Something Went Wrong. Please Try Again..',
          gravity: ToastGravity.BOTTOM);
      print('status_code = ${response.statusCode}');
    } else {
      //utility.closeLoader(context);
      Fluttertoast.showToast(msg: response.body, gravity: ToastGravity.BOTTOM);
      print('status_code = ${response.body}');
    }
    Navigator.pop(context);
    streamController.add("event");
  }

  addsaveedgrivance(BuildContext context) async {
    String url = CommonURL.URL;
    // print("raisegrievancesendarray$raisegrievancesendarray");
    loading();
    String senddata = jsonEncode(raisegrievancesendarray);
    Map<String, String> postdata = {
      "from": 'raiseGrievance',
      "idUser": utility.userid,
      "idRoaster": '1',
      "data": senddata,
      // "token": utility.accessTokken,
      // "refresh": utility.refreshTokken,
    };
    Map<String, String> headers = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };
    print("postdata$postdata");
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      //utility.closeLoader(context);
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("$jsonInput");
      var status = jsonInput["status"] as bool;
      String message = jsonInput["message"].toString();
      if (status) {
        Fluttertoast.showToast(
            msg: message,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.green.shade100);
      } else {
        Fluttertoast.showToast(msg: message, gravity: ToastGravity.BOTTOM);
      }
    } else if (response.statusCode == 500) {
      //utility.closeLoader(context);
      Fluttertoast.showToast(
          msg: 'Something Went Wrong. Please Try Again..',
          gravity: ToastGravity.BOTTOM);
      print('status_code = ${response.statusCode}');
    } else {
      //utility.closeLoader(context);
      Fluttertoast.showToast(msg: response.body, gravity: ToastGravity.BOTTOM);
      print('status_code = ${response.body}');
    }
    Navigator.pop(context);
    streamController.add("event");
  }

  ///
  // add grievance
  // addgrievance(BuildContext context) async {
  //   String url = CommonURL.URL;

  //   Map<String, String> postdata = {
  //     "from": 'grievanceAdd',
  //     "idUser": utility.userid.toString(),
  //     "idRoaster": '1',
  //     ""
  //     // "token": utility.accessTokken,
  //     // "refresh": utility.refreshTokken,
  //   };
  //   Map<String, String> headers = {
  //     'Content-type': 'application/hal+json',
  //     'Accept': 'application/json',
  //   };

  //   final response = await http.post(Uri.parse(url),
  //       body: jsonEncode(postdata), headers: headers);

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     print('weekearndetails = ${response.body}');

  //     Map<String, dynamic> jsonvalue = jsonDecode(response.body);
  //     Listdata = [];
  //     for (int i = 0; i < jsonvalue['data'].length; i++) {
  //       Listdata.add(EarningsData(
  //           earnComponentId:
  //               jsonvalue['data'][i]['earn_componentId'].toString(),
  //           earnComponentName:
  //               jsonvalue['data'][i]['earn_componentName'].toString(),
  //           data: jsonvalue['data'][i]['data'].toString(),
  //           noDays: jsonvalue['data'][i]['noDays'].toString(),
  //           arrayData: jsonvalue['data'][i]['arrayData'] as List,
  //           columns: jsonvalue['data'][i]['columns'],
  //           select: false));
  //     }
  //     setState(() {});
  //   }
  //   /*if(jsonInput.containsKey('accessToken')){
  //       var accessToken=jsonInput['accessToken'];
  //       sessionManager.SetAccessTokken(accessToken);
  //     }
  //     if(jsonInput.containsKey('refreshToken')){
  //       var refreshToken=jsonInput['refreshToken'];
  //       sessionManager.SetRefreshTokken(refreshToken);
  //     }*/
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
                  // color: Colors.purple.shade800,
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

  /// add grievance
  void uploadimage(BuildContext context, String date) async {
    // utility.showYourPopUp(context);
    loading();
    String url = CommonURL.URL;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields['from'] = "grievanceAdd";
    request.fields['idUser'] = utility.userid;
    request.fields['grievanceDate'] = date;
    request.fields['grievanceComment'] = commentcontroller.text;
    print(_image.path);
    request.files
        .add(await http.MultipartFile.fromPath('grievanceFile', _image.path));

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    print('upload img status = ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      //utility.closeLoader(context);
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("$jsonInput");
      var status = jsonInput["status"] as bool;
      String message = jsonInput["message"].toString();
      if (status) {
        Fluttertoast.showToast(
            msg: message,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.green.shade100);
      } else {
        Fluttertoast.showToast(msg: message, gravity: ToastGravity.BOTTOM);
      }
    } else if (response.statusCode == 500) {
      //utility.closeLoader(context);
      Fluttertoast.showToast(
          msg: 'Something Went Wrong. Please Try Again..',
          gravity: ToastGravity.BOTTOM);
      print('status_code = ${response.statusCode}');
    } else {
      //utility.closeLoader(context);
      Fluttertoast.showToast(msg: response.body, gravity: ToastGravity.BOTTOM);
      print('status_code = ${response.body}');
    }
    Navigator.pop(context);
    Navigator.pop(context);
    streamController.add("event");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text("Earnings"),
      //   backgroundColor: HexColor("#520283"),
      // ),
      appBar: CommonAppbar(
        title: 'Earnings',
        appBar: AppBar(),
        widgets: const [],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width - 15,
                  margin: const EdgeInsets.only(top: 8, right: 10, left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Week",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor(Colorscommon.greencolor)),
                    ),
                  )),
              Container(
                width: MediaQuery.of(context).size.width - 15,
                height: 40,
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
                      hint: const Text("-- Select Week -- "),
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
                        print('select date = $value');
                        change_date = value.toString();
                        showmonth = true;
                        weekearndetails(context);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showmonth,
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Saved Grievance"),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              color: Colors.orange.shade100,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Raised Grievance"),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              color: Colors.green.shade100,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: showmonth,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(.8),
                            width: 1,
                          ),
                        ),
                        elevation: 3,
                        // In many cases, the key isn't mandatory
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: Listdata.length,
                            itemBuilder: (context, index) {
                              Color containercolor;
                              if (Listdata[index].status.toString() == "1") {
                                containercolor = Colors.orange.shade100;
                              } else if (Listdata[index].status.toString() ==
                                  "2") {
                                containercolor = Colors.green.shade100;
                              } else {
                                containercolor = Colors.white;
                              }
                              // print(Listdata[index].noDays.toString());
                              return GestureDetector(
                                onTap: () {
                                  if ((Listdata[index].status.toString() ==
                                      "2")) {
                                  } else if (noraisestaus) {
                                  } else if (Listdata[index]
                                          .noDays
                                          .toString() ==
                                      "1") {
                                    commentcontroller.text = "";
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            insetPadding:
                                                const EdgeInsets.all(10),
                                            contentPadding: EdgeInsets.zero,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            titlePadding: EdgeInsets.zero,
                                            title: SizedBox(
                                              height: 50,
                                              child: Center(
                                                child: Text(
                                                  "Raise Grievance",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: "Lato",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: HexColor(
                                                          Colorscommon
                                                              .greencolor)),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ),
                                            titleTextStyle: TextStyle(
                                                color: Colors.grey[700]),
                                            // titlePadding: const EdgeInsets.only(left: 5, top: 5),
                                            content: SizedBox(
                                              height: 350,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20,
                                                              bottom: 10,
                                                              left: 10,
                                                              right: 10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            // ignore: prefer_const_literals_to_create_immutables
                                                            children: [
                                                              const Expanded(
                                                                flex: 1,
                                                                child:
                                                                    CommonText(
                                                                  text:
                                                                      "Issue Date",
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    CommonText(
                                                                  text: Listdata[
                                                                          index]
                                                                      .data
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            // ignore: prefer_const_literals_to_create_immutables
                                                            children: [
                                                              const Expanded(
                                                                flex: 1,
                                                                child:
                                                                    CommonText(
                                                                  text: "Type",
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    CommonText(
                                                                  text: Listdata[
                                                                          index]
                                                                      .earnComponentName
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                              // margin: const EdgeInsets.only(
                                                              //     top: 5, right: 10, left: 10),
                                                              child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              " Add Comments",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: HexColor(
                                                                      Colorscommon
                                                                          .greencolor)),
                                                            ),
                                                          )),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10,
                                                                    bottom: 0,
                                                                    left: 0,
                                                                    right: 0),
                                                            child: TextField(
                                                              controller:
                                                                  commentcontroller,
                                                              maxLines: 2,
                                                              cursorColor: HexColor(
                                                                  Colorscommon
                                                                      .greycolor),
                                                              // controller: descriptioncontroller,
                                                              style: TextStyle(
                                                                  color: HexColor(
                                                                      Colorscommon
                                                                          .greycolor),
                                                                  fontFamily:
                                                                      "TomaSans-Regular"),
                                                              decoration:
                                                                  const InputDecoration(
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.black)),
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                Colors.black)),
                                                                hintText:
                                                                    'Please Enter Comments',
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Bouncing(
                                                            onPress: () {
                                                              _showPicker(
                                                                  context);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  // margin: const EdgeInsets.only(
                                                                  //     top: 5, bottom: 2, left: 2),
                                                                  // width: 100,
                                                                  height: 40,
                                                                  child:
                                                                      ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor: HexColor(
                                                                          Colorscommon
                                                                              .greencolor),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                    ),
                                                                    //   RaisedButton(
                                                                    // color: HexColor(
                                                                    //     Colorscommon
                                                                    //         .greencolor),
                                                                    // shape: RoundedRectangleBorder(
                                                                    //     borderRadius:
                                                                    //         BorderRadius.circular(5)),
                                                                    child:
                                                                        const Text(
                                                                      "Upload Attachments",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // child: Text(
                                                      //   "Are you sure want to logout ?",
                                                      //   textAlign:
                                                      //       TextAlign.center,
                                                      //   style: TextStyle(
                                                      //     fontFamily:
                                                      //         'TomaSans-Regular',
                                                      //     fontSize: 18,
                                                      //     color: HexColor(
                                                      //         Colorscommon
                                                      //             .greycolor),
                                                      //   ),
                                                      // ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Bouncing(
                                                          onPress: () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20,
                                                                    left: 10,
                                                                    right: 0),
                                                            height: 40,
                                                            // width: 100,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                border: Border.all(
                                                                    color: HexColor(
                                                                        Colorscommon
                                                                            .greencolor))),
                                                            child: const Center(
                                                                child: Text(
                                                              "CANCEL",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Bouncing(
                                                          onPress: () {
                                                            utility.GetUserdata()
                                                                .then(
                                                                    (value) => {
                                                                          uploadimage(
                                                                              context,
                                                                              Listdata[index].data.toString())
                                                                        });
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 20,
                                                                    left: 0,
                                                                    right: 0),
                                                            height: 40,
                                                            // width: 100,
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    gradient:
                                                                        LinearGradient(
                                                                            colors: [
                                                                          HexColor(
                                                                              Colorscommon.greencolor),
                                                                          HexColor(
                                                                              Colorscommon.greencolor),
                                                                        ])),
                                                            child: const Center(
                                                                child: Text(
                                                              "SAVE",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // actions: <Widget>[

                                            // ],
                                          );
                                        });
                                  }

                                  // if (Listdata[index].noDays.toString() ==
                                  //     "1") {
                                  //   if (Listdata[index].select) {
                                  //     Listdata[index].select = false;
                                  //   } else {
                                  //     Listdata[index].select = true;
                                  //     componetiddatearray.add({
                                  //       "id": Listdata[index]
                                  //           .earnComponentId
                                  //           .toString(),
                                  //       'name': Listdata[index]
                                  //           .earnComponentName
                                  //           .toString(),
                                  //       "date": Listdata[index].data.toString()
                                  //     });
                                  //   }
                                  // }
                                  // selectedid = index.toString();
                                  // print("selectedid$selectedid");

                                  // setState(() {});
                                  // print(true);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      border: const Border(
                                        top: BorderSide(
                                            width: .2, color: Colors.black54),
                                        bottom: BorderSide(
                                            width: .2, color: Colors.black54),
                                      ),
                                      color: containercolor),

                                  // ignore: prefer_const_literals_to_create_immutables
                                  child: Row(children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible: Listdata[index]
                                                          .noDays
                                                          .toString() ==
                                                      "1" ||
                                                  Listdata[index]
                                                          .noDays
                                                          .toString() ==
                                                      "0",
                                              child: Text(
                                                Listdata[index]
                                                    .earnComponentName,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Visibility(
                                              visible: Listdata[index]
                                                          .noDays
                                                          .toString() !=
                                                      "1" &&
                                                  Listdata[index]
                                                          .noDays
                                                          .toString() !=
                                                      "0",
                                              child: ListTileTheme(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        right: 10,
                                                        left: 0,
                                                        bottom: 0,
                                                        top: 0),
                                                dense: true,
                                                horizontalTitleGap: 0.0,
                                                minLeadingWidth: 0,
                                                child: ExpansionTile(
                                                  title: Text(
                                                    Listdata[index]
                                                            .earnComponentName +
                                                        " (" +
                                                        Listdata[index]
                                                            .noDays
                                                            .toString() +
                                                        ")",
                                                    textAlign: TextAlign.start,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),

                                                    // style: TextStyle(
                                                    //     color:
                                                    //         Colors.purple.shade800,
                                                    //     fontWeight:
                                                    //         FontWeight.w600),
                                                    // style: Theme.of(context).textTheme.headline6,
                                                  ),
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: DataTable(
                                                              horizontalMargin:
                                                                  5,
                                                              showBottomBorder:
                                                                  true,
                                                              dividerThickness:
                                                                  1,
                                                              columnSpacing: 10,
                                                              columns: builddatacloumn(
                                                                  Listdata[
                                                                          index]
                                                                      .columns),
                                                              rows: builddatarowcell(
                                                                  Listdata[
                                                                          index]
                                                                      .arrayData,
                                                                  Listdata[
                                                                          index]
                                                                      .statusData,
                                                                  Listdata[
                                                                          index]
                                                                      .earnComponentId
                                                                      .toString(),
                                                                  Listdata[
                                                                          index]
                                                                      .earnComponentName
                                                                      .toString())),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  Listdata[index].data != "",
                                              child: Visibility(
                                                visible:
                                                    // ignore: unrelated_type_equality_checks
                                                    Listdata[index]
                                                                .noDays
                                                                .toString() ==
                                                            "1" ||
                                                        Listdata[index]
                                                                .noDays
                                                                .toString() ==
                                                            "0",
                                                child: Text(
                                                  "( " +
                                                      Listdata[index].data +
                                                      " )",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Visibility(
                                      visible: Listdata[index]
                                                  .noDays
                                                  .toString() ==
                                              "1" ||
                                          Listdata[index].noDays.toString() ==
                                              "0",
                                      child: Expanded(
                                          flex: 1,
                                          child: Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                ' :  ${Listdata[index].noDays.toString()}',
                                                textAlign: TextAlign.center,
                                              ),
                                              // Visibility(
                                              //     visible:
                                              //         Listdata[index].select,
                                              //     child: const Icon(
                                              //       Icons.check,
                                              //       color: Colors.green,
                                              //     )),
                                              const SizedBox(
                                                width: 10,
                                              )
                                            ],
                                          ))),
                                    ),
                                  ]),
                                ),
                              );
                            }),
                      )
                    ]),
                  )),
              Visibility(
                  visible: showmonth,
                  child: Visibility(
                    visible: !noraisestaus && !raisestaus,
                    child: Visibility(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Bouncing(
                              onPress: () {
                                addsaveedgrivance(context);
                                // print(
                                //     "componetiddatearray$componetiddatearray");
                              },
                              child: Container(
                                // margin: const EdgeInsets.only(
                                //     top: 20, left: 10, right: 0),
                                margin:
                                    const EdgeInsets.only(top: 10, left: 20),
                                height: 40,
                                decoration: BoxDecoration(
                                    color: HexColor(Colorscommon.greencolor),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color:
                                            HexColor(Colorscommon.greencolor))),
                                child: const Center(
                                    child: Text(
                                  "Raise Grievance",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.normal),
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 8,
                          ),
                          Expanded(
                            flex: 1,
                            child: Bouncing(
                              onPress: () {
                                nogrievance(context);
                                // validate();
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, right: 20),
                                height: 40,
                                decoration: BoxDecoration(
                                    color: HexColor(Colorscommon.greencolor),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color:
                                            HexColor(Colorscommon.greencolor))),
                                child: const Center(
                                    child: Text(
                                  "No Grievance",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  builddatacloumn(List columndata) {
    List<DataColumn> columns = [];
    for (var columndatastr in columndata) {
      print("columndatastr$columndatastr");
      // if ("Particulars" == columndatastr) {
      columns.add(
        DataColumn(
          label: Text(columndatastr.toString(),
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'TomaSans-Regular',
                  fontWeight: FontWeight.bold,
                  color: HexColor(Colorscommon.grey_low))),
        ),
      );
      // }
    }
    return columns;
  }

  builddatarowcell(List groupData, List statusdata, String componentid,
      String componentname) {
    // print(statusdata);
    List<DataRow> rows = [];
    if (groupData.isNotEmpty) {
      print("groupData$groupData");
      print("statusdata$statusdata");
    }

    // int i = groupData.length;
    int i = 0;
    for (var groupstr in groupData) {
      print(statusdata[i]);

      // print(groupstr);
      //  for (int i = 0; i < groupstr.length; i++) {
      //     if (i == 0) {
      //       print(statusdata[groupstr[0]]);
      //     }
      //     // pri nt(groupstr[i]);
      //   }
// for
      // print("groupstr$groupstr");
      // print(groupstr.length);
      // print(statusdata[i]);
      // print("groupstr$groupstr");
      Color setrowcolor;
      // setrowcolor = HexColor(Colorscommon.whitecolor);
      if (statusdata[i].toString() == "1") {
        setrowcolor = Colors.orange.shade100;
      } else if (statusdata[i].toString() == "2") {
        setrowcolor = Colors.green.shade100;
      } else {
        setrowcolor = Colors.white;
      }
      rows.add(DataRow(
          color: MaterialStateColor.resolveWith(
            (states) {
              return setrowcolor;
            },
          ),
          // ignore: avoid_types_as_parameter_names

          cells: (builddatarow(
              groupstr, context, commentcontroller, componentname, utility))));
      // i--;
      i++;
    }
    return rows;
  }
}
// (List groupstr, String date, BuildContext context, TextEditingController commentcontroller,String earncomponentname)

builddatarow(
    List groupstr,
    BuildContext context,
    TextEditingController commentcontroller,
    String earncomponentname,
    Utility utility) {
  void uploadimage(BuildContext context, String date) async {
    // utility.showYourPopUp(context);
    // loading();
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
                  // color: Colors.purple.shade800,
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
    String url = CommonURL.URL;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    request.fields['from'] = "grievanceAdd";
    request.fields['idUser'] = utility.userid;
    request.fields['grievanceDate'] = date;
    request.fields['grievanceComment'] = commentcontroller.text;

    // request.files.add(await http.MultipartFile.fromPath('file', _image.path));

    var streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);
    print('upload img status = ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      //utility.closeLoader(context);
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("$jsonInput");
      var status = jsonInput["status"] as bool;
      String message = jsonInput["message"].toString();
      if (status) {
        Fluttertoast.showToast(
            msg: message,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.green.shade100);
      } else {
        Fluttertoast.showToast(msg: message, gravity: ToastGravity.BOTTOM);
      }
    } else if (response.statusCode == 500) {
      //utility.closeLoader(context);
      Fluttertoast.showToast(
          msg: 'Something Went Wrong. Please Try Again..',
          gravity: ToastGravity.BOTTOM);
      print('status_code = ${response.statusCode}');
    } else {
      //utility.closeLoader(context);
      Fluttertoast.showToast(msg: response.body, gravity: ToastGravity.BOTTOM);
      print('status_code = ${response.body}');
    }
    Navigator.pop(context);
    Navigator.pop(context);
    streamController.add("event");
    // });
  }

  List<DataCell> cell = [];
  for (var valustr in groupstr) {
    cell.add(DataCell(GestureDetector(
        onTap: () {
          commentcontroller.text = "";
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  insetPadding: const EdgeInsets.all(10),
                  contentPadding: EdgeInsets.zero,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  titlePadding: EdgeInsets.zero,
                  title: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Raise Grievance",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold,
                            color: HexColor(Colorscommon.greencolor)),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  titleTextStyle: TextStyle(color: Colors.grey[700]),
                  // titlePadding: const EdgeInsets.only(left: 5, top: 5),
                  content: SizedBox(
                    height: 380,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 5),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 10, left: 10, right: 10),
                            child: Column(
                              children: [
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: CommonText(
                                        text: "Issue Date",
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CommonText(
                                        text: valustr.toString(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: CommonText(
                                        text: "Type",
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: CommonText(
                                        text: earncomponentname,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    // margin: const EdgeInsets.only(
                                    //     top: 5, right: 10, left: 10),
                                    child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    " Add Comments",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            HexColor(Colorscommon.greencolor)),
                                  ),
                                )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 0, left: 0, right: 0),
                                  child: TextField(
                                    controller: commentcontroller,
                                    maxLines: 2,
                                    cursorColor:
                                        HexColor(Colorscommon.greycolor),
                                    // controller: descriptioncontroller,
                                    style: TextStyle(
                                        color: HexColor(Colorscommon.greycolor),
                                        fontFamily: "TomaSans-Regular"),
                                    decoration: const InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      hintText: 'Please Enter Comments',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Bouncing(
                                  onPress: () {},
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        // margin: const EdgeInsets.only(
                                        //     top: 5, bottom: 2, left: 2),
                                        // width: 100,
                                        height: 40,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: HexColor(
                                                Colorscommon.greencolor),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                          //                           RaisedButton(
                                          // color:
                                          //     HexColor(Colorscommon.greencolor),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(5)),
                                          child: const Text(
                                            "Upload Attachments",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Bouncing(
                                onPress: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, left: 10, right: 0),
                                  height: 40,
                                  // width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: HexColor(
                                              Colorscommon.greencolor))),
                                  child: const Center(
                                      child: Text(
                                    "CANCEL",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Bouncing(
                                onPress: () {
                                  utility.GetUserdata().then((value) =>
                                      {uploadimage(context, valustr)});
                                  // uploadimage(
                                  //     context, Listdata[index].data.toString());
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, left: 0, right: 0),
                                  height: 40,
                                  // width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: LinearGradient(colors: [
                                        HexColor(Colorscommon.greencolor),
                                        HexColor(Colorscommon.greencolor)
                                      ])),
                                  child: const Center(
                                      child: Text(
                                    "SAVE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // actions: <Widget>[

                  // ],
                );
              });
        },
        child: Text(valustr.toString()))));
  }

  return cell;
}

class EarningsData {
  late String earnComponentId;
  late String earnComponentName;
  late String data;
  late String noDays;
  late String status;
  late List arrayData;
  late List statusData;
  late List columns;
  late bool select;

  EarningsData(
      {required this.earnComponentId,
      required this.earnComponentName,
      required this.data,
      required this.noDays,
      required this.arrayData,
      required this.columns,
      required this.select,
      required this.statusData,
      required this.status});

  EarningsData.fromJson(Map<String, dynamic> json) {
    earnComponentId = json['earn_componentId'].toString();
    earnComponentName = json['earn_componentName'].toString();
    data = json['data'].toString();
    noDays = json['noDays'].toString();
    status = json['status'].toString();
    arrayData = json['arrayData'] as List;
    statusData = json['statusData'] as List;
    columns = json['columns'] as List;
    select = json['select'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['earn_componentId'] = earnComponentId;
    data['earn_componentName'] = earnComponentName;
    data['data'] = this.data;
    data['noDays'] = noDays;
    data['arrayData'] = arrayData;
    data['columns'] = columns;
    data['select'] = select;
    data['statusData'] = statusData;
    data['status'] = status;
    return data;
  }
}
