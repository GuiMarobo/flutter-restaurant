import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'app/theme.dart';

// Ponto de entrada do app Garfada.
void main() {
  runApp(const GarfadaApp());
}

// Widget raiz: define o tema e as rotas de navegação.
class GarfadaApp extends StatelessWidget {
  const GarfadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garfada',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generate,
    );
  }
}
