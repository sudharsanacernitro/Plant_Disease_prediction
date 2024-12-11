import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

import 'ip_config.dart'; 
import 'location.dart';

import '../home/home_page.dart';


import 'package:camera/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget {

  String ip,lang;
   LoginScreen({super.key,required this.ip,required this.lang});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
    final TextEditingController _contactController = TextEditingController();

  String? firebase_key;
  
  List<LatLng>? _selectedLocation; // Declared variable to store selected location

  @override
  void initState() {
    super.initState();
    checkPreference();
  }

    Future<void> checkPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); 

    // Check if the key 'exampleKey' is set
    if (!prefs.containsKey('firebase_key')) {
        setupFirebaseMessaging();
        await prefs.setString('firebase_key', firebase_key!);
    }
    else{
      firebase_key=prefs.getString('firebase_key');
    }
  }


  Future<void> setupFirebaseMessaging() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission();
      print("Notification permissions: ${settings.authorizationStatus}");

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else {
        print('User denied permission');
      }

    
      firebase_key = await messaging.getToken();
      
  }

  void _login(BuildContext context) async {

    
    String name = _nameController.text;
    String district = _districtController.text;
    String contact = _contactController.text;
    

    dynamic data={'name':name,'dist':district,"contact":contact,"farm_location":_selectedLocation,"Firebase_token":firebase_key};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    

    try {
      // Send the message to the backend
      Response response = await Dio().post(
        'http://${widget.ip}:5000/login', // Replace with your actual API endpoint
        data:data
      );

      if (response.statusCode == 200) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('name', name);
        await prefs.setString('district', district);
        await prefs.setString('contact', contact);
        print("login successfull");
        Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigationBarExample(ip: widget.ip,lang:widget.lang)),
    );
       
      } else {
        print("unsusccessfull");
      }
    } catch (e) {
      print("Error sending message: $e");
     
    }

    
  }

 

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GROOT'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/sih_img.jpg'),
                  backgroundColor: Colors.grey,
                ),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                // TextField(
                //   controller: _addressController,
                //   decoration: InputDecoration(labelText: 'Address'),
                // ),
                TextField(
                  controller: _districtController,
                  decoration: InputDecoration(labelText: 'District'),
                ),
               
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapScreen()),
                    );

                    if (result != null) {
                      print(result);
                      setState(() {
                        _selectedLocation = result as List<LatLng>;
                      });
                    }
                  },
                  child: Text('Select Location'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _login(context),
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
