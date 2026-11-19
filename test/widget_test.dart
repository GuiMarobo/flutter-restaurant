import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/services/menu_service.dart';
import 'package:flutter_restaurant/state/order_controller.dart';
import 'package:flutter_restaurant/utils/search_query.dart';

void main() {
  setUp(() {
    order.clear();
    MenuService.offline.value = false;
  });

  // Simula a tela de um celular (360x780) em vez do padrão 800x600
  void usePhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Future<void> openApp(WidgetTester tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const RestaurantApp());
    await tester.pumpAndSettle(); // espera o cardápio carregar
  }

  Future<void> search(WidgetTester tester, String text) async {
    await tester.enterText(find.byKey(const Key('searchField')), text);
    await tester.tap(find.text('Pesquisar'));
    await tester.pumpAndSettle();
  }

  testWidgets('Cardápio mostra carregando e depois os pratos', (tester) async {
    usePhoneSize(tester);
    await tester.pumpWidget(const RestaurantApp());

    expect(find.text('Carregando...'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Bruschetta'), findsOneWidget);
    expect(find.text('Carregando...'), findsNothing);
  });

  testWidgets('Filtro de categoria mostra só bebidas', (tester) async {
    await openApp(tester);

    // Rola os chips para a esquerda até aparecer "Bebidas"
    await tester.scrollUntilVisible(
      find.text('Bebidas'),
      100,
      scrollable: find
          .ancestor(of: find.text('Todos'), matching: find.byType(Scrollable))
          .first,
    );
    final chip = find.widgetWithText(ChoiceChip, 'Bebidas');
    await tester.ensureVisible(chip); // traz o chip inteiro para a tela
    await tester.pumpAndSettle();
    await tester.tap(chip);
    await tester.pump();

    expect(find.text('Suco Natural'), findsOneWidget);
    expect(find.text('Bruschetta'), findsNothing);
  });

  testWidgets('Pesquisa só com espaços mostra erro e não navega', (
    tester,
  ) async {
    await openApp(tester);

    await search(tester, '   ');

    expect(find.text(searchErrorMessage), findsOneWidget);
    expect(find.byKey(const Key('searchFeedback')), findsNothing);
  });

  testWidgets('Pesquisa válida abre resultados e permite nova pesquisa', (
    tester,
  ) async {
    await openApp(tester);

    await search(tester, '  risoto  ');

    expect(find.text('Resultados para "risoto"'), findsOneWidget);
    expect(find.text('Risoto de Cogumelos'), findsOneWidget);
    expect(find.text('Bruschetta'), findsNothing);

    await tester.tap(find.text('Nova pesquisa'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('searchField')), findsOneWidget);
  });

  testWidgets('Pesquisa sem resultado mostra estado vazio', (tester) async {
    await openApp(tester);

    await search(tester, 'lasanha');

    expect(find.text('Nenhum prato encontrado'), findsOneWidget);
  });

  testWidgets('Sem conexão mostra erro e permite tentar novamente', (
    tester,
  ) async {
    MenuService.offline.value = true;
    await openApp(tester);

    expect(find.text('Sem conexão'), findsOneWidget);

    MenuService.offline.value = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();

    expect(find.text('Bruschetta'), findsOneWidget);
  });

  testWidgets('Detalhe adiciona ao pedido e o pedido é enviado', (
    tester,
  ) async {
    await openApp(tester);

    // Pedido começa vazio
    await tester.tap(find.text('Pedido'));
    await tester.pumpAndSettle();
    expect(find.text('Seu pedido está vazio'), findsOneWidget);

    // Volta ao cardápio e abre os detalhes
    await tester.tap(find.text('Ver cardápio'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bruschetta'));
    await tester.pumpAndSettle();
    expect(find.text('Descrição'), findsOneWidget);

    await tester.tap(find.byTooltip('Aumentar'));
    await tester.pump();
    await tester.tap(find.textContaining('Adicionar ao pedido'));
    await tester.pumpAndSettle();
    expect(order.count, 2);

    // Envia o pedido
    await tester.tap(find.text('Pedido'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enviar pedido'));
    await tester.pumpAndSettle();
    expect(find.text('Pedido enviado!'), findsOneWidget);

    await tester.tap(find.text('Voltar ao cardápio'));
    await tester.pumpAndSettle();
    expect(find.text('Bem-vindo!'), findsOneWidget);
    expect(order.isEmpty, isTrue);
  });
}
