
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartDialog extends StatelessWidget {
  final Map<String, List<double>> data;

  LineChartDialog({required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Weather Data Line Plot'),
      content: SizedBox(
        width: 300,
        height: 300,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: _getLineChartSpots(data),
                isCurved: true,
                color: Colors.blue,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  List<FlSpot> _getLineChartSpots(Map<String, List<double>> data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data['temp']!.length; i++) {
      spots.add(FlSpot(i.toDouble(), data['temp']![i]));
    }
    return spots;
  }
}

void showWeatherLineChart(BuildContext context) {
  Map<String, List<double>> data = {
    'temp': [79, 79, 79, 77],
    'pressure': [1011, 1010, 1010, 1013],
    'humidity': [90, 94, 83, 88],
    'wind': [3.65, 2.3, 2.3, 4.61],
  };

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LineChartDialog(data: data);
    },
  );
}
