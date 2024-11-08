import 'package:flutter/material.dart';
import 'card.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  final String ip;

  const Home({Key? key, required this.ip}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<LatLng> locationsToPass = [];
  String searchText = '';
  List<String> diseased_area=[];
  // Create an empty list for SampleCard objects
  List<SampleCard> allCards = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize the 'loc_map' card and load other cards dynamically
    allCards.add(loc_map(cardName: 'Map', locationsToPass: locationsToPass,disease_name:diseased_area));

    loadCards(); // Load cards from the backend
  }

  @override
  Widget build(BuildContext context) {
    // Filter the list of cards based on the searchText
    List<SampleCard> filteredCards = allCards.where((card) {
      return card.cardName.toLowerCase().contains(searchText.toLowerCase()) || card.cardName.toLowerCase() == "map";
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                searchText = searchText;
              });
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Affected-Areas', // Replace with your heading text
                  style: TextStyle(
                    fontSize: 24, // Adjust font size as needed
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Adjust color as needed
                  ),
                ),
              ),
              // Display only the filtered cards
              Column(
                children: filteredCards,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadCards() async {
    try {
      // Fetch data from the backend
       Response response = await Dio().get('http://${widget.ip}:5000/post_data');

      if (response.statusCode == 200) {
        dynamic data = response.data['Data'];

        for (dynamic i in data) {
          print(i);
          LatLng location = LatLng(i['coordinates'][0], i['coordinates'][1]);
          locationsToPass.add(location);
          diseased_area.add(i['Disease-name']);
          allCards.add(SampleCard(
            ip: widget.ip,
            cardName: i['Disease-name'],
            crop_name: i['plant-name'],
            img_path: i['img'],
            area: i['district'],
            solution:(i['Ai_solution']!=Null)?i['Ai_solution']:"No info provided",
          ));

          print(i);
        }

        // //for mysql db
        // for (dynamic i in data) {
        //   print(i);
          
        //   // Check if 'coordinates' is a list
          
        //     double lat = i[4] is String ? double.parse(i[4]) : i[4];
        //     double lng = i[5] is String ? double.parse(i[5]) : i[5];

        //     LatLng location = LatLng(lat, lng);
        //     locationsToPass.add(location);
          
        //   diseased_area.add(i[7]);
        //   allCards.add(SampleCard(
        //     ip: widget.ip,
        //     cardName: i[7],
        //     crop_name: i[3],
        //     img_path: i[6],
        //     area: i[1],
        //     solution:  'No solution available', // Handle missing 'Ai_solution' key
        //   ));
        // }


        setState(() {
          allCards = allCards;
        });
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
