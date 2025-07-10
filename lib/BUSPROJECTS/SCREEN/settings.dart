import 'package:flutter/material.dart';

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
  
          _buildSettingOption('Dark Mode', Icons.dark_mode, false),
          _buildSettingOption('Privacy Settings', Icons.privacy_tip, false),
          const SizedBox(height: 30),
          const Text(
            'Account Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSettingOption('Change Password', Icons.lock, false),
          navigation
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