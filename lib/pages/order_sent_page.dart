import 'package:flutter/material.dart';

import '../routes.dart';

// Confirmação: o pedido foi enviado para a cozinha.
class OrderSentPage extends StatelessWidget {
  const OrderSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              Icon(Icons.check_circle, size: 96, color: colors.primary),
              Text(
                'Pedido enviado!',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Seu pedido foi enviado para a cozinha.\n'
                'Mesa 05 · tempo estimado: 25 minutos.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  // Volta para o Cardápio limpando o histórico de telas
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoutes.home, (_) => false),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Voltar ao cardápio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
