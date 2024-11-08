import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';

import '../store_permission/download.dart'; // Make sure this import is valid
import 'chart.dart';
import 'chart1.dart';
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
  // Data to hold the environment data
  Map<String, List<double>> data = {
    "humidity": [],
    "pressure": [],
    "temp": [],
    "wind": [],
  };

  @override
  void initState() {
    super.initState();
    _show_envi_model();
  }

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

  void _show_envi_model() async {
    try {
      final response = await Dio().get('http://${widget.ip}:5000/environment');
      
      // Ensure the response is in the expected format
      Map<String, dynamic> responseData = response.data;

      // Directly convert to List<double> from the response data
      setState(() {
        data = {
          "humidity": List<double>.from(responseData['humidity']?.map((x) => x.toDouble()) ?? []),
          "pressure": List<double>.from(responseData['pressure']?.map((x) => x.toDouble()) ?? []),
          "temp": List<double>.from(responseData['temp']?.map((x) => x.toDouble()) ?? []),
          "wind": List<double>.from(responseData['wind']?.map((x) => x.toDouble()) ?? []),
        };
      });

      print(data); // Debugging: To verify the data
    } catch (e) {
      setState(() {
        // Set to default empty data if error occurs
        data = {
          "humidity": [],
          "pressure": [],
          "temp": [],
          "wind": [],
        };
      });
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch environment data')),
      );
    }
  }

  // Convert y-values into FlSpot points
  List<FlSpot> generateSpots(List<double> data) {
    return List<FlSpot>.generate(
      data.length,
      (index) => FlSpot(index.toDouble(), data[index]),
    );
  }

  // Function to handle logout
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Remove the login flag

    // Navigate back to login screen (replace with your actual login screen route)
  }
bool isLoading = false;  // To track loading state
  String pred = "";

   Future<void> fetchData() async {
    setState(() {
      isLoading = true;  // Set loading to true
    });

    try {
      // Dio to fetch data from backend
      final response = await Dio().get('http://${widget.ip}:5000/pred_env');

      if (response.statusCode == 200) {
        setState(() {
          pred = response.data["message"].toString();  // Assign the fetched data
          isLoading = false;  // Set loading to false when data is fetched
          _showDialog(pred);
        });
      } else {
        // Handle error response
        setState(() {
          pred = 'Failed to fetch data';
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle any error
      setState(() {
        pred = 'Error: $e';
        isLoading = false;
      });
    }
  }

void _showDialog( String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Predictions"),
          content: Text('Disease Name: '+message),
          actions: [
            TextButton(
              child: Text('Back'),
              onPressed: () {  
                 Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Show progress indicator when loading
        :SingleChildScrollView(
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
                SizedBox(height: 50,),
                Text('Your Environment Data', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                DemoPage(ip:widget.ip),
                SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: () {
                    fetchData();
                  },
                  child: Text('Get Predictions'),
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
