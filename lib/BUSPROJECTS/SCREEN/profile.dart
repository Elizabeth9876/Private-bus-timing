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
        '/help': (context) =>  HelpSupportPage(),
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
    // ... other routes ...
  ];

  List<Map<String, dynamic>> filteredBuses = [];

  @override
  void initState() {
    super.initState();
   
  }

  @override
  void dispose() {
    _pageController.dispose();
    _carouselController.dispose();
    
  }

  // ... [Keep all your existing helper methods like _startAutoPlay, _stopAutoPlay, etc.] ...

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel Slider
          SizedBox(
            height: 220,
            child: GestureDetector(
          
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
          
          // ... [Rest of your home page widgets] ...
        ],
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 30),
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue[100],
            child: const Icon(
              Icons.person,
              size: 60,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'john.doe@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),

          // Profile Options
          _buildProfileOption(Icons.person, 'Personal Information', route: '/personal'),
          _buildProfileOption(Icons.settings, 'Settings', route: '/settings'),
          _buildProfileOption(Icons.help, 'Help & Support', route: '/help'),
          _buildProfileOption(Icons.logout, 'Logout', isLogout: true),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {String? route, bool isLogout = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.blue,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : Colors.black87,
            fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
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
      builder: (context) => AlertDialog(
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

// Profile Pages
class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Information')),
      body: const Center(
        child: Text('This is your personal information.'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Text('Settings page content here.'),
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  HelpSupportPage({super.key});
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.question_answer_outlined, color: Colors.blue),
              title: const Text('FAQs'),
              subtitle: const Text('Common questions answered'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('FAQ tapped')),
                );
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.email_outlined, color: Colors.blue),
              title: const Text('Email Us'),
              subtitle: const Text('support@example.com'),
              onTap: () {},
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.phone_outlined, color: Colors.blue),
              title: const Text('Call Us'),
              subtitle: const Text('+91 98765 43210'),
              onTap: () {},
            ),
            const Divider(),

            const SizedBox(height: 20),
            const Text(
              'Send a Message',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message sent successfully!')),
                  );
                  _messageController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a message')),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}