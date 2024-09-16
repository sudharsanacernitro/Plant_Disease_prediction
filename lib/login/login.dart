import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  
  LatLng? _selectedLocation; // Declared variable to store selected location

  void _login(BuildContext context) async {
    String email = _emailController.text;
    String name = _nameController.text;
    String address = _addressController.text;
    String district = _districtController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email);
    await prefs.setString('name', name);
    await prefs.setString('address', address);
    await prefs.setString('district', district);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigationBarExample(ip: widget.ip,lang:widget.lang)),
    );
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
