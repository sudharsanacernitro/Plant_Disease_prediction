import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import './msg.dart';

class Broker extends StatefulWidget {
  final String ip;
  final String file_path;
  const Broker({Key? key, required this.ip, required this.file_path})
      : super(key: key);

  @override
  State<Broker> createState() => _HomeState();
}

class _HomeState extends State<Broker> {
  Future<Map<String, dynamic>> fetchData() async {
    final Dio dio = Dio();

    // Simulate a network call with Dio
    final data = {'file_path': widget.file_path};
    try {
      final response = await dio.post(
        'http://${widget.ip}:5000/web_loader',
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
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchData(), // The Dio network call
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the response, show a loading indicator
          return const Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF005A4F)), // Updated color
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // If an error occurred, show an error message
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (snapshot.hasData) {
          // Once data is received, load your main widgets
          if (snapshot.data?['error'] == false) {
            return ChatScreen(ip: widget.ip);
          } else {
            print(snapshot.data);
            return Center(
              child: SizedBox(
                width: 200,
                height: 100,
                child: Text(
                  'ENTER A VALID URL',
                  style: TextStyle(
                      fontSize: 20, color: Colors.red), // Updated color
                ),
              ),
            );
          }
        } else {
          return Center(
            child: Text(
              'No data received',
              style:
                  TextStyle(fontSize: 16, color: Colors.grey), // Updated color
            ),
          );
        }
      },
    );
  }
}

class LoadedWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  LoadedWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Text(
              'Body: ${data['body']}',
              style: const TextStyle(
                  fontSize: 20, color: Colors.white), // Updated color
            ),
          ),
        ),
      ],
    );
  }
}
