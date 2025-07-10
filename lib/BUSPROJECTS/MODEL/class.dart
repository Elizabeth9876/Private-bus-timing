import 'package:flutter/material.dart';

class SearchHistoryProvider with ChangeNotifier {
  final List<String> _history = [];

  List<String> get history => _history.reversed.toList();

  void addSearch(String searchTerm) {
    if (!_history.contains(searchTerm)) {
      _history.add(searchTerm);
      notifyListeners();
    }
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
