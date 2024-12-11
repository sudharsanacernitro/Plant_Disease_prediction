import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class JsonReaderScreen extends StatefulWidget {
  @override
  _JsonReaderScreenState createState() => _JsonReaderScreenState();
}

class _JsonReaderScreenState extends State<JsonReaderScreen> {
  Map<String, dynamic>? jsonData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    readJsonFromExternalStorage('apple_fruit.json'); // Replace with your JSON file name
  }

  Future<void> readJsonFromExternalStorage(String fileName) async {
    try {
      // Request storage permission
      if (true) {
        // Get the app's external file directory
        Directory? appDir = await getExternalStorageDirectory();

        if (appDir != null) {
          // Path to the JSON file
          String filePath = "${appDir.path}/$fileName";

          // Check if the file exists
          File file = File(filePath);
          if (await file.exists()) {
            // Read the file content
            String jsonContent = await file.readAsString();

            // Parse the JSON content
            setState(() {
              jsonData = json.decode(jsonContent);
              isLoading = false; // Update loading status
            });
          } else {
            print("File not found at $filePath");
            setState(() {
              isLoading = false; // Update loading status
            });
          }
        } else {
          print("App's external directory not found!");
          setState(() {
            isLoading = false; // Update loading status
          });
        }
      } else {
        print("Storage permission denied.");
        setState(() {
          isLoading = false; // Update loading status
        });
      }
    } catch (e) {
      print("Error reading JSON: $e");
      setState(() {
        isLoading = false; // Update loading status
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Reader'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : jsonData != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${jsonData!['name']}", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 8),
                      Text("Version: ${jsonData!['version']}", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 8),
                      Text("Description: ${jsonData!['description']}", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                )
              : Center(child: Text('No data found')),
    );
  }
}