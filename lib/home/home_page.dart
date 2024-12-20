import 'package:flutter/material.dart';
import 'layout_page.dart';
import '../Models/Model_selector.dart';
import '../post/post.dart';
import '../general_AI/chatbot/msg.dart';
import 'dart:developer' as devtools;
import 'dart:io';

class BottomNavigationBarExample extends StatefulWidget {
  final String ip, lang;
  const BottomNavigationBarExample({Key? key, required this.ip, required this.lang}) : super(key: key);

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  // Method to generate the widget options list
  late List<Widget> _widgetOptions;

    List<String> fileNames = [];


  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Home(ip: widget.ip),
      Modelselector(ip: widget.ip, lang: widget.lang), // Pass the IP and language
      General_chatPage(ip: widget.ip),
      ProfilePage(ip: widget.ip),
    ];
        _offline_image_upload('/storage/emulated/0/Android/data/com.example.camera/files/Offline_images/'); // Replace with your directory path

  }


 Future<void> _offline_image_upload(String directoryPath) async {
  try {
    final directory = Directory(directoryPath);
    if (await directory.exists()) {
      final files = directory.listSync();

      fileNames = files
           .map((file) => file.path)
          .toList();

      if(fileNames.length!=0)
      {

        return showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Upload"),
            content: Container(
              child: Text("You have some offline images ,To validate it click on upload"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Back"),
              ),
            ],
          );
        },);

      }


    } else {
      devtools.log("Directory does not exist");
    }
  } catch (e) {
    devtools.log("Error in listing files: $e");
  }
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex, // Show only the selected tab
            children: _widgetOptions, // Keep all the tabs in memory
          ),
          Positioned(
            bottom: 10, // Position the container above the screen bottom
            left: 10, // Adjust for the left margin
            right: 10, // Adjust for the right margin
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 1),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 26, 27, 26), // Adjust transparency
                borderRadius: BorderRadius.circular(15), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow color
                    blurRadius: 8, // Blur radius
                    offset: Offset(0, 2), // Shadow offset
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_filled, color: const Color.fromARGB(255, 119, 206, 121)),
                    onPressed: () => _onItemTapped(0),
                  ),
                  IconButton(
                    icon: const Icon(Icons.upload_file_outlined, color:   const Color.fromARGB(255, 119, 206, 121)),
                    onPressed: () => _onItemTapped(1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.message_outlined, color:   const Color.fromARGB(255, 119, 206, 121)),
                    onPressed: () => _onItemTapped(2),
                  ),
                  IconButton(
                    icon: const Icon(Icons.post_add, color:   const Color.fromARGB(255, 119, 206, 121)),
                    onPressed: () => _onItemTapped(3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
