import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_cards';

  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.toSet();
  }

  Future<bool> toggleFavorite(String cardId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    final favoritesSet = favorites.toSet();

    if (favoritesSet.contains(cardId)) {
      favoritesSet.remove(cardId);
    } else {
      favoritesSet.add(cardId);
    }

    await prefs.setStringList(_favoritesKey, favoritesSet.toList());
    return favoritesSet.contains(cardId);
  }

  Future<bool> isFavorite(String cardId) async {
    final favorites = await getFavorites();
    return favorites.contains(cardId);
  }
}
