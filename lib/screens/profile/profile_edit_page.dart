import 'package:flutter/material.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        leadingWidth: 85,
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile_default.jpeg'),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildEditableField('Name', 'Sara Jane'),
            _buildEditableField('Username', 'sarajane_zo'),
            _buildEditableField('Bio', "Breathing books that's how I live\nComing Soon... 🔔", maxLines: 3),
            const Divider(height: 32),
            _buildEditableField('Email', 'Sarajane.west@gmail.com', isEditable: false),
            _buildEditableField('Phone', '+1 202 555 0147'),
            _buildDropdownField('Gender', 'Female', ['Male', 'Female', 'Other']),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String value, {int maxLines = 1, bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          TextFormField(
            initialValue: value,
            maxLines: maxLines,
            readOnly: !isEditable,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          DropdownButtonFormField<String>(
            value: value,
            onChanged: (newValue) {},
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}