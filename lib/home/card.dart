

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "../g_map.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
          height: 180,
          child: Container(
            decoration: const BoxDecoration(
                  color:  Color.fromARGB(255, 175, 194, 185),
                   borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(192), // Radius for the top-left corner
                      bottomLeft: Radius.circular(192), // Radius for the bottom-left corner
                      topRight: Radius.circular(42),
                      bottomRight: Radius.circular(42)
                    ), 
                ),
            child: Center(
              child: Row(
                children: [
                  // Image.network(
                  //   'http://${ip}:5000/post_img/$img_path',
                  //    width: 0.6 * cardWidth,
                  //   height: 250,
                  //   fit: BoxFit.cover,
                  // ),
                  CircleAvatar(
                  radius: 80,
                backgroundImage: NetworkImage('$img_path'),
                  backgroundColor: Colors.grey,
                ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                    child: SizedBox(
                      width: 0.4 * cardWidth, // Set the width
                      height: 160, // Set the height
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left)
                        mainAxisAlignment: MainAxisAlignment.center, // Centers the children vertically
                        children: <Widget>[
                          Text(
                            'DISEASE:',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ), // Text aligned to the left
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                            child: Text(cardName, textAlign: TextAlign.center),
                          ), // Align text to the left
                    
                          Text(
                            'Plant-Name:',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ), // Text aligned to the left
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                            child: Text(crop_name, textAlign: TextAlign.center),
                          ),
                    
                          Text(
                            'Affected-Area:',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ), // Text aligned to the left
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                            child: Text(area, textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  )
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
    double cardWidth = screenWidth - (10 * 2);

    return InkWell(
      onTap: () {
        // Remove 'const' from GoogleMaps instantiation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoogleMaps(locations: locationsToPass,disease_name:disease_name)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 5, 211, 149), // Set the background color here
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            'assets/g_map.png',
            width: cardWidth * 1,
            height: 250,
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
