import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Colors.dart';
import '../CommonColor.dart';
import '../l10n/app_localizations.dart';

class DashboardPageNew extends StatefulWidget {
  late final String text;


  @override
  _DashboardPageState createState() => _DashboardPageState();

}

class _DashboardPageState extends State<DashboardPageNew> {
  Utility utility = Utility();
  List<dynamic>? dashboardData;
  String? groupValue;  // Store group value
  String? cityValue;   // Store city value
  bool _isScrollingForward = true;  // Track scroll direction (forward or backward)
  bool _isScrollingPaused = false;  // Flag to control pause/resume of scrolling
  String? attendanceLegend;
  String? otaOtdLegend;
  String? referralLegend;
  String? tripPointsLegend;
  String? weeklyRankLag;
  bool _isVisible = true;
  String username = "";
  String spusername = "";

  bool _isLoading = true; // NEW: loading flag
  bool _hasError = false; // NEW: error flag



  @override
  void initState() {
    super.initState();

    // Fetch user data first
    utility.GetUserdata().then((value) {
      // Check if lithiumid is valid
      if (utility.lithiumid != null && utility.lithiumid.isNotEmpty) {
        print('Lithium ID: ${utility.lithiumid}');
        username = utility.lithiumid;
        spusername = utility.mobileuser;

        // Fetch dashboard data after user data is ready
        fetchDashboardData();

        _startBlinking();
      } else {
        print('Failed to fetch valid lithiumid.');

        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
      setState(() {});
    });
  }


  void _startBlinking() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _isVisible = !_isVisible;  // Toggle visibility every second
      });
    });
  }

  Future<void> fetchDashboardData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // Get the current date and subtract one day
    DateTime currentDate = DateTime.now();
    DateTime yesterday = currentDate.subtract(Duration(days: 1));

    // Format the date in "dd-MM-yyyy" format
    String formattedDate = "${yesterday.day.toString().padLeft(2, '0')}-${(yesterday.month).toString().padLeft(2, '0')}-${yesterday.year}";

    final url = Uri.parse('https://apps.project-lithium.com/sp/webservice');
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };

    try {
      String dataJson = jsonEncode([
        {
          "lithiumid": utility.lithiumid,
          "date": formattedDate,  // Use the dynamically formatted date
        }
      ]);
print("gjgv$formattedDate");
      var request = http.MultipartRequest("POST", url)
        ..headers.addAll(headers)
        ..fields['from'] = "getspDashboard"
        ..fields['data'] = dataJson;

      var streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('dashboardData: ${jsonEncode(dashboardData)}');

        if (data['status'] == true && mounted) {
          setState(() {
            dashboardData = data['data']['sections']['metrics']['columns'];
            groupValue = data['data']['sections']['headers']['group'];  // Set the group value
            cityValue = data['data']['sections']['headers']['city'];    // Set the city value
            attendanceLegend = data['data']['sections']['legends']['attendance'];
            otaOtdLegend = data['data']['sections']['legends']['ota_otd'];
            referralLegend = data['data']['sections']['legends']['referral'];
            tripPointsLegend = data['data']['sections']['legends']['trip_points'];
            weeklyRankLag = dashboardData![1]['metrics'][0]['value']['weekly_rank_lag']?.toString() ?? 'N/A';
            _isLoading = false;
          });

          // Print legend values
          print("Attendance Legend: $attendanceLegend");
          print("OTA/OTD Legend: $otaOtdLegend");
          print("Referral Legend: $referralLegend");
          print("Trip Points Legend: $tripPointsLegend");
          print("Weekly Rank Lag: $weeklyRankLag");
        } else {
          print('API returned false status or widget is unmounted.');
          setState(() {
            dashboardData = [];
            _isLoading = false;
            _hasError = true;
          });
        }
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        setState(() {
          dashboardData = [];
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
      setState(() {
        dashboardData = [];
        _isLoading = false;
        _hasError = true;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar:PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: HexColor(Colorscommon.greenAppcolor),
            centerTitle: true,
            leading: SizedBox(), // Empty container to remove the back arrow and image
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  "Lithium Super City League 2.0",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato',
                    fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                        AppLocalizations.of(context)!.id == "आयडी" ||
                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                        ? 17
                        : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "                   SP Contest",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Lato',
                        fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                            AppLocalizations.of(context)!.id == "आयडी" ||
                            AppLocalizations.of(context)!.id == "ಐಡಿ")
                            ? 17
                            : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ],
            ),
            shape: CustomAppBarShape(),
          ),
        ),
        body: GestureDetector(
          onTapDown: (_) => setState(() => _isScrollingPaused = true),
          onTapUp: (_) => setState(() => _isScrollingPaused = false),
          onPanUpdate: (_) => setState(() => _isScrollingPaused = true),
          onPanEnd: (_) => setState(() => _isScrollingPaused = false),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : (_hasError || dashboardData!.isEmpty)
              ? const Center(child: Text("No data available"))
              : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Image.asset(
                              'assets/contest.jpeg',  // Path to your image asset
                              width: 110,  // Adjust the size of the image as needed
                              height: 110,  // Adjust the size of the image as needed
                            ),
                          ),

                        ),
                        const SizedBox(width: 10), // Add consistent spacing between items
                        Expanded(
                          child: Container(
                            height: 150,  // Fixed height for consistency
                            child: _buildDashboardItem(
                              title: dashboardData?[1]['title'] ?? 'N/A', // Safe fallback for title
                              icon: Icons.bar_chart,
                              backgroundColor: Colors.white,
                              textColor: HexColor(Colorscommon.greencolor),
                              rankLabel: "Rank : ",
                              rankValue: dashboardData != null && dashboardData!.isNotEmpty
                                  ? "${dashboardData![1]['metrics'][0]['value']['weekly_rank_group_wise_city'] ?? '-'}"
                                  : '-',
                              rankLabelColor: HexColor(Colorscommon.greencolor),  // This sets the color of the rank label
                              rankValueColor: HexColor(Colorscommon.red),   // This sets the color of the rank value
                            ),
                          ),
                        ),
                        const SizedBox(width: 10), // Add consistent spacing between items
                        Expanded(
                          child: Container(
                            height: 150,  // Fixed height for consistency
                            child: _buildDashboardItem(
                              title: dashboardData![2]['title'],
                              icon: Icons.pie_chart,
                              backgroundColor: Colors.white,
                              textColor: HexColor(Colorscommon.greencolor),
                              rankLabel: "Rank : ",
                              rankValue: dashboardData != null && dashboardData!.length > 2
                                  ? "${dashboardData![2]['metrics'][0]['value']['monthly_rank_group_wise_city'] ?? '-'}"
                                  : '-',
                              rankLabelColor: HexColor(Colorscommon.greencolor),  // This sets the color of the rank label
                              rankValueColor: HexColor(Colorscommon.red),                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(20),  // Padding inside the container
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),  // Margin around the container
                    decoration: BoxDecoration(
                      color: Colors.white,  // Light background color
                      borderRadius: BorderRadius.circular(12),  // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),  // Light shadow for depth
                          blurRadius: 8,  // Shadow blur
                          offset: Offset(0, 4),  // Position of the shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Space between elements
                      crossAxisAlignment: CrossAxisAlignment.center,  // Aligns vertically in the center
                      children: [
                        // Icon on the left side
                        Icon(
                          Icons.emoji_events,
                          color: HexColor(Colorscommon.greencolor),
                          size: 40,  // Icon size
                        ),
                        SizedBox(width: 15),  // Space between icon and text
                        // Text on the right side
                        Expanded(
                          child: Text(
                            weeklyRankLag ?? 'No data available',  // Display weeklyRankLag or fallback text
                            style: TextStyle(
                              fontSize: 16,
                              color: HexColor(Colorscommon.greencolor),
                              fontWeight: FontWeight.bold,  // Bold text for emphasis
                            ),
                            softWrap: true,  // Ensure the text wraps if it's too long
                          ),
                        ),
                        // CircleAvatar outside the row but still aligned horizontally in the same row
                        Container(
                          margin: EdgeInsets.only(left: 10),  // Adds space between the text and circle
                          child: CircleAvatar(
                            radius: 40,  // Set the size of the circle
                            backgroundColor: Colors.orange,  // Circle color
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Group",  // Display the label "Group" on the first line
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,  // Adjust the font size for the label
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  groupValue ?? '-',  // Display the group value or a default value if null
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,  // Adjust the font size for the group value
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table with data
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
                      ],
                      color: Colors.white, // Same background color as the header box
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Scrollbar(
                     // Attach ScrollController explicitly
                      thumbVisibility: true,
                      radius: Radius.circular(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 15,
                          dataRowHeight: 50,
                          headingRowHeight: 50,
                          columns: [

                             DataColumn(
                              label: Text(
                                'Metrics',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: HexColor(Colorscommon.greencolor),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Flexible(
                                child: Text(
                                  dashboardData![0]['title'] ?? 'Daily',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: HexColor(Colorscommon.greencolor),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Flexible(
                                child: Text(
                                  dashboardData![1]['title'] ?? 'Weekly',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: HexColor(Colorscommon.greencolor),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Flexible(
                                child: Text(
                                  dashboardData![2]['title'] ?? 'Monthly',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: HexColor(Colorscommon.greencolor),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ],
                          rows: dashboardData != null
                              ? [
                            createDataRow(
                              'Sp Attendance',
                              dailyValue: formatDecimal(dashboardData![0]['metrics'][0]['value']['days_26_present']),
                              weeklyValue: formatDecimal(dashboardData![1]['metrics'][0]['value']['days_26_present']),
                              monthlyValue: formatDecimal(dashboardData![2]['metrics'][0]['value']['days_26_present']),
                            ),
                            createDataRow(
                              'OTA/OTD',
                              dailyValue: formatDecimal(dashboardData![0]['metrics'][0]['value']['ota_otd_100_percent']),
                              weeklyValue: formatDecimal(dashboardData![1]['metrics'][0]['value']['ota_otd_100_percent']),
                              monthlyValue: formatDecimal(dashboardData![2]['metrics'][0]['value']['ota_otd_100_percent']),
                            ),
                            createDataRow(
                              'Trips',
                              dailyValue: formatDecimal(dashboardData![0]['metrics'][0]['value']['trip_points']),
                              weeklyValue: formatDecimal(dashboardData![1]['metrics'][0]['value']['trip_points']),
                              monthlyValue: formatDecimal(dashboardData![2]['metrics'][0]['value']['trip_points']),
                            ),
                            createDataRow(
                              'Referral',
                              dailyValue: formatDecimal(dashboardData![0]['metrics'][0]['value']['referral']),
                              weeklyValue: formatDecimal(dashboardData![1]['metrics'][0]['value']['referral']),
                              monthlyValue: formatDecimal(dashboardData![2]['metrics'][0]['value']['referral']),
                            ),
                            createDataRow(
                              'Total Points',
                              dailyValue: formatDecimal(dashboardData![0]['metrics'][0]['value']['total_points']),
                              weeklyValue: formatDecimal(dashboardData![1]['metrics'][0]['value']['total_points']),
                              monthlyValue: formatDecimal(dashboardData![2]['metrics'][0]['value']['total_points']),
                            ),
                          ]


                              : [],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,  // Align items to start for a clean flow
                      children: [
                        LegendItem(
                          color: HexColor(Colorscommon.greenAppcolor), // Softer blue for a more professional look
                          text: attendanceLegend ?? 'N/A',
                          icon: Icons.check_circle_outline,
                        ),
                        SizedBox(height: 10),  // Reduced space for a more compact look
                        LegendItem(
                          color: HexColor(Colorscommon.greenAppcolor), // Softer green for a professional touch
                          text: otaOtdLegend ?? 'N/A',
                          icon: Icons.schedule,
                        ),
                        SizedBox(height: 10),
                        LegendItem(
                          color: HexColor(Colorscommon.greenAppcolor), // Softer orange, still neutral
                          text: tripPointsLegend ?? 'N/A',
                          icon: Icons.card_travel,
                        ),
                        SizedBox(height: 10),
                        LegendItem(
                          color: HexColor(Colorscommon.greenAppcolor), // Subtle red
                          text: referralLegend ?? 'N/A',
                          icon: Icons.group_add,
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Helper function to build each dashboard item with rank info inside
  Widget _buildDashboardItem({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required String rankLabel,
    required String rankValue,
    required Color rankLabelColor,  // New parameter for rank label color
    required Color rankValueColor,  // New parameter for rank value color
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dashboard Item Header (Title + Icon)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: textColor,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Divider(
            color: HexColor(Colorscommon.greenAppcolor),  // Assuming Colorscommon.greenAppcolor is a valid hex color string
            thickness: 1,
            indent: 15,
            endIndent: 15,
          ),
          // Rank Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rankLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,  // Apply bold to rank label
                        color: rankLabelColor,  // Apply the rank label color
                      ),
                    ),
                    Text(
                      rankValue,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: rankValueColor,  // Apply the rank value color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  DataRow createDataRow(String label, {required dynamic dailyValue, required dynamic weeklyValue, required dynamic monthlyValue}) {
    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          return (states.contains(MaterialState.selected)) ? Colors.blue.shade100 : Colors.transparent;
        },
      ),
      cells: [
        DataCell(
          Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              dailyValue,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              weeklyValue,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              monthlyValue,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ),
      ],

    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

String formatDecimal(dynamic value) {
  if (value == null) {
    return '-';
  }

  // Check if the value can be parsed as a decimal number
  double numberValue = double.tryParse(value.toString()) ?? 0.0;

  // If it's a whole number, return it as is (without decimals)
  if (numberValue == numberValue.toInt()) {
    return numberValue.toInt().toString();
  }

  // Otherwise, format the number to 2 decimal places
  return numberValue.toStringAsFixed(2);
}


class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;

  LegendItem({required this.color, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.0),  // Horizontal margin for clean spacing
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),  // Soft background color with reduced opacity for a subtle feel
        borderRadius: BorderRadius.circular(8),  // Rounded corners for a smooth, professional look
        border: Border.all(
          color: color.withOpacity(0.3),  // Light border for definition
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20.0,  // Slightly smaller icon for a formal appearance
            ),
            SizedBox(width: 10),  // Reduced space between icon and text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,  // Slightly smaller text size for a formal touch
                  fontWeight: FontWeight.w500,  // Medium weight for readability
                  color: Colors.black,  // Use black text for a more neutral and professional look
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomAppBarShape extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double h = rect.height;
    double w = rect.width;
    double curveHeight = rect.height / 2;
    var p = Path();
    p.lineTo(0, h - 20);
    p.quadraticBezierTo(w / 2, h, w, h - 20);
    p.lineTo(w, 0);
    p.close();
    return p;
  }
}
