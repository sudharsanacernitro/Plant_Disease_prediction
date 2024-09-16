import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class VideoDownloadState {

  VideoDownloadState({required this.ip, required this.model_name});

  final String ip,model_name;
  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;

  Future<bool> saveVideo(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.manageExternalStorage)) {
          // Get the app's external storage directory
          directory = await getExternalStorageDirectory();
          print("Directory: ${directory?.path}");
        } else {
          return false;
        }
      } else {
        // For non-Android platforms, use a temporary directory
        directory = await getTemporaryDirectory();
      }

      if (directory != null) {
        File saveFile = File("${directory.path}/$fileName");

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        if (await directory.exists()) {
          await dio.download(url, saveFile.path, onReceiveProgress: (value1, value2) {
          });
          print("File saved at: ${saveFile.path}");
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }

  downloadFile() async {
   
    bool downloaded = await saveVideo(
        "http://$ip:5000/model_download/$model_name",
        "$model_name");
    if (downloaded) {
      print("File Downloaded Successfully");
      return true;
    } else {
      print("Problem Downloading File");
      return false;
    }
   
  }

 
}

//'/storage/emulated/0/Android/data/com.example.camera/files/video.mp4'


class _FileListScreenState {
  late Future<List<FileSystemEntity>> _files;

  void initState() {
    _files = _listFilesInDirectory('/storage/emulated/0/Android/data/com.example.camera/files/'); // Replace with your directory path
  }

  Future<List<FileSystemEntity>> _listFilesInDirectory(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (await directory.exists()) {
      return directory.listSync(); // Synchronously list files
    } else {
      throw Exception("Directory does not exist");
    }
  }
}