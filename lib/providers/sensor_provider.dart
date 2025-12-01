import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flood_detection/models/sensor_data.dart';
import 'package:flutter/material.dart';

class SensorProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<SensorData>>? _sensorSubscription;
  Timer? _initialLoadTimer;

  SensorData _currentSensorData = SensorData(
    floodStatus: 'Connecting...',
    rainSensorValue: 0,
    temperature: 0.0,
    humidity: 0,
    distance: 0,
    sensorId: 'app_capture_001',
    location: 'lab_fasilkom',
  );

  SensorData get currentSensorData => _currentSensorData;

  SensorData _getDefaultSensorData(String status) {
    return SensorData(
      floodStatus: status,
      rainSensorValue: 0,
      temperature: 0.0,
      humidity: 0,
      distance: 0,
      sensorId: 'app_capture_001',
      location: 'lab_fasilkom',
    );
  }

  SensorProvider() {
    _startListeningToSensorData();
  }

  Future<void> fetchSensorData() async {
    _initialLoadTimer?.cancel();
    _sensorSubscription?.cancel();

    _currentSensorData = _getDefaultSensorData('Connecting...');
    notifyListeners();
    _startListeningToSensorData();
  }

  void _startListeningToSensorData() {
    final sensorQuery = _firestore
        .collection('data_mahasiswa')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .withConverter<SensorData>(
          fromFirestore: SensorData.fromFirestore,
          toFirestore: (SensorData data, _) => {},
        );

    _initialLoadTimer = Timer(const Duration(seconds: 5), () {
      if (_currentSensorData.floodStatus == 'Connecting...') {
        _currentSensorData = _getDefaultSensorData('Try Again');
        notifyListeners();
      }
    });

    _sensorSubscription = sensorQuery.snapshots().listen(
      (querySnapshot) {
        _initialLoadTimer?.cancel();

        if (querySnapshot.docs.isNotEmpty) {
          _currentSensorData = querySnapshot.docs.first.data();
        } else {
          _currentSensorData = _getDefaultSensorData('No Document Found');
        }
        notifyListeners();
      },
      onError: (error) {
        _initialLoadTimer?.cancel();
        _currentSensorData = _getDefaultSensorData('Firestore Error');
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _initialLoadTimer?.cancel();
    _sensorSubscription?.cancel();
    super.dispose();
  }
}
