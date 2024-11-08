import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

import 'ip_config.dart'; 
import 'locatin.dart';

import '../home/home_page.dart';

class LoginScreen extends StatefulWidget {

  String ip,lang;
   LoginScreen({super.key,required this.ip,required this.lang});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
    final TextEditingController _contactController = TextEditingController();

  
  LatLng? _selectedLocation; // Declared variable to store selected location

  void _login(BuildContext context) async {
    String email = _emailController.text;
    String name = _nameController.text;
    String address = _addressController.text;
    String district = _districtController.text;
    String contact = _contactController.text;

    dynamic data={'email':email,'name':name,'addr':address,'dist':district,"contact":contact};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    

    try {
      // Send the message to the backend
      Response response = await Dio().post(
        'http://${widget.ip}:5000/login', // Replace with your actual API endpoint
        data:data
      );

      if (response.statusCode == 200) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('email', email);
        await prefs.setString('name', name);
        await prefs.setString('address', address);
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
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: _districtController,
                  decoration: InputDecoration(labelText: 'District'),
                ),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
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
                        _selectedLocation = result as LatLng;
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
