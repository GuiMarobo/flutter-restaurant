import 'package:flutter/material.dart';

import '../app/theme.dart';

// Campo "Buscar pelo nome" usado na tela principal e na tela de pesquisa.
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback onSubmitted;
  final FormFieldValidator<String>? validator;

  const SearchField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.focusNode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const Key('searchField'),
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (_) => onSubmitted(), // "Enter" do teclado pesquisa
      decoration: const InputDecoration(
        hintText: 'Buscar pelo nome',
        prefixIcon: Icon(Icons.search, color: AppColors.text),
        // Borda vermelha quando a consulta é recusada
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.favorite),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.favorite, width: 2),
        ),
      ),
    );
  }
}
