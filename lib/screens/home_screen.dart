import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inkora/providers/auth_provider.dart';
import 'package:inkora/screens/forum/forum_page.dart';
import 'package:inkora/screens/home/home_page.dart';
import 'package:inkora/screens/mylibrary/library_page.dart';
import 'package:inkora/screens/notifications/notification_page.dart';
import 'package:inkora/screens/profile/my_profile_page.dart';
import 'package:inkora/screens/write/write_page.dart';
import 'package:inkora/screens/search/search_page.dart';

class HomeScreen extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const HomeScreen({super.key, required this.themeNotifier});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;

  // Show logout confirmation dialog
  Future<void> _showLogoutConfirmation() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Text(
            'Confirm Logout',
            style: TextStyle(
              color: theme.textTheme.titleLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                // Perform logout
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user from the auth provider
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Inkora'),
        actions: [
          IconButton(
            icon: Icon(
              widget.themeNotifier.value == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              widget.themeNotifier.value =
                  widget.themeNotifier.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
            },
          ),
          IconButton(
            onPressed: () => _navigateTo(const SearchPage()),
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => _navigateTo(const NotificationPage()),
            icon: const Icon(Icons.notifications_none_outlined),
          ),
          IconButton(
            onPressed: () {
              // Show confirmation dialog before logout
              _showLogoutConfirmation();
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _getPage(currentPage, currentUser),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (int index) => setState(() => currentPage = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.edit_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Return the page based on the selected index
  Widget _getPage(int index, dynamic currentUser) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return LibraryPage(currentUser: currentUser); 
      case 2:
        return const WritePage();
      case 3:
        return const ForumPage();
      case 4:
        return MyProfilePage(currentUser: currentUser);
      default:
        return HomePage();
    }
  }

  // Function to navigate to a new page
  void _navigateTo(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}