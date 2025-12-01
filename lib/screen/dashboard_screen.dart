import 'package:flood_detection/widgets/flood_status_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';
import '../providers/sensor_provider.dart';
import '../widgets/donut_chart.dart';
import '../widgets/progress_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<SensorProvider>(context, listen: false).fetchSensorData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorProvider>(
      builder: (context, sensorData, child) {
        final data = sensorData.currentSensorData;
        const maxRainSensor = 500;
        const maxDistance = 500;

        final bool isDataAvailable =
            !(data.floodStatus == 'Connecting...' ||
                data.floodStatus == 'Firestore Error' ||
                data.floodStatus == 'No Document Found' ||
                data.floodStatus == 'No Document Found (Timeout)' ||
                data.floodStatus == 'Try Again');

        return RefreshIndicator(
          color: const Color(0xFF004D7A),
          onRefresh: () => _refreshData(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FloodStatusPanel(status: data.floodStatus),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DonutChart(
                      title: 'Rain Sensor',
                      value: data.rainSensorValue,
                      maxValue: maxRainSensor,
                      color: Colors.red[800]!,
                      unit: '',
                    ),
                    DonutChart(
                      title: 'Temperature',
                      value: data.temperature,
                      maxValue: 50,
                      color: Colors.blue[600]!,
                      unit: '°C',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ProgressBar(
                  title: 'Humidity (%)',
                  value: data.humidity,
                  maxValue: 100,
                  color: Colors.blue,
                ),

                const SizedBox(height: 10),

                ProgressBar(
                  title: 'Distance (CM)',
                  value: data.distance,
                  maxValue: maxDistance,
                  color: Colors.pink,
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: isDataAvailable
                      ? () {
                          Provider.of<HistoryProvider>(context, listen: false)
                              .addHistory(data)
                              .then((_) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Successfully saved')),
                                );
                              })
                              .catchError((error) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to save history'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D7A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Capture History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
