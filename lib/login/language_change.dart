import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_settings.dart';

class Change_language extends StatefulWidget {
  const Change_language({super.key});

  @override
  State<Change_language> createState() => _Change_languageState();
}

class _Change_languageState extends State<Change_language> {
List<String> languages = ['English','Tamil', 'Telugu', 'Hindi'];
  String? selectedLanguage=GlobalSettings.instance.language;


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (newValue) {
                setState(() {
                  selectedLanguage = newValue!;
                });
                GlobalSettings.instance.saveLanguage(newValue!);
              },
              items: languages.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: TextStyle(color: Colors.blue),),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Value: $selectedLanguage',
              style: TextStyle(fontSize: 16,color: Colors.white),
            ),
          ],
        ),
      );
  }
}