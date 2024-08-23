import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
 import 'camera_screen/camera_screen.dart';
 import 'home/home_page.dart';
import './hindi_trans.dart';
import '';
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
      home: const _Login(title: 'Flutter Demo Home Page'),
    );
  }
}

class _Login extends StatefulWidget {
  final String title;
  const _Login({super.key, required this.title});

  @override
  State<_Login> createState() => __LoginState();
}

class __LoginState extends State<_Login> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  bool _isError = false; // Track whether there is an error
  String selectedLanguage = 'English'; // Default language
  Translator translator = Translator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003D2F), // Dark green background
      appBar: AppBar(
        title: const Center(
          child: Text(
            'GROOT',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white, // White text
            ),
          ),
        ),
        backgroundColor: const Color(0xFF005A4F), // Darker green for the AppBar
        elevation: 0, // Remove shadow
      ),
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Text(
                translator.translate(selectedLanguage, "server ip"),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // White text
                ),
              ),
              const SizedBox(height: 10),
              Textbox(
                hintText: "Enter Server IP",
                controller: _controller1,
                isError: _isError,
              ),
              const SizedBox(height: 20), // Space between elements
              Text(
                translator.translate(selectedLanguage, "select-language"),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // White text
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(
                      0xFF004D40), // Dark green for dropdown background
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  dropdownColor:
                      const Color(0xFF004D40), // Dark green dropdown background
                  isExpanded: true,
                  underline: const SizedBox(), // Remove underline
                  iconEnabledColor: Colors.white, // White dropdown icon
                  items: <String>['English', 'Hindi']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style:
                            const TextStyle(color: Colors.white), // White text
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30), // Space between elements
              Container(
                width: double.infinity,
                child: button("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container button(String a)  {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF00796B), // Darker green button background
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      child: ElevatedButton(
        onPressed: () async{
           String ip = _controller1.text;
           if (ip.isNotEmpty) {
             bool isValid = await getinfo(ip);
             if (isValid) {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => BottomNavigationBarExample(ip: _controller1.text, lang: selectedLanguage)),
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
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 15), // Button padding
        ),
        child: Text(
          a,
          style: const TextStyle(
            color: Colors.white, // White text
            fontWeight: FontWeight.bold,
          ),
        ),
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

    try {
      final response = await Dio(options).get(
        "http://$ip:5000/check_endpoint",
      );
      return true;
    } on DioException catch (e) {
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
      decoration: BoxDecoration(
        color: isError
            ? Colors.red
            : const Color(0xFF004D40), // Red for error, dark green otherwise
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white), // White text
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white), // White hint text
          prefixIcon:
              const Icon(Icons.public, color: Colors.white), // White icon
          border: InputBorder.none, // Remove border
        ),
      ),
    );
  }
}
