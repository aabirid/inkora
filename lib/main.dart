import 'package:flutter/material.dart';
import 'package:inkora/models/user.dart';
import 'package:inkora/providers/follow_provider.dart';
import 'package:inkora/screens/auth/login_page.dart';
import 'package:inkora/theme/theme.dart';
import 'package:inkora/screens/forum/forum_page.dart';
import 'package:inkora/screens/home/home_page.dart';
import 'package:inkora/screens/mylibrary/library_page.dart';
import 'package:inkora/screens/notifications/notification_page.dart';
import 'package:inkora/screens/profile/my_profile_page.dart';
import 'package:inkora/screens/write/write_page.dart';
import 'package:inkora/screens/search/search_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FollowProvider()), // Ajoute ton provider ici
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentTheme, __) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentTheme,
          debugShowCheckedModeBanner: false,
          home: RootPage(themeNotifier: themeNotifier),
        );
      },
    );
  }
}

class RootPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const RootPage({super.key, required this.themeNotifier});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;

  // Définition de l'utilisateur actuel
  final User currentUser = User(
    id: 1,
    lastName: 'Doe',
    firstName: 'John',
    username: 'john_doe',
    email: 'john.doe@example.com',
    password: 'password123',
    gender: 'Male',
    registrationDate: DateTime.now(),
    status: 'Active',
    photo: 'assets/images/book_cover7.jpeg',
    bio: 'A passionate reader and writer.',
  );

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      body: _getPage(currentPage),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateTo(const LoginPage()),
        child: const Icon(Icons.arrow_forward),
      ),
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

  // Renvoie la page en fonction de l'index sélectionné
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return LibraryPage();
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

  // Fonction pour naviguer facilement
  void _navigateTo(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
