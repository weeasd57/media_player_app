import 'package:flutter/material.dart';
import '../../core/models/app_item.dart';
import '../pages/home_screen.dart';
import '../pages/library_screen.dart';
import '../pages/audio_player_screen.dart';
import '../pages/video_player_screen.dart';
import '../pages/settings_screen.dart';
import '../pages/equalizer_screen.dart';
import '../pages/favorites_screen.dart';

class AppProvider extends ChangeNotifier {
  int _selectedAppIndex = 0;
  int _selectedPageIndex = 0;
  // استخدام حالة واحدة للشريط الجانبي: false = مفتوح، true = مخفي
  bool _isSidebarHidden = false;

  int get selectedAppIndex => _selectedAppIndex;
  int get selectedPageIndex => _selectedPageIndex;
  // نحتفظ بهذا للتوافق مع الكود السابق، لكن دائمًا يكون false
  bool get isSidebarCollapsed => false;
  bool get isSidebarHidden => _isSidebarHidden;

  AppItem get currentApp => apps[_selectedAppIndex];
  AppPage get currentPage => currentApp.pages[_selectedPageIndex];

  // قائمة التطبيقات العشرة مع UI Kit مختلفة
  List<AppItem> get apps => [
    // 1. Modern UI Kit
    AppItem(
      id: 'modern_app',
      name: 'Modern UI',
      nameAr: 'واجهة عصرية',
      icon: Icons.auto_awesome,
      primaryColor: const Color(0xFF6366F1),
      secondaryColor: const Color(0xFF8B5CF6),
      uiKitType: 'modern',
      pages: [
        AppPage(
          id: 'home',
          name: 'Home',
          nameAr: 'الرئيسية',
          icon: Icons.home_rounded,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Library',
          nameAr: 'المكتبة',
          icon: Icons.library_music_rounded,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'favorites',
          name: 'Favorites',
          nameAr: 'المفضلة',
          icon: Icons.favorite_rounded,
          screen: const FavoritesScreen(),
        ),
        AppPage(
          id: 'settings',
          name: 'Settings',
          nameAr: 'الإعدادات',
          icon: Icons.settings_rounded,
          screen: const SettingsScreen(),
        ),
      ],
    ),

    // 2. Glassmorphic UI Kit
    AppItem(
      id: 'glassmorphic_app',
      name: 'Glassmorphic',
      nameAr: 'زجاجي',
      icon: Icons.blur_on,
      primaryColor: const Color(0xFF00D4FF),
      secondaryColor: const Color(0xFF5B73FF),
      uiKitType: 'glassmorphic',
      pages: [
        AppPage(
          id: 'home',
          name: 'Home',
          nameAr: 'الرئيسية',
          icon: Icons.home_outlined,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'audio',
          name: 'Audio',
          nameAr: 'الصوت',
          icon: Icons.headphones_outlined,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Video',
          nameAr: 'الفيديو',
          icon: Icons.play_circle_outline,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Equalizer',
          nameAr: 'المعادل',
          icon: Icons.equalizer_outlined,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 3. Neomorphic UI Kit
    AppItem(
      id: 'neomorphic_app',
      name: 'Neomorphic',
      nameAr: 'نيومورفيك',
      icon: Icons.layers,
      primaryColor: const Color(0xFF667EEA),
      secondaryColor: const Color(0xFF764BA2),
      uiKitType: 'neomorphic',
      pages: [
        AppPage(
          id: 'library',
          name: 'Library',
          nameAr: 'المكتبة',
          icon: Icons.library_books,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'favorites',
          name: 'Favorites',
          nameAr: 'المفضلة',
          icon: Icons.favorite_border,
          screen: const FavoritesScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Audio Player',
          nameAr: 'مشغل الصوت',
          icon: Icons.music_note,
          screen: const AudioPlayerScreen(),
        ),
      ],
    ),

    // 4. Gradient UI Kit
    AppItem(
      id: 'gradient_app',
      name: 'Gradient',
      nameAr: 'متدرج',
      icon: Icons.gradient,
      primaryColor: const Color(0xFFFF6B6B),
      secondaryColor: const Color(0xFF4ECDC4),
      uiKitType: 'gradient',
      pages: [
        AppPage(
          id: 'home',
          name: 'Dashboard',
          nameAr: 'لوحة التحكم',
          icon: Icons.dashboard,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'video',
          name: 'Video Player',
          nameAr: 'مشغل الفيديو',
          icon: Icons.video_library,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'settings',
          name: 'Settings',
          nameAr: 'الإعدادات',
          icon: Icons.tune,
          screen: const SettingsScreen(),
        ),
      ],
    ),

    // 5. Minimal UI Kit
    AppItem(
      id: 'minimal_app',
      name: 'Minimal',
      nameAr: 'بسيط',
      icon: Icons.minimize,
      primaryColor: const Color(0xFF000000),
      secondaryColor: const Color(0xFF6B7280),
      uiKitType: 'minimal',
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
          icon: Icons.folder,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Player',
          nameAr: 'المشغل',
          icon: Icons.play_arrow,
          screen: const AudioPlayerScreen(),
        ),
      ],
    ),

    // 6. Cyber UI Kit
    AppItem(
      id: 'cyber_app',
      name: 'Cyber',
      nameAr: 'سايبر',
      icon: Icons.computer,
      primaryColor: const Color(0xFF00FF9F),
      secondaryColor: const Color(0xFFFF0080),
      uiKitType: 'cyber',
      pages: [
        AppPage(
          id: 'home',
          name: 'Terminal',
          nameAr: 'الطرفية',
          icon: Icons.terminal,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'audio',
          name: 'Audio Matrix',
          nameAr: 'مصفوفة الصوت',
          icon: Icons.graphic_eq,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'EQ Matrix',
          nameAr: 'مصفوفة المعادل',
          icon: Icons.waves,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 7. Nature UI Kit
    AppItem(
      id: 'nature_app',
      name: 'Nature',
      nameAr: 'طبيعة',
      icon: Icons.eco,
      primaryColor: const Color(0xFF2ECC71),
      secondaryColor: const Color(0xFF27AE60),
      uiKitType: 'nature',
      pages: [
        AppPage(
          id: 'home',
          name: 'Garden',
          nameAr: 'الحديقة',
          icon: Icons.local_florist,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Forest',
          nameAr: 'الغابة',
          icon: Icons.forest,
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
          id: 'audio',
          name: 'Nature Sounds',
          nameAr: 'أصوات الطبيعة',
          icon: Icons.nature_people,
          screen: const AudioPlayerScreen(),
        ),
      ],
    ),

    // 8. Retro UI Kit
    AppItem(
      id: 'retro_app',
      name: 'Retro',
      nameAr: 'ريترو',
      icon: Icons.radio,
      primaryColor: const Color(0xFFE74C3C),
      secondaryColor: const Color(0xFFF39C12),
      uiKitType: 'retro',
      pages: [
        AppPage(
          id: 'home',
          name: 'Vintage Home',
          nameAr: 'الرئيسية الكلاسيكية',
          icon: Icons.home,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'audio',
          name: 'Vinyl Player',
          nameAr: 'مشغل الفينيل',
          icon: Icons.album,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Old TV',
          nameAr: 'التلفاز القديم',
          icon: Icons.tv,
          screen: const VideoPlayerScreen(),
        ),
      ],
    ),

    // 9. Ocean UI Kit
    AppItem(
      id: 'ocean_app',
      name: 'Ocean',
      nameAr: 'المحيط',
      icon: Icons.waves,
      primaryColor: const Color(0xFF006A6B),
      secondaryColor: const Color(0xFF0891B2),
      uiKitType: 'ocean',
      pages: [
        AppPage(
          id: 'home',
          name: 'Deep Sea',
          nameAr: 'أعماق البحر',
          icon: Icons.water,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Ocean Library',
          nameAr: 'مكتبة المحيط',
          icon: Icons.waves,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Ocean Sounds',
          nameAr: 'أصوات المحيط',
          icon: Icons.beach_access,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'favorites',
          name: 'Treasures',
          nameAr: 'الكنوز',
          icon: Icons.diamond,
          screen: const FavoritesScreen(),
        ),
      ],
    ),

    // 10. Sunset UI Kit
    AppItem(
      id: 'sunset_app',
      name: 'Sunset',
      nameAr: 'الغروب',
      icon: Icons.wb_sunny,
      primaryColor: const Color(0xFFFF6B35),
      secondaryColor: const Color(0xFFF7931E),
      uiKitType: 'sunset',
      pages: [
        AppPage(
          id: 'home',
          name: 'Golden Hour',
          nameAr: 'الساعة الذهبية',
          icon: Icons.wb_twilight,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Photo Library',
          nameAr: 'مكتبة الصور',
          icon: Icons.photo_library,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Sunset Videos',
          nameAr: 'فيديوهات الغروب',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'favorites',
          name: 'Golden Moments',
          nameAr: 'اللحظات الذهبية',
          icon: Icons.star,
          screen: const FavoritesScreen(),
        ),
        AppPage(
          id: 'settings',
          name: 'Camera Settings',
          nameAr: 'إعدادات الكاميرا',
          icon: Icons.camera_alt,
          screen: const SettingsScreen(),
        ),
      ],
    ),
  ];

  void selectApp(int appIndex) {
    if (appIndex != _selectedAppIndex) {
      _selectedAppIndex = appIndex;
      _selectedPageIndex = 0;
      notifyListeners();
    }
  }

  void selectPage(int pageIndex) {
    if (pageIndex != _selectedPageIndex &&
        pageIndex < currentApp.pages.length) {
      _selectedPageIndex = pageIndex;
      notifyListeners();
    }
  }

  void toggleSidebar() {
    // تبديل حالة الشريط الجانبي بين مفتوح ومخفي فقط
    _isSidebarHidden = !_isSidebarHidden;
    debugPrint("DEBUG: Sidebar ${_isSidebarHidden ? 'hidden' : 'visible'}");
    notifyListeners();
  }

  // دالة لفتح الشريط الجانبي من حالة الإخفاء
  void showSidebar() {
    _isSidebarHidden = false; // فتح
    notifyListeners();
  }

  // نحتفظ بهذه الدالة للتوافق مع الكود السابق
  void expandSidebar() {
    _isSidebarHidden = false; // فتح
    notifyListeners();
  }
}
