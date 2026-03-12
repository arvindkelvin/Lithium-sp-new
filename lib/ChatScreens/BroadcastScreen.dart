import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;



class BroadcastScreen extends StatefulWidget {
  @override
  _BroadcastScreenState createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  final TextEditingController messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? selectedFile;
  String? selectedFileType;
  bool isLoading = false;


  Timestamp? latestBroadcastTimestamp;

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  Set<String> selectedUserIds = {};
  bool selectAll = false;

  void filterSearchResults(String query) {
    List<Map<String, dynamic>> results = [];
    if (query.isEmpty) {
      results = allUsers;
    } else {
      results = allUsers.where((user) {
        final name = user['name']?.toLowerCase() ?? '';
        final email = user['email']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
    }

    setState(() {
      filteredUsers = results;

      // Reapply Select All if it's checked
      if (selectAll) {
        selectedUserIds = filteredUsers.map((u) => u['uid'].toString()).toSet();
      }
    });
  }

  /// 🔐 Save user's FCM token to Realtime DB
  Future<void> saveFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null && currentUser != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/${currentUser!.uid}");
      await ref.update({"fcmToken": token});
    }
  }

  Future<void> fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();
    List<Map<String, dynamic>> users = snapshot.docs
        .map((doc) => {'uid': doc.id, ...doc.data()})
        .where((user) => user['uid'] != currentUser!.uid)
        .toList();

    setState(() {
      allUsers = users;
      filteredUsers = users;
    });
  }


  /// 📤 Upload media file to server (PHP)
  Future<String?> uploadMediaFile(File file, String fileType) async {
    try {
      String userId = currentUser!.uid;
      String fileName = path.basename(file.path);

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("https://thinkproduct.thinksynq.in/whatsappint/file.php"),
      );

      request.fields["senderId"] = userId;
      request.fields["receiverId"] = "broadcast";
      request.fields["file_type"] = fileType;
      request.files.add(await http.MultipartFile.fromPath("file", file.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        String fileUrl = "https://thinkproduct.thinksynq.in/whatsappint/" + jsonResponse["file_url"];
        print("✅ File uploaded successfully: $fileUrl");
        return fileUrl;
      } else {
        print("❌ Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Upload error: $e");
    }
    return null;
  }

  Future<void> sendPushNotification(
      String receiverToken,
      String message, {
        String? mediaUrl,
        String? mediaType,
      }) async {
    try {
      String title = "📢 New Broadcast";
      String body = message.isNotEmpty
          ? message
          : (mediaType == "image"
          ? "📷 Image"
          : mediaType == "video"
          ? "🎥 Video"
          : "📎 File");

      await sendFcmNotification(
        token: receiverToken,
        title: title,
        body: body,
        imageUrl: mediaType == 'image' ? mediaUrl : null, // Only images show in FCM notifications
      );
    } catch (e) {
      print("❌ Push notification error: $e");
    }
  }

  Future<void> sendFcmNotification({
    required String token,
    required String title,
    required String body,
    String? imageUrl,
  }) async {
    try {
      final jsonString = await rootBundle.loadString('assets/sfdc-idp-2e342-firebase-adminsdk-bpamz-e6d2464dba.json');
      final serviceAccount = ServiceAccountCredentials.fromJson(jsonDecode(jsonString));

      final client = await clientViaServiceAccount(serviceAccount, [
        'https://www.googleapis.com/auth/firebase.messaging',
      ]);

      const projectId = 'sfdc-idp-2e342';
      final messagePayload = {
        "message": {
          "token": token,
          "notification": {
            "title": title,
            "body": body,
            if (imageUrl != null) "image": imageUrl,
          },
          "android": {
            "notification": {
              if (imageUrl != null) "image": imageUrl,
            },
          },
          "apns": {
            "payload": {
              "aps": {
                "alert": {
                  "title": title,
                  "body": body,
                },
                if (imageUrl != null) "mutable-content": 1,
              },
            },
            if (imageUrl != null)
              "fcm_options": {
                "image": imageUrl,
              },
          }
        }
      };

      final url = Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send');
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(messagePayload),
      );

      if (response.statusCode == 200) {
        print('✅ Notification sent!');
      } else {
        print('❌ Failed to send notification. Status Code: ${response.statusCode}');
        final responseBody = jsonDecode(response.body);
        print('🔍 Response: ${jsonEncode(responseBody)}');

        final details = responseBody['error']?['details'];
        if (details != null) {
          for (var detail in details) {
            if (detail['errorCode'] == 'UNREGISTERED') {
              print('🗑 Removing invalid token: $token');
              // TODO: Remove token from your Firebase DB or PHPMyAdmin
            }
          }
        }
      }
    } catch (e) {
      print("🚨 Notification sending failed: $e");
    }
  }



  Future<void> sendBroadcastMessage() async {
    setState(() => isLoading = true);

    String message = messageController.text.trim();
    String? uploadedMediaUrl;

    // Upload file if selected
    if (selectedFile != null && selectedFileType != 'location') {
      uploadedMediaUrl = await uploadMediaFile(selectedFile!, selectedFileType!);
    }

    if (message.isEmpty && uploadedMediaUrl == null) {
      setState(() => isLoading = false);
      return;
    }

    // Save broadcast metadata
    final broadcastRef = await _firestore.collection('broadcasts').add({
      'message': message,
      'mediaUrl': uploadedMediaUrl,
      'mediaType': selectedFileType,
      'timestamp': FieldValue.serverTimestamp(),
      'senderId': currentUser!.uid,
      'recipients': selectedUserIds.toList(), // ✅ Store recipient list
    });

    final broadcastSnapshot = await broadcastRef.get();
    final ts = broadcastSnapshot['timestamp'] as Timestamp?;

    setState(() {
      latestBroadcastTimestamp = ts;
    });

    // Prepare the list of notifications to send to users
    List<Future> notificationFutures = [];

    for (var userId in selectedUserIds) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final data = userDoc.data();

      if (data == null || data['fcmToken'] == null) continue;

      final token = data['fcmToken'].toString();
      if (token.isNotEmpty) {
        // Add the sendPushNotification call to the list of futures
        notificationFutures.add(
          sendPushNotification(
            token,
            message,
            mediaUrl: uploadedMediaUrl,
            mediaType: selectedFileType,
          ).then((_) async {
            // Save message for delivery tracking after the notification is sent
            await _firestore.collection('messages').add({
              'text': message,
              'senderId': currentUser!.uid,
              'receiverId': userId,
              'timestamp': FieldValue.serverTimestamp(),
              'participants': [currentUser!.uid, userId],
              'isBroadcast': true,
              'delivered': true,
              'mediaUrl': uploadedMediaUrl,
              'mediaType': selectedFileType,
            });
          }),
        );
      }
    }

    // Wait for all notification futures to complete (sending notifications simultaneously)
    await Future.wait(notificationFutures);


    setState(() {
      isLoading = false;
      selectedFile = null;
      selectedFileType = null;
      messageController.clear();
      selectedUserIds.clear(); // Clear the selected users (checkboxes)
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("📢 Broadcast sent to selected users")),
    );
  }



  Future<void> pickFile(String type) async {
    if (type != 'image' && type != 'video') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Only image and video files are allowed")),
      );
      return;
    }
    FilePickerResult? result;

    if (type == 'image') {
      result = await FilePicker.platform.pickFiles(type: FileType.image);
    } else if (type == 'video') {
      result = await FilePicker.platform.pickFiles(type: FileType.video);
    }
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result!.files.single.path!);
        selectedFileType = type;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    saveFCMToken();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(title: Text("📢 Broadcast Message")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (selectedFile != null) ...[
                Text("📎 Selected: ${path.basename(selectedFile!.path)}"),
                SizedBox(height: 8),
              ],
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Enter your broadcast message",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.image),
                    label: Text("Image"),
                    onPressed: () => pickFile('image'),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.videocam),
                    label: Text("Video"),
                    onPressed: () => pickFile('video'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: isLoading ? CircularProgressIndicator(color: Colors.white) : Icon(Icons.send),
                label: isLoading ? Text("Sending...") : Text("Send to All Users"),
                onPressed: isLoading ? null : sendBroadcastMessage,
              ),
              SizedBox(height: 10),

              // 📋 Card for User List (with fixed height and scrollable)
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Search users...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: filterSearchResults,
                      ),
                      // ✅ Select All Option (Placed at the top inside the card)
                      CheckboxListTile(
                        title: Text("Select All"),
                        value: selectAll,
                        onChanged: (bool? value) {
                          setState(() {
                            selectAll = value ?? false;
                            if (selectAll) {
                              selectedUserIds = filteredUsers
                                  .map((user) => user['uid'].toString())
                                  .toSet();
                            } else {
                              selectedUserIds.clear();
                            }
                          });
                        },
                      ),
                      Container(
                        height: 200, // Fixed height for the scrollable content area
                        child: SingleChildScrollView( // Make the user list scrollable
                          child: Column(
                            children: [
                              // 👤 User List
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = filteredUsers[index];
                                  final isSelected = selectedUserIds.contains(user['uid']);

                                  return CheckboxListTile(
                                    title: Text(user['email'] ?? 'Unnamed User'),
                                    subtitle: Text("UID: ${user['uid']}"),
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedUserIds.add(user['uid']);
                                        } else {
                                          selectedUserIds.remove(user['uid']);
                                        }

                                        selectAll = selectedUserIds.length == filteredUsers.length;
                                      });
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // 📬 Card for Delivery Status (with fixed height and scrollable)
              if (!isKeyboardVisible) ...[
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Delivery Status",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 300, // Fixed height for the card
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                latestBroadcastTimestamp == null
                                    ? Center(child: Text("No broadcast messages sent yet."))
                                    : StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('messages')
                                      .where('senderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                      .where('isBroadcast', isEqualTo: true)
                                      .where('timestamp', isGreaterThanOrEqualTo: latestBroadcastTimestamp)
                                      .orderBy('timestamp', descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(child: CircularProgressIndicator());
                                    }

                                    final messages = snapshot.data!.docs;
                                    if (messages.isEmpty) {
                                      return Center(child: Text("No recent broadcast deliveries."));
                                    }

                                    // Calculate the total number of users selected and the delivered count
                                    final deliveredUsers = <String>{}; // Set to track unique users who received the broadcast
                                    for (var message in messages) {
                                      final data = message.data() as Map<String, dynamic>;
                                      if (data['delivered'] == true) {
                                        deliveredUsers.add(data['receiverId']);
                                      }
                                    }

                                    final selectedUserCount = selectedUserIds.length;
                                    final deliveredCount = deliveredUsers.length;
                                    final progress = selectedUserCount > 0 ? deliveredCount / selectedUserCount : 0;

                                    return Column(
                                      children: [
                                        // Progress Summary
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              LinearProgressIndicator(
                                                value: progress.toDouble(),
                                                backgroundColor: Colors.grey[300],
                                                color: Colors.green,
                                                minHeight: 8,
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "$deliveredCount / $selectedUserCount delivered",
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        // List of Broadcast Messages
                                        Container(
                                          height: 250,  // Fixed height for the container
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: messages.length,
                                            itemBuilder: (context, index) {
                                              final data = messages[index].data() as Map<String, dynamic>;
                                              final isDelivered = data['delivered'] == true;

                                              return Card(
                                                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                child: ListTile(
                                                  leading: CircleAvatar(
                                                    backgroundColor: isDelivered
                                                        ? Colors.green.shade100
                                                        : Colors.orange.shade100,
                                                    child: Icon(
                                                      isDelivered ? Icons.check_circle : Icons.hourglass_bottom,
                                                      color: isDelivered ? Colors.green : Colors.orange,
                                                    ),
                                                  ),
                                                  title: Text(data['text'] ?? 'No message'),
                                                  subtitle: Text("To: ${data['receiverId']}"),
                                                  trailing: Text(
                                                    isDelivered ? "Delivered" : "Pending",
                                                    style: TextStyle(
                                                      color: isDelivered ? Colors.green : Colors.orange,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )

                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]

            ],
          ),
        ),
      ),
    );
  }

}
