import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'offline_models/offline_pred_screen.dart';
import "video_model.dart";

import '../languages/translator.dart';
import 'dart:ui';
import '../store_permission/download.dart'; // Make sure this import is valid

import './online_model.dart';

import './offline_models/solutions.dart';

class Modelselector extends StatefulWidget {
   final String ip;
 final String lang;
  const Modelselector({Key? key,required this.ip,required this.lang}) : super(key: key);

  @override
  _Modelselector createState() => _Modelselector();
}

class _Modelselector extends State<Modelselector> {

Map<String, String> models = {};

  @override
  void initState() {
    super.initState();
    available_models();
  }

  void available_models() async {
    try {
      final response = await Dio().post('http://${widget.ip}:5000/available_offline_models');
      Map<String, dynamic> data = response.data;
      setState(() {
        models = Map<String, String>.from(data['offline_models']);
      });
    } catch (e) {
      print("Error fetching models: $e");
    }
  }
 
  @override
  Widget build(BuildContext context) {
     double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("GROOT",style: TextStyle(fontFamily: 'crisp',color: Color.fromARGB(255, 119, 206, 121))),
        backgroundColor: Color.fromARGB(255, 26, 27, 26),
        toolbarHeight: 30,
        actions: [
            IconButton(
              icon: Icon(Icons.video_camera_back_outlined,color: Colors.blue,),
              onPressed: () {
               print("Video Model Clicked");
               Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  VideoModel(ip:widget.ip)));           
              },
            ),
          ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Model Type',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15,),
                Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5,                     // Spread radius
                        blurRadius: 7,                       // Blur radius
                        offset: Offset(3, 3),                // Offset: x,y
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          print('Online model button pressed');
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Camera(ip:widget.ip,lang: widget.lang,)));
                          
                        },
                        child: Container(
                          width: screenWidth*.4,
                          height: screenHeight*.2,
                          padding: EdgeInsets.all(40),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: const Color.fromARGB(255, 212, 211, 211),
                          ),
                          child: content_translator("Online"),
                        ),
                      ),
                      InkWell(
                        onTap: () {
            
                          print('Offline model button pressed');
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Offline_Model()));
                          
                        },
                        child: Container(
                          width: screenWidth*.4,
                          height: screenHeight*.2,
                          padding: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color:const Color.fromARGB(255, 212, 211, 211),
                          ),
                                
                          child: content_translator("Offline"),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                 Text(
                  'Download Models',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
    
                models.isEmpty? Center(child: CircularProgressIndicator()):
                show_Models(screenHeight, screenWidth),
                SizedBox(height: 50,)
               
              ],
            ),
          ),
        ),
      ),
    );
  }

  GridView show_Models(double screenHeight, double screenWidth) {
    return GridView.builder(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two cards per row
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 1, // Adjust as needed
              ),
              itemCount: models.length,
              itemBuilder: (context, index) {
                String key = models.keys.elementAt(index);
                String value = models[key]!;
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () async{
                         
                    final download = VideoDownloadState(ip: widget.ip, model_name: key+'.tflite');
                    bool Model_Download = await download.downloadFile();
                    final downloadlabels = VideoDownloadState(ip: widget.ip, model_name: key+'.txt');
                    bool label_Downloaded = await downloadlabels.downloadFile();
                    final download_solution = VideoDownloadState(ip: widget.ip, model_name: key+'.json');
                    bool Solutions_Downloaded = await download_solution.downloadFile();


                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(Model_Download && label_Downloaded && Solutions_Downloaded ? 'Download Successful' : 'Download Failed'),
                          content: Text(Model_Download && label_Downloaded && Solutions_Downloaded
                              ? 'The file has been downloaded successfully.'
                              : 'There was a problem downloading the file.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    },
                    child: Container(
                    
                      //padding: const EdgeInsets.all(8.0),
                      height: .7*screenHeight,
                      width: .3*screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            key,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          // Text(
                          //   value,
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: Colors.grey[600],
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              );
  }
  }

