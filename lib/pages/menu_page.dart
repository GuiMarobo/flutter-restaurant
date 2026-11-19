import 'package:flutter/material.dart';

import '../data/menu_data.dart';
import '../models/menu_item.dart';
import '../routes.dart';
import '../services/menu_service.dart';
import '../state/order_controller.dart';
import '../utils/search_query.dart';
import '../widgets/menu_list.dart';
import '../widgets/state_view.dart';

// Aba Cardápio: busca, categorias e lista de pratos.
class MenuPage extends StatefulWidget {
  final VoidCallback onOpenOrder;

  const MenuPage({super.key, required this.onOpenOrder});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<List<MenuItem>> _menu = MenuService.fetchMenu();
  String _selectedCategory =
      categories.first; // categoria selecionada nos chips

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  // Só começa a validar enquanto digita depois da primeira tentativa
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _menu = MenuService.fetchMenu();
    });
  }

  void _search() {
    // Consulta inválida: mostra o erro no campo e não pesquisa
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }
    final term = normalizeQuery(_searchController.text);
    _searchController.text = term; // mostra o termo já sem espaços extras
    FocusScope.of(context).unfocus();
    // Navega para a tela de resultados levando o termo pesquisado
    Navigator.of(context).pushNamed(AppRoutes.search, arguments: term);
  }

  List<MenuItem> _byCategory(List<MenuItem> items) =>
      _selectedCategory == 'Todos'
      ? items
      : items.where((i) => i.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cardápio Digital',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Menu para demonstrar a tela de erro de conexão
          ValueListenableBuilder(
            valueListenable: MenuService.offline,
            builder: (context, offline, _) => PopupMenuButton<void>(
              tooltip: 'Opções',
              itemBuilder: (_) => [
                CheckedPopupMenuItem(
                  checked: offline,
                  onTap: () {
                    MenuService.offline.value = !offline;
                    _reload();
                  },
                  child: const Text('Simular sem conexão'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // alinha os filhos à esquerda
        children: [
          // Cabeçalho: boas-vindas, mesa e campo de busca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              spacing: 8, // espaçamento entre os itens da coluna
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bem-vindo!',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  spacing: 6,
                  children: [
                    Icon(
                      Icons.table_restaurant,
                      size: 18,
                      color: colors.primary,
                    ),
                    // Flexible deixa o texto encolher em telas estreitas
                    Flexible(
                      child: Text(
                        'Mesa 05 · Escolha seu prato e faça o pedido',
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Form agrupa o campo para validar antes de pesquisar
                Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: const Key('searchField'),
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (_) =>
                              _search(), // Enter também pesquisa
                          validator: validateQuery,
                          decoration: InputDecoration(
                            labelText: 'Nome do prato', // rótulo do campo
                            hintText: 'Ex.: Risoto', // placeholder
                            prefixIcon: Icon(
                              Icons.search,
                              color: colors.primary,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            errorMaxLines: 4,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            // borda quando o campo está selecionado
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                color: colors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Ação explícita de pesquisa
                      SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: _search,
                          child: const Text('Pesquisar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Lista horizontal de categorias
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: category == _selectedCategory,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              _selectedCategory == 'Todos' ? 'Cardápio' : _selectedCategory,
              style: textTheme.titleLarge?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Expanded ocupa todo o espaço restante: carregando, erro ou lista
          Expanded(
            child: FutureBuilder(
              future: _menu,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const StateView.loading(
                    message: 'Buscando os pratos do cardápio.',
                  );
                }
                if (snapshot.hasError) {
                  return StateView(
                    icon: Icons.wifi_off,
                    title: 'Sem conexão',
                    message:
                        'Não foi possível carregar o cardápio. '
                        'Verifique sua internet e tente novamente.',
                    actionLabel: 'Tentar novamente',
                    onAction: _reload,
                  );
                }
                return MenuList(items: _byCategory(snapshot.data!));
              },
            ),
          ),
          // Botão "Ver pedido" aparece só quando há itens no pedido
          ListenableBuilder(
            listenable: order,
            builder: (context, _) => order.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SizedBox(
                      width: double.infinity, // ocupa toda a largura da tela
                      child: FilledButton(
                        onPressed: widget.onOpenOrder,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Ver pedido (${order.count}) · ${formatPrice(order.total)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
