import 'package:flutter/material.dart';

import '../app/theme.dart';

// Tela de estado reutilizável (RF07 / RF08):
// erro de conexão, nenhum resultado e nenhum favorito.
class StateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryLabel; // botão de texto opcional
  final VoidCallback? onSecondary;

  const StateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // SingleChildScrollView evita estouro em telas baixas
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: CircleAvatar(
              radius: 54,
              backgroundColor: AppColors.soft,
              child: Icon(icon, size: 44, color: AppColors.title),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              color: AppColors.title,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: textTheme.bodyLarge?.copyWith(color: AppColors.text),
          ),
          const SizedBox(height: 40),
          FilledButton(onPressed: onAction, child: Text(actionLabel)),
          if (secondaryLabel != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
          ],
        ],
      ),
    );
  }
}
