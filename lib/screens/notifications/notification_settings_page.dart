import 'package:flutter/material.dart';
import 'package:inkora/services/notification_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _isLoading = true;
  bool _followsEnabled = true;
  bool _commentsEnabled = true;
  bool _likesEnabled = true;
  bool _groupRequestsEnabled = true;
  bool _updatesEnabled = true;
  bool _promotionsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final settings = await NotificationService.getNotificationSettings();
      
      setState(() {
        _followsEnabled = settings['follows'] ?? true;
        _commentsEnabled = settings['comments'] ?? true;
        _likesEnabled = settings['likes'] ?? true;
        _groupRequestsEnabled = settings['groupRequests'] ?? true;
        _updatesEnabled = settings['updates'] ?? true;
        _promotionsEnabled = settings['promotions'] ?? false;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notification settings: $e');
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des paramètres')),
      );
    }
  }
  
  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await NotificationService.saveNotificationSettings(
        follows: _followsEnabled,
        comments: _commentsEnabled,
        likes: _likesEnabled,
        groupRequests: _groupRequestsEnabled,
        updates: _updatesEnabled,
        promotions: _promotionsEnabled,
      );
      
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paramètres enregistrés')),
      );
    } catch (e) {
      print('Error saving notification settings: $e');
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'enregistrement des paramètres')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres des Notifications'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _saveSettings,
            icon: _isLoading 
                ? SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(Icons.save),
            tooltip: 'Enregistrer',
          ),
        ],
      ),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Activité sociale",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text("Nouveaux abonnés"),
                  subtitle: const Text("Recevoir des notifications quand quelqu'un vous suit"),
                  value: _followsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _followsEnabled = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text("Commentaires"),
                  subtitle: const Text("Recevoir des notifications pour les commentaires sur vos livres"),
                  value: _commentsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _commentsEnabled = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text("J'aime"),
                  subtitle: const Text("Recevoir des notifications quand quelqu'un aime vos livres ou listes"),
                  value: _likesEnabled,
                  onChanged: (value) {
                    setState(() {
                      _likesEnabled = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text("Demandes de groupe"),
                  subtitle: const Text("Recevoir des notifications pour les demandes d'adhésion à vos groupes"),
                  value: _groupRequestsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _groupRequestsEnabled = value;
                    });
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Système",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text("Mises à jour"),
                  subtitle: const Text("Recevoir des notifications pour les nouvelles fonctionnalités"),
                  value: _updatesEnabled,
                  onChanged: (value) {
                    setState(() {
                      _updatesEnabled = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text("Promotions"),
                  subtitle: const Text("Recevoir des offres spéciales et des promotions"),
                  value: _promotionsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _promotionsEnabled = value;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

