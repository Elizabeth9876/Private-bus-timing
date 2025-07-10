import 'dart:async';
import 'package:flutter/material.dart';


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
      routes: {
        '/personal': (context) => const PersonalInfoPage(),
        '/settings': (context) => const SettingsPage(),
        '/help': (context) => const HelpSupportPage(),
      },
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

  // Search history storage
  final List<Map<String, dynamic>> _searchHistory = [];

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
      'busImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST6HiLeLVQFqdyTiqNCJiYHHQSNdaKSK_j1A&s',
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
      'busImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbLsJFlEc_qymDy5FCuNLl2U5Eyme9VHjXAQ&s',
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

  // Add to search history
  void _addToSearchHistory() {
    setState(() {
      // Check if this search already exists in history
      final existingIndex = _searchHistory.indexWhere(
        (item) => item['from'] == fromLocation && item['to'] == toLocation
      );
      
      // Remove existing entry if found
      if (existingIndex != -1) {
        _searchHistory.removeAt(existingIndex);
      }
      
      // Add new entry at the top
      _searchHistory.insert(0, {
        'from': fromLocation,
        'to': toLocation,
        'time': DateTime.now(),
      });
      
      // Limit history to 10 items
      if (_searchHistory.length > 10) {
        _searchHistory.removeLast();
      }
    });
  }

  Future<void> _showLocationPicker(bool isFrom) async {
    List<String> filteredLocations = List.from(locations);
    TextEditingController searchController = TextEditingController();

    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select ${isFrom ? 'From' : 'To'} Location'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search locations...',
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search, color: Colors.blue),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {
                                      filteredLocations = List.from(locations);
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            filteredLocations = locations
                                .where((location) => location
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Expanded(
                      child: filteredLocations.isEmpty
                          ? const Center(
                              child: Text(
                                'No locations found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredLocations.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: const Icon(Icons.location_on, color: Colors.blue),
                                    title: Text(filteredLocations[index]),
                                    onTap: () {
                                      Navigator.pop(context, filteredLocations[index]);
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
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
      _addToSearchHistory();
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
                  Navigator.pop(context);
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
    if (_searchHistory.isEmpty) {
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
              'No recent searches found',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _searchHistory.clear();
                  });
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final historyItem = _searchHistory[index];
              final time = historyItem['time'] as DateTime;
        
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.history, color: Colors.blue),
                  title: Text(
                    '${historyItem['from']} to ${historyItem['to']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                
                  trailing: IconButton(
                    icon: const Icon(Icons.directions_bus, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        fromLocation = historyItem['from'];
                        toLocation = historyItem['to'];
                        _currentIndex = 0;
                      });
                      _pageController.jumpToPage(0);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _filterBuses();
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      fromLocation = historyItem['from'];
                      toLocation = historyItem['to'];
                      _currentIndex = 0;
                    });
                    _pageController.jumpToPage(0);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _filterBuses();
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
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
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildProfileOption(Icons.person, 'Personal Information', route: '/personal'),
                _buildProfileOption(Icons.settings, 'Settings', route: '/settings'),
                _buildProfileOption(Icons.help, 'Help & Support', route: '/help'),
                _buildProfileOption(Icons.logout, 'Logout', isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {String? route, bool isLogout = false}) {
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
        onTap: () {
          if (isLogout) {
            _showLogoutConfirmation(context);
          } else if (route != null) {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController _nameController = TextEditingController(text: "John Doe");
  final TextEditingController _emailController = TextEditingController(text: "john.doe@example.com");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/1.jpg',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              _buildEditableField('Full Name', _nameController),
              _buildEditableField('Email', _emailController),
    
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          suffixIcon: const Icon(Icons.edit, size: 20),
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'App Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSettingOption('Notifications', Icons.notifications, true),
          _buildSettingOption('Dark Mode', Icons.dark_mode, false),
          _buildSettingOption('Privacy Settings', Icons.privacy_tip, false),
          const SizedBox(height: 30),
          const Text(
            'Account Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSettingOption('Change Password', Icons.lock, false),
          _buildSettingOption('Delete Account', Icons.delete, false),
        ],
      ),
    );
  }

  Widget _buildSettingOption(String title, IconData icon, bool isSwitch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: isSwitch
            ? Switch(
                value: true,
                onChanged: (value) {},
                activeColor: Colors.blue,
              )
            : const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need Help?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildHelpOption(
              'FAQs',
              'Find answers to common questions',
              Icons.help_outline,
            ),
            _buildHelpOption(
              'Contact Us',
              'Reach out to our support team',
              Icons.contact_support,
            ),
            _buildHelpOption(
              'Feedback',
              'Share your experience with us',
              Icons.feedback,
            ),
            const SizedBox(height: 30),
            const Text(
              'Send us a Message',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (messageController.text.trim().isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message sent successfully!')),
                  );
                  messageController.clear();
                }
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpOption(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}