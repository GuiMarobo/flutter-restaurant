import 'package:flutter/material.dart';

import '../app/theme.dart';

// Tela de estado reutilizável (RF07 / RF08):
// erro de conexão, nenhum resultado e nenhum favorito.
class StateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel; // botão de texto opcional
  final VoidCallback? onSecondary;

  const StateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // SingleChildScrollView evita estouro em telas baixas
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone num quadrado arredondado e levemente inclinado
            Transform.rotate(
              angle: -0.08,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.soft,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(icon, size: 44, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 28),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
            if (secondaryLabel != null) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
