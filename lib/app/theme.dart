import 'package:flutter/material.dart';

// Paleta de cores do Garfada: tons quentes de laranja e creme.
class AppColors {
  static const primary = Color(0xFFE2622C); // laranja dos botões
  static const ink = Color(0xFF2A211C); // marrom quase preto dos títulos
  static const background = Color(0xFFFFFAF5); // creme do fundo
  static const surface = Colors.white; // cartões
  static const soft = Color(0xFFFDEBDF); // laranja clarinho (campos, ícones)
  static const placeholder = Color(0xFFF3E6DA); // fundo da imagem
  static const muted = Color(0xFF7A6E66); // textos secundários
  static const border = Color(0xFFF0E2D6);
  static const favorite = Color(0xFFE0453A); // coração e erros
  static const star = Color(0xFFF2A93B); // estrela da nota
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    surface: AppColors.background,
    error: AppColors.favorite,
  );

  const pill = StadiumBorder(); // botões e campos em formato de pílula
  const buttonText = TextStyle(fontWeight: FontWeight.w700, fontSize: 15);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.ink,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.ink,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    ),
    // Campos sem borda, com fundo laranja clarinho
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.soft,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: TextStyle(color: AppColors.muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: AppColors.favorite),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: AppColors.favorite, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        textStyle: buttonText,
        shape: pill,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: AppColors.primary,
        textStyle: buttonText,
        side: const BorderSide(color: AppColors.primary),
        shape: pill,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: buttonText,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.soft,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.muted,
        ),
      ),
    ),
  );
}
