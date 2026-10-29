import 'package:flutter/material.dart';

import 'pages/home_page.dart';

// Paleta de cores do app
const primary = Color(0xFFC0392B);
const background = Color(0xFFFFF8F0);

// App começa aqui
void main() {
  runApp(const RestaurantApp());
}

// O app inteiro: define o tema e qual tela aparece primeiro.
class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardápio Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: background,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          foregroundColor: primary,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
