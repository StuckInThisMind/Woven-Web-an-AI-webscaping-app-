import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'search_results_page.dart';
import 'splash_screen.dart';
import 'summarize_page.dart';
import 'common_results_page.dart';
import 'google_page.dart';
import 'yandex_page.dart';
import 'yahoo_page.dart';
import 'duckduckgo_page.dart';
import 'bing_page.dart';
import 'search_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SearchState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wovenweb',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.amber,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/search': (context) => const SearchResultsPage(),
        '/summarize': (context) => const SummarizePage(output: ""), // Placeholder for SummarizePage
        '/common': (context) => const CommonResultsPage(results: []), // Placeholder for CommonResultsPage
        '/google': (context) => const GooglePage(), // Updated GooglePage route
        '/yandex': (context) => const YandexPage(output: ""), // Placeholder for YandexPage
        '/yahoo': (context) => const YahooPage(output: ""), // Placeholder for YahooPage
        '/duckduckgo': (context) => const DuckDuckGoPage(output: ""), // Placeholder for DuckDuckGoPage
        '/bing': (context) => const BingPage(output: ""), // Placeholder for BingPage
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
