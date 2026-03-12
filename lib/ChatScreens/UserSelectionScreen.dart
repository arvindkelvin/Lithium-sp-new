import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'AuthScreen.dart';
import 'BroadcastDetailScreen.dart';
import 'BroadcastScreen.dart';
import 'ChatScreen.dart';
import 'GroupChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController groupNameController = TextEditingController();
  List<String> selectedUsers = [];
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  TextEditingController groupSearchController = TextEditingController();
  String groupSearchQuery = '';

  void _createGroupChat() async {
    if (groupNameController.text.isEmpty || selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter a group name and select at least one member."),
      ));
      return;
    }

    selectedUsers.add(currentUser!.uid);

    DocumentReference groupRef = await FirebaseFirestore.instance.collection('groups').add({
      'groupName': groupNameController.text,
      'members': selectedUsers,
      'createdBy': currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupChatScreen(groupId: groupRef.id, groupName: groupNameController.text),
      ),
    );
  }

  void _showCreateGroupDialog() {
    TextEditingController searchController = TextEditingController();
    String searchQuery = "";
    bool selectAll = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Create Group"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: groupNameController,
                  decoration: InputDecoration(labelText: "Enter Group Name"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search Users",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').snapshots(),
                    builder: (ctx, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      var users = snapshot.data.docs;

                      var filteredUsers = users.where((user) {
                        var username = user.data()['username'].toString().toLowerCase();
                        return username.contains(searchQuery);
                      }).toList();

                      return Column(
                        children: [
                          if (filteredUsers.isNotEmpty)
                            CheckboxListTile(
                              title: Text("Select All"),
                              value: filteredUsers.every((user) => selectedUsers.contains(user.id)),
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected == true) {
                                    for (var user in filteredUsers) {
                                      if (!selectedUsers.contains(user.id)) {
                                        selectedUsers.add(user.id);
                                      }
                                    }
                                  } else {
                                    for (var user in filteredUsers) {
                                      selectedUsers.remove(user.id);
                                    }
                                  }
                                });
                              },
                            ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredUsers.length,
                              itemBuilder: (ctx, index) {
                                var userData = filteredUsers[index].data();
                                var userId = filteredUsers[index].id;

                                if (userId == currentUser!.uid) return Container();

                                return CheckboxListTile(
                                  title: Text(userData['username']),
                                  value: selectedUsers.contains(userId),
                                  onChanged: (bool? selected) {
                                    setState(() {
                                      if (selected == true) {
                                        selectedUsers.add(userId);
                                      } else {
                                        selectedUsers.remove(userId);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
              ElevatedButton(onPressed: _createGroupChat, child: Text("Create")),
            ],
          );
        });
      },
    );
  }

  void _confirmDeleteGroup(String groupId, String groupName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Group"),
        content: Text("Are you sure you want to delete the group '$groupName'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await FirebaseFirestore.instance.collection('groups').doc(groupId).delete();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Group deleted.")));
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteChat(String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Chat"),
        content: Text("Are you sure you want to delete chat with this user?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _deleteChatWithUser(userId);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Chat deleted.")));
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteChatWithUser(String userId) async {
    final messages = await FirebaseFirestore.instance
        .collection('messages')
        .where('participants', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var doc in messages.docs) {
      if (doc['participants'].contains(userId)) {
        await FirebaseFirestore.instance.collection('messages').doc(doc.id).delete();
      }
    }
  }


  // Function to build media preview based on media type (image, video, etc.)
  Widget _buildMediaPreview(String mediaUrl, String mediaType) {
    if (mediaType.startsWith('image')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          mediaUrl,
          height: 120,
          width: 120,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child; // Display the image once it's fully loaded
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.error, color: Colors.red); // Fallback if image fails to load
          },
        ),
      );
    } else if (mediaType.startsWith('video')) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoWebViewScreen(videoUrl: mediaUrl),
            ),
          );
        },
        child: Text(
          '📹 Tap to view video',
          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
        ),
      );
    }
    else if (mediaType.startsWith('audio')) {
      return Container(
        height: 60,
        width: double.infinity,
        color: Colors.green[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.audiotrack, size: 30, color: Colors.green),
            SizedBox(width: 10),
            Text('Audio: Tap to play', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    } else {
      return Container(
        height: 60,
        width: double.infinity,
        color: Colors.grey[200],
        child: Center(
          child: Icon(Icons.insert_drive_file, size: 32, color: Colors.grey),
        ),
      );
    }
  }

  final List<String> adminEmails = [
    'admin@gmail.com',
    'lithbng4784@gmail.com',
  ];



  @override
  Widget build(BuildContext context) {
    //final isAdmin = currentUser?.email == 'admin@gmail.com';
    //final isAdmin = adminEmails.contains(currentUser?.email);
    final isAdmin = adminEmails.contains(currentUser?.email);


    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          if (isAdmin)
            IconButton(
              icon: Icon(Icons.group_add),
              onPressed: _showCreateGroupDialog,
            ),
          if (isAdmin)
            IconButton(
              icon: Icon(Icons.speaker_group),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BroadcastScreen()),
                );
              },
            ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Show Broadcast only for non-admins
          if (!isAdmin)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('broadcasts')
                  .orderBy('timestamp', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                  return Container(); // Return empty if no data is found
                }

                var broadcast = snapshot.data.docs.first;
                String mediaUrl = broadcast['mediaUrl'] ?? ''; // Fetch mediaUrl
                String mediaType = broadcast['mediaType'] ?? ''; // Fetch mediaType

                return GestureDetector(
                  onTap: () {
                    // On tap, show the BroadcastDetailScreen with dynamic mediaUrl and mediaType
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BroadcastDetailScreen(
                          message: broadcast['message'] ?? "No message",
                          timestamp: (broadcast['timestamp'] as Timestamp).toDate(),
                          mediaUrl: mediaUrl,  // Pass the dynamic mediaUrl
                          mediaType: mediaType,  // Pass the dynamic mediaType
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.yellow[100],
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.campaign, color: Colors.orange),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Check if the broadcast message exists and display it
                              if (broadcast['message'] != null && broadcast['message'].toString().trim().isNotEmpty)
                                Text(
                                  "📢 Admin Broadcast: ${broadcast['message']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18, // Adjust the font size
                                    color: Colors.black, // Set text color to black for better contrast
                                  ),
                                ),
                              // Check if there is a media URL, and if so, display the media preview
                              if (mediaUrl.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: _buildMediaPreview(mediaUrl, mediaType), // Display media preview
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox(); // or a loading indicator

              var userData = snapshot.data!.data() as Map<String, dynamic>;
              bool canMessageAdmin = userData['canMessageAdmin'] ?? false;

              if (!canMessageAdmin) return SizedBox();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          senderId: currentUser!.uid,
                          receiverId: "XrjKbRBi4cR6XIFGmUfnfs1YxBj1",
                          receiverName: userData['username'] ?? 'User',
                          receiverFcmToken:"dqL-Ry_mRwCTJqOJUrKy_C:APA91bHPw4YBg3nIQtI0A5fkrqggE8c-Jfy2WB3EmbRLI9kYMsKXesjEHfc5YX7OHSWUgCBdtrq2pQyCTckJxKsptBiQLB3hI_ufjBmcxAhM5wg7dfRC2mo",

                        ),
                      ),
                    );
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ChatScreen(
                    //       senderId: currentUser!.uid,
                    //       receiverId: 'Adminuid', // Replace with actual
                    //       receiverName: 'Admin',
                    //       receiverFcmToken: 'adminFcmToken', // Replace with actual
                    //     ),
                    //   ),
                    // );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.admin_panel_settings, color: Colors.white),
                      ),
                      title: Text(
                        "Chat with Admin",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Start direct chat with the admin"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                ),
              );
            },
          ),


          // Show search and list of users for non-admins
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Users...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

          // List of users for non-admins
          if (isAdmin)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading users'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No users found'));
                  }

                  var users = snapshot.data!.docs;

                  // Filter out current user and apply search query
                  var filteredUsers = users.where((userDoc) {
                    var userData = userDoc.data() as Map<String, dynamic>;
                    var username = userData['username']?.toString().toLowerCase() ?? '';
                    return userDoc.id != currentUser!.uid && username.contains(searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (ctx, index) {
                      var userDoc = filteredUsers[index];
                      var userId = userDoc.id;
                      var userData = userDoc.data() as Map<String, dynamic>;
                      var canMessageAdmin = userData['canMessageAdmin'] ?? false;

                      return ListTile(
                        title: Text(userData['username'] ?? 'No name'),
                        subtitle: Text("Email: ${userData['email'] ?? 'N/A'}"),
                        trailing: Switch(
                          value: canMessageAdmin,
                          onChanged: (bool value) async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .update({'canMessageAdmin': value});
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to update: $e')),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          if (canMessageAdmin) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  senderId: currentUser!.uid,
                                  receiverId: userId,
                                  receiverName: userData['username'] ?? 'User',
                                  receiverFcmToken: userData['fcmToken'] ?? '',
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('This user cannot message the admin.')),
                            );
                          }
                        },
                        onLongPress: () => _confirmDeleteChat(userId),
                      );
                    },
                  );
                },
              ),
            ),


          Divider(),

          // Show search and list of groups for non-admins
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: groupSearchController,
                decoration: InputDecoration(
                  hintText: 'Search Groups...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (value) {
                  setState(() {
                    groupSearchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

          // List of groups for non-admins
          if (isAdmin)
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('groups').snapshots(),
                builder: (ctx, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                  var groups = snapshot.data.docs.where((group) {
                    var groupName = group['groupName'].toString().toLowerCase();
                    return groupName.contains(groupSearchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (ctx, index) {
                      var groupData = groups[index].data();
                      var groupId = groups[index].id;

                      return ListTile(
                        title: Text(groupData['groupName']),
                        subtitle: Text("Members: ${groupData['members'].length}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupChatScreen(groupId: groupId, groupName: groupData['groupName']),
                            ),
                          );
                        },
                        onLongPress: () => _confirmDeleteGroup(groupId, groupData['groupName']),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}




class VideoWebViewScreen extends StatelessWidget {
  final String videoUrl;

  const VideoWebViewScreen({Key? key, required this.videoUrl}) : super(key: key);

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
