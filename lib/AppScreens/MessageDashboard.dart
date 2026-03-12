import 'package:flutter/material.dart';

import '../Colors.dart';
import '../CommonAppbar.dart';
import '../CommonColor.dart';
import '../Utility.dart';

class MessageDashboard extends StatelessWidget {
  Utility utility = Utility();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(Colorscommon.greenAppcolor),
        centerTitle: true,
        leading: Container(),
        title: Text(
          "Messages",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        shape: CustomAppBarShape(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100], // Light Green Gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            children: [
              _buildGridItem(context, "One-to-One", Icons.person, Colors.blue, OneToOnePage()),
              _buildGridItem(context, "Group Message", Icons.group, Colors.green, GroupMessagePage()),
              _buildGridItem(context, "Broadcast", Icons.campaign, Colors.orange, BroadcastPage()),
              _buildGridItem(context, "Details", Icons.info, Colors.red, DetailsPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy pages with styled AppBars
class OneToOnePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("One-to-One Messages"), backgroundColor: Colors.blue),
      body: Center(child: Text("One-to-One Messages", style: TextStyle(fontSize: 18))),
    );
  }
}

class GroupMessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Group Messages"), backgroundColor: Colors.green),
      body: Center(child: Text("Group Messages", style: TextStyle(fontSize: 18))),
    );
  }
}

class BroadcastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Broadcast Messages"), backgroundColor: Colors.orange),
      body: Center(child: Text("Broadcast Messages", style: TextStyle(fontSize: 18))),
    );
  }
}

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details"), backgroundColor: Colors.red),
      body: Center(child: Text("Details Page", style: TextStyle(fontSize: 18))),
    );
  }
}
