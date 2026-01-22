import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_padding.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/recipe_model.dart';
import '../providers/recipe_provider.dart';
import '../widgets/common_widgets.dart';
import 'recipe_detail_page.dart';

class RecipeListPage extends ConsumerStatefulWidget {
  const RecipeListPage({super.key});

  @override
  ConsumerState<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends ConsumerState<RecipeListPage> {
  late TextEditingController _searchController;
  bool _isGridView = true;
  String _sortOrder = AppStrings.ascending;
  String? _selectedCategory;
  String? _selectedArea;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Recipe> _sortRecipes(List<Recipe> recipes) {
    final sorted = List<Recipe>.from(recipes);
    if (_sortOrder == AppStrings.ascending) {
      sorted.sort((a, b) => a.strMeal.compareTo(b.strMeal));
    } else {
      sorted.sort((a, b) => b.strMeal.compareTo(a.strMeal));
    }
    return sorted;
  }

  List<Recipe> _filterRecipes(List<Recipe> recipes) {
    List<Recipe> filtered = recipes;

    if (_selectedCategory != null) {
      filtered = filtered
          .where((r) => r.strCategory == _selectedCategory)
          .toList();
    }

    if (_selectedArea != null) {
      filtered = filtered.where((r) => r.strArea == _selectedArea).toList();
    }

    return filtered;
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedCategory != null) count++;
    if (_selectedArea != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final categories = ref.watch(categoriesProvider);
    final areas = ref.watch(areasProvider);

    List<Recipe> displayedRecipes = _filterRecipes(searchState.recipes);
    displayedRecipes = _sortRecipes(displayedRecipes);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Our Recipes',
            style: TextStyle(
              color: AppColors.darkGrey,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (mounted && _searchController.text == value) {
                    ref.read(searchProvider.notifier).search(value);
                  }
                });
              },
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchProvider.notifier).search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primaryPurple,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primaryPurple,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primaryPurple,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          // Filter & Sort Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // View Mode Toggle
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.grid_view),
                        isSelected: _isGridView,
                        onPressed: () {
                          setState(() => _isGridView = true);
                        },
                      ),
                      IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.list),
                        isSelected: !_isGridView,
                        onPressed: () {
                          setState(() => _isGridView = false);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Sort Button
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() => _sortOrder = value);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: AppStrings.ascending,
                      child: Text(AppStrings.ascending),
                    ),
                    PopupMenuItem(
                      value: AppStrings.descending,
                      child: Text(AppStrings.descending),
                    ),
                  ],
                  child: Chip(
                    label: Text(
                      '${AppStrings.sortBy}: $_sortOrder',
                      style: const TextStyle(color: AppColors.chipText),
                    ),
                    backgroundColor: AppColors.chipBackground,
                    side: const BorderSide(
                      color: AppColors.primaryPurple,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.horizontalMedium,
                      vertical: AppPadding.verticalSmall,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Category Filter
                categories.when(
                  data: (cats) => PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() => _selectedCategory = value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: '',
                        child: Text('All Categories'),
                      ),
                      ...cats.map(
                        (cat) => PopupMenuItem(value: cat, child: Text(cat)),
                      ),
                    ],
                    child: Chip(
                      label: Text(
                        _selectedCategory ?? AppStrings.category,
                        style: const TextStyle(color: AppColors.chipText),
                      ),
                      backgroundColor: AppColors.chipBackground,
                      side: const BorderSide(
                        color: AppColors.primaryPurple,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.horizontalMedium,
                        vertical: AppPadding.verticalSmall,
                      ),
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
                // Area Filter
                areas.when(
                  data: (areaList) => PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() => _selectedArea = value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: '', child: Text('All Areas')),
                      ...areaList.map(
                        (area) => PopupMenuItem(value: area, child: Text(area)),
                      ),
                    ],
                    child: Chip(
                      label: Text(
                        _selectedArea ?? AppStrings.area,
                        style: const TextStyle(color: AppColors.chipText),
                      ),
                      backgroundColor: AppColors.chipBackground,
                      side: const BorderSide(
                        color: AppColors.primaryPurple,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.horizontalMedium,
                        vertical: AppPadding.verticalSmall,
                      ),
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
                // Clear Filters Button
                if (_activeFilterCount > 0)
                  ActionChip(
                    label: Text(
                      '${AppStrings.clearFilters} ($_activeFilterCount)',
                      style: const TextStyle(
                        color: AppColors.activeChipText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: AppColors.primaryOrange,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.horizontalMedium,
                      vertical: AppPadding.verticalSmall,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedCategory = null;
                        _selectedArea = null;
                      });
                    },
                  ),
              ],
            ),
          ),
          SizedBox(height: AppPadding.verticalLarge),
          // Recipes Grid/List
          Expanded(
            child: searchState.isLoading
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: 6,
                    itemBuilder: (context, index) =>
                        LoadingShimmer(borderRadius: BorderRadius.circular(4)),
                  )
                : searchState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.error),
                        const SizedBox(height: AppPadding.verticalLarge),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(searchProvider.notifier).reset();
                          },
                          child: const Text(AppStrings.retry),
                        ),
                      ],
                    ),
                  )
                : displayedRecipes.isEmpty
                ? Center(child: Text(AppStrings.noRecipes))
                : _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: displayedRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = displayedRecipes[index];
                      return RecipeGridItem(
                        title: recipe.strMeal,
                        imageUrl: recipe.strMealThumb,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: displayedRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = displayedRecipes[index];
                      return RecipeListItem(
                        title: recipe.strMeal,
                        imageUrl: recipe.strMealThumb,
                        category: recipe.strCategory,
                        area: recipe.strArea,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailPage(recipe: recipe),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
