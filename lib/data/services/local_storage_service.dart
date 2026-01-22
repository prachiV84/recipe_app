import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';

class LocalStorageService {
  static const String favoritesKey = 'favorites';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // Get all favorite recipes
  Future<List<Recipe>> getFavorites() async {
    try {
      final jsonString = _prefs.getString(favoritesKey);
      if (jsonString == null) return [];

      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Add recipe to favorites
  Future<void> addFavorite(Recipe recipe) async {
    try {
      final favorites = await getFavorites();
      if (!favorites.any((r) => r.idMeal == recipe.idMeal)) {
        favorites.add(recipe.copyWith(isFavorite: true));
        await _saveFavorites(favorites);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Remove recipe from favorites
  Future<void> removeFavorite(String recipeId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((r) => r.idMeal == recipeId);
      await _saveFavorites(favorites);
    } catch (e) {
      rethrow;
    }
  }

  // Check if recipe is favorite
  Future<bool> isFavorite(String recipeId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((r) => r.idMeal == recipeId);
    } catch (e) {
      return false;
    }
  }

  // Save favorites to storage
  Future<void> _saveFavorites(List<Recipe> favorites) async {
    try {
      final jsonList = favorites.map((r) => r.toJson()).toList();
      await _prefs.setString(favoritesKey, jsonEncode(jsonList));
    } catch (e) {
      rethrow;
    }
  }
}
