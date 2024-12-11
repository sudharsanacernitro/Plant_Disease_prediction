import 'package:shared_preferences/shared_preferences.dart';

import 'package:translator/translator.dart';

class GlobalSettings {
  static final GlobalSettings _instance = GlobalSettings._internal();

  // Private constructor
  GlobalSettings._internal();

  // Getter for the singleton instance
  static GlobalSettings get instance => _instance;

  // Global variable
  String language = 'English';
  String? ip;
  final translator = GoogleTranslator();

  // Load the saved language from SharedPreferences
  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    language = prefs.getString('Language') ?? 'English';
  }

  // Save the selected language to SharedPreferences
  Future<void> saveLanguage(String newLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Language', newLanguage);
    language = newLanguage;
  }

  void update_ip(String ip) {
    
    this.ip = ip;
  }
}
