

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "../g_map.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';

class SampleCard extends StatelessWidget {
  const SampleCard({required this.ip,required this.cardName, required this.crop_name, required this.img_path,required this.area,required this.solution});
  final String cardName, crop_name, img_path,ip,area,solution;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - (10 * 2);
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
         onTap: () async{
        // Remove 'const' from GoogleMaps instantiation
       
          await _showinfo(context,solution);
      },
        child: SizedBox(
          
          child: Container(
            decoration:  const BoxDecoration(
                color:  Color.fromARGB(255, 55, 58, 55),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), // Radius for the top-left corner
                  bottomLeft: Radius.circular(20), // Radius for the bottom-left corner
                  topRight: Radius.circular(20), 
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow color
                    blurRadius: 10, // Softness of the shadow
                    offset: Offset(0, 4), // Shadow position (x, y)
                    spreadRadius: 2, // Spread radius for the shadow
                  ),
                ],
              ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Stack(
                      alignment: Alignment.bottomLeft, // Aligns the text to the center of the image
                      children: [
                        // Background image
                        ClipRRect(
                          borderRadius: BorderRadiusDirectional.all( Radius.circular(20)), // Optional rounded corners
                          child: Image.network(
                            img_path,
                            width: 290,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Text on top
                        Positioned(
                           bottom: 10,
                          left: 20,
                          child: Text(
                            cardName,
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 24, // Font size
                              fontWeight: FontWeight.bold, // Font weight
                              shadows: [
                                Shadow(
                                  blurRadius: 5, // Softens the shadow
                                  color: Colors.black, // Shadow color
                                  offset: Offset(2, 2), // Moves the shadow
                                ),
                              ],
                            ),
                          ),
                        ),]),
                  ),
                //   CircleAvatar(
                //   radius: 80,
                // backgroundImage: NetworkImage('$img_path'),
                //   backgroundColor: Colors.grey,
                // ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SizedBox(
                      width: 0.9 * cardWidth, // Set the width
                      height: 50, // Set the height
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left)
                        mainAxisAlignment: MainAxisAlignment.spaceAround, // Centers the children vertically
                        children: <Widget>[
                          // Align text to the left
                          Column(
                            children: [
                              Text(
                            'Plant-Name:',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),
                          ), // Text aligned to the left
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                            child: Text(crop_name, textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                          ),
                            ],
                          ),

                          Column(
                            children: [
                              Text(
                            'Plant-Name:',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),
                          ), // Text aligned to the left
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                            child: Text(area, textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                          ),
                            ],
                          ),
                          
                    
                          
                        ],
                      ),
                    ),
                  ),
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class loc_map extends SampleCard {
  final List<LatLng> locationsToPass;
  final List<String> disease_name;
  loc_map({required String cardName, required this.locationsToPass,required this.disease_name})
      : super(ip: "Noen", cardName: cardName, crop_name: 'None', img_path: 'None', area: 'none',solution: "none");

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        // Remove 'const' from GoogleMaps instantiation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoogleMaps(locations: locationsToPass,disease_name:disease_name)),
        );
      },
      child: Container(
        width: screenWidth*.95,
        
        margin: EdgeInsets.all(4),
        decoration: const BoxDecoration( 
         
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(66, 216, 53, 53), // Shadow color
                  blurRadius: 10, // Softness of the shadow
                  offset: Offset(0, 4), // Shadow position (x, y)
                  spreadRadius: 2, // Spread radius for the shadow
                ),
 
              ],
            ),
        child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Optional rounded corners
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/map.jpg',
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 2.0,
                          sigmaY: 2.0,
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(0), // Transparent overlay
                        ),
                      ),
                    ),
                        const Positioned(
                          bottom: 10,
                          right: 10,
                          child: Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 50, // Adjust icon size
                                ),
                        ),
                        Positioned(
                         bottom: 10,
                        left: 80,
                        child: Text(
                          "Diseased Areas",
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 24, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                            shadows: [
                              Shadow(
                                blurRadius: 5, // Softens the shadow
                                color: Colors.black, // Shadow color
                                offset: Offset(2, 2), // Moves the shadow
                              ),
                            ],
                          ),
                        ),
                      )
                    
                  ],
                ),
              ),
             
              

      ),
    );
  }
}


class post_heading extends SampleCard {
  const post_heading({required String cardName}) : super(ip:"Noen",cardName: cardName, crop_name: 'None', img_path: 'None',area:'none',solution: "none");
  
  @override
  
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - (10 * 2);
    return  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Solutions', // Replace with your heading text
                      style: TextStyle(
                        fontSize: 24, // Adjust font size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Adjust color as needed
                      ),
                    ),
                  );
    
  }
}

 

Future<void> _showinfo(BuildContext context,String solution) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevent dialog from closing on tap outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Solution'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(solution),
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
