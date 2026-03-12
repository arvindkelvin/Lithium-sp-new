
// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
// import 'package:flutter_application_sfdc_idp/Colors.dart';
// import 'package:flutter_application_sfdc_idp/CommonColor.dart';
// import 'package:flutter_application_sfdc_idp/CommonText.dart';
// import 'package:flutter_application_sfdc_idp/URL.dart';
// import 'package:flutter_application_sfdc_idp/Utility.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:url_launcher/url_launcher.dart';
//
//
// class FeeInvoices extends StatefulWidget {
//   const FeeInvoices({Key? key}) : super(key: key);
//
//   @override
//   State<FeeInvoices> createState() => _FeeInvoicesState();
// }
//
// class _FeeInvoicesState extends State<FeeInvoices> {
//   bool showmonth = false;
//   bool showpaycycle = false;
//   Utility utility = Utility();
//   List yearmonthlist = [];
//   String? selectedInvoiceId;
//   String? link;
//   String? imageUrl;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     utility.GetUserdata().then((value) => {
//           sessionManager.internetcheck().then((intenet) async {
//             if (intenet) {
//               fetchData(); // Call fetchData here
//             } else {
//               showTopSnackBar(
//                 context,
//                 const CustomSnackBar.error(
//                   message: "Please Check Your Internet Connection",
//                 ),
//               );
//             }
//           }),
//      // fetchData()
//         });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   var items = [];
//   List earnarray = [];
//   List earnarray2 = [];
//   List infoarray = [];
//   List infoarray2 = [];
//   List deductionarray = [];
//   List deductionarray2 = [];
//   List name = [
//     "Info",
//     "Invoice Amount",
//     "Rental Charges",
//     "Customer SLA & Compliance Details",
//     "Other Recoveries (Vehicle Damages, Security Deposit & Advances)",
//     "TDS",
//     "Net Amount Paid"
//   ];
//   var items2 = [];
//   String? dropdownvalue;
//   String? dropdownvalue2;
//   String? netpaidammount;
//   String? invoiceamount;
//   String? rentalcharges;
//   String? customerslacompliance;
//   String? otherrecover;
//   String? infoindex1;
//   String? tds;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(80),
//           child: CommonAppbar(
//             title: AppLocalizations.of(context)!.fee_Invoices,
//             appBar: AppBar(),
//             widgets: const [],
//           ),
//         ),
//         body: Container(
//           color: HexColor(Colorscommon.backgroundcolor),
//           margin: const EdgeInsets.all(10),
//           child: SingleChildScrollView(
//             child: Column(children: [
//               Container(
//                   width: MediaQuery.of(context).size.width - 15,
//                   margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Avenirtextmedium(
//                       customfontweight: FontWeight.w500,
//                       fontsize: (AppLocalizations.of(context)!.id ==  "ஐடி" ||
//                                                                 AppLocalizations.of(
//                                                                             context)!
//                                                                         .id ==
//                                                                     "आयडी" || AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ" ||
//                               AppLocalizations.of(context)!.id == "ಐಡಿ")
//                           ? 13
//                           : 15,
//                       text: AppLocalizations.of(context)!.year,
//                       textcolor: HexColor(Colorscommon.greendark),
//                     ),
//                   )),
//               Container(
//                 width: MediaQuery.of(context).size.width - 15,
//                 height: 40,
//                 margin: const EdgeInsets.all(15.0),
//                 padding: const EdgeInsets.all(3.0),
//                 decoration: const ShapeDecoration(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(width: 0.1, style: BorderStyle.solid),
//                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   ),
//                 ),
//                 child: Theme(
//                   data: Theme.of(context).copyWith(
//                       canvasColor: Colors.white, backgroundColor: Colors.white),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton(
//                       hint: const Text("Select Year And Month"),
//                       value: dropdownvalue,
//                       items: items.map((item) {
//                         return DropdownMenuItem(
//                           value: item,
//                           child: Text(item),
//                         );
//                       }).toList(),
//                       icon: Icon(
//                         Icons.keyboard_arrow_down,
//                         color: HexColor(Colorscommon.greencolor),
//                       ),
//                       onChanged: (value) {
//                         dropdownvalue = value.toString();
//                         fetchData2(dropdownvalue!);
//                         setState(() {
//                          // imageUrl;
//                           //print("imageUrl==$imageUrl");// Image.network(imageUrl!);// Open the link when it is available
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ), if (link != null)
//                 Card(
//                   margin: const EdgeInsets.all(10),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Link: $link',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             launch(link!); // Open the link when the button is pressed
//                           },
//                           child: Text('Open Link'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//             ),
//           ),
//         ),
//     );
//   }
//
//
//
//
//
//   Future<void> fetchData2(String selectedYear) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://10.10.14.14:8092/webservice'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({
//           'from': 'getInvoice',
//           'id': selectedInvoiceId,
//         }),
//       );
//
//       print('Response from the second API: ${response.body}');
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final Map<String, dynamic> data = json.decode(response.body);
//
//         if (data.containsKey('result') &&
//             data['result'] != null &&
//             data['result'].isNotEmpty) {
//           link = data['result'][0]['link'];
//
//           // Display the link in the console
//           print('Link: $link');
//
//           // Download the PDF file
//          // final http.Response pdfResponse = await http.get(Uri.parse(link!));
//           //final bytes = pdfResponse.bodyBytes;
//
//           // Set the imageUrl once the download is complete
//           setState(() {
//             imageUrl = link;
//           });
//
//           // Now you can use the 'bytes' variable to display the PDF or save it locally
//         } else {
//           print('No link data available in the response');
//         }
//       } else {
//         // Handle errors for the second API call
//         print('Failed to load data from the second API');
//       }
//     } catch (error) {
//       print('Error during the second API call: $error');
//     }
//   }
//
//   Future<void> fetchData() async {
//     try {
//       final response1 = await http.post(
//         Uri.parse('http://10.10.14.14:8092/webservice'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({
//           'from': 'getInvoiceList',
//           'lithium_id': 'LITHBNG4977',
//         }),
//       );
//
//       print('Response from the first API: ${response1.body}');
//
//       if (response1.statusCode == 200||response1.statusCode == 201) {
//         final Map<String, dynamic> data1 = json.decode(response1.body);
//         final List invoices = data1['result'];
//         selectedInvoiceId = invoices[0]['id'];
//
//         // Populate the items list with years
//         items = invoices.map((invoice) => invoice['monthyear']).toList();
//
//         setState(() {}); // Update the UI after populating the items list
//       } else {
//         // Handle errors for the first API call
//         print('Failed to load data from the first API. Status code: ${response1.statusCode}');
//         print('Response body: ${response1.body}');
//       }
//     } catch (error) {
//       print('Error during the first API call: $error');
//     }
//   }
//
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/CommonText.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:flutter_application_sfdc_idp/CommonAppbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../l10n/app_localizations.dart';

class FeeInvoices extends StatefulWidget {
  const FeeInvoices({Key? key}) : super(key: key);

  @override
  State<FeeInvoices> createState() => _FeeInvoicesState();
}

class _FeeInvoicesState extends State<FeeInvoices> {
  bool showMonth = false;
  bool showPayCycle = false;
  Utility utility = Utility();
  List<String> yearMonthList = [];
  String? selectedInvoiceId;
  String? link;
  List<dynamic> invoices = [];
  bool isLoading = false;
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    utility.GetUserdata().then((_) async {
      bool internet = await sessionManager.internetcheck();
      if (internet) {
        fetchData();
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CommonAppbar(
          title: AppLocalizations.of(context)!.fee_Invoices,
          appBar: AppBar(),
          widgets: const [],
        ),
      ),
      body: Container(
        color: HexColor(Colorscommon.backgroundcolor),
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 15,
                margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Avenirtextmedium(
                    customfontweight: FontWeight.w500,
                    fontsize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                        AppLocalizations.of(context)!.id == "आयडी" ||
                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                        ? 13
                        : 15,
                    text: AppLocalizations.of(context)!.year,
                    textcolor: HexColor(Colorscommon.greendark),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 15,
                height: 40,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.1, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.white,
                    colorScheme: ColorScheme.dark(surface: Colors.white),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: const Text("Select Year And Month"),
                      value: dropdownValue,
                      items: yearMonthList.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: HexColor(Colorscommon.greencolor),
                      ),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value;
                          final selectedInvoice = invoices.firstWhere(
                                (invoice) => invoice['monthyear'] == dropdownValue,
                            orElse: () => null,
                          );
                          if (selectedInvoice != null) {
                            selectedInvoiceId = selectedInvoice['id'];
                            fetchData2(selectedInvoiceId!);
                          } else {
                            print('Selected invoice ID is null.');
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
              if (isLoading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(HexColor(Colorscommon.greendark2)),
                ),
              if (link != null && !isLoading)
                Container(
                  height: 500,
                  child: PDFView(
                    filePath: link!,
                    autoSpacing: false,
                    pageSnap: true,
                    pageFling: false,
                    onRender: (pages) {
                      print('PDF rendered: $pages pages');
                    },
                    onError: (error) {
                      print('Error loading PDF: $error');
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  void loading() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevents back button from closing the dialog
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/lithiugif.gif',
                    width: 50,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text("Loading"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> fetchData() async {

    try {
      loading();
      var url = Uri.parse(CommonURL.localone);
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      };
      String dataJson = jsonEncode([
        {
          "service_provider": utility.service_provider_c,
        }
      ]);
      var request = http.MultipartRequest("POST", url)
        ..headers.addAll(headers)
        ..fields['from'] = "getInvoiceList2"
        ..fields['lithium_id'] = utility.lithiumid.toString()
        ..fields['data'] = dataJson;

      var response = await request.send();
      var response1 = await http.Response.fromStream(response);

      if (response1.statusCode == 200 || response1.statusCode == 201) {
        Navigator.pop(context);
        final Map<String, dynamic> data = json.decode(response1.body);
        invoices = data['result'];
        yearMonthList = invoices.map((invoice) => invoice['monthyear'].toString()).toList();
        setState(() {});

      } else {
        Navigator.pop(context);
        print('Failed to load data from the first API. Status code: ${response1.statusCode}');

      }
    } catch (error) {
      Navigator.pop(context);
      print('Error during the first API call: $error');
    }
  }

  Future<void> fetchData2(String selectedInvoiceId) async {
    setState(() => isLoading = true);

    String url = CommonURL.localone;
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'from': 'getInvoice',
        'id': selectedInvoiceId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('result') && data['result'].isNotEmpty) {
        link = data['result'][0]['link'];
        print("Link$link");
        await downloadAndLoadPDF(link!);
        setState(() => isLoading = false);
      } else {
        print('No link data available in the response');
        setState(() {
          isLoading = false;
          link = null;
        });
      }
    } else {
      print('Failed to load data from the second API');
      setState(() {
        isLoading = false;
        link = null;
      });
    }
  }

  Future<void> downloadAndLoadPDF(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/downloaded.pdf');
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        link = file.path;
      });
    } else {
      print('Failed to download PDF. Status code: ${response.statusCode}');
    }
  }
}
