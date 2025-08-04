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
  bool _isSidebarHidden = true;
  // إضافة متغيرات للتنقل إلى المفضلة والإعدادات
  bool _showFavorites = false;
  bool _showSettings = false;

  int get selectedAppIndex => _selectedAppIndex;
  int get selectedPageIndex => _selectedPageIndex;
  // نحتفظ بهذا للتوافق مع الكود السابق، لكن دائمًا يكون false
  bool get isSidebarCollapsed => false;
  bool get isSidebarHidden => _isSidebarHidden;
  bool get showFavorites => _showFavorites;
  bool get showSettings => _showSettings;

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
          id: 'audio',
          name: 'Audio Player',
          nameAr: 'مشغل الصوت',
          icon: Icons.headphones_rounded,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Video Player',
          nameAr: 'مشغل الفيديو',
          icon: Icons.play_circle_rounded,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Equalizer',
          nameAr: 'المعادل',
          icon: Icons.equalizer_rounded,
          screen: const EqualizerScreen(),
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
          id: 'library',
          name: 'Library',
          nameAr: 'المكتبة',
          icon: Icons.library_music_outlined,
          screen: const LibraryScreen(),
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
          icon: Icons.library_books,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Audio Player',
          nameAr: 'مشغل الصوت',
          icon: Icons.music_note,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Video Player',
          nameAr: 'مشغل الفيديو',
          icon: Icons.video_library,
          screen: const VideoPlayerScreen(),
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
          id: 'library',
          name: 'Library',
          nameAr: 'المكتبة',
          icon: Icons.library_music,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Audio Player',
          nameAr: 'مشغل الصوت',
          icon: Icons.headphones,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Video Player',
          nameAr: 'مشغل الفيديو',
          icon: Icons.video_library,
          screen: const VideoPlayerScreen(),
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
          name: 'Audio Player',
          nameAr: 'مشغل الصوت',
          icon: Icons.headphones,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Video Player',
          nameAr: 'مشغل الفيديو',
          icon: Icons.play_circle,
          screen: const VideoPlayerScreen(),
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
          id: 'library',
          name: 'Data Library',
          nameAr: 'مكتبة البيانات',
          icon: Icons.storage,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Audio Matrix',
          nameAr: 'مصفوفة الصوت',
          icon: Icons.graphic_eq,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Video Matrix',
          nameAr: 'مصفوفة الفيديو',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
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
          id: 'audio',
          name: 'Nature Sounds',
          nameAr: 'أصوات الطبيعة',
          icon: Icons.nature_people,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Nature Videos',
          nameAr: 'فيديوهات الطبيعة',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Nature EQ',
          nameAr: 'معادل الطبيعة',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
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
          id: 'library',
          name: 'Vintage Library',
          nameAr: 'المكتبة الكلاسيكية',
          icon: Icons.library_books,
          screen: const LibraryScreen(),
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
        AppPage(
          id: 'equalizer',
          name: 'Retro EQ',
          nameAr: 'المعادل الكلاسيكي',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
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
          id: 'video',
          name: 'Ocean Videos',
          nameAr: 'فيديوهات المحيط',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Ocean EQ',
          nameAr: 'معادل المحيط',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
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
          id: 'audio',
          name: 'Sunset Audio',
          nameAr: 'صوت الغروب',
          icon: Icons.headphones,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Sunset Videos',
          nameAr: 'فيديوهات الغروب',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Sunset EQ',
          nameAr: 'معادل الغروب',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 11. Neon UI Kit
    AppItem(
      id: 'neon_app',
      name: 'Neon',
      nameAr: 'نيون',
      icon: Icons.electric_bolt,
      primaryColor: const Color(0xFFFF0080),
      secondaryColor: const Color(0xFF00FFFF),
      uiKitType: 'neon',
      pages: [
        AppPage(
          id: 'home',
          name: 'Neon Home',
          nameAr: 'نيون الرئيسية',
          icon: Icons.flash_on,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Neon Library',
          nameAr: 'مكتبة النيون',
          icon: Icons.library_music,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Neon Audio',
          nameAr: 'نيون الصوت',
          icon: Icons.music_note,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Neon Video',
          nameAr: 'نيون الفيديو',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Neon EQ',
          nameAr: 'نيون المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 12. Material You UI Kit
    AppItem(
      id: 'material_you_app',
      name: 'Material You',
      nameAr: 'ماتيريال يو',
      icon: Icons.palette,
      primaryColor: const Color(0xFF6750A4),
      secondaryColor: const Color(0xFF625B71),
      uiKitType: 'material_you',
      pages: [
        AppPage(
          id: 'home',
          name: 'Material Home',
          nameAr: 'ماتيريال الرئيسية',
          icon: Icons.home,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Material Library',
          nameAr: 'ماتيريال المكتبة',
          icon: Icons.library_books,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Material Audio',
          nameAr: 'ماتيريال الصوت',
          icon: Icons.headphones,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Material Video',
          nameAr: 'ماتيريال الفيديو',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Material EQ',
          nameAr: 'ماتيريال المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 13. Dark Matter UI Kit
    AppItem(
      id: 'dark_matter_app',
      name: 'Dark Matter',
      nameAr: 'المادة المظلمة',
      icon: Icons.dark_mode,
      primaryColor: const Color(0xFF1A1A1A),
      secondaryColor: const Color(0xFF333333),
      uiKitType: 'dark_matter',
      pages: [
        AppPage(
          id: 'home',
          name: 'Dark Home',
          nameAr: 'المظلم الرئيسية',
          icon: Icons.nights_stay,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Dark Library',
          nameAr: 'المظلم المكتبة',
          icon: Icons.library_books,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Dark Audio',
          nameAr: 'المظلم الصوت',
          icon: Icons.audiotrack,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Dark Video',
          nameAr: 'المظلم الفيديو',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Dark EQ',
          nameAr: 'المظلم المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 14. Holographic UI Kit
    AppItem(
      id: 'holographic_app',
      name: 'Holographic',
      nameAr: 'هولوجرافيك',
      icon: Icons.auto_awesome,
      primaryColor: const Color(0xFF9C27B0),
      secondaryColor: const Color(0xFF673AB7),
      uiKitType: 'holographic',
      pages: [
        AppPage(
          id: 'home',
          name: 'Holo Home',
          nameAr: 'هولو الرئيسية',
          icon: Icons.blur_on,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Holo Library',
          nameAr: 'هولو المكتبة',
          icon: Icons.library_books,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Holo Audio',
          nameAr: 'هولو الصوت',
          icon: Icons.headphones,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Holo Video',
          nameAr: 'هولو الفيديو',
          icon: Icons.video_library,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Holo Equalizer',
          nameAr: 'هولو المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 15. Vintage UI Kit
    AppItem(
      id: 'vintage_app',
      name: 'Vintage',
      nameAr: 'فينتاج',
      icon: Icons.camera_alt,
      primaryColor: const Color(0xFF8D6E63),
      secondaryColor: const Color(0xFFA1887F),
      uiKitType: 'vintage',
      pages: [
        AppPage(
          id: 'home',
          name: 'Vintage Home',
          nameAr: 'فينتاج الرئيسية',
          icon: Icons.home_outlined,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Vintage Library',
          nameAr: 'فينتاج المكتبة',
          icon: Icons.library_music,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Vintage Audio',
          nameAr: 'فينتاج الصوت',
          icon: Icons.radio,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Vintage Video',
          nameAr: 'فينتاج الفيديو',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Vintage EQ',
          nameAr: 'فينتاج المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 16. Crystal UI Kit
    AppItem(
      id: 'crystal_app',
      name: 'Crystal',
      nameAr: 'كريستال',
      icon: Icons.diamond,
      primaryColor: const Color(0xFF00BCD4),
      secondaryColor: const Color(0xFF26C6DA),
      uiKitType: 'crystal',
      pages: [
        AppPage(
          id: 'home',
          name: 'Crystal Home',
          nameAr: 'كريستال الرئيسية',
          icon: Icons.home_max,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Crystal Library',
          nameAr: 'كريستال المكتبة',
          icon: Icons.library_books,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Crystal Audio',
          nameAr: 'كريستال الصوت',
          icon: Icons.headphones,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Crystal Video',
          nameAr: 'كريستال الفيديو',
          icon: Icons.video_collection,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Crystal EQ',
          nameAr: 'كريستال المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 17. Synthwave UI Kit
    AppItem(
      id: 'synthwave_app',
      name: 'Synthwave',
      nameAr: 'سينث ويف',
      icon: Icons.waves,
      primaryColor: const Color(0xFFFF6EC7),
      secondaryColor: const Color(0xFF00D4FF),
      uiKitType: 'synthwave',
      pages: [
        AppPage(
          id: 'home',
          name: 'Synth Home',
          nameAr: 'سينث الرئيسية',
          icon: Icons.graphic_eq,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Synth Library',
          nameAr: 'سينث المكتبة',
          icon: Icons.library_music,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Synth Audio',
          nameAr: 'سينث الصوت',
          icon: Icons.music_video,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Synth Video',
          nameAr: 'سينث الفيديو',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Synth Equalizer',
          nameAr: 'سينث المعادل',
          icon: Icons.tune,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 18. Nordic UI Kit
    AppItem(
      id: 'nordic_app',
      name: 'Nordic',
      nameAr: 'نورديك',
      icon: Icons.ac_unit,
      primaryColor: const Color(0xFF37474F),
      secondaryColor: const Color(0xFF546E7A),
      uiKitType: 'nordic',
      pages: [
        AppPage(
          id: 'home',
          name: 'Nordic Home',
          nameAr: 'نورديك الرئيسية',
          icon: Icons.cottage,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Nordic Library',
          nameAr: 'نورديك المكتبة',
          icon: Icons.menu_book,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Nordic Audio',
          nameAr: 'نورديك الصوت',
          icon: Icons.headphones,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Nordic Video',
          nameAr: 'نورديك الفيديو',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Nordic EQ',
          nameAr: 'نورديك المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 19. Cosmic UI Kit
    AppItem(
      id: 'cosmic_app',
      name: 'Cosmic',
      nameAr: 'كوني',
      icon: Icons.stars,
      primaryColor: const Color(0xFF3F51B5),
      secondaryColor: const Color(0xFF9C27B0),
      uiKitType: 'cosmic',
      pages: [
        AppPage(
          id: 'home',
          name: 'Cosmic Home',
          nameAr: 'كوني الرئيسية',
          icon: Icons.rocket_launch,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Cosmic Library',
          nameAr: 'كوني المكتبة',
          icon: Icons.library_books,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Cosmic Audio',
          nameAr: 'كوني الصوت',
          icon: Icons.headphones,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Cosmic Video',
          nameAr: 'كوني الفيديو',
          icon: Icons.movie,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Cosmic EQ',
          nameAr: 'كوني المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
        ),
      ],
    ),

    // 20. Brutalist UI Kit
    AppItem(
      id: 'brutalist_app',
      name: 'Brutalist',
      nameAr: 'بروتاليست',
      icon: Icons.architecture,
      primaryColor: const Color(0xFF424242),
      secondaryColor: const Color(0xFF616161),
      uiKitType: 'brutalist',
      pages: [
        AppPage(
          id: 'home',
          name: 'Brutal Home',
          nameAr: 'بروتال الرئيسية',
          icon: Icons.construction,
          screen: HomeScreen(onNavigateToTab: (index) {}),
        ),
        AppPage(
          id: 'library',
          name: 'Brutal Library',
          nameAr: 'بروتال المكتبة',
          icon: Icons.folder,
          screen: const LibraryScreen(),
        ),
        AppPage(
          id: 'audio',
          name: 'Brutal Audio',
          nameAr: 'بروتال الصوت',
          icon: Icons.speaker,
          screen: const AudioPlayerScreen(),
        ),
        AppPage(
          id: 'video',
          name: 'Brutal Video',
          nameAr: 'بروتال الفيديو',
          icon: Icons.videocam,
          screen: const VideoPlayerScreen(),
        ),
        AppPage(
          id: 'equalizer',
          name: 'Brutal EQ',
          nameAr: 'بروتال المعادل',
          icon: Icons.equalizer,
          screen: const EqualizerScreen(),
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
    notifyListeners();
  }

  // دالة لفتح الشريط الجانبي من حالة الإخفاء
  void showSidebar() {
    _isSidebarHidden = false; // فتح
    notifyListeners();
  }

  // دالة لإخفاء الشريط الجانبي
  void hideSidebar() {
    _isSidebarHidden = true; // إخفاء
    notifyListeners();
  }

  // نحتفظ بهذه الدالة للتوافق مع الكود السابق
  void expandSidebar() {
    _isSidebarHidden = false; // فتح
    notifyListeners();
  }

  // دالة للتنقل إلى المفضلة
  void navigateToFavorites() {
    _showFavorites = true;
    _showSettings = false;
    notifyListeners();
  }

  // دالة للتنقل إلى الإعدادات
  void navigateToSettings() {
    _showSettings = true;
    _showFavorites = false;
    notifyListeners();
  }

  // دالة للعودة إلى الصفحة الرئيسية
  void navigateToHome() {
    _showFavorites = false;
    _showSettings = false;
    notifyListeners();
  }
}
