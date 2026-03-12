import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../Utility.dart';
import 'UserSelectionScreen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {


  final String _defaultPassword = 'pass@123';


  Utility utility = Utility();
  var username = "";
  var spusername = "";

  @override
  void initState() {
    super.initState();
    utility.GetUserdata().then((value) {
      print(utility.lithiumid.toString());
      print(utility.city.toString());
      print(utility.campus.toString());

      username = utility.lithiumid;
      spusername = utility.mobileuser;

      _loginOrCreateWithUtilityData(); // 🔁 Perform login/create based on lithiumid

      setState(() {});
    });
  }

  // 🔁 Auto login or create based on lithiumid
  Future<void> _loginOrCreateWithUtilityData() async {
    setState(() {
    });

    final email = "${utility.lithiumid}@gmail.com";
    final password = _defaultPassword;
    final city = utility.city;
    final campus = utility.campus;

    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      UserCredential userCredential;

      try {
        // Try to create user
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': utility.lithiumid,
          'email': email,
          'mobile': utility.mobileuser,
          'city': city,
          'campus': campus,
          'uid': userCredential.user!.uid,
          'fcmToken': fcmToken,
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // If exists, login
          userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).update({
            'fcmToken': fcmToken,
            'city': city,
            'campus': campus,
          });
        } else {
          rethrow;
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserSelectionScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auth Error: ${e.toString()}")),
      );
    }

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Just show loading
      ),
    );
  }

}
