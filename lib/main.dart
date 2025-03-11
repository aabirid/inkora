import 'package:flutter/material.dart';
import 'package:inkora/screens/forum/forum_page.dart';
import 'package:inkora/screens/home/home_page.dart';
import 'package:inkora/screens/mylibrary/library_page.dart';
import 'package:inkora/screens/notifications/notification_page.dart';
import 'package:inkora/screens/profile/profile_page.dart';
import 'package:inkora/screens/write/write_page.dart';
import 'package:inkora/screens/search/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> pages = [
    HomePage(),
    LibraryPage(),
    WritePage(),
    ForumPage(),
    ProfilePage(),
  ];

  // The current page index
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Inkora'),
         actions: [
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
                icon: Icon(Icons.search)),
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
                icon: Icon(Icons.notifications_none_outlined)),
          ],
        ),
         body: pages[currentPage],
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.star),
        // ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.book_rounded), label: 'MyLibrary'),
            NavigationDestination(
                icon: Icon(Icons.add_circle_outline_rounded), label: 'Write'),
            NavigationDestination(
                icon: Icon(Icons.groups_sharp), label: 'Forum'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              currentPage = index;
            });
          },
          selectedIndex: currentPage,
        ));
  }
}
