import 'package:flutter/material.dart';
import 'card.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../languages/translator.dart';

class Home extends StatefulWidget {
  final String ip;

  const Home({Key? key, required this.ip}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<LatLng> locationsToPass = [];
  String searchText = '';
  List<String> diseased_area = [];
  List<SampleCard> allCards = [];

  List<SampleCard> MapCard=[];

  @override
  void initState() {
    super.initState();

    MapCard.add(loc_map(cardName: 'Map', locationsToPass: locationsToPass, disease_name: diseased_area));
    //allCards.add(post_heading(cardName: 'Solutions'));

    loadCards();
  }

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<SampleCard> filteredCards = allCards.where((card) {
      return card.cardName.toLowerCase().contains(searchText.toLowerCase()) || card.cardName.toLowerCase() == "map";
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('GROOT',style: TextStyle(fontFamily: 'crisp',color: Color.fromARGB(255, 119, 206, 121)),),
        backgroundColor: Color.fromARGB(255, 26, 27, 26),
        toolbarHeight: 30,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          // Headings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _navigateToPage(0),
                child: Column(
                  children: [
                    Heading_translator("solutions"),
                    if (_currentPage == 0)
                      Container(
                        height: 2,
                        width: 100,
                        color: Colors.black,
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToPage(1),
                child: Column(
                  children: [
                    Heading_translator("Map"),
                    if (_currentPage == 1)
                      Container(
                        height: 2,
                        width: 100,
                        color: Colors.black,
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
               
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        searchbox(),
                        Column(
                          children: filteredCards,
                        ),
                        
                        SizedBox(height: 50,)
                      ],
                    ),
                  ),
                
               
                  SingleChildScrollView(
                    child: Column(
                      children: [searchbox(),
                      SizedBox(height: 30,),
                      Column(
                        children: MapCard,
                      )
                      ],
                    ),
                  ),
                
              ],
            ),
          ),
          
        ],
      ),
    );
  }

  Container searchbox() {
    return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            
            decoration: BoxDecoration(
              color:Color.fromARGB(255, 55, 58, 55),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), // Radius for the top-left corner
                bottomLeft: Radius.circular(20), // Radius for the bottom-left corner
                topRight: Radius.circular(20), 
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child:TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              
              border: InputBorder.none,
              //filled: true,
              //fillColor:Color.fromARGB(255, 55, 58, 55),
              prefixIcon: Icon(Icons.search, color: Colors.white), // Add search icon
              contentPadding: EdgeInsets.symmetric(vertical: 14), // Adjust vertical alignment
            ),
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
          ),
          );
  }

  Future<void> loadCards() async {
    try {
      Response response = await Dio().get('http://${widget.ip}:5000/post_data');

      if (response.statusCode == 200) {
        dynamic data = response.data['Data'];

        for (dynamic i in data) {
          LatLng location = LatLng(i['coordinates'][0], i['coordinates'][1]);
          locationsToPass.add(location);
          diseased_area.add(i['Disease-name']);
          allCards.add(SampleCard(
            ip: widget.ip,
            cardName: i['Disease-name'],
            crop_name: i['plant-name'],
            img_path: i['img'],
            area: i['district'],
            solution: (i['Ai_solution'] != null) ? i['Ai_solution'] : "No info provided",
          ));
        }

        setState(() {});
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
