import 'package:flutter/material.dart';
import '../../core/models/app_item.dart';
import '../pages/home_screen.dart';
import '../pages/library_screen.dart';
import '../pages/audio_player_screen.dart';
import '../pages/video_player_screen.dart';
import '../pages/settings_screen.dart';
import '../pages/equalizer_screen.dart';
import '../pages/favorites_screen.dart';
// import '../pages/playlists_screen.dart';
// import '../pages/recent_played_screen.dart';

class AppProvider extends ChangeNotifier {
  int _selectedAppIndex = 0; // التطبيق المحدد حالياً
  int _selectedPageIndex = 0; // الصفحة المحددة في التطبيق الحالي

  int get selectedAppIndex => _selectedAppIndex;
  int get selectedPageIndex => _selectedPageIndex;

  AppItem get currentApp => apps[_selectedAppIndex];
  AppPage get currentPage => currentApp.pages[_selectedPageIndex];

  // قائمة التطبيقات المتاحة
  List<AppItem> get apps => [
    // تطبيق Media Player الأساسي
    AppItem(
      id: 'media_player',
      name: 'Media Player',
      nameAr: 'مشغل الوسائط',
      icon: Icons.music_note,
      primaryColor: Colors.blue,
      secondaryColor: Colors.blueAccent,
      pages: [
        AppPage(
          id: 'home',
          name: 'Home',
          nameAr: 'الرئيسية',
          icon: Icons.home,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Library',
          nameAr: 'المكتبة',
          icon: Icons.library_music,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'favorites',
          name: 'Favorites',
          nameAr: 'المفضلة',
          icon: Icons.favorite,
          screen: const FavoritesScreen(),
        ),
        AppPage(
          id: 'playlists',
          name: 'Playlists',
          nameAr: 'قوائم التشغيل',
          icon: Icons.playlist_play,
          screen: const LibraryScreen(), // استخدام LibraryScreen بدلاً من المفقودة
        ),
        AppPage(
          id: 'recent',
          name: 'Recent',
          nameAr: 'المشغل مؤخراً',
          icon: Icons.history,
          screen: const LibraryScreen(), // استخدام LibraryScreen بدلاً من المفقودة
        ),
      ],
    ),
    
    // تطبيق Audio Player
    AppItem(
      id: 'audio_player',
      name: 'Audio Player',
      nameAr: 'مشغل الصوت',
      icon: Icons.headphones,
      primaryColor: Colors.green,
      secondaryColor: Colors.greenAccent,
      pages: [
        AppPage(
          id: 'player',
          name: 'Player',
          nameAr: 'المشغل',
          icon: Icons.play_circle,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Equalizer',
          nameAr: 'المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // تطبيق Video Player
    AppItem(
      id: 'video_player',
      name: 'Video Player',
      nameAr: 'مشغل الفيديو',
      icon: Icons.video_library,
      primaryColor: Colors.red,
      secondaryColor: Colors.redAccent,
      pages: [
        AppPage(
          id: 'video',
          name: 'Video',
          nameAr: 'الفيديو',
          icon: Icons.play_arrow,
          screen: const VideoPlayerScreen(),
        ),
      ],
    ),

    // تطبيق Settings
    AppItem(
      id: 'settings',
      name: 'Settings',
      nameAr: 'الإعدادات',
      icon: Icons.settings,
      primaryColor: Colors.grey,
      secondaryColor: Colors.grey.shade400,
      pages: [
        AppPage(
          id: 'settings',
          name: 'Settings',
          nameAr: 'الإعدادات',
          icon: Icons.settings,
          screen: const SettingsScreen(),
        ),
      ],
    ),
  ];

  void selectApp(int appIndex) {
    if (appIndex != _selectedAppIndex) {
      _selectedAppIndex = appIndex;
      _selectedPageIndex = 0; // العودة للصفحة الأولى في التطبيق الجديد
      notifyListeners();
    }
  }

  void selectPage(int pageIndex) {
    if (pageIndex != _selectedPageIndex && pageIndex < currentApp.pages.length) {
      _selectedPageIndex = pageIndex;
      notifyListeners();
    }
  }
}
