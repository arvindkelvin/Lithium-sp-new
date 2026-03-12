import 'package:flutter/material.dart';
import 'package:flutter_application_sfdc_idp/widget/language_picker_widget.dart';

class selectlanguage extends StatefulWidget {
  @override
  State<selectlanguage> createState() => _selectlanguageState();
}

class _selectlanguageState extends State<selectlanguage> {
  @override
  Widget build(BuildContext context) {
    return LanguagePickerWidget(
      fontsizeprefeerd: 18,
    );
  }
}
