// App constants - No hardcoded strings!
class AppStrings {
  // App
  static const String appName = 'Recipe App';

  // Bottom Navigation
  static const String homeTab = 'Recipes';
  static const String favoritesTab = 'Favorites';

  // Recipe List Page
  static const String searchHint = 'Search recipes...';
  static const String gridView = 'Grid';
  static const String listView = 'List';
  static const String sortBy = 'Sort by Name';
  static const String ascending = 'A-Z';
  static const String descending = 'Z-A';
  static const String filterBy = 'Filters';
  static const String category = 'Category';
  static const String area = 'Area';
  static const String clearFilters = 'Clear All';
  static const String activeFilters = 'Active Filters';
  static const String noRecipes = 'No recipes found';

  // Recipe Detail Page
  static const String ingredients = 'Ingredients';
  static const String instructions = 'Instructions';
  static const String overview = 'Overview';
  static const String watchVideo = 'Watch Video';
  static const String addToFavorites = 'Add to Favorites';
  static const String removeFromFavorites = 'Remove from Favorites';
  static const String noVideo = 'No video available';

  // Favorites Page
  static const String emptyFavorites = 'No favorites yet';
  static const String addRecipe = 'Add a recipe to favorites!';

  // General
  static const String loading = 'Loading...';
  static const String error = 'Something went wrong';
  static const String retry = 'Retry';
  static const String close = 'Close';
}

class AppUrls {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const String searchByName = '/search.php?s=';
  static const String filterByArea = '/filter.php?a=';
  static const String filterByCategory = '/filter.php?c=';
  static const String getRecipeDetail = '/lookup.php?i=';
  static const String getCategories = '/categories.php';
  static const String getAreas = '/list.php?a=list';
}
