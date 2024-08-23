import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class normal_ChatScreen extends StatefulWidget {
  final String ip;
  const normal_ChatScreen({Key? key, required this.ip}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<normal_ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add(Message(text: _controller.text, isMe: true));
      _controller.clear();
    });

    try {
      final result = await response();
      print('Response data: ${result['message']}');

      setState(() {
        _messages.add(Message(text: result['message'], isMe: false));
        _controller.clear();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<dynamic> response() async {
    final Dio dio = Dio();

    // Simulate a network call with Dio
    final data = {'query': _messages.last.text};
    try {
      final response = await dio.post(
        'http://${widget.ip}:5000/common_reply',
        data: data,
        options: Options(
          headers: {
            'Content-Type':
                'application/json', // Ensure the content type is set to JSON
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003D2F), // Dark greenish-black background
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                    message: _messages[_messages.length - 1 - index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      hintStyle: TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: Color(
                          0xFF005A4F), // Darker green fill for the text field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send,
                      color: Color(0xFF00C851)), // Bright green send icon
                  onPressed: () {}, // _sendMessage function call commented
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isMe
              ? Color(0xFF00C851)
              : Color(
                  0xFF005A4F), // Bright green for sender, dark green for receiver
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
