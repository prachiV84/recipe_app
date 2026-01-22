import 'package:flutter/material.dart';
import 'package:recipe_app/core/constants/app_constants.dart';
import 'package:recipe_app/presentation/pages/recipe_list_page.dart';
import 'package:recipe_app/presentation/pages/favorites_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appName),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.restaurant), text: 'Recipes'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(children: [const RecipeListPage(), FavoritesPage()]),
      ),
    );
  }
}
