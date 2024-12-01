import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Models/online_pred_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'g_map.dart';
import 'store_permission/download.dart';

import 'login/login.dart';
import 'login/ip_config.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: MapScreen(),
      home: Config(title: 'GROOT',),
    );
  }
}