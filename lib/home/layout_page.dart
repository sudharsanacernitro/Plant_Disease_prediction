import 'package:camera/home/card.dart';
import 'package:flutter/material.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() =>
      _Home();
}

class  _Home extends State< Home> {
 

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child:  Center(
          
          child: Column(
            children: [
              SampleCard(cardName: 'card-1'),
              SampleCard(cardName: 'card-1'),
              SampleCard(cardName: 'card-1'),
              SampleCard(cardName: 'card-1')
            ],
          )
          ),
    );
    
  }
}
