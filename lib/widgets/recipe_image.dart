import 'package:flutter/material.dart';

import '../app/theme.dart';

class RecipeImage extends StatelessWidget {
  final String? url;
  final double? height;
  final double iconSize;

  const RecipeImage({
    super.key,
    required this.url,
    this.height,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: Icon(
        Icons.ramen_dining,
        size: iconSize,
        color: AppColors.primary.withValues(alpha: 0.45),
        semanticLabel: 'Imagem indisponível',
      ),
    );

    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.placeholder,
      child: url == null
          ? fallback
          : LayoutBuilder(
              builder: (context, constraints) => Image.network(
                url!,
                fit: BoxFit.cover,
                cacheWidth: _decodeWidth(context, constraints),
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(
                        child: SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
            ),
    );
  }

  int? _decodeWidth(BuildContext context, BoxConstraints constraints) {
    final side = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : MediaQuery.sizeOf(context).width;
    return (side * MediaQuery.devicePixelRatioOf(context)).round();
  }
}
