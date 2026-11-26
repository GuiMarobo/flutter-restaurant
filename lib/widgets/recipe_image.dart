import 'package:flutter/material.dart';

import '../app/theme.dart';

// Imagem da receita com alternativa visual (RF02):
// - sem endereço de imagem -> mostra um ícone no lugar;
// - carregando -> mostra um indicador pequeno;
// - falha ao baixar -> mostra o mesmo ícone.
class RecipeImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final double iconSize;
  final double radius;

  const RecipeImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.iconSize = 40,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: Icon(
        Icons.restaurant_menu,
        size: iconSize,
        color: AppColors.primary.withValues(alpha: 0.5),
        semanticLabel: 'Imagem indisponível',
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        height: height,
        color: AppColors.placeholder,
        child: url == null
            ? fallback
            : Image.network(
                url!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(
                        child: SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }
}
