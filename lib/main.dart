import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'app/theme.dart';

// Ponto de entrada do app Saborê.
void main() {
  runApp(const SaboreApp());
}

// Widget raiz: define o tema e as rotas de navegação.
class SaboreApp extends StatelessWidget {
  const SaboreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saborê',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generate,
    );
  }
}
