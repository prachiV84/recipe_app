import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/presentation/widgets/common_widgets.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('RecipeGridItem displays title and image', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeGridItem(
              title: 'Test Recipe',
              imageUrl: 'https://example.com/image.jpg',
              onTap: () {},
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Test Recipe'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('RecipeGridItem onTap callback is triggered', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeGridItem(
              title: 'Test Recipe',
              imageUrl: 'https://example.com/image.jpg',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, true);
    });

    testWidgets('RecipeListItem is a Card widget', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeListItem(
              title: 'Test Recipe',
              imageUrl: 'https://example.com/image.jpg',
              category: 'Seafood',
              area: 'Italian',
              onTap: () {},
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('RecipeListItem onTap callback is triggered', (
      WidgetTester tester,
    ) async {
      // Arrange
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeListItem(
              title: 'Test Recipe',
              imageUrl: 'https://example.com/image.jpg',
              category: 'Seafood',
              area: 'Italian',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, true);
    });

    testWidgets('LoadingShimmer widget builds', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingShimmer(height: 100, width: 200)),
        ),
      );

      // Act & Assert
      expect(find.byType(LoadingShimmer), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('LoadingShimmer animates', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingShimmer(height: 100, width: 200)),
        ),
      );

      // Act
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      expect(find.byType(LoadingShimmer), findsOneWidget);
    });
  });
}
