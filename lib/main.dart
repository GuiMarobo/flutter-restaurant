import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'app/theme.dart';

void main() {
  runApp(const GarfadaApp());
}

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
