import 'package:flutter/material.dart';

import '../app/theme.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool loading;

  const SearchField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.focusNode,
    this.validator,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Expanded(
          child: TextFormField(
            key: const Key('searchField'),
            controller: controller,
            focusNode: focusNode,
            validator: validator,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (_) => onSubmitted?.call(),
            decoration: const InputDecoration(
              hintText: 'Nome da receita',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.search, color: AppColors.primary),
              ),
            ),
          ),
        ),
        SizedBox.square(
          dimension: 52,
          child: IconButton.filled(
            tooltip: 'Pesquisar',
            onPressed: onSubmitted,
            icon: loading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.arrow_forward_rounded),
          ),
        ),
      ],
    );
  }
}
