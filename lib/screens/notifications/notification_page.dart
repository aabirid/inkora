import 'package:flutter/material.dart';
import 'package:inkora/screens/notifications/notification_settings_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
// Liste des notifications (exemple de données)
  final List<Map<String, String>> notifications = [
    {
      "title": "Nouveau message",
      "subtitle": "Vous avez reçu un nouveau message de Alice.",
      "time": "Il y a 5 min"
    },
    {
      "title": "Mise à jour disponible",
      "subtitle": "Une nouvelle version de l'application est prête.",
      "time": "Il y a 1 heure"
    },
    {
      "title": "Succès de l'opération",
      "subtitle": "Votre publication a été ajoutée avec succès.",
      "time": "Hier"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        actions: [
          IconButton(onPressed: () { Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsPage(),
      ),
    );}, icon: Icon(Icons.settings_outlined))
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "Aucune notification pour le moment.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  //margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    title: Text(
                      notif["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notif["subtitle"]!),
                    trailing: Text(
                      notif["time"]!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () {
                    },
                  ),
                );
              },
            ),
    );
  }
}
