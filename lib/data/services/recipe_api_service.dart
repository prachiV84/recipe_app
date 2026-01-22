import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/recipe_model.dart';
import '../../core/constants/app_constants.dart';

class RecipeApiService {
  final http.Client _httpClient;

  RecipeApiService(this._httpClient);

  // Search recipes by name
  Future<List<Recipe>> searchRecipesByName(String name) async {
    try {
      if (name.isEmpty) {
        return [];
      }

      final response = await _httpClient
          .get(Uri.parse('${AppUrls.baseUrl}${AppUrls.searchByName}$name'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['meals'] == null) return [];

        final recipes = (json['meals'] as List)
            .map((meal) => Recipe.fromJson(meal))
            .toList();
        return recipes;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Filter recipes by area
  Future<List<Recipe>> filterRecipesByArea(String area) async {
    try {
      final response = await _httpClient
          .get(Uri.parse('${AppUrls.baseUrl}${AppUrls.filterByArea}$area'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['meals'] == null) return [];

        final recipes = (json['meals'] as List)
            .map((meal) => Recipe.fromJson(meal))
            .toList();
        return recipes;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Filter recipes by category
  Future<List<Recipe>> filterRecipesByCategory(String category) async {
    try {
      final response = await _httpClient
          .get(
            Uri.parse('${AppUrls.baseUrl}${AppUrls.filterByCategory}$category'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['meals'] == null) return [];

        final recipes = (json['meals'] as List)
            .map((meal) => Recipe.fromJson(meal))
            .toList();
        return recipes;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get recipe detail by ID
  Future<Recipe> getRecipeDetail(String id) async {
    try {
      final response = await _httpClient
          .get(Uri.parse('${AppUrls.baseUrl}${AppUrls.getRecipeDetail}$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['meals'] == null || json['meals'].isEmpty) {
          throw Exception('Recipe not found');
        }

        return Recipe.fromJson(json['meals'][0]);
      } else {
        throw Exception('Failed to load recipe');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get all categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _httpClient
          .get(Uri.parse('${AppUrls.baseUrl}${AppUrls.getCategories}'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['categories'] == null) return [];

        final categories = (json['categories'] as List)
            .map((cat) => cat['strCategory'] as String)
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get all areas
  Future<List<String>> getAreas() async {
    try {
      final response = await _httpClient
          .get(Uri.parse('${AppUrls.baseUrl}${AppUrls.getAreas}'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['meals'] == null) return [];

        final areas = (json['meals'] as List)
            .map((area) => area['strArea'] as String)
            .toList();
        return areas;
      } else {
        throw Exception('Failed to load areas');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
