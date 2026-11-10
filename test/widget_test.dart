import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utils/search_query.dart';

void main() {
  testWidgets('Cardápio mostra pratos e adiciona ao pedido', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RestaurantApp());

    expect(find.text('Cardápio Digital'), findsOneWidget);
    expect(find.text('Bruschetta'), findsOneWidget);
    expect(find.textContaining('Ver pedido'), findsNothing);

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

    expect(find.textContaining('Ver pedido (1)'), findsOneWidget);
  });

  testWidgets('Filtro de categoria mostra só bebidas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RestaurantApp());

    await tester.tap(find.widgetWithText(ChoiceChip, 'Bebidas'));
    await tester.pump();

    expect(find.text('Suco Natural'), findsOneWidget);
    expect(find.text('Bruschetta'), findsNothing);
  });

  testWidgets('Pesquisa só com espaços mostra erro e não pesquisa', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RestaurantApp());

    await tester.enterText(find.byKey(const Key('searchField')), '   ');
    await tester.tap(find.text('Pesquisar'));
    await tester.pump();

    expect(find.text(searchErrorMessage), findsOneWidget);
    expect(find.byKey(const Key('searchFeedback')), findsNothing);
    expect(find.text('Bruschetta'), findsOneWidget);
  });

  testWidgets('Pesquisa válida mostra o termo e permite nova consulta', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RestaurantApp());
    final field = find.byKey(const Key('searchField'));

    await tester.enterText(field, '  risoto  ');
    await tester.tap(find.text('Pesquisar'));
    await tester.pump();

    expect(find.text('Resultados para "risoto": 1 prato'), findsOneWidget);
    expect(find.text('Risoto de Cogumelos'), findsOneWidget);
    expect(find.text('Bruschetta'), findsNothing);

    // Corrige e pesquisa de novo
    await tester.enterText(field, 'pudim');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    expect(find.text('Resultados para "pudim": 1 prato'), findsOneWidget);

    await tester.tap(find.text('Limpar'));
    await tester.pump();

    expect(find.byKey(const Key('searchFeedback')), findsNothing);
    expect(find.text('Bruschetta'), findsOneWidget);
  });
}
