import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_application_1/BUSPROJECTS/SCREEN/loginpage.dart';

void main() {
  runApp(
    MaterialApp(
      home: REGISTER(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class REGISTER extends StatefulWidget {
  const REGISTER({super.key});

  @override
  State<REGISTER> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<REGISTER> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  bool agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 185, 179, 252),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.blue, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      ],
                      onSaved: (val) => name = val ?? '',
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter your name';
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) {
                          return 'Name must contain only letters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (val) => email = val ?? '',
                      validator: (val) => val!.contains('@') ? null : 'Enter valid email',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (val) => password = val ?? '',
                      validator: (val) => val!.length < 6 ? 'Minimum 6 characters' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: agreeToTerms,
                          onChanged: (val) {
                            setState(() {
                              agreeToTerms = val ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text("I agree to processing of my data"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        if (!agreeToTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You must agree to data processing')),
                          );
                          return;
                        }

                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Account created successfully!')),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
