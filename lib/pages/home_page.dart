import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../models/recipe.dart';
import '../services/api_exception.dart';
import '../services/recipe_service.dart';
import '../utils/search_query.dart';
import '../widgets/app_header.dart';
import '../widgets/loading_view.dart';
import '../widgets/recipe_list.dart';
import '../widgets/search_field.dart';
import '../widgets/state_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void _reload() {
    setState(() {
      _recipes = RecipeService.fetchRecipes();
    });
  }

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeader(trailing: _OfflineMenu(onChanged: _reload)),
          Expanded(
            child: FutureBuilder(
              future: _recipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: LoadingView(),
                  );
                }

                if (snapshot.hasError) {
                  final error = snapshot.error;
                  return StateView(
                    icon: Icons.cloud_off_rounded,
                    title: 'Ops! As receitas não carregaram.',
                    message: error is ApiException
                        ? error.message
                        : 'Tente novamente.',
                    actionLabel: 'Tentar de novo',
                    onAction: _reload,
                  );
                }

                final recipes = snapshot.data!;
                return RecipeList(
                  recipes: recipes,
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'O que vamos\ncozinhar hoje?',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                            ),
                      ),
                      const SizedBox(height: 16),
                      SearchField(
                        controller: _searchController,
                        onSubmitted: _openSearch,
                      ),
                      SectionTitle(
                        title: 'Todas as receitas',
                        count: recipes.length,
                        subtitle: recipes.isEmpty
                            ? 'Nenhuma receita disponível no momento.'
                            : 'Toque em uma receita para ver o preparo.',
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
