import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ta'),
    const Locale('te'),
    const Locale('mr'),
    const Locale('hi'),
    const Locale('kn'),
  ];
  static String getFlag(String code) {
    switch (code) {
      case 'ta':
        return 'தமிழ்';
      case 'hi':
        return 'हिंदी';
      case 'te':
        return 'తెలుగు';
      case 'en':
        return 'English';
      case 'mr':
        return 'मराठी';
      case 'kn':
        return 'ಕನ್ನಡ';

      default:
        return 'English';
    }
  }
}
