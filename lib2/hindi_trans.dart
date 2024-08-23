class Translator {
  // English language map object
  Map<String, dynamic> en = {
    "home": "Home",
    "upload": "Uploads",
    "ai_chat": "AI-Chat",
    "post":"Post",
    "server_ip":"Server_IP",
    "select-language":"Select-Language",
    "camera":"Camera",
    "gallery":"Gallery",
  };

  // Hindi language map object
  Map<String, dynamic> hi = {
    "home": "घर",
    "upload": "अपलोड",
    "ai_chat": "एआई-चैट",
    "post":"पोस्ट",
    "server_ip":"सर्वर-आईपी ",
    "select-language":"भाषा चुनें",
    "camera":"कैमरा",
    "gallery":"गैलरी",
  };


  // Method to return the selected language map
  dynamic to(String selectedLanguage) {
    if (selectedLanguage == "English") {
      return en;
    } else if (selectedLanguage == "Hindi") {
      return hi;
    } 
  }

  // Method to translate a key to the selected language
  String translate(String selectedLanguage, String text) {
    return to(selectedLanguage)[text.toLowerCase().replaceAll(" ", "_")];
  }
}

// Enum to represent the supported languages
enum LanguagesEnum { English, Hindi }
