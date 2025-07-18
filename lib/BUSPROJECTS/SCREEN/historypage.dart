import 'package:flutter/material.dart';
import 'package:flutter_application_1/BUSPROJECTS/PROVIDER/provider.dart';
import 'package:provider/provider.dart';


class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BusDetailsProvider>(context);
    final history = provider.searchHistory;

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.blue[300]),
            const SizedBox(height: 16),
            const Text('Your Travel History', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 16),
            const Text('No recent searches found'),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Searches', style: TextStyle(fontSize: 20)),
              TextButton(
                onPressed: provider.clearHistory,
                child: const Text('Clear All', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.blue),
                  title: Text('${item.from} to ${item.to}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.directions_bus, color: Colors.green),
                    onPressed: () => provider.loadSearch(item),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
