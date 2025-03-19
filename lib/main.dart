import 'package:flutter/material.dart';
import 'package:inkora/screens/auth/login_page.dart';
import 'package:inkora/theme/theme.dart';
import 'package:inkora/screens/forum/forum_page.dart';
import 'package:inkora/screens/home/home_page.dart';
import 'package:inkora/screens/mylibrary/library_page.dart';
import 'package:inkora/screens/notifications/notification_page.dart';
import 'package:inkora/screens/profile/my_profile_page.dart';
import 'package:inkora/screens/write/write_page.dart';
import 'package:inkora/screens/search/search_page.dart';

void main() {
  runApp(MyApp());
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

  final List<Widget> pages = [
    HomePage(),
    LibraryPage(),
    WritePage(),
    ForumPage(),
    MyProfilePage(),
  ];

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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext) {
                    return SearchPage();
                  },
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext) {
                    return NotificationPage();
                  },
                ),
              );
            },
            icon: const Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: pages[currentPage],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (int index) {
          setState(() {
            currentPage = index;
          });
        },
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
}
