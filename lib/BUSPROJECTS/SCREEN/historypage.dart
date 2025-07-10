import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<SearchHistoryProvider>().history;

    return Scaffold(
      appBar: AppBar(title: const Text('Search History')),
      body: history.isEmpty
          ? const Center(child: Text('No search history found.'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(history[index]),
                );
              },
            ),
    );
  }
}
