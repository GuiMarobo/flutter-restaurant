import 'package:flutter/material.dart';

import '../app/theme.dart';

// Feedback de carregamento (RF06): "esqueleto" dos cartões + mensagem.
class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({super.key, this.message = 'Carregando receitas…'});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // Não deixa rolar o esqueleto
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const _Bar(height: 48, radius: 12),
        const SizedBox(height: 24),
        const _SkeletonCard(),
        const _SkeletonCard(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.text),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        spacing: 16,
        children: [
          _Bar(width: 96, height: 100, radius: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                _Bar(height: 12),
                FractionallySizedBox(widthFactor: 0.7, child: _Bar(height: 12)),
                SizedBox(height: 12),
                FractionallySizedBox(widthFactor: 0.5, child: _Bar(height: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Retângulo cinza que imita um conteúdo ainda não carregado.
class _Bar extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _Bar({this.width, required this.height, this.radius = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE4E7DF),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
