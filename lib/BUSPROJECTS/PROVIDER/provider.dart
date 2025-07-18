import 'package:flutter/material.dart';
import 'package:flutter_application_1/BUSPROJECTS/MODEL/class.dart';


class BusDetailsProvider with ChangeNotifier {
  final List<BusSearch> _searchHistory = [];

  List<BusSearch> get searchHistory => List.unmodifiable(_searchHistory);

  void addSearch(BusSearch search) {
    if (!_searchHistory.any((s) => s.from == search.from && s.to == search.to)) {
      _searchHistory.insert(0, search);
      notifyListeners();
    }
  }

  void clearHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  void loadSearch(BusSearch search) {
    debugPrint('Loading bus search: ${search.from} to ${search.to}');
    // Add navigation or action logic here
  }
}
