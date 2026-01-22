import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../core/di/service_locator.dart';

// Repository provider
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  return getIt<RecipeRepository>();
});

// Search state notifier
class SearchState {
  final String query;
  final List<Recipe> recipes;
  final bool isLoading;
  final String? error;

  SearchState({
    this.query = '',
    this.recipes = const [],
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<Recipe>? recipes,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      query: query ?? this.query,
      recipes: recipes ?? this.recipes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final RecipeRepository repository;

  SearchNotifier(this.repository) : super(SearchState()) {
    // Load initial recipes on startup
    _loadInitialRecipes();
  }

  Future<void> _loadInitialRecipes() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Load popular recipes by searching for a common ingredient/meal
      final recipes = await repository.searchRecipesByName('a');
      state = state.copyWith(recipes: recipes, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> search(String query) async {
    state = state.copyWith(query: query, isLoading: true, error: null);
    try {
      final recipes = query.isEmpty
          ? await repository.searchRecipesByName(
              'a',
            ) // Show default recipes if cleared
          : await repository.searchRecipesByName(query);
      state = state.copyWith(recipes: recipes, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> filterByCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final recipes = await repository.filterRecipesByCategory(category);
      state = state.copyWith(recipes: recipes, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> filterByArea(String area) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final recipes = await repository.filterRecipesByArea(area);
      state = state.copyWith(recipes: recipes, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void reset() {
    state = SearchState();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  return SearchNotifier(ref.watch(recipeRepositoryProvider));
});

// Favorites provider
class FavoritesNotifier extends StateNotifier<List<Recipe>> {
  final RecipeRepository repository;

  FavoritesNotifier(this.repository) : super(const []);

  Future<void> loadFavorites() async {
    try {
      final favorites = await repository.getFavoriteRecipes();
      state = favorites;
    } catch (e) {
      state = [];
    }
  }

  Future<void> addToFavorites(Recipe recipe) async {
    try {
      await repository.addToFavorites(recipe);
      state = [...state, recipe.copyWith(isFavorite: true)];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromFavorites(String recipeId) async {
    try {
      await repository.removeFromFavorites(recipeId);
      state = state.where((r) => r.idMeal != recipeId).toList();
    } catch (e) {
      rethrow;
    }
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Recipe>>((ref) {
      final notifier = FavoritesNotifier(ref.watch(recipeRepositoryProvider));
      notifier.loadFavorites();
      return notifier;
    });

// Recipe detail provider
final recipeDetailProvider = FutureProvider.family<Recipe, String>((
  ref,
  id,
) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getRecipeDetail(id);
});

// Categories provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getCategories();
});

// Areas provider
final areasProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getAreas();
});

// Check if favorite provider
final isFavoriteProvider = FutureProvider.family<bool, String>((
  ref,
  recipeId,
) async {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.isFavorite(recipeId);
});
