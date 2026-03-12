// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Earnings.dart';
import 'package:flutter_application_sfdc_idp/Colors.dart';
import 'package:flutter_application_sfdc_idp/CommonColor.dart';
import 'package:flutter_application_sfdc_idp/Utility.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/URL.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'CommonAppbar.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie_audio/chewie_audio.dart';

import 'l10n/app_localizations.dart';

class Localnotifications extends StatefulWidget {
  const Localnotifications({
    Key? key,
  }) : super(key: key);

  @override
  State<Localnotifications> createState() => _LocalnotificationsState();
}

class _LocalnotificationsState extends State<Localnotifications>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Utility utility = Utility();
  var userid;
  bool isloading = true;
  List<dynamic> _mediaList = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    utility.GetUserdata().then((_) => {
      // sessionManager.internetcheck().then((internet) async {
      //   if (internet) {
          userid = utility.lithiumid.toString(),
          Future.delayed(const Duration(seconds: 5)),
          utility.showspeedteststatus(context),
          setState(() {
            getnoficationlist(userid);
          }),
      //   } else {
      //     showTopSnackBar(
      //       context,
      //       const CustomSnackBar.error(
      //         message: "Please Check Your Internet Connection",
      //       ),
      //     );
      //   }
      // }),
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void updateNotification(String messageid) async {
    String url = CommonURL.URL;

    Map<String, String> postdata = {
      "from": "updateNotification",
      "id": messageid,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);

    isloading = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);

      String status = jsonInput['status'].toString();

      if (status == 'true') {
        getnoficationlist(userid);
      }
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.somethingwentwrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    setState(() {});
  }
  void getnoficationlist(String userid) async {
    String url = CommonURL.URL;

    Map<String, String> postdata = {
      "from": "getNotificationListBySP",
      "lithiumID": userid,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/hal+json',
      'Accept': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(postdata), headers: requestHeaders);
    isloading = false;
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonInput = jsonDecode(response.body);
      print("get notification jsonInput = $jsonInput");

      String status = jsonInput['status'].toString();

      if (status == 'true') {
        utility.showspeedteststatus(context);
        _mediaList = jsonInput["data"];
      }
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context)!.somethingwentwrong,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: HexColor(Colorscommon.greenAppcolor),
            centerTitle: true,
            leading: Container(),
            title: const Text(
              "Messages",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: CustomAppBarShape(),
          ),
        ),
        body: isloading
            ? Center(
          child: CircularProgressIndicator(
            color: HexColor(Colorscommon.greencolor),
          ),
        ) : (_mediaList.isNotEmpty)
            ? ListView.builder(
            itemCount: _mediaList.length,
            itemBuilder: (BuildContext context, int index) {

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                elevation: 3,
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  backgroundColor: Colors.white,
                  title: _buildTitle(
                      _mediaList[index]["title"]
                          .toString(),
                      _mediaList[index]["read_status"]
                          .toString()),
                  trailing: const SizedBox(),
                  onExpansionChanged: (bool val) {

                    if (_mediaList[index]["read_status"].toString() == "0") {
                      updateNotification(_mediaList[index]["id"].toString());
                    }
                  },
                  children: <Widget>[
                    Column(
                      children: [
                        // Inside children of ExpansionTile
                        Visibility(
                          visible: (_mediaList[index]["notificationimage"].toString() != "null" &&
                              _mediaList[index]["notificationimage"].toString() != ""),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width - 30,
                              height: 250,
                              child: Image.network(
                                CommonURL.imgURL + _mediaList[index]["notificationimage"].toString(),
                                fit: BoxFit.cover,
                              ),
                            ),

                        ),





                        // Visibility(
                        //   visible: (_mediaList[index]["notificationimage"].toString() != "null" && _mediaList[index]["notificationimage"].toString() != ""),
                        //   child: SizedBox(
                        //     width: MediaQuery.of(context).size.width - 20,
                        //     height: 150,
                        //     child: Image.network(CommonURL.imgURL + _mediaList[index]["notificationimage"].toString()),
                        //   ),
                        // ),

                        // video
                        Visibility(
                          visible: _mediaList[index]["notificationvideo"].toString() != "null" &&
                              _mediaList[index]["notificationvideo"].toString() != "",
                          child: VideoPlayerScreen(url: '${CommonURL.audiovideoURL}${_mediaList[index]['notificationvideo']}'),
                        ),

                        //audio
                        Visibility(
                          visible: _mediaList[index]["notificationaudio"].toString() != "null" &&
                              _mediaList[index]["notificationaudio"].toString() != "",
                          child: AudioPlayerWidget(url: '${CommonURL.audiovideoURL}${_mediaList[index]['notificationaudio']}'),
                        ),

                        //text
                        Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Text(
                              _mediaList[index]["message"]
                                  .toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: 'TomaSans-Regular',
                                  color: HexColor(
                                      Colorscommon.blackcolor)),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  ],
                ),
              );
            })
            : Center(
          child: Text(
            'No Data Available',
            style: TextStyle(
                color: HexColor(Colorscommon.redcolor),
                fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String tiltstr, String colorsstr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              Icons.mail,
              color: colorsstr == "0"
                  ? HexColor(Colorscommon.grey_low)
                  : HexColor(Colorscommon.greencolor),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                tiltstr,
                style: const TextStyle(
                  fontFamily: 'AvenirLTStd-Book',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                maxLines: 4, // Limits the text to 2 lines
                overflow: TextOverflow.ellipsis, // Adds "..." if the text overflows
              ),
            ),
          ],
        ),
      ],
    );
  }


// Widget _buildTitle(String tiltstr, String colorsstr) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Row(
  //         children: <Widget>[
  //           Icon(
  //             Icons.mail,
  //             color: colorsstr == "0"
  //                 ? HexColor(Colorscommon.grey_low)
  //                 : HexColor(Colorscommon.greencolor),
  //           ),
  //           const SizedBox(
  //             width: 10,
  //           ),
  //           Text(
  //             tiltstr,
  //             style: const TextStyle(
  //                 fontFamily: 'AvenirLTStd-Book',
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 17),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
}

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  AudioPlayerWidget({required this.url});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  ChewieAudioController? _chewieAudioController;
  late VideoPlayerController _AudioPlayerController;

  @override
  void initState() {
    super.initState();
    _AudioPlayerController = VideoPlayerController.network(widget.url);
    _chewieAudioController = ChewieAudioController(
      videoPlayerController: _AudioPlayerController,
      autoPlay: false,
      looping: false,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _AudioPlayerController.dispose();
    _chewieAudioController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ChewieAudio(
        controller: _chewieAudioController!,
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  void _initVideoPlayer() {
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: true,
      allowFullScreen: true,
      allowMuting: true,
      autoInitialize: true,
      // placeholder: Container(
      //   color: Colors.grey[300],
      // ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 16/10,
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}