import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../services/menu_service.dart';
import '../widgets/menu_list.dart';
import '../widgets/state_view.dart';

// Tela de resultados: recebe o termo válido digitado no Cardápio.
class SearchResultsPage extends StatefulWidget {
  final String term;

  const SearchResultsPage({super.key, required this.term});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<List<MenuItem>> _results = MenuService.search(widget.term);

  void _retry() {
    setState(() {
      _results = MenuService.search(widget.term);
    });
  }

  // Volta ao Cardápio, onde o campo continua preenchido para corrigir
  void _newSearch() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisa')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mostra o termo recebido
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Resultados para "${widget.term}"',
                    key: const Key('searchFeedback'),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _newSearch,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Nova pesquisa'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _results,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return StateView.loading(
                    message: 'Procurando "${widget.term}" no cardápio.',
                  );
                }
                if (snapshot.hasError) {
                  return StateView(
                    icon: Icons.wifi_off,
                    title: 'Sem conexão',
                    message:
                        'Não foi possível fazer a pesquisa. '
                        'Verifique sua internet e tente novamente.',
                    actionLabel: 'Tentar novamente',
                    onAction: _retry,
                  );
                }
                final items = snapshot.data!;
                if (items.isEmpty) {
                  return StateView(
                    icon: Icons.search_off,
                    title: 'Nenhum prato encontrado',
                    message:
                        'Não encontramos "${widget.term}". '
                        'Confira o nome digitado ou pesquise outro prato.',
                    actionLabel: 'Nova pesquisa',
                    onAction: _newSearch,
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Text(
                        '${items.length} ${items.length == 1 ? 'prato encontrado' : 'pratos encontrados'}',
                      ),
                    ),
                    Expanded(child: MenuList(items: items)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
