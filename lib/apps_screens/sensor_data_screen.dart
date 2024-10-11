import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:to_do_sensor_tracking_app/utils/app_color.dart';

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  List<double> gyroX = [], gyroY = [], gyroZ = [];
  List<double> accelX = [], accelY = [], accelZ = [];

  StreamSubscription? gyroStream, accelStream;
  final double threshold = 1.5;
  bool alertShown = false;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  @override
  void dispose() {
    gyroStream?.cancel();
    accelStream?.cancel();
    super.dispose();
  }

  void startListening() {
    gyroStream = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        gyroX.add(event.x);
        gyroY.add(event.y);
        gyroZ.add(event.z);
        if (gyroX.length > 100) {
          gyroX.removeAt(0);
          gyroY.removeAt(0);
          gyroZ.removeAt(0);
        }
      });
      checkAlert(event.x, event.y);
    });

    accelStream = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        accelX.add(event.x);
        accelY.add(event.y);
        accelZ.add(event.z);
        if (accelX.length > 100) {
          accelX.removeAt(0);
          accelY.removeAt(0);
          accelZ.removeAt(0);
        }
      });
    });
  }

  void checkAlert(double x, double y) {
    if (!alertShown && x.abs() > threshold && y.abs() > threshold) {
      alertShown = true;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ALERT'),
          content: Text('High movement detected on two axes!'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  alertShown = false;
                });
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget buildChart(String title, List<double> xData, List<double> yData, List<double> zData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BlackColor),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(xData.length, (i) => FlSpot(i.toDouble(), xData[i])),
                    isCurved: true,
                    color: RedColor,
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: List.generate(yData.length, (i) => FlSpot(i.toDouble(), yData[i])),
                    isCurved: true,
                    color: GreenColor,
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: List.generate(zData.length, (i) => FlSpot(i.toDouble(), zData[i])),
                    isCurved: true,
                    color: BlueColor,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensor Data')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildChart('Gyro', gyroX, gyroY, gyroZ),
              SizedBox(height: 16),
              buildChart('Accelerometer Sensor Data', accelX, accelY, accelZ),
            ],
          ),
        ),
      ),
    );
  }
}
