import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_padding.dart';
import '../../data/models/recipe_model.dart';
import '../providers/recipe_provider.dart';

class RecipeDetailPage extends ConsumerStatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  ConsumerState<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends ConsumerState<RecipeDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _favoriteAnimationController;
  late Animation<double> _favoriteScaleAnimation;
  late ScrollController _scrollController;
  bool _isFavorite = false;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    _favoriteAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _favoriteScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _favoriteAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _checkIfFavorite();
  }

  void _handleScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _favoriteAnimationController.dispose();
    super.dispose();
  }

  void _checkIfFavorite() async {
    final isFav = await ref
        .read(recipeRepositoryProvider)
        .isFavorite(widget.recipe.idMeal);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  void _toggleFavorite() async {
    try {
      if (_isFavorite) {
        await ref
            .read(favoritesProvider.notifier)
            .removeFromFavorites(widget.recipe.idMeal);
      } else {
        await ref
            .read(favoritesProvider.notifier)
            .addToFavorites(widget.recipe);
        _favoriteAnimationController.forward().then((_) {
          _favoriteAnimationController.reverse();
        });
      }
      setState(() => _isFavorite = !_isFavorite);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite
                  ? AppStrings.addToFavorites
                  : AppStrings.removeFromFavorites,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppStrings.error)));
      }
    }
  }

  void _showFullScreenImageViewer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => _FullScreenImageViewer(
          imageUrl: widget.recipe.strMealThumb,
          heroTag: widget.recipe.idMeal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Recipe Details',
            style: TextStyle(
              color: AppColors.darkGrey,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fixed Image at Top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Hero(
              tag: widget.recipe.idMeal,
              child: GestureDetector(
                onTap: _showFullScreenImageViewer,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.recipe.strMealThumb,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 64,
                          ),
                        );
                      },
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ),
                    // Zoom indicator
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.zoom_in, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Tap to zoom',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Scrollable Content Below Image
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 600),
                child: Transform.translate(
                  offset: Offset(0, _scrollOffset * 0.1),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Recipe Title and Chips
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.recipe.strMeal,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      Chip(
                                        label: Text(
                                          widget.recipe.strCategory,
                                          style: const TextStyle(
                                            color: AppColors.activeChipText,
                                          ),
                                        ),
                                        backgroundColor:
                                            AppColors.primaryOrange,
                                        side: BorderSide.none,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppPadding.horizontalMedium,
                                          vertical: AppPadding.verticalSmall,
                                        ),
                                      ),
                                      Chip(
                                        label: Text(
                                          widget.recipe.strArea,
                                          style: const TextStyle(
                                            color: AppColors.activeChipText,
                                          ),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          151,
                                          96,
                                          187,
                                        ),
                                        side: BorderSide.none,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppPadding.horizontalMedium,
                                          vertical: AppPadding.verticalSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ScaleTransition(
                                    scale: _favoriteScaleAnimation,
                                    child: IconButton(
                                      iconSize: 32,
                                      icon: Icon(
                                        _isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: _isFavorite
                                            ? Colors.redAccent
                                            : Colors.grey[600],
                                      ),
                                      onPressed: _toggleFavorite,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Tab bar
                        Container(
                          color: Colors.white,
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.black87,
                            unselectedLabelColor: Colors.grey[600],
                            indicatorColor: Colors.orange,
                            tabs: const [
                              Tab(text: AppStrings.overview),
                              Tab(text: AppStrings.ingredients),
                              Tab(text: AppStrings.instructions),
                            ],
                          ),
                        ),
                        // Tab Content
                        SizedBox(
                          height: 500,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Overview Tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Category: ${widget.recipe.strCategory}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Area: ${widget.recipe.strArea}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    if (widget.recipe.strYoutube.isNotEmpty)
                                      _YouTubePlayerSection(
                                        youtubeUrl: widget.recipe.strYoutube,
                                      ),
                                  ],
                                ),
                              ),
                              // Ingredients Tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.ingredients,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...widget.recipe.ingredients.entries.map(
                                      (entry) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                '${entry.key} - ${entry.value}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Instructions Tab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.instructions,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ..._buildInstructions(
                                      widget.recipe.strInstructions,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInstructions(String instructions) {
    final steps = instructions
        .split('.')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    return steps.asMap().entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
              child: Text(
                '${entry.key + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                entry.value.trim(),
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

// Full Screen Image Viewer Widget
class _FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String heroTag;

  const _FullScreenImageViewer({required this.imageUrl, required this.heroTag});

  @override
  State<_FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<_FullScreenImageViewer> {
  bool _isZoomed = false;
  bool _showControls = true;

  void _toggleZoom() {
    setState(() {
      _isZoomed = !_isZoomed;
      if (_isZoomed) {
        _showControls = false;
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final viewerHeight = screenHeight * 0.75;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: (!_isZoomed || _showControls) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    if (!_isZoomed)
                      Text(
                        'Tap to zoom',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: viewerHeight,
              child: GestureDetector(
                onTap: () {
                  if (_isZoomed) {
                    _toggleControls();
                  } else {
                    _toggleZoom();
                  }
                },
                child: Hero(
                  tag: widget.heroTag,
                  child: Container(
                    color: _isZoomed ? Colors.black : Colors.white,
                    child: _isZoomed
                        ? PhotoView(
                            imageProvider: NetworkImage(widget.imageUrl),
                            initialScale: PhotoViewComputedScale.contained,
                            minScale: PhotoViewComputedScale.contained * 0.8,
                            maxScale: PhotoViewComputedScale.covered * 3,
                            backgroundDecoration: const BoxDecoration(
                              color: Colors.black,
                            ),
                            enableRotation: false,
                            onTapUp: (context, details, controllerValue) {
                              _toggleControls();
                            },
                          )
                        : Center(
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.error_outline,
                                    color: Colors.grey,
                                    size: 64,
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: AnimatedOpacity(
                  opacity: (!_isZoomed || _showControls) ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isZoomed ? Icons.zoom_out : Icons.zoom_in,
                        color: Colors.grey[400],
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isZoomed
                            ? 'Pinch to zoom • Double tap to reset'
                            : 'Tap image to zoom in',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      if (_isZoomed) ...[
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isZoomed = false;
                              _showControls = true;
                            });
                          },
                          icon: const Icon(Icons.close),
                          label: const Text('Exit Zoom'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YouTubePlayerSection extends StatefulWidget {
  final String youtubeUrl;

  const _YouTubePlayerSection({required this.youtubeUrl});

  @override
  State<_YouTubePlayerSection> createState() => _YouTubePlayerSectionState();
}

class _YouTubePlayerSectionState extends State<_YouTubePlayerSection> {
  bool _isLoading = false;

  Future<void> _openVideo() async {
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(widget.youtubeUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Unable to open video')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.watchVideo,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.play_circle_fill),
              label: Text(
                _isLoading ? 'Opening video...' : AppStrings.watchVideo,
              ),
              onPressed: _isLoading ? null : _openVideo,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: AppColors.activeChipText,
                padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.verticalLarge,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
