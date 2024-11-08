
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'layout_page.dart';
import '../camera_screen/online_pred_screen.dart';
import '../post/post.dart';
import '../general_AI/chatbot/msg.dart';

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
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Home(ip: widget.ip),
      Modelselector(ip: widget.ip, lang: widget.lang), // Pass the IP and language
      General_chatPage(ip: widget.ip),
      ProfilePage(ip: widget.ip),
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
      body: IndexedStack(
        index: _selectedIndex,  // Show only the selected tab
        children: _widgetOptions, // Keep all the tabs in memory
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
            label: 'Upload',
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
