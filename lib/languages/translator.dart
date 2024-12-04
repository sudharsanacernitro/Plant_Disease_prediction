import 'package:camera/languages/translation_data';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import './translation_data.dart';

Future<String> translate(String data) async {
  final translator = GoogleTranslator();
  final translatedText = await translator.translate(data, to: 'ta');
  return translatedText.text;
}

Container content_translator(String data) {

    return Container(
        child: FutureBuilder<String>(
          future: translate(data), // Call your translate function
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
              return Text(data
                  ,style: TextStyle(
                  fontFamily: 'comics',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ); // Handle errors
              } 
          else {
              return Text(
                snapshot.data ?? data,
                style: TextStyle(
                  fontFamily: 'comics',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ); // Display the translated text
            }
          },
        )
    );
  
}

Container Heading_translator(String data) {

    return Container(
              child: Text(Translate_lng.translations[data.toLowerCase()]![0],
              style: TextStyle(
                  fontFamily: 'comics',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
              )
              )
         );
  
}



