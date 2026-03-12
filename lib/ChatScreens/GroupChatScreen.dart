import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  GroupChatScreen({required this.groupId, required this.groupName});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('messages')
        .add({
      'senderId': currentUser!.uid,
      'messageText': _messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  void _showGroupOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('groups').doc(widget.groupId).get(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            List members = snapshot.data!['members'];

            return Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Group Members", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: FutureBuilder<List<DocumentSnapshot>>(
                        future: Future.wait(
                          members.map((uid) =>
                              FirebaseFirestore.instance.collection('users').doc(uid).get()),
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return CircularProgressIndicator();
                          final userDocs = snapshot.data!;
                          return ListView.builder(
                            itemCount: userDocs.length,
                            itemBuilder: (ctx, index) {
                              var userData = userDocs[index].data() as Map<String, dynamic>?;
                              String uid = userDocs[index].id;

                              if (userData == null) {
                                return ListTile(title: Text(uid));
                              }

                              return ListTile(
                                title: Text(userData['username'] ?? userData['email'] ?? uid),
                                subtitle: Text(userData['email'] ?? ''),
                                trailing: uid != currentUser!.uid
                                    ? IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () => _confirmRemove(uid),
                                )
                                    : null,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Text("Add Members", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return CircularProgressIndicator();
                          var allUsers = snapshot.data!.docs;

                          return ListView(
                            children: allUsers.map((doc) {
                              var userData = doc.data() as Map<String, dynamic>;
                              String uid = userData['uid'];
                              String displayName = userData['username'] ?? userData['email'] ?? uid;

                              bool alreadyInGroup = members.contains(uid);

                              return ListTile(
                                title: Text(displayName),
                                subtitle: Text(userData['email'] ?? ''),
                                trailing: alreadyInGroup
                                    ? Icon(Icons.check, color: Colors.green)
                                    : IconButton(
                                  icon: Icon(Icons.person_add),
                                  onPressed: () => _addUserToGroup(uid),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addUserToGroup(String uid) async {
    DocumentReference groupRef = FirebaseFirestore.instance.collection('groups').doc(widget.groupId);
    await groupRef.update({
      'members': FieldValue.arrayUnion([uid])
    });

    Navigator.pop(context);
    _showGroupOptions(); // Refresh bottom sheet
  }

  void _confirmRemove(String uid) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Remove Member"),
        content: Text("Are you sure you want to remove this member from the group?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _removeMember(uid);
            },
            child: Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _removeMember(String uid) async {
    DocumentReference groupRef = FirebaseFirestore.instance.collection('groups').doc(widget.groupId);
    await groupRef.update({
      'members': FieldValue.arrayRemove([uid])
    });

    Navigator.pop(context);
    _showGroupOptions(); // Refresh bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        actions: [
          IconButton(icon: Icon(Icons.group), onPressed: _showGroupOptions),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var messages = snapshot.data.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    var message = messages[index].data();
                    bool isSentByMe = message['senderId'] == currentUser!.uid;

                    return Align(
                      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isSentByMe ? Colors.blue[300] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(message['messageText']),
                      ),
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
                Expanded(child: TextField(controller: _messageController)),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
