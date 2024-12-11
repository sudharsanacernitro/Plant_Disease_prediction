import 'package:camera/languages/translation_data.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../global_settings.dart';


Map<String,List> language_code={
                                    "English":["en",-1],
                                    'Tamil':['ta',0],
                                    'Telugu':['tl',1],
                                    'Hindi':['hi',2]
                                    };

Future<String> translate(String data) async {


  final lng=language_code[GlobalSettings.instance.language]![0];
  final translatedText = await GlobalSettings.instance.translator.translate(data, to: lng);
  return translatedText.text;
}

Container content_translator(String data) {
    if (GlobalSettings.instance.language=="English"){
            return Container(
              child: Text(data
                          ,style: TextStyle(
                          fontFamily: 'comics',
                          fontSize: 15,
                          
                        ),
                      ),
            ); 
    }
    else
    {
        return Container(
            child: FutureBuilder<String>(
              future: translate(data), // Call your translate function
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasError) {
                  return Text(data
                      ,style: TextStyle(
                      fontFamily: 'comics',
                      fontSize: 15,
                      
                    ),
                  ); // Handle errors
                  } 
              else {
                  return Text(
                    snapshot.data ?? data,
                    style: TextStyle(
                      fontFamily: 'comics',
                      fontSize: 15
                    ),
                  ); // Display the translated text
                }
              },
            )
        );
    }
  
}

Container Heading_translator(String data) {


      if (GlobalSettings.instance.language=="English"){
            return Container(
              child: Text(data
                          ,style: TextStyle(
                          fontFamily: 'comics',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ); 
    }
    else{
        final language=GlobalSettings.instance.language;
        return Container(
                  child: Text(Translate_lng.translations[data.toLowerCase()]![language_code[language]![1]],
                  style: TextStyle(
                      fontFamily: 'comics',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                  )
                  )
            );
    }
  
}



