import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../AI_chat_screen/broker.dart';
import '../hindi_trans.dart';
import '../current_loc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
   LatLng? mylocation;

  dynamic cat=['Apple','Potato','Corn','grapes','paddy',];
  @override
  Widget build(BuildContext context) {
          String selectedLanguage = widget.lang; // Default language
       print(widget.ip+" camera page");
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
       appBar: AppBar(
        title: const Text(
          'GROOT',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
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
                items:imgtype=="Leaf"? <String>['Apple','Potato','Corn','grapes','paddy',]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style: TextStyle(color:Colors.black),),
                  );
                }).toList() :   <String>['Apple','Potato']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style: TextStyle(color:Colors.black),),
                  );
                }).toList()
                ,
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
                getimg('gallery');
              },
              icon: const Icon(Icons.photo_album,size: 40,color:Colors.black,), // The icon
              label:Text(translator.translate(selectedLanguage,'gallery'),style: TextStyle(color: Colors.black,fontSize: 20,fontFamily:AutofillHints.addressCity),), 
                     // The text
                        ),
              ],
            )
            
            // ,TextButton.icon(
            //   onPressed: () {
                
            //   },
            //   icon: const Icon(Icons.post_add,size: 40,color:Colors.black,), // The icon
            //   label:Text("Additional Info",style: TextStyle(color: Colors.black,fontSize: 20,fontFamily:AutofillHints.addressCity),), 
            //          // The text
            //             ),


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
    try {
      await _showEnableLocationDialog(context);
          Map<String, double> coordinates = await getCurrentLocation();
          FormData formData= FormData.fromMap({
                'file': await MultipartFile.fromFile(img.path, filename: 'upload.jpg',),
                'type':imgtype,
                'crop_name':data_file,
                'location':coordinates
              });

             

          var response = await Dio().post(
            "http://${widget.ip}:5000/upload",
            data: formData,
          );
          if (response.statusCode == 200) { // HTTP 201 Created
            print(response.data); // Print the response data
            if(response.data['diseased']==true)
            {
              print(response.data);
               _showDialog('Diseased', response.data['result'],response.data['insert_id'],response.data['ref']);
            } 
            else
            {
             _show_img_err();
            }
          }
           else {
            print('Failed to post data');
          }
      } catch (e) {
        print(e);
      } 
}


Future<void> _showEnableLocationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent dialog from closing on tap outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Remainder'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('If location is Disabled please Enable it.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          
        ],
      );
    },
  );
}

 void _showDialog(String title, String message,String id,String ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text('Disease Name: '+message),
          actions: [
            TextButton(
              child: Text('Proceed'),
              onPressed: () {
                
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Broker(ip: widget.ip, file_path: message+".txt",insertion_id:id,disease:ref,disease_name:message),
                  ),
                );

              },
            ),

            TextButton(
              child: Text('Back'),
              onPressed: () {  
                 Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }



 void _show_img_err() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Ensure The image is correct"),
          actions: [
            TextButton(
              child: Text('Back'),
              onPressed: () {  
                 Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

}

 
