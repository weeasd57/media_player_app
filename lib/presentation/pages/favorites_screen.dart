import 'package:flutter/material.dart';
import '../../widgets/neumorphic_components.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart'; // Corrected path
import '../providers/app_provider.dart'; // Added import for AppProvider

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, AppProvider>(
      builder: (context, localeProvider, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(localeProvider.favorites),
            centerTitle: true,
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        const Icon(Icons.clear_all, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          localeProvider.getLocalizedText(
                            'مسح الكل',
                            'Clear All',
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'sort',
                    child: Row(
                      children: [
                        const Icon(Icons.sort),
                        const SizedBox(width: 8),
                        Text(localeProvider.getLocalizedText('ترتيب', 'Sort')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: localeProvider.getLocalizedText('الأغاني', 'Songs'),
                  icon: const Icon(Icons.music_note),
                ),
                Tab(
                  text: localeProvider.getLocalizedText('الفيديوهات', 'Videos'),
                  icon: const Icon(Icons.video_library),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildFavoriteSongs(localeProvider, appProvider),
              _buildFavoriteVideos(localeProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoriteSongs(
    LocaleProvider localeProvider,
    AppProvider appProvider,
  ) {
    if (appProvider.favoriteSongs.isEmpty) {
      return _buildEmptyState(
        icon: Icons.favorite,
        title: localeProvider.getLocalizedText(
          'لا توجد أغاني مفضلة',
          'No favorite songs',
        ),
        subtitle: localeProvider.getLocalizedText(
          'أضف أغانيك المفضلة هنا',
          'Add your favorite songs here',
        ),
        localeProvider: localeProvider,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...appProvider.favoriteSongs.map((song) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NeumorphicContainer(
              child: ListTile(
                leading: NeumorphicContainer(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    song.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.music_note),
                  ),
                ),
                title: Flexible(
                  child: Text(song.title),
                ), // Use Flexible instead of Expanded
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(song.artist),
                    ), // Use Flexible instead of Expanded
                    Text(
                      localeProvider.getLocalizedText('المدة: ', 'Duration: ') +
                          '${song.duration.inMinutes}:${(song.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                trailing: FittedBox(
                  // Wrap with FittedBox
                  fit: BoxFit.scaleDown, // Add fit property
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NeumorphicButton(
                        onTap: () {
                          appProvider.toggleFavoriteSong(song);
                        },
                        icon: Icons.favorite,
                        iconColor: Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      NeumorphicButton(onTap: () {}, icon: Icons.play_arrow),
                    ],
                  ),
                ), // End FittedBox
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFavoriteVideos(LocaleProvider localeProvider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Empty state or content
        _buildEmptyState(
          icon: Icons.video_library,
          title: localeProvider.getLocalizedText(
            'لا توجد فيديوهات مفضلة',
            'No favorite videos',
          ),
          subtitle: localeProvider.getLocalizedText(
            'أضف فيديوهاتك المفضلة هنا',
            'Add your favorite videos here',
          ),
          localeProvider: localeProvider,
        ),

        // Uncomment this section to show favorite videos
        /*
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 16 / 10,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return NeumorphicContainer(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.video_library, size: 48),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: NeumorphicButton(
                            onPressed: () {},
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localeProvider.getLocalizedText('فيديو مفضل ${index + 1}', 'Favorite Video ${index + 1}'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          localeProvider.getLocalizedText('أضيف منذ ${index + 1} أيام', 'Added ${index + 1} days ago'),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        */
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required LocaleProvider localeProvider, // Add this parameter
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          // Add SingleChildScrollView
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicContainer(
                width: 120,
                height: 120,
                child: Icon(icon, size: 60, color: Colors.grey[400]),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                // Wrap with SizedBox to control width
                width: double.infinity, // Take full width
                child: NeumorphicCustomButton(
                  onPressed: () {
                    // Navigate to library or add favorites
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add),
                        const SizedBox(width: 8),
                        Text(
                          localeProvider.getLocalizedText(
                            'استكشاف المكتبة',
                            'Explore Library',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ), // End SizedBox
            ],
          ),
        ),
      ),
    );
  }
}
