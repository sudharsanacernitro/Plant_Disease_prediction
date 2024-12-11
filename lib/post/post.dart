import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';

import '../store_permission/download.dart'; // Make sure this import is valid

import '../login/ip_config.dart';



class ProfilePage extends StatefulWidget {
  final String ip;

  ProfilePage({
    required this.ip,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  void _showModels(BuildContext context) async {
    try {
      final response = await Dio().post('http://${widget.ip}:5000/available_offline_models');
      Map<String, dynamic> data = response.data;
      Map<String, dynamic> models = Map<String, dynamic>.from(data['offline_models']);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Available Models'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: models.keys.map((modelName) {
                  return ElevatedButton(
                    onPressed: () async {
                      print('Model path: ${models[modelName]}');
                      final download = VideoDownloadState(ip: widget.ip, model_name: models[modelName]);
                      bool isDownloaded = await download.downloadFile();

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(isDownloaded ? 'Download Successful' : 'Download Failed'),
                            content: Text(isDownloaded
                                ? 'The file has been downloaded successfully.'
                                : 'There was a problem downloading the file.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(modelName),
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch models')),
      );
    }
  }

  
  // Function to handle logout
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Remove the login flag

   
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/sih_img.jpg'),
                  backgroundColor: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'GROOT',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final prefs = snapshot.data!;
                      final email = prefs.getString('email') ?? '';
                      final name = prefs.getString('name') ?? '';
                      final address = prefs.getString('address') ?? '';
                      final district = prefs.getString('district') ?? '';

                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: $email', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text('Name: $name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text('Address: $address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text('District: $district', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            SizedBox(height: 30),
                           
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    launchURL('https://t.me/+0nPH6dRcfsMyOWE9');
                  },
                  child: Text('Join the Community'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showModels(context),
                  child: Text('Offline-Models'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _logout(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen(ip: widget.ip, lang: "English")),
                    );
                  },
                  child: Text('Logout'),
                ),
               
                SizedBox(height: 20),
               
               
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
