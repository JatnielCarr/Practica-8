import 'package:flutter/material.dart';
import 'package:pokecard_dex/l10n/l10n.dart';
import 'package:pokecard_dex/pokemon_cards/view/cards_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
        scaffoldBackgroundColor: Colors.green,
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CardsPage(), // ← Cambio aquí
    );
  }
}
