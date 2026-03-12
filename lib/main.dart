import 'dart:async';
import 'dart:io';
//import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_sfdc_idp/AppScreens/Languagepick.dart';
import 'package:flutter_application_sfdc_idp/l10n/l10n.dart';
import 'package:flutter_application_sfdc_idp/Login.dart';
import 'package:flutter_application_sfdc_idp/provider/locale_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppScreens/Earnings/Dashboardtabbar.dart';
import 'ChatScreens/AuthScreen.dart';
import 'Colors.dart';
import 'CommonColor.dart';
import 'Networkconnection.dart';
import 'l10n/app_localizations.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); //--
}

final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>(debugLabel: "navigator");

void main() async {

  HttpOverrides.global = MyHttpOverrides();
 // MyConnectivity.instance.initialise();

  // debugPaintSizeEnabled = true;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize connectivity monitoring
  //Get.put(NetworkController(), permanent: true);

  await Firebase.initializeApp();
  FirebaseMessaging firebaseFCM = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.instance.getInitialMessage();

  var initializationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      final String? payload = response.payload;

      if (payload != null && payload.isNotEmpty) {
        var notifytsqid = payload.substring(payload.indexOf(':') + 3);

        print("flutterLocalNotification payload = $payload");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('fromnotify', true);

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => const MyTabPage(
              selectedtab: 2,
              title: '',
            ),
          ),
        );
      } else {
        print("No data in flutterLocalNotificationsPlugin payload");
      }
    },
  );

  firebaseFCM.getToken().then((token) {
    assert(token != null);
  });
  String token;
  token = (await firebaseFCM.getToken())!;
  print("fcm token =  $token");
  if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
  if (Platform.isAndroid) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? apple = message.notification?.apple;
    if (Platform.isAndroid) {
      if (notification != null && android != null && message.data != null) {
        print("push onMessage = ${notification.body.toString()}");

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title, // Title of our notification
            notification.body, // Body of our notification
            const NotificationDetails(
                android: AndroidNotificationDetails("1", "tsq",
                    channelDescription: "tsq FIDO reports",
                    importance: Importance.high,
                    priority: Priority.high,
                    //styleInformation: BigTextStyleInformation("null"),
                    largeIcon:
                    DrawableResourceAndroidBitmap('@mipmap/ic_launcher')),
                iOS: DarwinNotificationDetails()),
            // payload: message.data["view"]);
            payload: notification.body.toString());
        // String? data = notification.title;
        // print("notification data = $data");
      }
    } else if (Platform.isIOS) {
      if (notification != null && apple != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title, // Title of our notification
            notification.body, // Body of our notification
            const NotificationDetails(
                android: AndroidNotificationDetails(
                  "1",
                  "tsq",
                ),
                iOS: DarwinNotificationDetails()),
            payload: message.data["view"]);
      }
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title, // Title of our notification
        notification?.body, // Body of our notification
        const NotificationDetails(
            android: AndroidNotificationDetails("1", "tsq",
                channelDescription: "tsq FIDO reports",
                importance: Importance.high,
                priority: Priority.high,
                styleInformation: BigTextStyleInformation(""),
                largeIcon:
                DrawableResourceAndroidBitmap('@mipmap/ic_launcher')),
            iOS: DarwinNotificationDetails()),
        payload: notification?.body);

    navigatorKey.currentState?.push(
      MaterialPageRoute(
          builder: (_) => const MyTabPage(
            selectedtab: 2,
            title: '',
          )),
    );
  });
  FirebaseMessaging.onBackgroundMessage((message) async {
    await Firebase.initializeApp();

    RemoteNotification? notification = message.notification;

    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.title, // Title of our notification
        notification?.body, // Body of our notification
        const NotificationDetails(
            android: AndroidNotificationDetails("1", "tsq",
                channelDescription: "tsq FIDO reports",
                importance: Importance.high,
                priority: Priority.high,
                styleInformation: BigTextStyleInformation(""),
                largeIcon:
                DrawableResourceAndroidBitmap('@mipmap/ic_launcher')),
            iOS: DarwinNotificationDetails()),
        payload: notification?.body);

    navigatorKey.currentState?.push(
      MaterialPageRoute(
          builder: (_) => const MyTabPage(
            selectedtab: 2,
            title: '',
          )),
    );
  });

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool languagestatus = false;


  getdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var statusbool = prefs.getBool('selectlanguagestatus') ?? false;
    if (statusbool == null || statusbool == false) {
      languagestatus = false;
    } else {
      languagestatus = true;
    }
  }

  MaterialColor _createMaterialColor(Color color) {
    List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
    Map<int, Color> swatch = <int, Color>{};
    final int primary = color.value;
    for (int i = 0; i < 10; i += 1) {
      swatch[strengths[i]!] = Color(primary & 0xFF000000 | (primary & 0x00FFFFFF) + 0x01000000 * i);
    }
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => LocaleProvider(),
    builder: (context, child) {
      getdata();
      final provider = Provider.of<LocaleProvider>(context);
      print(provider.locale);
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        // title: title,
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   textSelectionTheme: TextSelectionThemeData(
        //       selectionHandleColor: HexColor(Colorscommon.greenlight)),
        // ),
        theme: ThemeData(
          useMaterial3: false, // 👈 Disable Material 3
          primarySwatch: _createMaterialColor(HexColor(Colorscommon.greendark2)),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: HexColor(Colorscommon.greendark2), // Set the cursor color here
            selectionHandleColor: HexColor(Colorscommon.greendark2), // Set the handle color here
          ),

          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(HexColor(Colorscommon.greendark2)), // Scrollbar thumb color
            //trackColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)),
            trackColor: WidgetStateProperty.all(Colors.white), // Scrollbar track color
            thickness: WidgetStateProperty.all(2.0), // Scrollbar thickness
          ),

        ),
        locale: provider.locale,
        supportedLocales: L10n.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Visibility(
          visible: languagestatus == false,
          child: languagepicker(),
          replacement: Login(),
        ),
      );
    },
  );
}