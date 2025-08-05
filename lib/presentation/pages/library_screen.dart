import 'package:flutter/material.dart';
import '../../widgets/neumorphic_components.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../../core/models/song.dart'; // Import Song model
import '../providers/app_provider.dart'; // Import AppProvider

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            title: Text(localeProvider.getLocalizedText('المكتبة', 'Library')),
            centerTitle: true,
            actions: [
              IconButton(icon: const Icon(Icons.search), onPressed: () {}),
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
                Tab(
                  text: localeProvider.getLocalizedText(
                    'قوائم التشغيل',
                    'Playlists',
                  ),
                  icon: const Icon(Icons.playlist_play),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildSongsTab(localeProvider, appProvider),
              _buildVideosTab(localeProvider),
              _buildPlaylistsTab(localeProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSongsTab(
    LocaleProvider localeProvider,
    AppProvider appProvider,
  ) {
    final List<Song> dummySongs = List.generate(
      10,
      (index) => Song(
        id: 'song_${index + 1}',
        title: localeProvider.getLocalizedText(
          'أغنية ${index + 1}',
          'Song ${index + 1}',
        ),
        artist: localeProvider.getLocalizedText(
          'فنان ${index + 1}',
          'Artist ${index + 1}',
        ),
        album: localeProvider.getLocalizedText(
          'ألبوم ${index + 1}',
          'Album ${index + 1}',
        ),
        duration: Duration(minutes: 3, seconds: (index + 1) * 5),
        imageUrl: 'https://via.placeholder.com/150',
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search and Filter
        Row(
          children: [
            Expanded(
              child: NeumorphicContainer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: localeProvider.getLocalizedText(
                      'البحث في الأغاني...',
                      'Search in Songs...',
                    ),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            NeumorphicButton(icon: Icons.filter_list, onTap: () {}),
          ],
        ),

        const SizedBox(height: 20),

        // Songs List
        ...dummySongs.map((song) {
          final isFavorite = appProvider.isSongFavorite(song);
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
                title: Text(song.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.artist),
                    Text(
                      '${song.duration.inMinutes}:${(song.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NeumorphicButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      iconColor: isFavorite ? Colors.red : null,
                      onTap: () {
                        appProvider.toggleFavoriteSong(song);
                      },
                      size: 35,
                    ),
                    const SizedBox(width: 8),
                    NeumorphicButton(icon: Icons.play_arrow, onTap: () {}),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildVideosTab(LocaleProvider localeProvider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search and Filter
        Row(
          children: [
            Expanded(
              child: NeumorphicContainer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: localeProvider.getLocalizedText(
                      'البحث في الفيديوهات...',
                      'Search in Videos...',
                    ),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            NeumorphicButton(icon: Icons.filter_list, onTap: () {}),
          ],
        ),

        const SizedBox(height: 20),

        // Videos Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 16 / 9,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return NeumorphicContainer(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.video_library, size: 48),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localeProvider.getLocalizedText(
                            'فيديو ${index + 1}',
                            'Video ${index + 1}',
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${(index + 5).toString().padLeft(2, '0')}:00',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlaylistsTab(LocaleProvider localeProvider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Create Playlist Button
        NeumorphicCustomButton(
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add),
                const SizedBox(width: 8),
                Text(
                  localeProvider.getLocalizedText(
                    'إنشاء قائمة تشغيل جديدة',
                    'Create New Playlist',
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Default Playlists
        NeumorphicContainer(
          child: ListTile(
            leading: NeumorphicContainer(
              width: 50,
              height: 50,
              child: const Icon(Icons.favorite, color: Colors.red),
            ),
            title: Text(
              localeProvider.getLocalizedText('المفضلة', 'Favorites'),
            ),
            subtitle: Text(
              localeProvider.getLocalizedText('0 عنصر', '0 items'),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ),

        const SizedBox(height: 12),

        NeumorphicContainer(
          child: ListTile(
            leading: NeumorphicContainer(
              width: 50,
              height: 50,
              child: const Icon(Icons.access_time, color: Colors.blue),
            ),
            title: Text(
              localeProvider.getLocalizedText(
                'المشغل مؤخراً',
                'Recently Played',
              ),
            ),
            subtitle: Text(
              localeProvider.getLocalizedText('0 عنصر', '0 items'),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ),

        const SizedBox(height: 20),

        // Custom Playlists
        Text(
          localeProvider.getLocalizedText(
            'قوائم التشغيل المخصصة',
            'Custom Playlists',
          ),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        ...List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NeumorphicContainer(
              child: ListTile(
                leading: NeumorphicContainer(
                  width: 50,
                  height: 50,
                  child: const Icon(Icons.queue_music),
                ),
                title: Text(
                  localeProvider.getLocalizedText(
                    'قائمة التشغيل ${index + 1}',
                    'Playlist ${index + 1}',
                  ),
                ),
                subtitle: Text(
                  localeProvider.getLocalizedText(
                    '${(index + 1) * 3} عنصر',
                    '${(index + 1) * 3} items',
                  ),
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          Text(
                            localeProvider.getLocalizedText('تعديل', 'Edit'),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            localeProvider.getLocalizedText('حذف', 'Delete'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
            ),
          );
        }),
      ],
    );
  }
}
