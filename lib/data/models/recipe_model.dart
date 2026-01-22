// Simple Recipe Model with JSON serialization
class Recipe {
  final String idMeal;
  final String strMeal;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String strYoutube;
  final Map<String, String> ingredients; // ingredient: measure
  final bool isFavorite;

  Recipe({
    required this.idMeal,
    required this.strMeal,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.strYoutube,
    required this.ingredients,
    this.isFavorite = false,
  });

  // Convert from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <String, String>{};

    // Extract ingredients (API returns strIngredient1, strMeasure1, etc.)
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().isNotEmpty) {
        ingredients[ingredient] = measure ?? '';
      }
    }

    return Recipe(
      idMeal: json['idMeal']?.toString() ?? '',
      strMeal: json['strMeal'] ?? '',
      strCategory: json['strCategory'] ?? '',
      strArea: json['strArea'] ?? '',
      strInstructions: json['strInstructions'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strYoutube: json['strYoutube'] ?? '',
      ingredients: ingredients,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strYoutube': strYoutube,
      'isFavorite': isFavorite,
    };
  }

  // Copy with changes
  Recipe copyWith({
    String? idMeal,
    String? strMeal,
    String? strCategory,
    String? strArea,
    String? strInstructions,
    String? strMealThumb,
    String? strYoutube,
    Map<String, String>? ingredients,
    bool? isFavorite,
  }) {
    return Recipe(
      idMeal: idMeal ?? this.idMeal,
      strMeal: strMeal ?? this.strMeal,
      strCategory: strCategory ?? this.strCategory,
      strArea: strArea ?? this.strArea,
      strInstructions: strInstructions ?? this.strInstructions,
      strMealThumb: strMealThumb ?? this.strMealThumb,
      strYoutube: strYoutube ?? this.strYoutube,
      ingredients: ingredients ?? this.ingredients,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
