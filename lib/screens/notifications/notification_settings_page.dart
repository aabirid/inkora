import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool messagesEnabled = true;
  bool updatesEnabled = true;
  bool promotionsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres des Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("Recevoir les messages"),
            subtitle: const Text("Recevoir des notifications pour les nouveaux messages"),
            value: messagesEnabled,
            onChanged: (value) {
              setState(() {
                messagesEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Mises à jour"),
            subtitle: const Text("Recevoir des notifications pour les nouvelles fonctionnalités"),
            value: updatesEnabled,
            onChanged: (value) {
              setState(() {
                updatesEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Promotions"),
            subtitle: const Text("Recevoir des offres spéciales et des promotions"),
            value: promotionsEnabled,
            onChanged: (value) {
              setState(() {
                promotionsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
