import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:geolocator/geolocator.dart';

import '../Colors.dart';
import '../CommonColor.dart';
import 'SentImagesScreen.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String senderId;
  final String receiverFcmToken; // Add this

  ChatScreen({
    required this.receiverId,
    required this.receiverName,
    required this.senderId,
    required this.receiverFcmToken,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  bool _isTyping = false;
  Timer? _typingTimer;
  final user = FirebaseAuth.instance.currentUser;
  String? receiverId;
  List<Map<String, dynamic>> mediaFiles = [];
  Timer? _mediaFetchTimer; // ✅ Timer for fetching media

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_updateTypingStatus);
    // ✅ Start periodic media fetching
    _mediaFetchTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchMediaFiles();
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_updateTypingStatus);
    _setTypingStatus(false);
    _messageController.dispose();
    _mediaFetchTimer?.cancel(); // ✅ Stop timer when chat is closed

    super.dispose();
  }

  Future<void> saveFCMToken() async {
    try {
      // Get a fresh token from Firebase Messaging
      String? token = await FirebaseMessaging.instance.getToken();

      // Only proceed if token is valid and the user is logged in
      if (token != null && FirebaseAuth.instance.currentUser != null) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userId");

        // Update the FCM token in the database
        await ref.update({"fcmToken": token});
        print("✅ FCM token updated for user $userId");
      }
    } catch (e) {
      print("❌ Error updating FCM token: $e");
    }
  }



  String _getFileType(String fileName) {
    List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    List<String> videoExtensions = ['mp4', 'avi', 'mov', 'mkv', 'flv'];
    List<String> documentExtensions = [
      'pdf',
      'doc',
      'docx',
      'txt',
      'xls',
      'xlsx',
      'ppt',
      'pptx'
    ];

    String extension = fileName.split('.').last.toLowerCase();

    if (imageExtensions.contains(extension)) {
      return "image";
    } else if (videoExtensions.contains(extension)) {
      return "video";
    } else if (documentExtensions.contains(extension)) {
      return "document";
    } else {
      return "unknown"; // Default if type is unknown
    }
  }

  Future<void> fetchMediaFiles() async {
    try {
      final response = await http.get(
        Uri.parse("https://thinkproduct.thinksynq.in/whatsappint/getfiles.php"),
      );
      //  "http://10.10.14.14/john/whatsappint/getfiles.php"
      //   https://thinkproduct.thinksynq.in/whatsappint/getfiles.php

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "success") {
          List<Map<String, dynamic>> fetchedFiles =
              List<Map<String, dynamic>>.from(data["users"]);

          // ✅ Filter only sender & receiver media files
          List<Map<String, dynamic>> filteredFiles = fetchedFiles
              .where((file) =>
                  (file["user_id"] == user!.uid &&
                      file["recivedid"] == widget.receiverId) ||
                  (file["user_id"] == widget.receiverId &&
                      file["recivedid"] == user!.uid))
              .toList();

          // ✅ Update UI using setState
          setState(() {
            mediaFiles = filteredFiles;
          });
        }
      }
    } catch (e) {
      print("🚨 Error fetching media files: $e");
    }
  }

  Future<void> uploadFileToServer(File file, String fileType) async {
    try {
      String userId = user!.uid;
      String fileName = path.basename(file.path);

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://thinkproduct.thinksynq.in/whatsappint/file.php"),
      );

      //https://thinkproduct.thinksynq.in/whatsappint/file.php
      //http://10.10.14.14/john/whatsappint/file.php

      request.fields["senderId"] = userId;
      request.fields["receiverId"] = widget.receiverId;
      request.files.add(await http.MultipartFile.fromPath("file", file.path));
      request.fields["file_type"] = fileType;
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        String fileUrl = jsonResponse["file_url"];

        fetchMediaFiles();
        getMessagesWithMedia();

        print("✅ File uploaded successfully: $fileUrl");

        // ✅ Send push notification with media preview
        sendPushNotification(
          widget.receiverFcmToken,
          "", // Empty message for media-only notifications
          mediaUrl: fileUrl,
          mediaType: fileType,
        );
      } else {
        print("❌ Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Error uploading file: $e");
    }
  }

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileName = path.basename(file.path);
      String userId = FirebaseAuth.instance.currentUser!.uid;

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://thinkproduct.thinksynq.in/whatsappint/file.php"), // Change to your API URL
      );

      request.fields["user_id"] = userId;
      request.files.add(await http.MultipartFile.fromPath("file", file.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        if (jsonResponse["success"] == true) {
          String fileUrl = jsonResponse["file_url"];

          // ✅ Save file details in Firebase Realtime Database
          DatabaseReference ref =
              FirebaseDatabase.instance.ref("messages").push();
          await ref.set({
            "senderId": userId,
            "receiverId": receiverId,
            // Change accordingly
            "fileUrl": fileUrl,
            "fileType": jsonResponse["file_type"],
            // 'image', 'video', 'document'
            "timestamp": ServerValue.timestamp,
          });

          print("✅ File uploaded successfully: $fileUrl");
        } else {
          print("❌ Upload failed: ${jsonResponse["message"]}");
        }
      } else {
        print("❌ Server error: ${response.statusCode}");
      }
    }
  }

  void _setTypingStatus(bool isTyping) async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'typingStatus': isTyping,
      });
    }
  }

  void _updateTypingStatus() {
    if (_messageController.text.isNotEmpty) {
      if (!_isTyping) {
        _setTypingStatus(true); // ✅ Set typing to true
        setState(() => _isTyping = true);
      }

      // ✅ Reset timer every time the user types
      _typingTimer?.cancel();
      _typingTimer = Timer(Duration(seconds: 3), () {
        if (_messageController.text.isEmpty) {
          _setTypingStatus(false);
          setState(() => _isTyping = false);
        }
      });
    } else {
      _setTypingStatus(false);
      setState(() => _isTyping = false);
    }
  }

  Future<void> sendMessage(
      String senderId, String receiverId, String messageText) async {
    if (messageText.trim().isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'messageText': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _setTypingStatus(false);
      _messageController.clear();

      // ✅ Send push notification for text
      sendPushNotification(widget.receiverFcmToken, messageText);
    } catch (e) {
      print("❌ Error sending message: $e");
    }
  }

  Future<void> sendPushNotification(String receiverToken, String message,
      {String? mediaUrl, String? mediaType}) async {
    try {
      final jsonString = await rootBundle.loadString(
          'assets/sfdc-idp-2e342-firebase-adminsdk-bpamz-e6d2464dba.json');
      final serviceAccount =
          ServiceAccountCredentials.fromJson(jsonDecode(jsonString));

      final client = await clientViaServiceAccount(
        serviceAccount,
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      const String projectId =
          "sfdc-idp-2e342"; // Replace with your Firebase Project ID
      final Uri url = Uri.parse(
          "https://fcm.googleapis.com/v1/projects/$projectId/messages:send");

      Map<String, dynamic> notificationBody = {
        "title": "Admin chat",
        "body": message.isNotEmpty
            ? message
            : (mediaType == "image"
            ? "📷 Image"
            : mediaType == "video" ? "🎥 Video" : "📍 Location"),
      };

      Map<String, dynamic> messageData = {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "type": mediaType ?? "text",
        "message": message,
      };

      // ✅ Add media URL if available
      if (mediaUrl != null) {
        messageData["mediaUrl"] = mediaUrl;
      }

      var body = jsonEncode({
        "message": {
          "token": receiverToken,
          "notification": notificationBody,
          "data": messageData,
          "android": {
            "notification": {
              "sound": "default",
              "image": mediaType == "image" ? mediaUrl : null,
              // ✅ Show image preview on Android
            }
          },
          "apns": {
            "payload": {
              "aps": {
                "sound": "default",
                "mutable-content": 1, // Required for rich notifications on iOS
              }
            },
            "fcm_options": {
              "image": mediaType == "image" ? mediaUrl : null,
              // ✅ Show image preview on iOS
            }
          }
        }
      });

      var response = await client.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: body);

      print("📨 Notification Sent: ${response.body}");
      if (response.statusCode == 200) {
        print("✅ Push notification sent successfully!");
      } else {
        print(
            "❌ Failed to send notification. Status Code: ${response.statusCode}");
        print("🔍 Response: ${response.body}");
      }
    } catch (e) {
      print("❌ Error sending notification: $e");
    }
  }



  Future<void> pickFileAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileName = path.basename(file.path);
      String fileType = _getFileType(fileName);

      // ✅ Show Preview Before Uploading
      _showFilePreview(file, fileType);
    }
  }



// Fetch and send the location
//   Future<void> fetchAndSendLocation() async {
//     try {
//       // Get current location
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       double latitude = position.latitude;
//       double longitude = position.longitude;
//
//       // Ensure that location data is valid
//       if (latitude != null && longitude != null) {
//         print("✅ Fetched location: $latitude, $longitude");
//
//         // Send location as a message or media
//         await sendLocationToServer(latitude, longitude);
//       } else {
//         print("🚨 Invalid location data received.");
//       }
//     } catch (e) {
//       print("🚨 Error fetching location: $e");
//     }
//   }

// Send the location to the server and send a push notification
  Future<void> sendLocationToServer(double latitude, double longitude) async {
    try {
      String userId = user!.uid;
      String locationMessage = "Location: Lat: $latitude, Long: $longitude";

      // Send the location message as normal text
      await sendMessage(userId, widget.receiverId, locationMessage);

      // Send push notification with the location as text
      sendPushNotification(
        widget.receiverFcmToken,
        "📍 Location Shared: $locationMessage",
      );
    } catch (e) {
      print("🚨 Error sending location: $e");
    }
  }

// Function to launch Google Maps with the given latitude and longitude
  void launchGoogleMaps(double latitude, double longitude) async {
    final String googleMapsUrl = 'https://www.google.com/maps?q=$latitude,$longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      print("🚨 Could not open Google Maps");
    }
  }


  Future<void> pickImageAndUpload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);

      // ✅ Show Preview Before Uploading
      _showFilePreview(file, "image");
    }
  }

  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open $url");
    }
  }

  void showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.image, color: HexColor(Colorscommon.greencolor)),
              title: Text("Image"),
              onTap: () {
                Navigator.pop(context);
                pickImageAndUpload();
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library, color: HexColor(Colorscommon.greencolor)),
              title: Text("Video"),
              onTap: () {
                Navigator.pop(context);
                pickVideoAndUpload();
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: HexColor(Colorscommon.greencolor)),
              title: Text("Send Location"),
              onTap: () {
                Navigator.pop(context);
              //  fetchAndSendLocation(); // Fetch and send location
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> pickVideoAndUpload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      File file = File(video.path);

      // ✅ Show Preview Before Uploading
      _showFilePreview(file, "video");
    }
  }

  void _showFilePreview(File file, String fileType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Preview"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (fileType == "image") // ✅ Show Image Preview
                Image.file(file, width: 250, fit: BoxFit.cover),
              if (fileType == "video") // ✅ Show Video Preview
                Icon(Icons.videocam, size: 100, color: Colors.green),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: HexColor(Colorscommon.greencolor))),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      uploadFileToServer(file, fileType);
                    },
                    child: Text("Upload", style: TextStyle(color: HexColor(Colorscommon.red))),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getMessagesWithMedia() async {
    List<Map<String, dynamic>> mediaMessages = [];
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final response = await http.get(Uri.parse(
          "http://thinkproduct.thinksynq.in//whatsappint/getfiles.php"));
      https: //thinkproduct.thinksynq.in/whatsappint/file.php

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "success") {
          List<Map<String, dynamic>> mediaFiles =
              List<Map<String, dynamic>>.from(data["users"]);

          // ✅ Correct filter for media messages in chat screen
          for (var file in mediaFiles) {
            if ((file["user_id"] == currentUserId &&
                    file["recivedid"] == widget.receiverId) ||
                (file["user_id"] == widget.receiverId &&
                    file["recivedid"] == currentUserId)) {
              mediaMessages.add({
                "senderId": file["user_id"],
                "receiverId": file["recivedid"],
                "fileUrl": file["file_url"],
                "fileType": file["file_type"],
                "timestamp": file["uploaded_at"]?.toString() ??
                    DateTime.now().toIso8601String(),
              });
            }
          }
        }
      } else {
        print("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Error fetching media messages: $e");
    }

    print("📸 Retrieved Media Messages: $mediaMessages");
    return mediaMessages;
  }

  Stream<List<Map<String, dynamic>>> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('messages')
        .where(Filter.or(
          Filter.and(
            Filter('senderId', isEqualTo: user!.uid),
            Filter('receiverId', isEqualTo: widget.receiverId),
          ),
          Filter.and(
            Filter('senderId', isEqualTo: widget.receiverId),
            Filter('receiverId', isEqualTo: user!.uid),
          ),
        ))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(child: Text("User not signed in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: fetchMessagesAndMediaStream(), // ✅ Fetch messages + media
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // return Center(child: Text(""));
                  return Center(child: CircularProgressIndicator());
                }

                var messagesAndMedia = snapshot.data!;

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.receiverId)
                      .snapshots(),
                  builder: (ctx, typingSnapshot) {
                    bool isReceiverTyping = false;
                    if (typingSnapshot.hasData && typingSnapshot.data!.exists) {
                      var userData =
                          typingSnapshot.data!.data() as Map<String, dynamic>;
                      isReceiverTyping = userData['typingStatus'] ?? false;
                    }

                    return ListView.builder(
                      reverse: true,
                      itemCount:
                          messagesAndMedia.length + (isReceiverTyping ? 1 : 0),
                      itemBuilder: (ctx, index) {
                        if (index == 0 && isReceiverTyping) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Typing...",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54),
                              ),
                            ),
                          );
                        }

                        var item = messagesAndMedia[
                            index - (isReceiverTyping ? 1 : 0)];
                        return buildMessageWidget(item);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: HexColor(Colorscommon.greencolor)),
                  onPressed: showAttachmentOptions,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Enter message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: HexColor(Colorscommon.greencolor)),
                  onPressed: () => sendMessage(
                      user!.uid, widget.receiverId, _messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        return DateTime.now();
      }
    } else {
      return DateTime.now();
    }
  }

  Stream<List<Map<String, dynamic>>> fetchMessagesAndMediaStream() {
    // ✅ Real-time Firestore messages
    Stream<List<Map<String, dynamic>>> textMessagesStream = FirebaseFirestore
        .instance
        .collection('messages')
        .where(Filter.or(
          Filter.and(
            Filter('senderId', isEqualTo: user!.uid),
            Filter('receiverId', isEqualTo: widget.receiverId),
          ),
          Filter.and(
            Filter('senderId', isEqualTo: widget.receiverId),
            Filter('receiverId', isEqualTo: user!.uid),
          ),
        ))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());

    // ✅ Periodically fetch MySQL media messages
    Future<List<Map<String, dynamic>>> fetchMediaMessages() async {
      List<Map<String, dynamic>> mediaMessages = [];
      try {
        final response = await http.get(Uri.parse(
            "https://thinkproduct.thinksynq.in/whatsappint/getfiles.php"));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data["status"] == "success") {
            List<Map<String, dynamic>> mediaFiles =
                List<Map<String, dynamic>>.from(data["users"]);

            for (var file in mediaFiles) {
              if ((file["user_id"] == user!.uid &&
                      file["recivedid"] == widget.receiverId) ||
                  (file["user_id"] == widget.receiverId &&
                      file["recivedid"] == user!.uid)) {
                mediaMessages.add({
                  "senderId": file["user_id"],
                  "receiverId": file["recivedid"],
                  "fileUrl": file["file_url"],
                  "fileType": file["file_type"] ?? "image",
                  "timestamp": file["uploaded_at"]?.toString() ??
                      DateTime.now().toIso8601String(),
                  "type": "media",
                });
              }
            }
          }
        }
      } catch (e) {
        print("🚨 Error fetching media messages: $e");
      }
      return mediaMessages;
    }

    return textMessagesStream.asyncMap((textMessages) async {
      List<Map<String, dynamic>> mediaMessages = await fetchMediaMessages();

      // ✅ Add a "type" field to distinguish between text and media
      for (var message in textMessages) {
        message['type'] = 'text';
      }

      // ✅ Merge text and media messages
      List<Map<String, dynamic>> allMessages = [
        ...textMessages,
        ...mediaMessages
      ];

      // ✅ Sort messages by timestamp (newest first)
      allMessages.sort((a, b) {
        DateTime timeA = parseTimestamp(a['timestamp']);
        DateTime timeB = parseTimestamp(b['timestamp']);
        return timeB.compareTo(timeA);
      });

      return allMessages;
    });
  }

  Widget buildMessageWidget(Map<String, dynamic> message) {
    bool isSentByMe =
        message['senderId'] == FirebaseAuth.instance.currentUser!.uid;
    String type = message['type'] ?? "text"; // "text" or "media"
    String formattedTime = DateFormat('hh:mm a • dd MMM')
        .format(parseTimestamp(message['timestamp']));

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.blue[300] : Colors.grey[300],

          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Check if it's a media message
            if (type == "media") ...[
              if (message['fileType'] == "image")
                // Show Image Preview
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImagePreviewScreen(imageUrl: message['fileUrl']),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      message['fileUrl'], // Load image URL
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey);
                      },
                    ),
                  ),
                ),
              if (message['fileType'] == "video")
                // Show Video Thumbnail and Play Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoWebViewScreen(videoUrl: message['fileUrl']),
                      ),
                    );
                  },
                  child: Text(
                    '📹 Tap to view video',
                    style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline),
                  ),
                ),
            ],

            // If it's a text message, show the message text
            if (type == "text" && message['messageText'] != null)
              Text(message['messageText'], style: TextStyle(fontSize: 16)),

            SizedBox(height: 5),
            // Show timestamp
            Text(formattedTime,
                style: TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  ImagePreviewScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Preview")),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
    );
  }
}

class VideoWebViewScreen extends StatelessWidget {
  final String videoUrl;

  const VideoWebViewScreen({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      // body: WebView(
      //   initialUrl: videoUrl,
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
    );
  }
}
