import 'package:flutter/material.dart';

// Paleta de cores tirada do Guia Visual do Saborê.
class AppColors {
  static const primary = Color(0xFF245C4A); // verde dos botões
  static const title = Color(0xFF1F3D32); // verde escuro dos títulos
  static const background = Color(0xFFF7F4EE); // bege do fundo
  static const surface = Colors.white; // cartões e campos
  static const soft = Color(0xFFE6EEE7); // verde clarinho (chips, ícones)
  static const placeholder = Color(0xFFE5E3D8); // fundo da imagem
  static const text = Color(0xFF5E6461); // textos secundários
  static const border = Color(0xFFDDDDD5);
  static const favorite = Color(0xFFC0502B); // coração e erros
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    surface: AppColors.background,
    error: AppColors.favorite,
  );

  const radius = BorderRadius.all(Radius.circular(12));
  const buttonPadding = EdgeInsets.symmetric(vertical: 16);
  const buttonText = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.title,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.title,
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    ),
    // Campos de texto brancos com borda arredondada
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      hintStyle: const TextStyle(color: AppColors.text),
      border: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: buttonPadding,
        textStyle: buttonText,
        shape: const RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: buttonPadding,
        textStyle: buttonText,
        side: const BorderSide(color: AppColors.primary),
        shape: const RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.soft,
    ),
  );
}
