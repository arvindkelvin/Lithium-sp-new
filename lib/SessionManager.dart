import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String userid = "userid";
  final String serveruuid = "serveruuid";
  final String lithiumid = "lithiumid";
  final String clientid = "clientid";
  final String refreshtokken = "refreshtokken";
  final String accesstokken = "accesstokken";
  final String weburl = "weburl";
  final String password = "password";
  final String state = "state";
  final String sp_username = "sp_username";
  final String psw_encrypt = "psw_encrypt";
  final String mobile_no = "mobile_no";
  final String email_id = "email_id";
  final String city = "city";
  final String campus = "campus";
  final String firstlogin = "firstlogin";
  final String _30minsend = "_30minsend";
  final String service_provider_c = "service_provider_c";
  final String mobileuser = "mobileuser";

  Future<String> getmobileuser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String mobileuser;
    mobileuser = (pref.getString("mobileuser"))!;
    return mobileuser;
  }

  Future<void> setmobileuser(String authToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(mobileuser, authToken);
  }

  Future<String> getspid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String serviceProviderC;
    serviceProviderC = (pref.getString("service_provider_c"))!;
    return serviceProviderC;
  }

  Future<void> setspiod(String authToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(service_provider_c, authToken);
  }

  Future<String> get30mins() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String minsend;
    minsend = (pref.getString(_30minsend))!;
    return minsend;
  }

  Future<void> set30mins(String authToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_30minsend, authToken);
  }

  Future<void> setfirstlogin(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(firstlogin, lastsync);
  }

  Future<String?> getfirstlogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? firstlogin;
    firstlogin = pref.getString(this.firstlogin);

    return firstlogin;
  }

  Future<void> setmobile_no(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(mobile_no, lastsync);
  }

  Future<String?> getmobile_no() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? mobileNo;
    mobileNo = pref.getString(mobile_no);

    return mobileNo;
  }

  Future<void> setemail_id(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(email_id, lastsync);
  }

  Future<String?> getemail_id() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? emailId;
    emailId = pref.getString(email_id);

    return emailId;
  }

  Future<void> setcity(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(city, lastsync);
  }

  Future<String?> getcity() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? emailId;
    emailId = pref.getString(city);

    return emailId;
  }

  Future<void> setcampus(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(campus, lastsync);
  }

  Future<String?> getcampus() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? emailId;
    emailId = pref.getString(campus);

    return emailId;
  }

  Future<void> setlithiumid(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(lithiumid, lastsync);
  }

  Future<String?> getlithiumid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? lithiumid;
    lithiumid = pref.getString(this.lithiumid);

    return lithiumid;
  }

  Future<void> setsp_username(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(sp_username, lastsync);
  }

  Future<String?> getsp_username() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? spUsername;
    spUsername = pref.getString(sp_username);

    return spUsername;
  }

  Future<void> setpsw_encrypt(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(psw_encrypt, lastsync);
  }

  Future<String?> getpsw_encrypt() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? pswEncrypt;
    pswEncrypt = pref.getString(psw_encrypt);

    return pswEncrypt;
  }


  Future<bool> internetcheck() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; // No network at all
    }

    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }




  Future<void> setpassword(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(password, lastsync);
  }

  Future<String?> getpassword() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? password;
    password = pref.getString(this.password);

    return password;
  }

  Future<void> settoken(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(accesstokken, lastsync);
  }

  Future<String?> gettoken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? accesstokken;
    accesstokken = pref.getString(this.accesstokken);

    return accesstokken;
  }

  Future<String?> getrefreshtoken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? refreshtokken;
    refreshtokken = pref.getString(this.refreshtokken);

    return refreshtokken;
  }

  Future<void> setrefreshtoken(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(refreshtokken, lastsync);
  }

  Future<String?> getserverstate() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? serverstate;
    serverstate = pref.getString(state);

    return serverstate;
  }

  Future<void> setserverstate(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(state, lastsync);
  }

  Future<String?> getuuid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? uuid;
    uuid = pref.getString(serveruuid);

    return uuid;
  }

  Future<String?> getuserid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userid;
    userid = pref.getString(this.userid);
    return userid;
  }

  Future<void> setuserid(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userid, lastsync);
  }

  Future<void> setuuid(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(serveruuid, lastsync);
  }

  Future<void> setweburl(String lastsync) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(weburl, lastsync);
  }

  Future<String?> getweburl() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? weburl;
    weburl = pref.getString(this.weburl);
    print("weburl$weburl");

    return weburl;
  }


  final String imageKey = "image";

  // Save image string to SharedPreferences
  Future<void> setImage(String image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(imageKey, image);
  }

  // Retrieve image string from SharedPreferences
  Future<String?> getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(imageKey);
  }



}
