import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../global_settings.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> processImage(String imgtype, String predDisease, String path) async {
  // Check for internet connectivity
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    print("No Internet Connection");
    await store_offline_img(imgtype, predDisease,  path);
    
  }

  
  await postOfflineDet(imgtype, predDisease, path);
}

Future<void> postOfflineDet(String imgtype, String predDisease, String path) async {
  try {
    String? ip = GlobalSettings.instance.ip;

    // Validate the IP
    if (ip == null || ip.isEmpty) {
      print("Invalid IP address in GlobalSettings.");
      return;
    }

    // Prepare form data
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(path, filename: 'upload.jpg'),
      'type': imgtype,
      'disease_name': predDisease,
    });

    // Make the POST request
    Response response = await Dio().post(
      "http://$ip:5000/offline_upload",
      data: formData,
    );

    // Check the response status
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      print("Success: ${response.data}");
    } else {
      print("Error occured => stored in local");
     await store_offline_img(imgtype, predDisease,  path);
    }
  } on DioError catch (dioError) {
    // Handle Dio-specific errors
    print("Error occured => stored in local");
    await store_offline_img(imgtype, predDisease,  path);
  } catch (e) {
    // Handle other errors
    print("Error occured => stored in local");
   await store_offline_img(imgtype, predDisease,  path);
  }
}

Future<void> store_offline_img(String imgType, String predDisease, String path) async {
  try {
    // Log the provided path for debugging
    print("Input file path: $path");

    // Check if the file path is empty
    if (path.isEmpty) {
      print("Error: Provided file path is empty.");
      return;
    }
    
    
      // Get the app's external storage directory
      Directory? appDir = await getExternalStorageDirectory();
      if (appDir == null) {
        print("App's external storage directory not found!");
        return;
      }

      // Define the folder for storing the image
      String folderPath = '${appDir.path}/Offline_images';

      // Create the folder if it doesn't exist
      Directory(folderPath).createSync(recursive: true);

      // Generate a sanitized unique filename
      String uniqueFileName =
          "image_${DateTime.now().millisecondsSinceEpoch}_${imgType}_${predDisease.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_')}.jpg";

      // Full destination path
      String destinationPath = "$folderPath/$uniqueFileName";

      // Validate the source file
      File sourceFile = File(path);
      if (!await sourceFile.exists()) {
        print("Source file does not exist: $path");
        return;
      }

      // Debugging: Log the copy operation
      print("Copying file to: $destinationPath");

      // Copy the file to the new location
      await sourceFile.copy(destinationPath);

      print("Image copied to: $destinationPath");
    
  } catch (e) {
    print("Error copying image: $e");
  }
}


