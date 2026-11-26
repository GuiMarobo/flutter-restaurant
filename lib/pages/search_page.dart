import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recipe.dart';
import '../services/api_exception.dart';
import '../services/recipe_service.dart';
import '../utils/formatters.dart';
import '../utils/search_query.dart';
import '../widgets/app_bottom_bar.dart';
import '../widgets/loading_view.dart';
import '../widgets/recipe_list.dart';
import '../widgets/search_field.dart';
import '../widgets/state_view.dart';

enum SearchStatus { idle, loading, results, empty, error }

class SearchPage extends StatefulWidget {
  final String? initialTerm;

  const SearchPage({super.key, this.initialTerm});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  SearchStatus _status = SearchStatus.idle;
  String _term = '';
  List<Recipe> _results = [];
  ApiException? _error;

  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    final term = widget.initialTerm;
    if (term != null) {
      _controller.text = term;
      _status = SearchStatus.loading;
      _term = term;
      _fetch(term);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_status == SearchStatus.loading) return;

    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }

    final term = normalizeQuery(_controller.text);
    _controller.text = term;
    _focusNode.unfocus();
    setState(() {
      _status = SearchStatus.loading;
      _term = term;
    });
    _fetch(term);
  }

  Future<void> _fetch(String term) async {
    final requestId = ++_requestId;
    try {
      final recipes = await RecipeService.searchRecipes(term);
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _results = recipes;
        _status = recipes.isEmpty ? SearchStatus.empty : SearchStatus.results;
      });
    } on ApiException catch (error) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _error = error;
        _status = SearchStatus.error;
      });
    }
  }

  void _retry() {
    setState(() => _status = SearchStatus.loading);
    _fetch(_term);
  }

  void _clear() {
    _requestId++;
    _controller.clear();
    _formKey.currentState?.reset();
    setState(() {
      _status = SearchStatus.idle;
      _results = [];
      _autovalidate = AutovalidateMode.disabled;
    });
    _focusNode.requestFocus();
  }

  void _changeSearch() {
    _focusNode.requestFocus();
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  void _backToList() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar receitas')),
      bottomNavigationBar: const AppBottomBar(popToHome: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidate,
              child: SearchField(
                controller: _controller,
                focusNode: _focusNode,
                validator: validateQuery,
                loading: _status == SearchStatus.loading,
                onSubmitted: _status == SearchStatus.loading ? null : _submit,
              ),
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_status) {
      case SearchStatus.idle:
        return const StateView(
          icon: Icons.manage_search_rounded,
          title: 'Qual prato você quer fazer?',
          message: 'Dica: vale digitar só uma parte do nome.',
        );

      case SearchStatus.loading:
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: LoadingView(message: 'Buscando “$_term”…'),
        );

      case SearchStatus.error:
        return StateView(
          icon: Icons.cloud_off_rounded,
          title: 'Ops! A busca falhou.',
          message: _error!.message,
          actionLabel: 'Tentar de novo',
          onAction: _retry,
          secondaryLabel: 'Voltar para o início',
          onSecondary: _backToList,
        );

      case SearchStatus.empty:
        return StateView(
          icon: Icons.no_food_outlined,
          title: 'Nada por aqui',
          message:
              'Nenhuma receita com “$_term”. '
              'Que tal tentar outro nome?',
          actionLabel: 'Tentar outro nome',
          onAction: _changeSearch,
          secondaryLabel: 'Voltar para o início',
          onSecondary: _backToList,
        );

      case SearchStatus.results:
        return RecipeList(
          recipes: _results,
          header: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${countRecipes(_results.length)} para “$_term”',
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _clear,
                  icon: const Icon(Icons.close_rounded, size: 18),
                  label: const Text('Limpar busca'),
                ),
              ],
            ),
          ),
        );
    }
  }
}
