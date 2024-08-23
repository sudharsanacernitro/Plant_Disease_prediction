import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  final String ip;
  const Camera({Key? key, required this.ip}) : super(key: key);

  @override
  State<Camera> createState() => __CameraState();
}

class __CameraState extends State<Camera> {
  // File? _selectedimg;
  // dynamic img;
  String imgtype = "Leaf";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF003D2F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /* _selectedimg != null
                ? TextButton.icon(
                    onPressed: () {
                      // Add your onPressed code here!
                      print('TextButton Pressed');
                      postInfo();
                    },
                    icon: const Icon(
                      Icons.upload_file,
                      size: 40,
                      color: Colors.white,
                    ), // The icon
                    label: const Text(
                      'Upload',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: AutofillHints.addressCity),
                    ),
                  )
                : Container(),
            _selectedimg != null
                ? Image.file(
                    _selectedimg!,
                    width: screenWidth,
                    height: screenWidth,
                  )
                : */
            Image.asset(
              'assets/upload.jpg',
              width: screenWidth,
              height: screenWidth,
            ),
            DropdownButton<String>(
              dropdownColor: const Color(0xFF005A4F),
              value: imgtype,
              items: <String>['Leaf', 'Fruit']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  imgtype = newValue!;
                });
              },
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Add your onPressed code here!
                    print('TextButton Pressed');
                    // getimg('camera');
                  },
                  icon: const Icon(
                    Icons.photo_camera,
                    size: 50,
                    color: Colors.white,
                  ), // The icon
                  label: const Text(
                    'Camera',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: AutofillHints.addressCity),
                  ),
                ),
                const SizedBox(width: 20),
                TextButton.icon(
                  onPressed: () {
                    // Add your onPressed code here!
                    print('TextButton Pressed');
                    // getimg('gallery');
                  },
                  icon: const Icon(
                    Icons.photo_album,
                    size: 40,
                    color: Colors.white,
                  ), // The icon
                  label: const Text(
                    'Gallery',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: AutofillHints.addressCity),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*
  Future getimg(dynamic a) async {
    if (a == "camera") {
      img = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      img = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (img == null) return;

    setState(() {
      _selectedimg = File(img!.path);
    });
  }

  Future<void> postInfo() async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        img.path,
        filename: 'upload.jpg',
      ),
      'type': imgtype,
    });
    try {
      var response = await Dio().post(
        "http://${widget.ip}:5000/upload",
        data: formData,
      );
      if (response.statusCode == 200) {
        print(response.data); // Print the response data
        if (response.data['diseased'] == true) {
          _showDialog('Diseased', response.data['result']);
        } else {
          _showDialog('Healthy', response.data['result']);
        }
      } else {
        print('Failed to post data');
      }
    } catch (e) {
      print(e);
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Disease Name: ' + message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Broker(ip: widget.ip, file_path: message + ".txt"),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  */
}
