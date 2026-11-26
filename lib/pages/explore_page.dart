import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../models/recipe.dart';
import '../services/api_exception.dart';
import '../services/recipe_service.dart';
import '../utils/search_query.dart';
import '../widgets/app_header.dart';
import '../widgets/loading_view.dart';
import '../widgets/recipe_list.dart';
import '../widgets/search_field.dart';
import '../widgets/state_view.dart';

// Aba Explorar = Tela Principal (RF01) + Listagem (RF02).
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // A requisição é criada UMA vez no initState (primeira abertura),
  // e não no build: assim ela não se repete a cada reconstrução da tela.
  late Future<List<Recipe>> _recipes;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recipes = RecipeService.fetchRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // "Tentar novamente": cria uma nova requisição.
  void _reload() {
    setState(() {
      _recipes = RecipeService.fetchRecipes();
    });
  }

  // Abre a tela de pesquisa levando o termo digitado (ou nada, se vazio).
  void _openSearch() {
    final term = normalizeQuery(_searchController.text);
    FocusScope.of(context).unfocus();
    Navigator.of(context)
        .pushNamed(AppRoutes.search, arguments: term.isEmpty ? null : term);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeader(trailing: _OfflineMenu(onChanged: _reload)),
          Expanded(
            // FutureBuilder desenha cada estado da requisição
            child: FutureBuilder(
              future: _recipes,
              builder: (context, snapshot) {
                // 1) Carregando (RF06)
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: SectionTitle(title: 'Explorar receitas'),
                      ),
                      Expanded(child: LoadingView()),
                    ],
                  );
                }

                // 2) Erro (RF07)
                if (snapshot.hasError) {
                  final error = snapshot.error;
                  return StateView(
                    icon: Icons.priority_high,
                    title: 'Não foi possível carregar as receitas.',
                    message: error is ApiException
                        ? error.message
                        : 'Tente novamente.',
                    actionLabel: 'Tentar novamente',
                    onAction: _reload,
                  );
                }

                // 3) Sucesso: busca no topo e lista de receitas
                final recipes = snapshot.data!;
                return RecipeList(
                  recipes: recipes,
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(
                        title: 'Receitas',
                        subtitle: 'Pesquise uma receita pelo nome.',
                        large: true,
                      ),
                      SearchField(
                        controller: _searchController,
                        onSubmitted: _openSearch,
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _openSearch,
                        child: const Text('Buscar receitas'),
                      ),
                      SectionTitle(
                        title: 'Receitas disponíveis',
                        subtitle: recipes.isEmpty
                            ? 'Nenhuma receita disponível no momento.'
                            : 'Selecione uma receita para ver o preparo.',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Menu ⋮ para simular a falta de internet e mostrar a tela de erro no vídeo.
class _OfflineMenu extends StatelessWidget {
  final VoidCallback onChanged;

  const _OfflineMenu({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: RecipeService.simulateOffline,
      builder: (context, offline, _) => PopupMenuButton<void>(
        tooltip: 'Opções',
        itemBuilder: (_) => [
          CheckedPopupMenuItem(
            checked: offline,
            onTap: () {
              RecipeService.simulateOffline.value = !offline;
              onChanged();
            },
            child: const Text('Simular sem conexão'),
          ),
        ],
      ),
    );
  }
}
