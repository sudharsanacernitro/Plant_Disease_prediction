import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SampleCard extends StatelessWidget {
  const SampleCard({required this.cardName});
  final String cardName;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double card_width=screenWidth-(10*2);
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        height: 200,
        child: Container(
      color: Colors.blue,
      child: Center(
        child: Row(
  children: [
    Image.asset('assets/dummy_plant.jpg', width: 0.6 * card_width, height: 250,),
    SizedBox(
      width: 0.4 * card_width,  // Set the width
      height: 200, // Set the height
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left)
        mainAxisAlignment: MainAxisAlignment.center, // Centers the children vertically
        children: <Widget>[
          Text('DISEASE:',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),), // Text aligned to the left
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Text('black-rot', textAlign: TextAlign.center)), // Align text to the left

          Text('Plant-Name:',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),), // Text aligned to the left
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Text('black-rot', textAlign: TextAlign.center)),
          
          Text('Affected-Area:',style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold),), // Text aligned to the left
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
            child: Text('black-rot', textAlign: TextAlign.center)),
        ],
      ),
    )
  ],
)

      ),
        ),
      ),
    );

  }
}