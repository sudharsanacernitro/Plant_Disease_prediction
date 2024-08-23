import 'package:camera/home/layout_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../AI_chat_screen/broker.dart';
import '../hindi_trans.dart';

class Camera extends StatefulWidget {
 final String ip;
 final String lang;
  const Camera({Key? key,required this.ip,required this.lang}) : super(key: key);

  @override
  State<Camera> createState() => __CameraState();
}

class __CameraState extends State<Camera> {

  File ? _selectedimg;
   dynamic img;
   String imgtype="Leaf";
   String data_file="Apple";
    Translator translator = Translator();


  @override
  Widget build(BuildContext context) {
          String selectedLanguage = widget.lang; // Default language
       print(widget.ip+" camera page");
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [            
             _selectedimg!=null? TextButton.icon(
              onPressed: () {
                // Add your onPressed code here!
                print('TextButton Pressed');
                 postInfo();
              },
              icon: const Icon(Icons.upload_file,size: 40,color:Colors.black,), // The icon
              label:const  Text('upload',style: TextStyle(color: Colors.black,fontSize: 20,fontFamily:AutofillHints.addressCity),), 
                     // The text
                        ):Container(),
            _selectedimg!=null? Image.file(_selectedimg!,width: screenWidth,height: screenWidth,):Image.asset('assets/upload.jpg'),

             Center(
               child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  DropdownButton<String>(
                  value: imgtype,
                  items: <String>['Leaf', 'Fruit']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(color:Colors.black),),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      imgtype = newValue!;
                    });
                  },
                  ),
                  const SizedBox(width: 20,),
                  DropdownButton<String>(
                value: data_file,
                items: <String>['Apple', 'Potato','Corn','BlueBerry']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style: TextStyle(color:Colors.black),),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    data_file = newValue!;
                  });
                },
                           ),
                 ]
                 
               ),
             ),

            Row(
              children: [
                TextButton.icon(
              onPressed: () {
                // Add your onPressed code here!
                print('TextButton Pressed');
                getimg('camera');
              },
              icon: const Icon(Icons.photo_camera,size: 50,color:Colors.black,), // The icon
              label:const  Text('Camera',style: TextStyle(color: Colors.black,fontSize: 20,fontFamily:AutofillHints.addressCity),), 
                     // The text
                        ),
              const SizedBox(width: 20),
               TextButton.icon(
              onPressed: () {
                // Add your onPressed code here!
                print('TextButton Pressed');
                getimg('gallery');
              },
              icon: const Icon(Icons.photo_album,size: 40,color:Colors.black,), // The icon
              label:Text(translator.translate(selectedLanguage,'gallery'),style: TextStyle(color: Colors.black,fontSize: 20,fontFamily:AutofillHints.addressCity),), 
                     // The text
                        ),
              ],
            ),
          ],
          
        )
      ),
    );
  }


  Future getimg(dynamic a) async
  {

   
    if(a=="camera")
    {
    img=await ImagePicker().pickImage(source: ImageSource.camera);
    }
    else{
          img=await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if(img==null)return;

  
    setState(() {
      _selectedimg=File(img!.path);
    });
  }




Future<void> postInfo() async {
 FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(img.path, filename: 'upload.jpg',),
      'type':imgtype,
    });
    try {
          var response = await Dio().post(
            "http://${widget.ip}:5000/upload",
            data: formData,
          );
          if (response.statusCode == 200) { // HTTP 201 Created
            print(response.data); // Print the response data
            if(response.data['diseased']==true)
            {
              _showDialog('Diseased', response.data['result']);
            } 
            else
            {
              if(response.data['non-img']==true)
              {
                   _showDialog('No predictable image found', response.data['result']);
              }
              else{
                   _showDialog('Healthy', response.data['result']);
              }
            }
            
          }
           else {
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
          content: Text('Disease Name: '+message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Broker(ip: widget.ip, file_path: message+".txt"),
                  ),
                );

              },
            ),
          ],
        );
      },
    );
  }



}

 
