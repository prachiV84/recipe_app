import '../models/recipe_model.dart';
import '../services/recipe_api_service.dart';
import '../services/local_storage_service.dart';

class RecipeRepository {
  final RecipeApiService apiService;
  final LocalStorageService storageService;

  RecipeRepository({required this.apiService, required this.storageService});

  // Search recipes by name
  Future<List<Recipe>> searchRecipesByName(String name) async {
    return await apiService.searchRecipesByName(name);
  }

  // Filter recipes by area
  Future<List<Recipe>> filterRecipesByArea(String area) async {
    return await apiService.filterRecipesByArea(area);
  }

  // Filter recipes by category
  Future<List<Recipe>> filterRecipesByCategory(String category) async {
    return await apiService.filterRecipesByCategory(category);
  }

  // Get recipe detail
  Future<Recipe> getRecipeDetail(String id) async {
    final recipe = await apiService.getRecipeDetail(id);
    final isFav = await storageService.isFavorite(id);
    return recipe.copyWith(isFavorite: isFav);
  }

  // Get categories
  Future<List<String>> getCategories() async {
    return await apiService.getCategories();
  }

  // Get areas
  Future<List<String>> getAreas() async {
    return await apiService.getAreas();
  }

  // Get favorite recipes
  Future<List<Recipe>> getFavoriteRecipes() async {
    return await storageService.getFavorites();
  }

  // Add to favorites
  Future<void> addToFavorites(Recipe recipe) async {
    return await storageService.addFavorite(recipe);
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String recipeId) async {
    return await storageService.removeFavorite(recipeId);
  }

  // Check if recipe is favorite
  Future<bool> isFavorite(String recipeId) async {
    return await storageService.isFavorite(recipeId);
  }
}
