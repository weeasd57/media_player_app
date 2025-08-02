import 'package:flutter/material.dart';
import '../../widgets/neumorphic_components.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('المكتبة'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الأغاني', icon: Icon(Icons.music_note)),
            Tab(text: 'الفيديوهات', icon: Icon(Icons.video_library)),
            Tab(text: 'قوائم التشغيل', icon: Icon(Icons.playlist_play)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSongsTab(),
          _buildVideosTab(),
          _buildPlaylistsTab(),
        ],
      ),
    );
  }

  Widget _buildSongsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search and Filter
        Row(
          children: [
            Expanded(
              child: NeumorphicContainer(
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'البحث في الأغاني...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            NeumorphicButton(
              icon: Icons.filter_list,
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Songs List
        ...List.generate(10, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NeumorphicContainer(
              child: ListTile(
                leading: NeumorphicContainer(
                  width: 50,
                  height: 50,
                  child: const Icon(Icons.music_note),
                ),
                title: Text('أغنية ${index + 1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('فنان ${index + 1}'),
                    Text(
                      '3:${(index + 1).toString().padLeft(2, '0')}',
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
                      icon: Icons.favorite_border,
                      onTap: () {},
                      size: 35,
                    ),
                    const SizedBox(width: 8),
                    NeumorphicButton(
                      icon: Icons.play_arrow,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildVideosTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search and Filter
        Row(
          children: [
            Expanded(
              child: NeumorphicContainer(
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'البحث في الفيديوهات...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            NeumorphicButton(
              icon: Icons.filter_list,
              onTap: () {},
            ),
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
                          'فيديو ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${(index + 5).toString().padLeft(2, '0')}:00',
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
      ],
    );
  }

  Widget _buildPlaylistsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Create Playlist Button
        NeumorphicCustomButton(
          onPressed: () {},
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text('إنشاء قائمة تشغيل جديدة'),
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
            title: const Text('المفضلة'),
            subtitle: const Text('0 عنصر'),
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
            title: const Text('المشغل مؤخراً'),
            subtitle: const Text('0 عنصر'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ),

        const SizedBox(height: 20),

        // Custom Playlists
        Text(
          'قوائم التشغيل المخصصة',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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
                title: Text('قائمة التشغيل ${index + 1}'),
                subtitle: Text('${(index + 1) * 3} عنصر'),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('حذف'),
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
