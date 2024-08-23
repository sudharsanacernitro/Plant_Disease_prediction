
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../home/layout_page.dart';
import '../camera_screen/camera_screen.dart';
import '../post/post.dart';
import '../general_AI/common_ai.dart';

class BottomNavigationBarExample extends StatefulWidget {
   final String ip,lang;
  const BottomNavigationBarExample({Key? key,required this.ip,required this.lang}) : super(key: key);

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  // Method to generate the widget options list
  List<Widget> _getWidgetOptions() {
    return <Widget>[
      Home(),
      Camera(ip: widget.ip),  // Use widget.ip to pass the IP address
      normal_ChatScreen(ip:widget.ip),
      MyForm()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ZORA',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _getWidgetOptions().elementAt(_selectedIndex), // Generate widget list dynamically
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, color: Colors.black),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 4, 151, 78),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file_outlined, color: Colors.black),
            label: 'upload',
            backgroundColor: Color.fromARGB(255, 4, 151, 78),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined, color: Colors.black),
            label: 'AI-Chat',
            backgroundColor: Color.fromARGB(255, 4, 151, 78),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add, color: Colors.black),
            label: 'Post',
            backgroundColor: Color.fromARGB(255, 4, 151, 78),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
