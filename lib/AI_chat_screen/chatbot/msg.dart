import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import 'text_to_speech.dart';
import 'video_leaner.dart';

class ChatPage extends StatefulWidget {
  final String ip;
  final String insertion_id, disease, disease_name;
  
  const ChatPage({
    Key? key,
    required this.ip,
    required this.insertion_id,
    required this.disease,
    required this.disease_name,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> chatMessages = [];
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _textController = TextEditingController();

  List<Widget> chatWidgets = [];
  bool _speechEnabled = false;
  bool _isListening = false;
  String _selectedLanguage = 'en_US';
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    setState(() {
      _addMessageWidget(
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(4, 4),
              ),
            ],
          ),
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              VideoPlayerWidget(
                videoPath: 'assets/${widget.disease_name}.mp4',
                width: 300,
                height: 200,
              ),
              Text("Disease Awareness video"),
            ],
          ),
        ),
      );
    });
  }

  void addMessage(String sender_content, String AI_content) {
    final newMessage = {'sender': sender_content, 'AI': AI_content};
    chatMessages.add(newMessage);
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (val) => print("Error: $val"),
      onStatus: (val) => print("Status: $val"),
    );
    setState(() {});
  }

  void _toggleListening() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

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

  void _sendMessage() async {
    if (_textController.text.isNotEmpty) {
      String userMessage = _textController.text;
      _addMessageWidget(_buildMessageWidget(userMessage, true, null));
      _textController.clear();

      try {
        Response response = await Dio().post(
          'http://${widget.ip}:5000/reply',
          data: {
            'query': userMessage,
            'lang': _selectedLanguage,
          },
        );

        if (response.statusCode == 200) {
          String reply = response.data['message'];
          addMessage(userMessage, reply);
          _addMessageWidget(_buildMessageWidget(reply, false, response.data["random_path"]));
        } else {
          _addMessageWidget(_buildMessageWidget("Error: Failed to get a response.", false, null));
        }
      } catch (e) {
        _addMessageWidget(_buildMessageWidget("Error: Could not send message.", false, null));
      }
    }
  }

  Widget _buildMessageWidget(String message, bool isUser, String? randImg) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
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
              if (randImg != null)
                Container(
                  width: 270.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    'http://${widget.ip}:5000/post_img/$randImg',
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                  ),
                ),
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

  void _addMessageWidget(Widget widget) {
    setState(() {
      chatWidgets.add(widget);
    });
  }

  Future<void> postInfo() async {
    try {
      final data = jsonEncode({
        'insertion_id': widget.insertion_id,
        'convo': chatMessages,
      });

      var response = await Dio().post(
        "http://${widget.ip}:5000/store_chat",
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Data posted successfully');
      } else {
        print('Failed to post data');
      }
    } catch (e) {
      print("Error posting chat data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        await postInfo();
        Navigator.of(context).pop();
      },
      child: Scaffold(
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
      ),
    );
  }
}
