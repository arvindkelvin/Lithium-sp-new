import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import '../Colors.dart';
import '../CommonAppbar.dart';
import '../CommonColor.dart';
import '../URL.dart';
import '../l10n/app_localizations.dart';


class DriverPledgeScreen extends StatefulWidget {
  @override
  _DriverPledgeScreenState createState() => _DriverPledgeScreenState();
}

class _DriverPledgeScreenState extends State<DriverPledgeScreen> {
  final TextEditingController socController = TextEditingController();
  final List<TextEditingController> odometerControllers = List.generate(6, (index) => TextEditingController());
  bool isStarted = false;
  bool isSubmitted = false;

  String vehicleCheck = '';
  String wellRested = '';
  String feelingTired = '';
  List<String> selectedPromises = [];
  File? img1;
  File? img3;
  final picker = ImagePicker();
  String? imgname = 'Verify your face';
  bool isImageCaptured = false;
  bool isImageCaptured2 = false;
  bool isCheckingSimilarity = false;


  void _onChanged(String value) {
    // Close the keyboard if the input length is 3
    if (value.length == 3) {
      FocusScope.of(context).unfocus(); // This will close the keyboard
    }
    setState(() {});
  }

  autoCaptureImage1(int index) async {
    try {
      List<CameraDescription> cameras = await availableCameras();
      CameraDescription? backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      if (backCamera != null) {
        final CameraController controller = CameraController(
          backCamera,
          ResolutionPreset.max,
        );
        await controller.initialize();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 400.0,
                        width: double.infinity,
                        child: CameraPreview(controller),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          XFile? imageFile = await controller.takePicture();
                          if (imageFile != null) {
                            setState(() {
                              if (index == 1) {
                                img1 = File(imageFile.path);
                              }
                              if (index == 2) {
                                img3 = File(imageFile.path);
                              }
                            });
                            Navigator.pop(context);
                           // await performImage();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Failed to capture image");
                            print('Failed to capture image');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Capture Image',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        Fluttertoast.showToast(msg: "No back camera available");
        print('No back camera available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
      Fluttertoast.showToast(msg: "Error initializing camera");
    }
  }

  Future<void> performImage() async {
    try {
      if (img1 != null) {
        setState(() {
          isImageCaptured = true;
        });
      }
      if (img3 != null) {
        setState(() {
          isImageCaptured2 = true;
        });
      }
    } catch (e) {
      print('Error during face matching: $e');
    } finally {
      if (mounted) {
        setState(() {
          isCheckingSimilarity = false;
        });
      }
    }
  }

  Future<String> generateTempImagePath() async {
    Directory tempDir = await getTemporaryDirectory();
    return '${tempDir.path}/temp_image.jpg';
  }



  Future<void> handleSubmit() async {
    if (!isFormComplete) return;

    setState(() {
      isSubmitted = true;
      // clearImage();
    });

    String odometerValue = getOdometerValue();
    List<Map<String, dynamic>> promises = selectedPromises.map((promise) {
      int id = selectedPromises.indexOf(promise) + 1;
      return {"id": id, "description": promise};
    }).toList();

    showLoadingDialog();

    var formData = {
      'from': 'pretripsspcheckinonline',
      'lithiumid': 'lithbng4444',
      'soc': socController.text,
      'odometer': odometerValue,
      'inspectvehilce': vehicleCheck == 'Y' ? '1' : '0',
      'feelingwell': wellRested == 'Y' ? '1' : '0',
      'feelingtired': feelingTired == 'Y' ? '1' : '0',
      'latitude': '12.85958',
      'longtitude': '13.9484',
      'promise': jsonEncode(promises),
    };
 print("All data ==>>$formData");
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(CommonURL.localone),
      );

      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'multipart/form-data';

      formData.forEach((key, value) {
        request.fields[key] = value;
      });

      print("All data ==>>$img1");


      if (img1 != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'socimage',
            img1!.path,
          ),
        );
      }



      if (img3 != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'odometerimage',
            img3!.path
          ),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      Navigator.of(context).pop(); // Close the loading dialog

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(responseBody);
        if (responseData['status'] == true) {
          showCustomDialog(
            context: context,
            title: 'Success',
            message: responseData['message'],
            icon: Icons.check_circle,
            iconColor: Colors.green, // Path to your Lottie animation
          );
        } else {
          showCustomDialog(
            context: context,
            title: 'Submission Failed',
            message: 'Submission failed: ${responseData['message']}',
            icon: Icons.error,
            iconColor: Colors.red,// Path to your Lottie animation
          );
        }
      } else {
        showCustomDialog(
          context: context,
          title: 'Server Error',
          message: 'Server error: ${response.statusCode}',
          icon: Icons.error,
          iconColor: Colors.red,
          // Path to your Lottie animation
        );
      }
    } catch (e) {
      print("Error: $e");
      Navigator.of(context).pop(); // Close the loading dialog
      showCustomDialog(
        context: context,
        title: 'Error',
        message: 'Error: $e',
        icon: Icons.error,
        iconColor: Colors.red,
        // Path to your Lottie animation
      );
    }

    setState(() {
      // Clear all input fields
      socController.clear();
      img1 = null;
      img3 = null;
      odometerControllers.forEach((controller) => controller.clear());
      vehicleCheck = '';
      wellRested = '';
      feelingTired = '';
      selectedPromises.clear();
      isStarted = false; // Hide the form and show the Start button again
    });
  }

  void clearImage() {
    setState(() {
      img1 = null; // or img1 = File(''); depending on your implementation
      img3 = null; // or img3 = File('');
    });
  }


  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCustomDialog({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: iconColor),
              SizedBox(
                width: 40,
                height: 40,

              ),
              SizedBox(width: 8),
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
      animationType: DialogTransitionType.slideFromBottomFade,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  void _handleOdometerChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }

    // Close the keyboard automatically when the user finishes entering the last value
    if (value.length == 1 && index == 5) {
      FocusScope.of(context).unfocus(); // Unfocus to close the keyboard
    }

    setState(() {});
  }


  String getOdometerValue() {
    return odometerControllers.map((controller) => controller.text).join('');
  }

  bool get isFormComplete {
    String odometerValue = getOdometerValue();
    bool allPromisesSelected = selectedPromises.length == 5; // 5 promises in total
    return socController.text.isNotEmpty &&
        odometerValue.length == 6 &&
        vehicleCheck.isNotEmpty &&
        wellRested.isNotEmpty &&
        feelingTired.isNotEmpty ;
    //&&
        // allPromisesSelected &&
        // socImage != null &&
        // odometerImage != null;
  }

  Widget buildCheckboxTile(String title) {
    bool isChecked = selectedPromises.contains(title); // Check if this promise is selected

    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isChecked ? Colors.green.withOpacity(0.1) : Colors.white, // Change background color based on checked state
        ),
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (isChecked) {
                selectedPromises.remove(title);
              } else {
                selectedPromises.add(title);
              }
            });
          },
          child: Row(
            children: [
              // Custom checkbox (using Icon)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isChecked ? Colors.green : Colors.transparent,
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: isChecked
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : SizedBox.shrink(), // Empty box when not selected
              ),
              SizedBox(width: 10), // Space between checkbox and title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: isChecked ? Colors.green : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Navigator.pop(context, true);
          return false;
        },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: HexColor(Colorscommon.greenAppcolor),
            centerTitle: true,
            leading: Container(),
            title: Column(
              children: [
                Text(
                  "Driver pledge",
                  //AppLocalizations.of(context)!.plannedtrips,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lato',
                    fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                        AppLocalizations.of(context)!.id == "आयडी" ||
                        AppLocalizations.of(context)!.id == "ಐಡಿ")
                        ? 15
                        : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(
                //   "(" + utility.Todaystr + ")",
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontFamily: 'Lato',
                //     fontSize: (AppLocalizations.of(context)!.id == "ஐடி" ||
                //         AppLocalizations.of(context)!.id == "आयडी" ||
                //         AppLocalizations.of(context)!.id == "ಐಡಿ")
                //         ? 15
                //         : 18,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
            shape: CustomAppBarShape(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Center(
                  child: Icon(
                    Icons.directions_car_rounded,
                    color: Colors.teal,
                    size: 100,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'As a driver, I pledge:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                if (isStarted) ...[
                  // SOC Input
                  Text(
                    '1. Please enter the current state of charge (SOC%) of your vehicle:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15.0), // More rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 5), // Shadow position
                ),
              ],
            ),
            child: TextField(
              controller: socController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(3), // Limit input to 3 characters
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0), // Match the container's border radius
                  borderSide: BorderSide(color: Colors.teal, width: 2.0), // Border color and width
                ),
                hintText: 'Enter End SOC',
                hintStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Padding inside the TextField
                prefixIcon: Icon(Icons.battery_full, color: Colors.green), // Icon for visual appeal
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  int parsedValue = int.parse(value);

                  if (parsedValue > 100) {
                    // Show a toast message
                    Fluttertoast.showToast(
                      msg: "End SOC cannot exceed 100",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    // Reset the controller's text to 100
                    socController.text = '100';
                    socController.selection = TextSelection.fromPosition(
                      TextPosition(offset: socController.text.length),
                    );
                  }
                }

                // Check if value is exactly 2 digits (excluding "10") or exactly 3 digits
                if ((value.length == 2 && value != "10") || value.length == 3) {
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => autoCaptureImage1(1),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), backgroundColor: Colors.teal, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      elevation: 3, // Subtle elevation for depth
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Makes button size wrap its content
                      children: [
                        Icon(
                          img1 == null ? Icons.camera_alt_outlined : Icons.refresh, // Smaller icons
                          size: 18, // Smaller icon size
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Small space between icon and text
                        Text(
                          img1 == null ? 'Take Image' : 'Retake', // Shorter text for compact size
                          style: TextStyle(fontSize: 14, color: Colors.white), // Smaller text size
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Odometer Input
                  Text(
                    '2. Please enter the current odometer reading (in kilometers):',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 40,
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(8.0), // Rounded corners

                        ),
                        child: TextField(
                          controller: odometerControllers[index],
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0), // Match the container's border radius
                              borderSide: BorderSide(color: Colors.teal, width: 2.0), // Border color and width
                            ),
                            counterText: '',
                           // hintText: '*', // Optional hint or symbol
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
                          ),
                          onChanged: (value) => _handleOdometerChanged(value, index),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => autoCaptureImage1(2),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), backgroundColor: Colors.teal, // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      elevation: 3, // Subtle elevation for depth
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Makes button size wrap its content
                      children: [
                        Icon(
                          img3 == null ? Icons.camera_alt_outlined : Icons.refresh, // Smaller icons
                          size: 18, // Smaller icon size
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Small space between icon and text
                        Text(
                          img3 == null ? 'Take Image' : 'Retake', // Shorter text for compact size
                          style: TextStyle(fontSize: 14, color: Colors.white), // Smaller text size
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Vehicle Inspection Question
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3. Have you inspected your vehicle overall before the trip begins? [Y/N]',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10), // Add space between question and options
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'Y',
                          groupValue: vehicleCheck,
                          activeColor: Colors.green, // Custom color for selected radio
                          onChanged: (value) {
                            setState(() {
                              vehicleCheck = value!;
                            });
                          },
                        ),
                        Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'N',
                          groupValue: vehicleCheck,
                          activeColor: Colors.red, // Custom color for selected radio
                          onChanged: (value) {
                            setState(() {
                              vehicleCheck = value!;
                            });
                          },
                        ),
                        Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
                  SizedBox(height: 10),

                  // Well Rested Question
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '4. Are you feeling well rested? [Y/N]',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10), // Add space between question and options
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'Y',
                          groupValue: wellRested,
                          activeColor: Colors.green, // Custom color for selected radio
                          onChanged: (value) {
                            setState(() {
                              wellRested = value!;
                            });
                          },
                        ),
                        Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'N',
                          groupValue: wellRested,
                          activeColor: Colors.red, // Custom color for selected radio
                          onChanged: (value) {
                            setState(() {
                              wellRested = value!;
                            });
                          },
                        ),
                        Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
                  SizedBox(height: 10),

                  // Feeling Tired Question
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '5. Are you feeling tired/sleepy? [Y/N]',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10), // Add space between question and options
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'Y',
                          groupValue: feelingTired,
                          activeColor: Colors.green, // Custom color for selected radio
                          onChanged: (value) {
                            setState(() {
                              feelingTired = value!;
                            });
                          },
                        ),
                        Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'N',
                          groupValue: feelingTired,
                          activeColor: Colors.red, // Custom color for selected radio
                          onChanged: (value) {
                            setState(() {
                              feelingTired = value!;
                            });
                          },
                        ),
                        Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
                  SizedBox(height: 20),

                  // Promises Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Padding around the section
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '6. I Promise to:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10), // Add space between the title and checkboxes
                Column(
                  children: [
                    buildCheckboxTile('Wear the seat belt'),
                    buildCheckboxTile('Follow traffic rules'),
                    buildCheckboxTile('Be polite to passengers'),
                    buildCheckboxTile('Keep your vehicle in clean/safe condition'),
                    buildCheckboxTile('Drive responsibly and safely'),
                  ],
                ),
              ],
            ),
          ),

                  SizedBox(height: 10),
                  if (isFormComplete && !isSubmitted)
                    Center(
                      child: ElevatedButton(
                        onPressed: handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),


                ],
                // SizedBox(height:10),
                if (!isStarted) // Show Start button only if not started
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isStarted = true;
                          isSubmitted = false; // Reset submission status

                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), backgroundColor: Colors.teal, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                        elevation: 3, // Subtle elevation for depth
                      ),
                      child: Text(
                        'Start',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}


