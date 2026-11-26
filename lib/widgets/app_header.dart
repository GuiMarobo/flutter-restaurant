import 'package:flutter/material.dart';

import '../app/theme.dart';

// Cabeçalho com a identidade do app ("Saborê") e uma linha divisória (RF01).
class AppHeader extends StatelessWidget {
  final Widget? trailing; // ação opcional à direita

  const AppHeader({super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 12, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Saborê',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.title,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ?trailing, // só aparece se existir
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12, right: 12),
            child: Divider(height: 1, color: AppColors.border),
          ),
        ],
      ),
    );
  }
}

// Título de seção com subtítulo opcional (ex.: "Favoritos" / "Receitas salvas...").
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool large;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Text(
            title,
            style: (large ? textTheme.headlineSmall : textTheme.titleLarge)
                ?.copyWith(color: AppColors.title, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.text),
            ),
        ],
      ),
    );
  }
}
