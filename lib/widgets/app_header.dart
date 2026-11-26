import 'package:flutter/material.dart';

import '../app/theme.dart';

// Cabeçalho com a identidade do app: ícone + nome "Garfada" (RF01).
class AppHeader extends StatelessWidget {
  final Widget? trailing; // ação opcional à direita

  const AppHeader({super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 4),
      child: Row(
        spacing: 10,
        children: [
          // "Logo": garfo e faca num quadrado laranja arredondado
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant, color: Colors.white, size: 20),
          ),
          Expanded(
            child: Text(
              'Garfada',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
          ?trailing, // só aparece se existir
        ],
      ),
    );
  }
}

// Título de seção com contador opcional (ex.: "Todas as receitas  [50]").
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int? count;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            spacing: 8,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (count != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.soft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            ),
        ],
      ),
    );
  }
}
