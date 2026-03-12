import 'URL.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_speedtest/flutter_speedtest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Utility {
  DateTime Today = DateTime.now();
  DateTime dayaftertommrow = DateTime.now().add(const Duration(days: 3));
  DateTime minus3day = DateTime.now().add(const Duration(days: -3));
  final _speedtest = FlutterSpeedtest(
      baseUrl: CommonURL.herokuurl,
      pathDownload: '/download',
      pathUpload: '/upload',
      pathResponseTime: '/ping');
  DateTime selectedDate = DateTime.now();
  String Todaystr = '';
  String timeText = 'Set A Time';
  TimeOfDay currentTime = TimeOfDay.now();
  bool fromnotify = false;

  late String idTeamMember,
      code,
      Loginbool,
      name,
      sp_username,
      password,
      mobileno,
      emailId,
      designation,
      accessTokken,
      refreshTokken,
      followupCount,
      pjpCount,
      idSaleshierarchy,
      isManager,
      currencyName,
      companyLogo,
      userid,
      service_provider_c,
      lithiumid,
      mobileuser,
      sfid,
      city,
      campus;

  Future<void> GetUserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    idTeamMember = prefs.getString('idTeamMember') ?? '';
    code = prefs.getString('code') ?? '';
    name = prefs.getString('name') ?? '';
    sp_username = prefs.getString('sp_username') ?? '';
    password = prefs.getString('password') ?? '';
    mobileno = prefs.getString('mobileno') ?? '';
    emailId = prefs.getString('emailId') ?? '';
    designation = prefs.getString('designation') ?? '';
    accessTokken = prefs.getString('access_tokken') ?? '';
    refreshTokken = prefs.getString('refreshtokken') ?? '';
    Loginbool = prefs.getString('loginbool') ?? '';
    pjpCount = prefs.getString('pjpCount') ?? '';
    followupCount = prefs.getString('followupCount') ?? '';
    idSaleshierarchy = prefs.getString('idSaleshierarchy') ?? '';
    isManager = prefs.getString('isManager') ?? '';
    companyLogo = prefs.getString('companyLogo') ?? '';
    currencyName = prefs.getString('currencyName') ?? '';
    userid = prefs.getString('userid') ?? '';
    lithiumid = prefs.getString('lithiumid') ?? '';
    service_provider_c = prefs.getString('service_provider_c') ?? '';
    mobileuser = prefs.getString('mobileuser') ?? '';
    fromnotify = prefs.getBool('fromnotify') ?? false;
    sfid = prefs.getString('sfid') ?? " ";
    city = prefs.getString('city') ?? " ";
    campus = prefs.getString('campus') ?? " ";

    Todaystr = DateFormat('dd-MM-yyyy').format(Today);
  }

  void _showSlowConnectionSnackBar(BuildContext context) {
    if (!context.mounted) return;

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    showTopSnackBar(
      overlay,
      CustomSnackBar.error(
        message: "Your Internet Connection is Very Slow",
        textStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'AvenirLTStd-Black',
          color: HexColor(Colorscommon.whitecolor),
        ),
        backgroundColor: HexColor(Colorscommon.grey_low),
      ),
      displayDuration: const Duration(seconds: 30),
    );
  }


  bool _isSlowConnection(double percent, double transferRate,
      double thresholdPercent, double thresholdRate) {
    return percent > thresholdPercent && transferRate < thresholdRate;
  }

  Future<void> _runSpeedTest({
    required BuildContext context,
    required double thresholdPercent,
    required double thresholdRate,
  }) async {
    bool status = true;

    _speedtest.getDataspeedtest(
      progressResponse: (percent, transferRate) {
        if (_isSlowConnection(percent as double, transferRate as double,
                thresholdPercent, thresholdRate) &&
            status) {
          status = false;
          _showSlowConnectionSnackBar(context);
        }
      },
      onError: (errorMessage) {
        print("Error: $errorMessage");
      },
      downloadOnProgress: (percent, transferRate) {
        if (_isSlowConnection(
                percent, transferRate, thresholdPercent, thresholdRate) &&
            status) {
          status = false;
          _showSlowConnectionSnackBar(context);
        }
      },
      uploadOnProgress: (percent, transferRate) {
        if (_isSlowConnection(
                percent, transferRate, thresholdPercent, thresholdRate) &&
            status) {
          status = false;
          _showSlowConnectionSnackBar(context);
        }
      },
      onDone: () {
        print("Speed test completed.");
      },
    );
  }

  Future<void> showYourpopupinternetstatus(BuildContext context) async {
    await _runSpeedTest(
      context: context,
      thresholdPercent: 50.0, // Use double values
      thresholdRate: 0.8, // Use double values
    );
  }

  Future<void> showspeedteststatus(BuildContext context) async {
    await _runSpeedTest(
      context: context,
      thresholdPercent: 60.0, // Use double values
      thresholdRate: 2.0, // Use double values
    );
  }

  void showYourPopUp(BuildContext context) {
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

  void closeLoader(BuildContext context) {
    debugPrint('close loader called');
    Navigator.of(context, rootNavigator: true).pop();
  }

  String DateConvertINDIA1(String inputdate) {
    if (inputdate.length > 4) {
      var inputFormat = DateFormat("yyyy-MM-dd");

      var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('dd-MM-yyyy');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    }
    return "-";
  }

  String dateconverteryyyymmdd(String inputdate) {
    if (inputdate.length > 4) {
      var inputFormat = DateFormat("dd-MMM-yyyy");

      var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('yyyy-MM-dd');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    }
    return "-";
  }

  String DateConvertINDIA2(String inputdate) {
    if (inputdate.length > 4) {
      var inputFormat = DateFormat("yyyy-MM-dd");

      var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    }
    return "-";
  }

  String DateConvert2(String inputdate) {
    var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  String DateConvert3(String inputdate) {
    var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  String datepickerdateconverter(String inputdate) {
    var inputFormat = DateFormat('yyyy-MM-dd');

    var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

    var outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  String SendDate(String inputdate) {
    if (inputdate.length > 4) {
      var inputFormat = DateFormat("yyyy-MM-dd");

      var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('yyyy/MM/dd');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    }
    return "-";
  }

  Future<String> selectTimeto(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          // Enforce 12-hour format
          child: Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.highContrastLight(
                // Change the border color
                primary: HexColor(Colorscommon.greencolor),
                // Change the text color
                onSurface: HexColor(Colorscommon.greencolor),
              ),
            ),
            child: child ?? const Text(""),
          ),
        );
      },
    );

    if (selectedTime != null) {
      MaterialLocalizations localizations = MaterialLocalizations.of(context);
      String formattedTime = localizations.formatTimeOfDay(
        selectedTime,
        alwaysUse24HourFormat: false, // Ensure 12-hour format here as well
      );
      timeText = formattedTime;
      print("currenttime: $timeText");
      return formattedTime + "." + timeText;
    }

    return ""; // Return empty if no time is selected
  }

  // Future<String> selectTimeto(BuildContext context) async {
  //   TimeOfDay? selectedTime = await showTimePicker(
  //     context: context,
  //     initialTime: currentTime,
  //     builder: (context, child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           colorScheme: ColorScheme.highContrastLight(
  //             // change the border color
  //             primary: HexColor(Colorscommon.greencolor),
  //             // change the text color
  //             onSurface: HexColor(Colorscommon.greencolor),
  //           ),
  //           // button colors
  //         ),
  //         child: child ?? const Text(""),
  //       );
  //     },
  //     // builder: (BuildContext? context, Widget child) {
  //     //   return Theme(
  //     //     data: ThemeData.light().copyWith(
  //     //       colorScheme: ColorScheme.light(
  //     //         primary: HexColor(Colorscommon.redcolor),
  //     //         // header background color
  //     //         onPrimary: Colors.white,
  //     //         // header text color
  //     //         onSurface: Colors.black, // body text color
  //     //       ),
  //     //     ),
  //     //     child: child,
  //     //   );
  //     // },
  //   );
  //   MaterialLocalizations localizations = MaterialLocalizations.of(context);
  //   if (selectedTime != null) {
  //     String formattedTime = localizations.formatTimeOfDay(selectedTime,
  //         alwaysUse24HourFormat: true);
  //     timeText = formattedTime;
  //     print("currenttime$timeText");
  //   }
  //   String formattedTime = localizations.formatTimeOfDay(selectedTime!,
  //       alwaysUse24HourFormat: false);
  //   return formattedTime + "." + timeText;
  // }

  String SendDate2(String inputdate) {
    if (inputdate.length > 4) {
      var inputFormat = DateFormat("dd/MM/yyyy");

      var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('dd-MM-yyyy');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    }
    return "-";
  }

  String SendDate3(String inputdate) {
    if (inputdate.length > 4) {
      var inputFormat = DateFormat("dd-MM-yyyy");

      var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    }
    return "-";
  }

  String datetimetotime(String inputdate) {
    if (inputdate.length > 4) {
      var inputFormat = DateFormat("yyyy-MM-dd hh:mm:ss");

      var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('HH:MM');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    }
    return "HH:MM";
  }

  String datetimetotime2(String inputdate) {
    if (inputdate.length > 4) {
      var inputFormat = DateFormat("HH:MM:SS");

      var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('HH:MM');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    }
    return "HH:MM";
  }

  String SendDate4(String inputdate) {
    if (inputdate.length > 4) {
      var inputFormat = DateFormat("dd/MM/yyyy");

      var inputDate = inputFormat.parse(inputdate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('yyyy/MM/dd');
      var outputDate = outputFormat.format(inputDate);

      return outputDate;
    }
    return "-";
  }

  Future<String> Displaydate2(BuildContext context, String fromdate,
      String todate, String fromdateselected, String vaildstardate) async {
    DateTime selectedDate;
    DateTime intdate;
    DateTime lastdate;
    print("fromdate$fromdate");
    print("fromdateselected$fromdateselected");
    print("todate$todate");
    if (todate == "1") {
      DateTime tempDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);
      selectedDate = tempDate;
      intdate = tempDate;
      // lastdate = DateTime(2025);
      lastdate = dayaftertommrow.add(const Duration(days: 30));
      if (fromdate == "1") {
        if (vaildstardate == "1") {
          DateTime tempDate =
              DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);
          DateTime lasttempDate =
              (DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected))
                  .add(const Duration(days: 1));
          selectedDate = tempDate;
          intdate = tempDate;
          lastdate = lasttempDate;
          // lastdate = lasttempDate.add(const Duration(days: 30));
        } else {
          DateTime tempDate =
              DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);

          selectedDate = tempDate;
          intdate = tempDate.add(const Duration(days: 0));
          lastdate = tempDate.add(const Duration(days: 1));
        }
      } else {}
    } else if (todate == "2") {
      DateTime tempDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);
      selectedDate = tempDate;
      intdate = DateTime(1990);
      lastdate = tempDate;
    } else if (fromdate == "2") {
      selectedDate = dayaftertommrow;
      intdate = dayaftertommrow;
      // lastdate = DateTime(2025);
      lastdate = intdate.add(const Duration(days: 30));
    } else {
      selectedDate = minus3day;
      intdate = DateTime(1990);
      lastdate = minus3day;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: intdate,
      lastDate: lastdate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: HexColor(Colorscommon.greenAppcolor),
              onPrimary: Colors.white,
              onSurface: Colors.black, // body text color
            ),
          ),
          child: child ?? const Text(''),
        );
      },
    );

    if (picked != null && picked != selectedDate) selectedDate = picked;
    print('picked date = $selectedDate');

    return picked.toString();
  }

  Future<String> Displaydate1(BuildContext context, String fromdate,
      String todate, String fromdateselected, String vaildstardate) async {
    DateTime selectedDate;
    DateTime intdate;
    DateTime lastdate;

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the previous two dates
    DateTime previousDate1 = currentDate.subtract(Duration(days: 1));
    DateTime previousDate2 = currentDate.subtract(Duration(days: 2));

    // Set selectedDate to the currentDate
    selectedDate = currentDate;

    // Set intdate to previousDate2
    intdate = previousDate2;

    // Set lastdate to currentDate
    lastdate = currentDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: intdate,
      lastDate: lastdate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: HexColor(Colorscommon.greenAppcolor),
              onPrimary: Colors.white,
              onSurface: Colors.black, // body text color
            ),
          ),
          child: child ?? const Text(''),
        );
      },
    );

    if (picked != null && picked != selectedDate) selectedDate = picked;
    print('picked date = $selectedDate');

    return picked.toString();
  }

  Future<String> Displaydate3(BuildContext context, String fromdate,
      String todate, String fromdateselected, String vaildstardate) async {
    DateTime selectedDate;
    DateTime intdate;
    DateTime lastdate;
    print("fromdate$fromdate");
    print("fromdateselected$fromdateselected");
    print("todate$todate");
    if (todate == "1") {
      DateTime tempDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);
      selectedDate = tempDate;
      intdate = tempDate;
      // lastdate = DateTime(2025);
      lastdate = dayaftertommrow.add(const Duration(days: 30));
      if (fromdate == "1") {
        if (vaildstardate == "1") {
          DateTime tempDate =
              DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);
          DateTime lasttempDate =
              (DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected))
                  .add(const Duration(days: 1));
          selectedDate = tempDate;
          intdate = tempDate;
          lastdate = lasttempDate;
          // lastdate = lasttempDate.add(const Duration(days: 30));
        } else {
          DateTime tempDate =
              DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);

          selectedDate = tempDate;
          intdate = DateTime(1990);
          lastdate = tempDate.add(const Duration(days: 30));
        }
      } else {}
    } else if (todate == "2") {
      DateTime tempDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);
      selectedDate = tempDate;
      intdate = DateTime(1990);
      lastdate = tempDate;
    } else if (fromdate == "2") {
      selectedDate = dayaftertommrow;
      intdate = dayaftertommrow;
      // lastdate = DateTime(2025);
      lastdate = intdate.add(const Duration(days: 30));
    } else {
      selectedDate = minus3day;
      intdate = DateTime(1990);
      lastdate = minus3day;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: intdate,
      lastDate: lastdate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: HexColor(Colorscommon.greenAppcolor),
              onPrimary: Colors.white,
              onSurface: Colors.black, // body text color
            ),
          ),
          child: child ?? const Text(''),
        );
      },
    );

    if (picked != null && picked != selectedDate) selectedDate = picked;
    print('picked date = $selectedDate');

    return picked.toString();
  }

  Future<String> Displaydate(BuildContext context, String fromdate,
      String todate, String fromdateselected, String vaildstardate) async {
    DateTime selectedDate;
    DateTime intdate;
    DateTime lastdate;
    print("fromdate$fromdate");
    print("fromdateselected$fromdateselected");
    print("todate$todate");
    if (todate == "1") {
      DateTime tempDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);
      selectedDate = tempDate;
      intdate = tempDate;
      // lastdate = DateTime(2025);
      lastdate = dayaftertommrow.add(const Duration(days: 30));
      if (fromdate == "1") {
        if (vaildstardate == "1") {
          DateTime tempDate =
              DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);
          DateTime lasttempDate =
              (DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected))
                  .add(const Duration(days: 1));
          selectedDate = tempDate;
          intdate = tempDate;
          lastdate = lasttempDate;
          // lastdate = lasttempDate.add(const Duration(days: 30));
        } else {
          DateTime tempDate =
              DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);

          selectedDate = tempDate;
          intdate = DateTime(1990);
          lastdate = tempDate.add(const Duration(days: 30));
        }
      } else {}
    } else if (todate == "2") {
      DateTime tempDate =
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(fromdateselected);
      selectedDate = tempDate;
      intdate = DateTime(1990);
      lastdate = tempDate;
    } else if (fromdate == "2") {
      selectedDate = dayaftertommrow;
      intdate = dayaftertommrow;
      // lastdate = DateTime(2025);
      lastdate = intdate.add(const Duration(days: 30));
    } else {
      selectedDate = minus3day;
      intdate = DateTime(1990);
      lastdate = minus3day;
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: intdate,
      lastDate: lastdate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: HexColor(Colorscommon.greenAppcolor),
              onPrimary: Colors.white,
              onSurface: Colors.black, // body text color
            ),
          ),
          child: child ?? const Text(''),
        );
      },
    );

    if (picked != null && picked != selectedDate) selectedDate = picked;
    print('picked date = $selectedDate');

    return picked.toString();
  }
}
