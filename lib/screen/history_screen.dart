import 'package:flood_detection/widgets/history_status_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/history_item.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();

    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );

    if (!historyProvider.isInitialized) {
      historyProvider.fetchHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, historyProvider, child) {
        List<HistoryItem> historyList = historyProvider.history;

        if (historyProvider.isLoading && !historyProvider.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        if (historyList.isEmpty) {
          return const Center(child: Text('No history data available.'));
        }

        return ListView.builder(
          itemCount: historyList.length,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          itemBuilder: (context, index) {
            final item = historyList[index];

            return HistoryStatusCard(date: item.date, status: item.status);
          },
        );
      },
    );
  }
}
