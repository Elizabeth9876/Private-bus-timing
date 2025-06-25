import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HelpSupportScreen(),
  ));
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.blue,
      ),
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
              leading: const Icon(Icons.help_outline),
              title: const Text('FAQs'),
              subtitle: const Text('Frequently asked questions'),
              onTap: () {
                // Navigate to FAQ screen or show a dialog
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email Support'),
              subtitle: const Text('support@example.com'),
              onTap: () {
                // You can use url_launcher to open email
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call Us'),
              subtitle: const Text('+91 9876543210'),
              onTap: () {
                // You can use url_launcher to call
              },
            ),
            const Divider(),

            const SizedBox(height: 20),
            const Text(
              'Send us a message',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            const MessageForm(),
          ],
        ),
      ),
    );
  }
}

class MessageForm extends StatefulWidget {
  const MessageForm({super.key});

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  void _submitMessage() {
    if (_formKey.currentState!.validate()) {
      String message = _messageController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message sent: $message')),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Type your message here...',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a message' : null,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _submitMessage,
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
