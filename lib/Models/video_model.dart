import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dio/dio.dart';

class VideoModel extends StatefulWidget {
  String ip;
     VideoModel({Key? key,required this.ip}) : super(key: key);

  @override
  _VideoModelScreenState createState() => _VideoModelScreenState();
}

class _VideoModelScreenState extends State<VideoModel> {
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();

  Future<void> _pickVideo() async {
    final XFile? pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      setState(() {
        _videoFile = File(pickedVideo.path);
      });
    }
  }

  Future<void> _captureVideo() async {
    final XFile? capturedVideo = await _picker.pickVideo(source: ImageSource.camera);
    if (capturedVideo != null) {
      setState(() {
        _videoFile = File(capturedVideo.path);
      });
    }
  }

  Future<void> _uploadVideo() async {
      if (_videoFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a video first.')),
        );
        return;
      }

      try {
        String uploadUrl = 'http://${widget.ip}:5000/video_model';
        FormData formData = FormData.fromMap({
          'video': await MultipartFile.fromFile(_videoFile!.path, filename: 'uploaded_video.mp4'),
        });

        Response response = await _dio.post(uploadUrl, data: formData);

        ScaffoldMessenger.of(context).showSnackBar(
          //response.data['message']
          SnackBar(content: Text("Uploaded Successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video upload failed: $e')),
        );
      }
    }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('GROOT'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DottedBorder(
              color: Colors.black, // Color of the border
              strokeWidth: 2, // Thickness of the dotted border
              dashPattern: [6, 3], // Length of dashes and gaps
              borderType: BorderType.RRect, // Border shape
              radius: Radius.circular(10), // Rounded corners
              child: Container(
                height: 100,
                width: 0.9 * screenWidth,
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Ensure all the sides in the video have equal screen time and ensure there is only one fruit/leaf in the video no more than that',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
            _videoFile == null
                ? Text('No video selected')
                : Stack(
                    children: [
                      Container(
                        width: 0.9 * screenWidth,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 5, // How far the shadow spreads
                              blurRadius: 10, // How blurry the shadow looks
                              offset: Offset(0, 3), // Position of the shadow (x, y)
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _videoFile!.path.split('/').last,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 12,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _videoFile = null;
                            });
                          },
                          child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                  ElevatedButton(
              onPressed: _uploadVideo,
              child: Text('Upload Video'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick Video from Gallery'),
            ),
            ElevatedButton(
              onPressed: _captureVideo,
              child: Text('Capture Video with Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
