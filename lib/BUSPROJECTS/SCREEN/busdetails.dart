import 'package:flutter/material.dart';
import 'package:flutter_application_1/BUSPROJECTS/SCREEN/travels.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BusDetailsScreen(),
  ));
}

class BusDetailsScreen extends StatelessWidget {
  const BusDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> routeTimings = [
      {'from': 'Vytilla', 'to': 'Thammanam', 'time': '10:00 AM - 10:10 AM'},
      {'from': 'Thammanam', 'to': 'Ravipuram', 'time': '10:10 AM - 10:23 AM'},
      {'from': 'Ravipuram', 'to': 'Thevara', 'time': '10:23 AM - 10:35 AM'},
      {'from': 'Thevara', 'to': 'Kundanoor', 'time': '10:35 AM - 10:50 AM'},
      {'from': 'Kundanoor', 'to': 'Aroor', 'time': '10:50 AM - 11:10 AM'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Bus Full Details"),
        backgroundColor: Colors.blue,
         actions: [
          ElevatedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TravelHomePage()));
          }, 
          child: Text('Back'))
         ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚌 Bus Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRAwUxu2250mVV1jaeWgfqUc0QXT4cst0ZOw&s',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // ℹ️ Bus Info
            const Text(
              'Bus Name: Royal Express',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const Text(
              'Bus Number: KL-45-A-7890',
              style: TextStyle(color: Colors.black87),
            ),
            const Text(
              'Driver Name: Suresh Kumar',
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 24),

            const Text(
              'Route',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vytilla → Thammanam → Ravipuram → Thevara → Kundanoor → Aroor',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 32, color: Colors.blueAccent),

            const Text(
              'Segment Timings',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),

            // 📍 Segment Timings List
            ListView.builder(
              itemCount: routeTimings.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final segment = routeTimings[index];
                return Card(
                  color: const Color(0xFFE3F2FD), // Light blue
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.directions_bus, color: Colors.blue),
                    title: Text(
                      '${segment['from']} → ${segment['to']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    subtitle: Text(
                      'Time: ${segment['time']}',
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
