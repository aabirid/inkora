import 'package:flutter/material.dart';
import 'package:inkora/providers/auth_provider.dart';
import 'package:inkora/providers/follow_provider.dart';
import 'package:inkora/providers/forum_data_provider.dart';
import 'package:inkora/providers/join_provider.dart';
import 'package:inkora/screens/auth/login_page.dart';
import 'package:inkora/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:inkora/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FollowProvider()),
        ChangeNotifierProvider(create: (_) => FollowProvider()),
        ChangeNotifierProvider(create: (_) => JoinProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ForumDataProvider>(
          create: (_) => ForumDataProvider(),
          update: (_, authProvider, forumProvider) {
            if (authProvider.isAuthenticated && authProvider.currentUser != null) {
              forumProvider!.currentUser = authProvider.currentUser!;
            }
            return forumProvider!;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ValueNotifier(ThemeMode.light);
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentTheme, __) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentTheme,
          debugShowCheckedModeBanner: false,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              // Check if user is authenticated
              if (authProvider.isAuthenticated) {
                return HomeScreen(themeNotifier: themeNotifier);
              } else {
                return const LoginPage();
              }
            },
          ),
        );
      },
    );
  }
}

