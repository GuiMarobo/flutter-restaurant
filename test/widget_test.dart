import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_restaurant/main.dart';

void main() {
  testWidgets('Cardápio mostra pratos e adiciona ao pedido',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RestaurantApp());

    expect(find.text('Cardápio Digital'), findsOneWidget);
    expect(find.text('Bruschetta'), findsOneWidget);
    expect(find.textContaining('Ver pedido'), findsNothing);

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();

    expect(find.textContaining('Ver pedido (1)'), findsOneWidget);
  });

  testWidgets('Filtro de categoria mostra só bebidas',
      (WidgetTester tester) async {
    await tester.pumpWidget(const RestaurantApp());

    await tester.tap(find.widgetWithText(ChoiceChip, 'Bebidas'));
    await tester.pump();

    expect(find.text('Suco Natural'), findsOneWidget);
    expect(find.text('Bruschetta'), findsNothing);
  });
}
