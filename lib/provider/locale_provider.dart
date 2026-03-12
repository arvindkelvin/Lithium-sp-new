import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/l10n/l10n.dart';
import 'package:flutter_application_sfdc_idp/languageslectionscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  late Locale _locale = Locale('en');
  LocaleProvider() {
    setup();
  }

  void setup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languagecode = await prefs.getString('languagecode') ?? 'en';
    print("$languagecode");
    _locale = Locale("$languagecode");
    notifyListeners();
  }

  void selectlanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("test$locale");
    prefs.setString("languagecode", "$locale");
    notifyListeners();
  }

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    // if (!L10n.all.contains(locale)) return;

    _locale = locale;
    selectlanguage();
    notifyListeners();
  }

  void clearLocale() {
    _locale = Locale("en");
    notifyListeners();
  }
}
