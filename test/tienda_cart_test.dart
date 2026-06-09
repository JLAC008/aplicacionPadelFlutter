import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:padel_fighter_league/screens/tienda/tienda_screen.dart';

void main() {
  testWidgets('shop cart manages quantities, total and checkout',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: const TiendaScreen(),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('add-Camiseta Pro')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('shop-cart-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('cart-Camiseta Pro')), findsOneWidget);
    expect(find.text('49,99 €'), findsWidgets);
    expect(find.byKey(const Key('quantity-Camiseta Pro')), findsOneWidget);

    final increaseButton = find.byKey(const Key('increase-Camiseta Pro'));
    await tester.tap(increaseButton);
    await tester.pumpAndSettle();

    final quantity = tester.widget<Text>(
      find.byKey(const Key('quantity-Camiseta Pro')),
    );
    expect(quantity.data, '2');
    expect(find.text('99,98 €'), findsWidgets);

    final checkoutButton = find.text('FINALIZAR COMPRA');
    await tester.tap(checkoutButton);
    await tester.pumpAndSettle();

    expect(find.text('Pedido confirmado'), findsOneWidget);
  });
}
