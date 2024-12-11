import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'login/ip_config.dart';

import './global_settings.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase
  await GlobalSettings.instance.loadLanguage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'comics',
        scaffoldBackgroundColor: Colors.white, //Color.fromARGB(255, 2, 119, 31),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white), // Change color here
        ),
      ),
      //home: MapScreen(),
      home: Config(title: 'GROOT',),
    );
  }
}



