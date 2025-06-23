import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/BUSPROJECTS/SCREEN/busdetails.dart';

void main() {
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kerala Private Bus Travel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const TravelHomePage(),
    );
  }
}

class TravelHomePage extends StatefulWidget {
  const TravelHomePage({super.key});

  @override
  State<TravelHomePage> createState() => _TravelHomePageState();
}

class _TravelHomePageState extends State<TravelHomePage> {
  int _currentIndex = 0;
  String fromLocation = 'Thevara';
  String toLocation = 'Vytila';
  final PageController _pageController = PageController();
  final PageController _carouselController = PageController(viewportFraction: 0.9);
  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;

  // Carousel configuration
  final Duration _carouselInterval = const Duration(seconds: 3);
  final Curve _carouselCurve = Curves.easeInOut;
  final bool _autoPlay = true;
  final bool _pauseAutoPlayOnManualScroll = true;

  final List<String> locations = [
    'Thevara',
    'Vytila',
    'Thammanam',
    'Palarivattom',
    'Edappally',
    'Kakkanad',
    'Kaloor',
    'Fort Kochi'
  ];

  final List<Map<String, dynamic>> carouselItems = [
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRAwUxu2250mVV1jaeWgfqUc0QXT4cst0ZOw&s',
      'title': 'Comfortable Travel',
      'subtitle': 'Enjoy your journey with our buses',
    },
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbLsJFlEc_qymDy5FCuNLl2U5Eyme9VHjXAQ&s',
      'title': 'Punctual Service',
      'subtitle': 'We value your time with our timely schedules',
    },
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST6HiLeLVQFqdyTiqNCJiYHHQSNdaKSK_j1A&s',
      'title': 'Extensive Network',
      'subtitle': 'Connecting all major locations in Kerala',
    },
  ];

  final List<Map<String, dynamic>> busRoutes = [
    {
      'name': 'Route 1',
      'timing': '6:00 AM - 8:00 AM',
      'route': 'Thevara - Revipuram - Vytila - Thammanam',
      'busImage': 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'stops': ['Thevara', 'Revipuram', 'Vytila', 'Thammanam'],
      'frequency': 'Every 30 mins',
      'driver': 'Rajesh Kumar',
      'conductor': 'Suresh Nair',
      'busNumber': 'KL-07 AB 1234',
      'schedule': [
        {'stop': 'Thevara', 'time': '6:00 AM', 'status': 'Departed'},
        {'stop': 'Revipuram', 'time': '6:20 AM', 'status': 'On Time'},
        {'stop': 'Vytila', 'time': '6:40 AM', 'status': 'Not Reached'},
        {'stop': 'Thammanam', 'time': '7:00 AM', 'status': 'Not Reached'},
      ]
    },
    {
      'name': 'Route 2',
      'timing': '8:30 AM - 10:30 AM',
      'route': 'Vytila - Palarivattom - Edappally - Kakkanad',
      'busImage': 'https://images.unsplash.com/photo-1506929562872-bb421503ef21?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'stops': ['Vytila', 'Palarivattom', 'Edappally', 'Kakkanad'],
      'frequency': 'Every 45 mins',
      'driver': 'Manoj Pillai',
      'conductor': 'Anil Krishnan',
      'busNumber': 'KL-07 CD 5678',
      'schedule': [
        {'stop': 'Vytila', 'time': '8:30 AM', 'status': 'Departed'},
        {'stop': 'Palarivattom', 'time': '8:55 AM', 'status': 'On Time'},
        {'stop': 'Edappally', 'time': '9:20 AM', 'status': 'Not Reached'},
        {'stop': 'Kakkanad', 'time': '9:50 AM', 'status': 'Not Reached'},
      ]
    },
    {
      'name': 'Route 3',
      'timing': '4:00 PM - 6:00 PM',
      'route': 'Thevara - Kaloor - Edappally - Vytila',
      'busImage': 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
      'stops': ['Thevara', 'Kaloor', 'Edappally', 'Vytila'],
      'frequency': 'Every 1 hour',
      'driver': 'Vipin Das',
      'conductor': 'Sunil Menon',
      'busNumber': 'KL-07 EF 9012',
      'schedule': [
        {'stop': 'Thevara', 'time': '4:00 PM', 'status': 'Departed'},
        {'stop': 'Kaloor', 'time': '4:25 PM', 'status': 'Delayed by 10 mins'},
        {'stop': 'Edappally', 'time': '4:50 PM', 'status': 'Not Reached'},
        {'stop': 'Vytila', 'time': '5:20 PM', 'status': 'Not Reached'},
      ]
    },
  ];

  List<Map<String, dynamic>> filteredBuses = [];

  @override
  void initState() {
    super.initState();
    _carouselController.addListener(_onCarouselPageChanged);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _carouselController.dispose();
    _stopAutoPlay();
    super.dispose();
  }

  void _onCarouselPageChanged() {
    setState(() {
      _currentCarouselIndex = _carouselController.page?.round() ?? 0;
    });
  }

  void _startAutoPlay() {
    if (!_autoPlay) return;
    
    _carouselTimer = Timer.periodic(_carouselInterval, (timer) {
      if (_carouselController.hasClients) {
        final nextPage = (_currentCarouselIndex + 1) % carouselItems.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: _carouselCurve,
        );
      }
    });
  }

  void _stopAutoPlay() {
    _carouselTimer?.cancel();
    _carouselTimer = null;
  }

  void _onCarouselManualScrollStart() {
    if (_pauseAutoPlayOnManualScroll) {
      _stopAutoPlay();
    }
  }

  void _onCarouselManualScrollEnd() {
    if (_pauseAutoPlayOnManualScroll) {
      _startAutoPlay();
    }
  }

  Future<void> _showLocationPicker(bool isFrom) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select ${isFrom ? 'From' : 'To'} Location'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: locations.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(locations[index]),
                  onTap: () {
                    Navigator.pop(context, locations[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        if (isFrom) {
          fromLocation = selected;
        } else {
          toLocation = selected;
        }
      });
    }
  }

  void _filterBuses() {
    setState(() {
      filteredBuses = busRoutes.where((bus) {
        final stops = bus['stops'] as List<String>;
        return stops.contains(fromLocation) && stops.contains(toLocation) &&
            stops.indexOf(fromLocation) < stops.indexOf(toLocation);
      }).toList();
    });

    if (filteredBuses.isNotEmpty) {
      _showFilteredBusesDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No buses found for the selected route'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showFilteredBusesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Available Buses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredBuses.length,
                  itemBuilder: (BuildContext context, int index) {
                    final bus = filteredBuses[index];
                    return ListTile(
                      leading: const Icon(Icons.directions_bus, color: Colors.blue),
                      title: Text(bus['name']),
                      subtitle: Text(bus['timing']),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.pop(context);
                        _showBusDetails(bus);
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBusDetails(Map<String, dynamic> bus) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 50),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${bus['name']} Schedule',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${bus['driver']} (Driver) | ${bus['conductor']} (Conductor)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.route, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Route: ${bus['route']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Frequency: ${bus['frequency']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Detailed Schedule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const Divider(height: 20),
              
              ...(bus['schedule'] as List).map((stop) {
                final arrivalTime = stop['time'];
                final departureTime = _calculateDepartureTime(arrivalTime);
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          stop['stop'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          arrivalTime,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          departureTime,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(stop['status']),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            stop['status'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BusDetailsScreen(),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _calculateDepartureTime(String arrivalTime) {
    try {
      final parts = arrivalTime.split(' ');
      final timePart = parts[0];
      final period = parts[1];
      
      final timeParts = timePart.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      
      minute += 2;
      if (minute >= 60) {
        minute -= 60;
        hour += 1;
      }
      
      String newPeriod = period;
      if (hour == 12 && minute > 0 && period == 'AM') {
        newPeriod = 'PM';
      } else if (hour == 12 && minute > 0 && period == 'PM') {
        newPeriod = 'AM';
      }
      
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $newPeriod';
    } catch (e) {
      return arrivalTime;
    }
  }

  Color _getStatusColor(String status) {
    if (status.contains('Departed')) return Colors.blue;
    if (status.contains('On Time')) return Colors.green;
    if (status.contains('Delayed')) return Colors.orange;
    return Colors.grey;
  }

  Widget _buildBusRouteCard({
    required String routeName,
    required String timing,
    required String routeStops,
    required String busImage,
    required String frequency,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    routeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timing,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      busImage,
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routeStops,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              frequency,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.blue[300]),
          const SizedBox(height: 16),
          Text(
            'Your Travel History',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No recent trips found',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue[100],
            child: const Icon(Icons.person, size: 50, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'john.doe@example.com',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Profile Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildProfileOption(Icons.person, 'Personal Information'),
                _buildProfileOption(Icons.history, 'Trip History'),
                _buildProfileOption(Icons.settings, 'Settings'),
                _buildProfileOption(Icons.help, 'Help & Support'),
                _buildProfileOption(Icons.logout, 'Logout', isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {bool isLogout = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.blue),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Carousel Slider
          SizedBox(
            height: 220,
            child: GestureDetector(
              onPanDown: (_) => _onCarouselManualScrollStart(),
              onPanEnd: (_) => _onCarouselManualScrollEnd(),
              child: PageView.builder(
                controller: _carouselController,
                itemCount: carouselItems.length,
                itemBuilder: (context, index) {
                  final item = carouselItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Stack(
                      children: [
                        // Image with gradient overlay
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                            },
                            blendMode: BlendMode.darken,
                            child: Image.network(
                              item['image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, size: 50),
                                );
                              },
                            ),
                          ),
                        ),
                        // Text content
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['subtitle'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Enhanced Carousel Indicator
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(carouselItems.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentCarouselIndex == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentCarouselIndex == index 
                      ? Colors.blue 
                      : Colors.grey[300],
                ),
              );
            }),
          ),
          
          const SizedBox(height: 16),
          
          // Search Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // From Location
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.blue),
                        title: Text(fromLocation, style: const TextStyle(fontSize: 16)),
                        trailing: const Icon(Icons.arrow_drop_down),
                        onTap: () => _showLocationPicker(true),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // To Location
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.red),
                        title: Text(toLocation, style: const TextStyle(fontSize: 16)),
                        trailing: const Icon(Icons.arrow_drop_down),
                        onTap: () => _showLocationPicker(false),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Find Buses Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _filterBuses,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Find Buses',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Popular Routes Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Popular Bus Routes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Bus Routes List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: busRoutes.map((route) {
                return _buildBusRouteCard(
                  routeName: route['name'],
                  timing: route['timing'],
                  routeStops: route['route'],
                  busImage: route['busImage'],
                  frequency: route['frequency'],
                  onPressed: () => _showBusDetails(route),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kerala Private Buses'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildHomePage(),
          _buildHistoryPage(),
          _buildProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}