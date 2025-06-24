import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';
import 'services/theme_data.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exposure Explorers',
      debugShowCheckedModeBanner: false,

      // Color theme
      theme: customTheme,

      // Routing
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}
