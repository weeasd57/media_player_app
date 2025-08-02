import 'package:flutter/material.dart';
import '../../widgets/neumorphic_components.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.red),
                    SizedBox(width: 8),
                    Text('مسح الكل'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort),
                    SizedBox(width: 8),
                    Text('ترتيب'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الأغاني', icon: Icon(Icons.music_note)),
            Tab(text: 'الفيديوهات', icon: Icon(Icons.video_library)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoriteSongs(),
          _buildFavoriteVideos(),
        ],
      ),
    );
  }

  Widget _buildFavoriteSongs() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Empty state or content
        _buildEmptyState(
          icon: Icons.favorite,
          title: 'لا توجد أغاني مفضلة',
          subtitle: 'أضف أغانيك المفضلة هنا',
        ),
        
        // Uncomment this section to show favorite songs
        /*
        ...List.generate(8, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NeumorphicContainer(
              child: ListTile(
                leading: NeumorphicContainer(
                  width: 50,
                  height: 50,
                  child: const Icon(Icons.music_note),
                ),
                title: Text('أغنية مفضلة ${index + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('فنان ${index + 1}'),
                    Text(
                      'أضيف منذ ${index + 1} أيام',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NeumorphicButton(
                      onPressed: () {},
                      child: const Icon(Icons.favorite, color: Colors.red, size: 20),
                    ),
                    const SizedBox(width: 8),
                    NeumorphicButton(
                      onPressed: () {},
                      child: const Icon(Icons.play_arrow),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        */
      ],
    );
  }

  Widget _buildFavoriteVideos() {  
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Empty state or content
        _buildEmptyState(
          icon: Icons.video_library,
          title: 'لا توجد فيديوهات مفضلة',
          subtitle: 'أضف فيديوهاتك المفضلة هنا',
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
                          'فيديو مفضل ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'أضيف منذ ${index + 1} أيام',
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
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeumorphicContainer(
              width: 120,
              height: 120,
              child: Icon(
                icon,
                size: 60,
                color: Colors.grey[400],
              ),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            NeumorphicCustomButton(
              onPressed: () {
                // Navigate to library or add favorites
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('استكشاف المكتبة'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
