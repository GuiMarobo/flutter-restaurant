import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recipe.dart';
import '../services/api_exception.dart';
import '../services/recipe_service.dart';
import '../utils/search_query.dart';
import '../widgets/app_bottom_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/loading_view.dart';
import '../widgets/recipe_list.dart';
import '../widgets/search_field.dart';
import '../widgets/state_view.dart';

// Estados possíveis da tela de pesquisa.
enum SearchStatus { idle, loading, results, empty, error }

// Tela de pesquisa remota pelo nome (RF03).
class SearchPage extends StatefulWidget {
  final String? initialTerm; // termo vindo da tela principal (pode ser null)

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
  String _term = ''; // último termo pesquisado
  List<Recipe> _results = [];
  ApiException? _error;

  // Cada pesquisa ganha um número. Se chegar a resposta de uma pesquisa
  // antiga (o usuário já limpou ou pesquisou outra coisa), ela é ignorada.
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

  // Botão "Pesquisar" ou Enter do teclado.
  void _submit() {
    // Evita cliques repetidos enquanto uma pesquisa está em andamento (RF06)
    if (_status == SearchStatus.loading) return;

    // Consulta vazia ou só com espaços: mostra o erro e não pesquisa
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }

    final term = normalizeQuery(_controller.text); // trata espaços externos
    _controller.text = term;
    _focusNode.unfocus();
    setState(() {
      _status = SearchStatus.loading;
      _term = term;
    });
    _fetch(term);
  }

  // Chama a API e atualiza o estado com o resultado.
  Future<void> _fetch(String term) async {
    final requestId = ++_requestId;
    try {
      final recipes = await RecipeService.searchRecipes(term);
      if (!mounted || requestId != _requestId) return; // resposta antiga
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

  // "Limpar pesquisa": apaga o campo e os resultados.
  void _clear() {
    _requestId++; // descarta uma pesquisa que ainda esteja carregando
    _controller.clear();
    _formKey.currentState?.reset();
    setState(() {
      _status = SearchStatus.idle;
      _results = [];
      _autovalidate = AutovalidateMode.disabled;
    });
    _focusNode.requestFocus();
  }

  // "Alterar pesquisa": coloca o cursor no campo com o texto selecionado.
  void _changeSearch() {
    _focusNode.requestFocus();
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  // "Ver todas as receitas": volta para a listagem.
  void _backToList() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisar receitas')),
      bottomNavigationBar: const AppBottomBar(popToHome: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 1, indent: 24, endIndent: 24),
          _buildForm(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  // Campo + botão "Pesquisar" (sempre no topo).
  Widget _buildForm() {
    final loading = _status == SearchStatus.loading;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_status == SearchStatus.idle)
              const SectionTitle(title: 'Qual receita você procura?'),
            const Text(
              'Nome da receita',
              style: TextStyle(
                color: AppColors.title,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SearchField(
              controller: _controller,
              focusNode: _focusNode,
              validator: validateQuery,
              onSubmitted: _submit,
            ),
            const SizedBox(height: 16),
            // Desabilitado enquanto carrega: impede pesquisas repetidas
            FilledButton(
              onPressed: loading ? null : _submit,
              child: loading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Pesquisar'),
            ),
          ],
        ),
      ),
    );
  }

  // Conteúdo abaixo do formulário, conforme o estado atual.
  Widget _buildContent() {
    switch (_status) {
      case SearchStatus.idle:
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Você pode buscar por parte do nome da receita.',
            style: TextStyle(color: AppColors.text),
          ),
        );

      case SearchStatus.loading:
        return Padding(
          padding: const EdgeInsets.only(top: 24),
          child: LoadingView(message: 'Pesquisando “$_term”…'),
        );

      // Falha de rede/servidor (RF07) — diferente de "nenhum resultado"
      case SearchStatus.error:
        return StateView(
          icon: Icons.wifi_off,
          title: 'Não foi possível pesquisar.',
          message: _error!.message,
          actionLabel: 'Tentar novamente',
          onAction: _retry,
          secondaryLabel: 'Ver todas as receitas',
          onSecondary: _backToList,
        );

      // Busca sem correspondências (RF08)
      case SearchStatus.empty:
        return StateView(
          icon: Icons.search_off,
          title: 'Nenhum resultado',
          message:
              'Não encontramos receitas para “$_term”. '
              'Tente outro termo.',
          actionLabel: 'Alterar pesquisa',
          onAction: _changeSearch,
          secondaryLabel: 'Ver todas as receitas',
          onSecondary: _backToList,
        );

      case SearchStatus.results:
        return RecipeList(
          recipes: _results,
          header: SectionTitle(
            title: 'Resultados para “$_term”',
            subtitle: 'Toque na receita para ver o preparo.',
          ),
          footer: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: OutlinedButton(
              onPressed: _clear,
              child: const Text('Limpar pesquisa'),
            ),
          ),
        );
    }
  }
}
