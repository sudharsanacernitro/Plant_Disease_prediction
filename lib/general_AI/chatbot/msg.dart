import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'text_to_speech.dart';
import 'dart:convert';

import 'package:dio/dio.dart';

class General_chatPage extends StatefulWidget {
   final String ip;
  const General_chatPage({Key? key, required this.ip}) : super(key: key);

  @override
  State<General_chatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<General_chatPage> {
  List<dynamic> chatMessages = [];
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _textController = TextEditingController();

  bool _speechEnabled = false;
  bool _isListening = false;
  String _selectedLanguage = 'en_US';
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void addMessage(String content, String sender) {
    final newMessage = {
      'sender':sender,
      'Message':content
  };
    
      chatMessages.add(newMessage);
    
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

  // Send message (text input or speech result)
 void _sendMessage() async {
  if (_textController.text.isNotEmpty) {
    String userMessage = _textController.text;

    setState(() {
      _messages.add({'user': userMessage});
      addMessage(userMessage, "user");
    });

    try {
      // Send the message to the backend
      Response response = await Dio().post(
        'http://${widget.ip}:5000/common_reply', // Replace with your actual API endpoint
        data: {
          'query': userMessage,
          'lang':_selectedLanguage
        },
      );

      if (response.statusCode == 200) {
        // Assuming the backend sends a reply message
        String reply = response.data['message'];
        _addReply(reply);
      } else {
        _addReply("Error: Failed to get a response.");
      }
    } catch (e) {
      print("Error sending message: $e");
      _addReply("Error: Could not send message.");
    }

    _textController.clear(); // Clear the text field
  }
}

// Add a reply from the backend or static
void _addReply(String reply) {
  setState(() {
    _messages.add({'bot': reply});
     addMessage(reply, "AI");
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GROOT",style: TextStyle(fontFamily: 'crisp',color: Color.fromARGB(255, 119, 206, 121))),
        backgroundColor: Color.fromARGB(255, 26, 27, 26),
        toolbarHeight: 30,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message.keys.first == 'user';
                  return ListTile(
                    title: Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                              onTap: () {
                                // Add your action here
                                print("Container clicked!");
                                TextToSpeechScreenState().speak(message.values.first);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isUser ? Color.fromARGB(255, 26, 27, 26) : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  message.values.first,
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            )
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Dropdown for language selection
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
                      // Microphone button for listening
                      IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: _isListening ? Colors.red :  Color.fromARGB(255, 26, 27, 26),
                        ),
                        iconSize: 40,
                        onPressed: _speechEnabled ? _toggleListening : null,
                      ),
                    ],
                  ),
                  // Text input field
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message or use the mic...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage, // Send message
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 40,)
          ],
        ),
      );
  }
}
