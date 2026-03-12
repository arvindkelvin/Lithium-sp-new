import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BroadcastHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📜 Broadcast History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('broadcasts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final broadcasts = snapshot.data!.docs;

          if (broadcasts.isEmpty) {
            return Center(child: Text("No broadcasts yet."));
          }

          return ListView.builder(
            itemCount: broadcasts.length,
            itemBuilder: (context, index) {
              final data = broadcasts[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['message'] ?? ''),
                subtitle: Text("🕒 ${data['timestamp']?.toDate().toLocal() ?? 'Time not available'}"),
              );
            },
          );
        },
      ),
    );
  }
}
