import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import 'text_to_speech.dart';
import 'video_leaner.dart';

class ChatPage extends StatefulWidget {
  final String ip;
  final String insertion_id,disease,disease_name;
  const ChatPage({Key? key, required this.ip, required this.insertion_id,required this.disease,required this.disease_name}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _textController = TextEditingController();

  List<Widget> chatWidgets = []; // New list to hold any widget type
  bool _speechEnabled = false;
  bool _isListening = false;
  String _selectedLanguage = 'en_US';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    setState(() {
      _addMessageWidget(
        Container(
                  decoration: BoxDecoration(
            color: Colors.white,  // Background color for the shadow effect
            borderRadius: BorderRadius.circular(8),  // Rounded corners, if desired
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),  // Shadow color with opacity
                spreadRadius: 2,                        // Spread of the shadow
                blurRadius: 8,                          // Blur radius for a softer shadow
                offset: Offset(4, 4),                   // Position of the shadow
              ),
            ],
          ),
          margin: EdgeInsets.all(10),
          child: Column(
            children: [VideoPlayerWidget(
                videoPath: 'assets/${widget.disease_name}.mp4',
                width: 300,
                height: 200,
              ),
              Text("Disease Awareness video")
              ]
          ),
        ),
);
    });
  }

  // Initialize speech recognition
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (val) => print("Error: $val"),
      onStatus: (val) => print("Status: $val"),
    );
    setState(() {});
  }

  // Start or stop listening
  void _toggleListening() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  // Start listening to speech
  Future<void> _startListening() async {
    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _textController.text = result.recognizedWords;
        });
      },
      localeId: _selectedLanguage,
    );
    setState(() {
      _isListening = true;
    });
  }

  // Stop listening
  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

Future<void> _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  // Send message (text input or speech result)
  void _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      String userMessage = _textController.text;
      _addMessageWidget(_buildMessageWidget(userMessage, true,null));
      _textController.clear();

      try {
        Response response = await Dio().post(
          'http://${widget.ip}:5000/reply', // Replace with your actual API endpoint
          data: {
            'query': userMessage,
            'lang': _selectedLanguage,
          },
        );

        if (response.statusCode == 200) {
          String reply = response.data['message'];
          print(response.data["random_path"]);
          _addMessageWidget(_buildMessageWidget(reply, false,response.data["random_path"]));
        } else {
          _addMessageWidget(_buildMessageWidget("Error: Failed to get a response.", false,null));
        }
      } catch (e) {
        print("Error sending message: $e");
        _addMessageWidget(_buildMessageWidget("Error: Could not send message.", false,null));
      }
    }
  }

 Widget _buildMessageWidget(String message, bool isUser,String? rand_img) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: GestureDetector(
      onTap: () {
        print("Container clicked!");
        TextToSpeechScreenState().speak(message);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            rand_img!=null?Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
              width: 270.0,
              height: 250.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                  'http://${widget.ip}:5000/post_img/${rand_img}',
                  width:30.0,
                  height: 30.0,
                  fit: BoxFit.cover,
                ),

              )]):SizedBox(),
            Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black,
                fontSize: 17,
              ),
            ),
            if (!isUser)
              InkWell(
                onTap: () => _launchURL(widget.disease),
                child: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Ref',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

  // Add any widget to the chat
  void _addMessageWidget(Widget widget) {
    setState(() {
      chatWidgets.add(widget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GROOT'),
        actions: [
    IconButton(
      icon: Icon(Icons.info),
      onPressed: () {
        _launchURL("https://youtu.be/_xra3fMgLNA?si=y_1ViaVC0FmDPJRD");
              },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: chatWidgets,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    DropdownButton<String>(
                      value: _selectedLanguage,
                      items: const [
                        DropdownMenuItem(value: 'en_US', child: Text('English')),
                        DropdownMenuItem(value: 'hi_IN', child: Text('Hindi')),
                        DropdownMenuItem(value: 'ta_IN', child: Text('Tamil')),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.blue,
                      ),
                      iconSize: 40,
                      onPressed: _speechEnabled ? _toggleListening : null,
                    ),
                  ],
                ),
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type a message or use the mic...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
