// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pokecard_dex/app/app.dart';
import 'package:pokecard_dex/pokemon_cards/view/cards_page.dart';

void main() {
  group('App', () {
    testWidgets('renders CardsPage', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(App());
        await tester.pumpAndSettle();
        expect(find.byType(CardsPage), findsOneWidget);
      });
    });
  });
}
