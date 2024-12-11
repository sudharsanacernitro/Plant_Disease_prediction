import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart'; // Ensure this package is correctly set up
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as devtools;

import 'process_offline_img.dart';

class Offline_Model extends StatefulWidget {
  const Offline_Model({super.key});

  @override
  State<Offline_Model> createState() => _Offline_ModelState();
}

class _Offline_ModelState extends State<Offline_Model> {
  File? filePath;
  String label = '';
  double confidence = 0.0;
  String? selectedFilePath;
  List<String> fileNames = [];
  bool isModelLoaded = false;

  String? uniqueFileName;


  @override
  void initState() {
    super.initState();
    _listFilesInDirectory('/storage/emulated/0/Android/data/com.example.camera/files/'); // Replace with your directory path
  }

  @override
  void dispose() {
    Tflite.close(); // Ensure to close the interpreter when disposing
    super.dispose();
  }

 Future<void> _listFilesInDirectory(String directoryPath) async {
  try {
    final directory = Directory(directoryPath);
    if (await directory.exists()) {
      final files = directory.listSync();
      setState(() {
        // Filter files to include only those with a .tflite extension
        fileNames = files
            .where((file) => file.path.endsWith('.tflite'))
            .map((file) => file.path)
            .toList();
      });
    } else {
      devtools.log("Directory does not exist");
    }
  } catch (e) {
    devtools.log("Error in listing files: $e");
  }
}

  Future<void> _loadModel() async {
    if (selectedFilePath == null) {
      devtools.log("No model selected.");
      return;
    }

    try {
      String? res;
      String fileName = selectedFilePath!.split('/').last;

      switch (fileName) {
        case "apple_leaf.tflite":
          res = await Tflite.loadModel(
            model: "/storage/emulated/0/Android/data/com.example.camera/files/apple_leaf.tflite",
            labels: "/storage/emulated/0/Android/data/com.example.camera/files/apple_leaf.txt",
            numThreads: 1,
            isAsset: false,
            useGpuDelegate: false,
          );
          break;
        case "apple_fruit.tflite":
          res = await Tflite.loadModel(
            model: "/storage/emulated/0/Android/data/com.example.camera/files/apple_fruit.tflite",
            labels: "/storage/emulated/0/Android/data/com.example.camera/files/apple_fruit.txt",
            numThreads: 1,
            isAsset: false,
            useGpuDelegate: false,
          );
          break;
        case "potato_leaf.tflite":
          res = await Tflite.loadModel(
            model: "/storage/emulated/0/Android/data/com.example.camera/files/potato_leaf.tflite",
            labels: "/storage/emulated/0/Android/data/com.example.camera/files/potato_leaf.txt",
            numThreads: 1,
            isAsset: false,
            useGpuDelegate: false,
          );
          break;
        case "potato_vegtable.tflite":
          res = await Tflite.loadModel(
            model: "/storage/emulated/0/Android/data/com.example.camera/files/potato_vegtable.tflite",
            labels: "/storage/emulated/0/Android/data/com.example.camera/files/potato_vegtable.txt",
            numThreads: 1,
            isAsset: false,
            useGpuDelegate: false,
          );
          break;
        case "grape_leaf.tflite":
          res = await Tflite.loadModel(
            model: "/storage/emulated/0/Android/data/com.example.camera/files/grape_leaf.tflite",
            labels: "/storage/emulated/0/Android/data/com.example.camera/files/grape_leaf.txt",
            numThreads: 1,
            isAsset: false,
            useGpuDelegate: false,
          );
          break;

        case "grape_leaf.tflite":
          res = await Tflite.loadModel(
            model: "/storage/emulated/0/Android/data/com.example.camera/files/grape_leaf.tflite",
            labels: "/storage/emulated/0/Android/data/com.example.camera/files/grape_leaf.txt",
            numThreads: 1,
            isAsset: false,
            useGpuDelegate: false,
          );
          break;

        case "corn_leaf.tflite":
          res = await Tflite.loadModel(
            model: "/storage/emulated/0/Android/data/com.example.camera/files/corn_leaf.tflite",
            labels: "/storage/emulated/0/Android/data/com.example.camera/files/corn_leaf.txt",
            numThreads: 1,
            isAsset: false,
            useGpuDelegate: false,
          );
          break;

        case "paddy_leaf.tflite":
          res = await Tflite.loadModel(
            model: "/storage/emulated/0/Android/data/com.example.camera/files/paddy_leaf.tflite",
            labels: "/storage/emulated/0/Android/data/com.example.camera/files/paddy_leaf.txt",
            numThreads: 1,
            isAsset: false,
            useGpuDelegate: false,
          );
          break;
        
        default:
          devtools.log("Model file not recognized.");
          return;
      }

      if (res != null) {
        devtools.log("Model loaded successfully.");
        setState(() {
          isModelLoaded = true;
        });
      } else {
        devtools.log("Model failed to load.");
      }
    } catch (e) {
      devtools.log("Error in model loading: $e");
    }
  }

  Future<void> runModelOnImage(String imagePath) async {
    if (!isModelLoaded) {
      devtools.log("Model is not loaded.");
      return;
    }

    try {
      var recognitions = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 127.5, // Adjusted to normalize images (mean for models is often 127.5)
        imageStd: 127.5,  // Scaling for normalization
        numResults: 2,
        threshold: 0.2,
        asynch: true,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        devtools.log(recognitions.toString());
        setState(() {
          confidence = (recognitions[0]['confidence'] * 100);
          label = recognitions[0]['label'].toString();
        });
        //uniqueFileName = "image_${DateTime.now().millisecondsSinceEpoch}=>${label}.jpg";
        //save_image_file();
        await processImage(selectedFilePath!.split('/').last,label,imagePath);
      } else {
        devtools.log("No recognitions found.");
      }
    } catch (e) {
      devtools.log("Error in running model: $e");
    }
  }

  Future<void> pickImage(bool fromCamera) async {
    final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      filePath = File(image.path);
    });
    print('selected_file');
    print(filePath);

    if (selectedFilePath != null) {
      await _loadModel();
      await runModelOnImage(image.path);
    } else {
      devtools.log("No model selected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GROOT-OFFLINE",style: TextStyle(fontFamily: 'crisp',color: Color.fromARGB(255, 119, 206, 121))),
        backgroundColor: Color.fromARGB(255, 26, 27, 26),
        toolbarHeight: 30,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Dropdown button for file selection
              DropdownButton<String>(
                value: selectedFilePath,
                hint: Text('Select a model'),
                items: fileNames.map((filePath) {
                  return DropdownMenuItem<String>(
                    value: filePath,
                    child: Text(filePath.split('/').last),
                  );
                }).toList(),
                onChanged: (selectedPath) {
                  setState(() {
                    selectedFilePath = selectedPath;
                    isModelLoaded = false; // Reset model loaded flag
                  });
                },
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 20,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Container(
                        height: 280,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/upload.jpg'),
                          ),
                        ),
                        child: filePath == null
                            ? const Text('')
                            : Image.file(
                                filePath!,
                                fit: BoxFit.fill,
                              ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "The Accuracy is ${confidence.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => pickImage(true),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text("Take a Photo"),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => pickImage(false),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    foregroundColor: Colors.black),
                child: const Text("Pick from gallery"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
