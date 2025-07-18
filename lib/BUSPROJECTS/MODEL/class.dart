class BusSearch {
  final String from;
  final String to;

  BusSearch({required this.from, required this.to});

  Map<String, String> toMap() => {'from': from, 'to': to};

  static BusSearch fromMap(Map<String, String> map) =>
      BusSearch(from: map['from']!, to: map['to']!);
}
