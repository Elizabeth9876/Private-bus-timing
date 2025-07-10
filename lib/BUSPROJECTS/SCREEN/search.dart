import 'package:flutter/material.dart';
import 'package:flutter_application_1/BUSPROJECTS/MODEL/class.dart';
import 'package:flutter_application_1/BUSPROJECTS/SCREEN/historypage.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<SearchHistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Bus Route Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter route',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    final route = _controller.text.trim();
                    if (route.isNotEmpty) {
                      historyProvider.addSearch(route);
                      _controller.clear();
                      // Navigate or show results
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Searched: $route')),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('View Search History'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryPage ()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
