import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../hindi_trans.dart';
import '../home/home_page.dart';
import 'login.dart';

import 'language_change.dart';
import '../global_settings.dart';

class Config extends StatefulWidget {
  final String title;
  const Config({super.key, required this.title});

  @override
  State<Config> createState() => __ConfigState();
}

class __ConfigState extends State<Config> {
  final TextEditingController _controller1 = TextEditingController();

  bool _isError = false; // Track whether there is an error
      String selectedLanguage = 'English'; // Default language
 Translator translator = Translator();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 19, 22),
      appBar: AppBar(
        title: const Text(
          'ZORA',
          
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            children:<Widget> [
               Text(
                translator.translate(selectedLanguage, "server_ip"),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 214, 112, 29),
                ),
              ),
              Textbox(
                hintText: "Enter Server IP",
                controller: _controller1,
                isError: _isError,
                 // Pass error state to Textbox
              ),
                
                Change_language(),
             
              Container(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [button("Continue")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container button(String a) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () async {
          String ip = _controller1.text;
          
          if (ip.isNotEmpty) {
            bool isValid = await getinfo(ip);
            if (isValid) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen(ip:_controller1.text,lang: selectedLanguage,)),
              );
              print(_controller1.text);
            } else {
              setState(() {
                _isError = true; // Set error state if the IP is invalid
              });
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
        ),
        child: Text(a),
      ),
    );
  }

  Future<bool> getinfo(String ip) async {
          print('error');
          BaseOptions options = new BaseOptions(
          baseUrl: "http://$ip:5000",
          connectTimeout: Duration(milliseconds: 5000),
          receiveTimeout: Duration(milliseconds: 5000),
            );
            GlobalSettings.instance.update_ip(ip);

        try {
        final response = await Dio(options).get(
          "http://$ip:5000/check_endpoint",);
        return true;
           } 
      on DioException catch (e) {
          if (e.type == DioExceptionType.receiveTimeout) {
            print('Receive timeout!');
            return false;
          } else if (e.type == DioExceptionType.sendTimeout) {
            print('Send timeout!');
            return false;
          } else {
            print('Request failed: $e');
            return false;
          }
        }
  }

}

class Textbox extends StatelessWidget {
  const Textbox({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isError,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(Icons.public),
          prefixIconColor: const Color.fromARGB(255, 17, 13, 1),
          filled: true,
          fillColor: isError ? Colors.red : Colors.white,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      ),
    );
  }
}



class SplashScreen extends StatefulWidget {
  String ip,lang;

   SplashScreen({required this.ip,required this.lang});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>BottomNavigationBarExample(ip: widget.ip,lang:widget.lang)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LoginScreen(ip: widget.ip,lang:widget.lang) ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}