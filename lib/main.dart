import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/BUSPROJECTS/SCREEN/loginpage.dart';
import 'package:flutter_application_1/BUSPROJECTS/SCREEN/secondpage.dart';
import 'package:flutter_application_1/firebase_options.dart';
void main() async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const BusApp(),
  ));
}

class BusApp extends StatelessWidget {
  const BusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B6CFF), Color(0xFF1E2A78)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Custom background shapes
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: BackgroundPainter(),
          ),

          // Main content
          const SafeArea(
            child: WelcomeContent(),
          ),
        ],
      ),
    );
  }
}

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WelcomeText(),
            const SizedBox(height: 60),
            // Action buttons
            const SignInSignUpButtons(),
          ],
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Welcome",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Enjoy your journey",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class SignInSignUpButtons extends StatelessWidget {
  const SignInSignUpButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          child: const Text(
            "Sign in",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const REGISTER()
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "Sign up",
            style: TextStyle(
              color: Color(0xFF1E2A78),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Abstract wave shape
    paint.color = Colors.white.withOpacity(0.1);
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    path1.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.4,
      size.width * 0.6,
      size.height * 0.2,
    );
    path1.quadraticBezierTo(
      size.width * 0.9,
      0,
      size.width,
      size.height * 0.1,
    );
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();
    canvas.drawPath(path1, paint);

    // Abstract circles
    paint.color = Colors.white.withOpacity(0.2);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.7),
      25,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.6),
      35,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      40,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: const Center(child: Text("Sign In Screen")),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: const Center(child: Text("Sign Up Screen")),
    );
  }
}