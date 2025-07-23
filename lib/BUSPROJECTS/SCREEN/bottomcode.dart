import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_1/BUSPROJECTS/SCREEN/historypage.dart'; // Make sure this file exists

void main() {
  runApp(MaterialApp(
    home: BottomCode(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF5F8FF),
        labelStyle: TextStyle(color: Colors.blue),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    ),
  ));
}

// ---------------- BOTTOM NAVIGATION CONTROLLER ---------------- //

class BottomCode extends StatefulWidget {
  const BottomCode({super.key});

  @override
  State<BottomCode> createState() => _BottomCodeState();
}

class _BottomCodeState extends State<BottomCode> {
  int currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    HistoryTab(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ---------------- HOME PAGE ---------------- //

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> fromLocations = ['Thevara', 'Ernakulam', 'Kakkanad'];
  final List<String> toLocations = ['Vytila', 'Aluva', 'Thrissur'];

  String selectedFrom = 'Thevara';
  String selectedTo = 'Vytila';

  int carouselIndex = 0;

  final List<String> carouselImages = [
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1506466010722-395aa2bef877?auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1508610048659-a06b669e30a4?auto=format&fit=crop&w=800&q=60',
  ];

  final List<Map<String, String>> busDetails = [
    {'name': 'City Rider', 'route': 'Thevara - Vytila', 'time': '7:30 AM'},
    {'name': 'Metro Express', 'route': 'Ernakulam - Aluva', 'time': '8:00 AM'},
    {'name': 'GreenLine', 'route': 'Kakkanad - Thrissur', 'time': '9:15 AM'},
  ];

  void searchBuses() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Searching buses'),
        content: Text('From: $selectedFrom\nTo: $selectedTo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Search Buses",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedFrom,
                    decoration: const InputDecoration(labelText: "From"),
                    items: fromLocations
                        .map((location) => DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedFrom = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTo,
                    decoration: const InputDecoration(labelText: "To"),
                    items: toLocations
                        .map((location) => DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedTo = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: searchBuses,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text("Search"),
              ),
            ),
            const SizedBox(height: 32),
            const Text("Popular Routes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            CarouselSlider.builder(
              itemCount: carouselImages.length,
              itemBuilder: (context, index, realIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    carouselImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey),
                  ),
                );
              },
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) =>
                    setState(() => carouselIndex = index),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: carouselImages.asMap().entries.map((entry) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: carouselIndex == entry.key
                        ? Colors.blue
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text("Available Buses",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ...busDetails.map((bus) {
              return Card(
                color: Colors.white,
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading:
                      const Icon(Icons.directions_bus, color: Colors.blue),
                  title: Text(bus['name']!),
                  subtitle: Text('${bus['route']} • ${bus['time']}'),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// ---------------- PROFILE PAGE ---------------- //

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HistoryTab()),
            );
          },
          child: const Text('Go to History'),
        ),
      ),
    );
  }
}
