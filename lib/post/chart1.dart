import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';

class DemoPage extends StatefulWidget {
  final String ip;
  const DemoPage({super.key,required this.ip,});

  @override
  State<DemoPage> createState() => _DemoPageState();
}


// Convert y-values into FlSpot points
List<FlSpot> generateSpots(List<double> data) {
  return List<FlSpot>.generate(
    data.length,
    (index) => FlSpot(index.toDouble(), data[index]),
  );
}

class _DemoPageState extends State<DemoPage> {
   List<double> humidity = [];
 List<double> pressure = [];
 List<double> temp = [];
 List<double> wind = [];

 Future<void> fetchData() async {
    try {
      var dio = Dio();
      final response = await dio.get('http://${widget.ip}:5000/environment');

      // Assuming the response is a JSON object with keys: "humidity", "pressure", "temp", "wind"
      // Convert each response list into List<double>
      setState(() {
      // Converting each value to double explicitly
      humidity = List<double>.from(response.data['humidity'].map((value) => value.toDouble()));
      pressure = List<double>.from(response.data['pressure'].map((value) => value.toDouble()));
      temp = List<double>.from(response.data['temp'].map((value) => value.toDouble()));
      wind = List<double>.from(response.data['wind'].map((value) => value.toDouble()));
    });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

    @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
          children: [
            // Humidity Graph
            SizedBox(
              height: 300, // Set chart height
              child: LineChart(
                LineChartData(
                  minY: 1000, 
                  lineBarsData: [
                    LineChartBarData(
                      spots: generateSpots(humidity),
                      isCurved: false,
                      color: Colors.blue,
                      barWidth: 3,
                    ),
                  ],
                  titlesData:  FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Text('Humidity (%)'),
                       sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Transform.rotate(
                        angle: -1.5708, // Rotate -90 degrees (in radians)
                        child: Text(
                          value.toString(),
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      );
                    },
                  ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text('Time'),
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: false), // Hide right axis
                    ),
                    topTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: false), // Hide top axis
                    ),
                  ),
                  gridData:  FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(width: 1, color: Colors.black),
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pressure Graph
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: generateSpots(pressure),
                      isCurved: false,
                      color: Colors.green,
                      barWidth: 3,
                    ),
                  ],
                  titlesData:  FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Text('Pressure (hPa)'),
                       sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Transform.rotate(
                        angle: 0, // Rotate -90 degrees (in radians)
                        child: Text(
                          value.toString(),
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      );
                    },
                  ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text('Time'),
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(width: 1, color: Colors.black),
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Temperature Graph
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: generateSpots(temp),
                      isCurved: false,
                      color: Colors.orange,
                      barWidth: 3,
                    ),
                  ],
                  titlesData:  FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Text('Temperature (°C)'),
                      sideTitles: SideTitles(
                    showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Transform.rotate(
                              angle: 0, // Rotate -90 degrees (in radians)
                              child: Text(
                                value.toString(),
                                style: TextStyle(fontSize: 10, color: Colors.black),
                              ),
                            );
                          },
                        ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text('Time'),
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(width: 1, color: Colors.black),
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Wind Speed Graph
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: generateSpots(wind),
                      isCurved: false,
                      color: Colors.red,
                      barWidth: 3,
                    ),
                  ],
                  titlesData:  FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Text('Wind Speed (m/s)'),
                      sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Transform.rotate(
                        angle: 0, // Rotate -90 degrees (in radians)
                        child: Text(
                          value.toString(),
                          style: TextStyle(fontSize: 10, color: Colors.black),
                              ),
                            );
                          },
                        ),
                      
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text('Time'),
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(width: 1, color: Colors.black),
                      bottom: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
  }
}