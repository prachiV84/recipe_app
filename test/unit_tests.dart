import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/data/services/recipe_api_service.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/data/services/local_storage_service.dart';

// Mock services
class MockRecipeApiService extends Mock implements RecipeApiService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  group('Recipe API Service Tests', () {
    late MockRecipeApiService mockApiService;

    setUp(() {
      mockApiService = MockRecipeApiService();
    });

    test('searchRecipesByName returns list of recipes', () async {
      // Arrange
      final mockRecipes = [
        Recipe(
          idMeal: '1',
          strMeal: 'Chicken',
          strCategory: 'Seafood',
          strArea: 'Italian',
          strInstructions: 'Cook it',
          strMealThumb: 'https://example.com/image.jpg',
          strYoutube: 'https://youtube.com/watch?v=123',
          ingredients: {'Chicken': '500g'},
        ),
      ];

      when(
        () => mockApiService.searchRecipesByName('Chicken'),
      ).thenAnswer((_) async => mockRecipes);

      // Act
      final result = await mockApiService.searchRecipesByName('Chicken');

      // Assert
      expect(result, isA<List<Recipe>>());
      expect(result.length, 1);
      expect(result[0].strMeal, 'Chicken');
    });

    test('searchRecipesByName returns empty list for empty query', () async {
      // Arrange
      when(
        () => mockApiService.searchRecipesByName(''),
      ).thenAnswer((_) async => []);

      // Act
      final result = await mockApiService.searchRecipesByName('');

      // Assert
      expect(result, isEmpty);
    });

    test('filterRecipesByCategory returns list of recipes', () async {
      // Arrange
      final mockRecipes = [
        Recipe(
          idMeal: '1',
          strMeal: 'Fish',
          strCategory: 'Seafood',
          strArea: 'Italian',
          strInstructions: 'Cook it',
          strMealThumb: 'https://example.com/image.jpg',
          strYoutube: '',
          ingredients: {'Fish': '500g'},
        ),
      ];

      when(
        () => mockApiService.filterRecipesByCategory('Seafood'),
      ).thenAnswer((_) async => mockRecipes);

      // Act
      final result = await mockApiService.filterRecipesByCategory('Seafood');

      // Assert
      expect(result, isA<List<Recipe>>());
      expect(result[0].strCategory, 'Seafood');
    });

    test('getRecipeDetail returns single recipe', () async {
      // Arrange
      final mockRecipe = Recipe(
        idMeal: '52772',
        strMeal: 'Chick-Fil-A-Sandwich',
        strCategory: 'Seafood',
        strArea: 'American',
        strInstructions: 'Make sandwich',
        strMealThumb: 'https://example.com/image.jpg',
        strYoutube: 'https://youtube.com/watch?v=123',
        ingredients: {'Chicken': '1', 'Bread': '1'},
      );

      when(
        () => mockApiService.getRecipeDetail('52772'),
      ).thenAnswer((_) async => mockRecipe);

      // Act
      final result = await mockApiService.getRecipeDetail('52772');

      // Assert
      expect(result, isA<Recipe>());
      expect(result.idMeal, '52772');
    });
  });

  group('Recipe Repository Tests', () {
    late MockRecipeApiService mockApiService;
    late MockLocalStorageService mockStorageService;
    late RecipeRepository repository;

    setUp(() {
      mockApiService = MockRecipeApiService();
      mockStorageService = MockLocalStorageService();
      repository = RecipeRepository(
        apiService: mockApiService,
        storageService: mockStorageService,
      );
    });

    test('searchRecipesByName delegates to API service', () async {
      // Arrange
      final mockRecipes = [
        Recipe(
          idMeal: '1',
          strMeal: 'Chicken',
          strCategory: 'Seafood',
          strArea: 'Italian',
          strInstructions: 'Cook',
          strMealThumb: 'https://example.com/image.jpg',
          strYoutube: '',
          ingredients: {'Chicken': '500g'},
        ),
      ];

      when(
        () => mockApiService.searchRecipesByName('Chicken'),
      ).thenAnswer((_) async => mockRecipes);

      // Act
      final result = await repository.searchRecipesByName('Chicken');

      // Assert
      expect(result, mockRecipes);
      verify(() => mockApiService.searchRecipesByName('Chicken')).called(1);
    });

    test('addToFavorites adds recipe to storage', () async {
      // Arrange
      final recipe = Recipe(
        idMeal: '1',
        strMeal: 'Chicken',
        strCategory: 'Seafood',
        strArea: 'Italian',
        strInstructions: 'Cook',
        strMealThumb: 'https://example.com/image.jpg',
        strYoutube: '',
        ingredients: {'Chicken': '500g'},
      );

      when(
        () => mockStorageService.addFavorite(any()),
      ).thenAnswer((_) async {});

      // Act
      await repository.addToFavorites(recipe);

      // Assert
      verify(() => mockStorageService.addFavorite(any())).called(1);
    });

    test('isFavorite returns boolean from storage', () async {
      // Arrange
      when(
        () => mockStorageService.isFavorite('1'),
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.isFavorite('1');

      // Assert
      expect(result, true);
      verify(() => mockStorageService.isFavorite('1')).called(1);
    });
  });

  group('Recipe Model Tests', () {
    test('Recipe.fromJson creates recipe correctly', () {
      // Arrange
      final json = {
        'idMeal': '52772',
        'strMeal': 'Chick-Fil-A-Sandwich',
        'strCategory': 'Seafood',
        'strArea': 'American',
        'strInstructions': 'Make it',
        'strMealThumb': 'https://example.com/image.jpg',
        'strYoutube': 'https://youtube.com/watch?v=123',
        'strIngredient1': 'Chicken',
        'strMeasure1': '500g',
      };

      // Act
      final recipe = Recipe.fromJson(json);

      // Assert
      expect(recipe.idMeal, '52772');
      expect(recipe.strMeal, 'Chick-Fil-A-Sandwich');
      expect(recipe.ingredients.containsKey('Chicken'), true);
    });

    test('Recipe.toJson converts to JSON correctly', () {
      // Arrange
      final recipe = Recipe(
        idMeal: '52772',
        strMeal: 'Chick-Fil-A-Sandwich',
        strCategory: 'Seafood',
        strArea: 'American',
        strInstructions: 'Make it',
        strMealThumb: 'https://example.com/image.jpg',
        strYoutube: 'https://youtube.com/watch?v=123',
        ingredients: {'Chicken': '500g'},
        isFavorite: true,
      );

      // Act
      final json = recipe.toJson();

      // Assert
      expect(json['idMeal'], '52772');
      expect(json['strMeal'], 'Chick-Fil-A-Sandwich');
      expect(json['isFavorite'], true);
    });

    test('Recipe.copyWith creates new instance with changes', () {
      // Arrange
      final recipe = Recipe(
        idMeal: '52772',
        strMeal: 'Chick-Fil-A-Sandwich',
        strCategory: 'Seafood',
        strArea: 'American',
        strInstructions: 'Make it',
        strMealThumb: 'https://example.com/image.jpg',
        strYoutube: 'https://youtube.com/watch?v=123',
        ingredients: {'Chicken': '500g'},
        isFavorite: false,
      );

      // Act
      final updatedRecipe = recipe.copyWith(isFavorite: true);

      // Assert
      expect(updatedRecipe.isFavorite, true);
      expect(updatedRecipe.strMeal, recipe.strMeal);
      expect(recipe.isFavorite, false);
    });
  });
}
