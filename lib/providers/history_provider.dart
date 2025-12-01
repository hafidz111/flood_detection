import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flood_detection/models/history_item.dart';
import 'package:flood_detection/models/sensor_data.dart';
import 'package:flutter/material.dart';

class HistoryProvider with ChangeNotifier {
  final DatabaseReference _dbBaseRef = FirebaseDatabase.instance.ref();
  final List<HistoryItem> _localHistory = [];

  bool _isLoading = false;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  List<HistoryItem> get history => _localHistory;

  bool get isInitialized => _isInitialized;

  Future<void> fetchHistory({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) {
      debugPrint('Skipping fetch: History already loaded.');
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Authentication required. User is not logged in.');
    }

    if (!_isInitialized) {
      _isLoading = true;
      notifyListeners();
    }

    final DatabaseReference dbUserRef = _dbBaseRef
        .child('histories_by_user')
        .child(user.uid)
        .child('data_mahasiswa');

    try {
      final snapshot = await dbUserRef.get();
      _localHistory.clear();

      if (snapshot.exists && snapshot.value != null) {
        final Map<dynamic, dynamic> data =
            snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          final historyMap = value as Map<dynamic, dynamic>;
          final timestampStr = historyMap['timestamp'] as String?;
          final status = historyMap['floodstatus'] as String? ?? 'Unknown';

          if (timestampStr != null) {
            final date = DateTime.parse(timestampStr).toLocal();
            _localHistory.add(HistoryItem(date: date, status: status));
          }
        });
        _localHistory.sort((a, b) => b.date.compareTo(a.date));
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('🚨 FIREBASE RTDB READ ERROR: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHistory(SensorData sensorData) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Authentication required. User is not logged in.');
    }
    final DatabaseReference dbUserRef = _dbBaseRef
        .child('histories_by_user')
        .child(user.uid)
        .child('data_mahasiswa');

    final now = DateTime.now().toUtc();

    final Map<String, dynamic> historyEntry = {
      'distance': sensorData.distance,
      'floodstatus': sensorData.floodStatus,
      'humidity': sensorData.humidity,
      'rainsensorvalue': sensorData.rainSensorValue,
      'temperature': sensorData.temperature,

      'sensor_id': sensorData.sensorId,
      'location': sensorData.location,

      'timestamp': now.toIso8601String(),
    };

    try {
      await dbUserRef.push().set(historyEntry);
      final newHistoryItem = HistoryItem(
        date: now,
        status: sensorData.floodStatus,
      );
      _localHistory.insert(0, newHistoryItem);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
