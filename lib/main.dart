import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';
import 'services/theme_data.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// For responsive UI
double _scaleFactor(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 400) return 0.7;
  if (width < 850) return 0.8;
  if (width > 1024) return 1;
  return 0.9;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(_scaleFactor(context))),
  child: 

    MaterialApp(
      title: 'Exposure Explorers',
      debugShowCheckedModeBanner: false,

      // Color theme
      theme: customTheme,

      // Routing
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
      },
    )
  );}
}
