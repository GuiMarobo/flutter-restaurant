import 'package:flutter/material.dart';

// Tela de estado reutilizável: carregando, erro, nenhum resultado, pedido vazio.
class StateView extends StatelessWidget {
  final IconData? icon; // null = mostra o indicador de carregamento
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateView({
    super.key,
    this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  const StateView.loading({super.key, required this.message})
    : icon = null,
      title = 'Carregando...',
      actionLabel = null,
      onAction = null;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // SingleChildScrollView evita estouro em telas baixas
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            if (icon == null)
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(),
              )
            else
              Icon(icon, size: 72, color: colors.primary),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (actionLabel != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FilledButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
