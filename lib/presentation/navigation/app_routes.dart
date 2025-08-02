import 'package:flutter/material.dart';
import '../pages/home_screen.dart';
import '../pages/audio_player_screen.dart';
import '../pages/video_player_screen.dart';
import '../pages/settings_screen.dart';
import '../pages/equalizer_screen.dart';
import '../pages/library_screen.dart';
import '../pages/favorites_screen.dart';
// الصفحات التالية ستحتاج إنشاؤها لاحقاً
// import '../pages/playlists_screen.dart';
// import '../pages/recent_played_screen.dart';
// import '../pages/up_next_screen.dart';
// import '../pages/playlist_screen.dart';
// import '../pages/artist_album_view_screen.dart';
// import '../pages/explore_device_screen.dart';

/// مسارات التطبيق - إدارة مركزية لجميع الصفحات
class AppRoutes {
  // أسماء المسارات
  static const String home = '/';
  static const String audioPlayer = '/audio-player';
  static const String videoPlayer = '/video-player';
  static const String settings = '/settings';
  static const String equalizer = '/equalizer';
  static const String library = '/library';
  static const String favorites = '/favorites';
  static const String playlists = '/playlists';
  static const String playlist = '/playlist';
  static const String recentPlayed = '/recent-played';
  static const String upNext = '/up-next';
  static const String artistAlbumView = '/artist-album-view';
  static const String exploreDevice = '/explore-device';

  /// خريطة جميع المسارات
  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    audioPlayer: (context) => const AudioPlayerScreen(),
    videoPlayer: (context) => const VideoPlayerScreen(),
    settings: (context) => const SettingsScreen(),
    equalizer: (context) => const EqualizerScreen(),
    library: (context) => const LibraryScreen(),
    favorites: (context) => const FavoritesScreen(),
    // الصفحات التالية ستحتاج إنشاؤها لاحقاً
    // playlists: (context) => const PlaylistsScreen(),
    // playlist: (context) => const PlaylistScreen(),
    // recentPlayed: (context) => const RecentPlayedScreen(),
    // upNext: (context) => const UpNextScreen(),
    // artistAlbumView: (context) => const ArtistAlbumViewScreen(),
    // exploreDevice: (context) => const ExploreDeviceScreen(),
  };

  /// التنقل إلى صفحة معينة
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// التنقل مع استبدال الصفحة الحالية
  static Future<T?> navigateAndReplace<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// التنقل مع حذف جميع الصفحات السابقة
  static Future<T?> navigateAndRemoveUntil<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// العودة إلى الصفحة السابقة
  static void goBack(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }

  /// التنقل مع انتقال مخصص
  static Future<T?> navigateWithCustomTransition<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    TransitionType transitionType = TransitionType.slide,
  }) {
    Route<T> route;

    switch (transitionType) {
      case TransitionType.fade:
        route = PageRouteBuilder<T>(
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: duration,
        );
        break;
      case TransitionType.scale:
        route = PageRouteBuilder<T>(
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: curve),
              ),
              child: child,
            );
          },
          transitionDuration: duration,
        );
        break;
      case TransitionType.slide:
      default:
        route = PageRouteBuilder<T>(
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: curve),
              ),
              child: child,
            );
          },
          transitionDuration: duration,
        );
        break;
    }

    return Navigator.push<T>(context, route);
  }

  /// إنشاء مسار مخصص
  static Route<T> createRoute<T>(Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    TransitionType transitionType = TransitionType.slide,
  }) {
    switch (transitionType) {
      case TransitionType.fade:
        return PageRouteBuilder<T>(
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: duration,
        );
      case TransitionType.scale:
        return PageRouteBuilder<T>(
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          transitionDuration: duration,
        );
      case TransitionType.slide:
      default:
        return PageRouteBuilder<T>(
          pageBuilder: (context, animation, _) => page,
          transitionsBuilder: (context, animation, _, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: duration,
        );
    }
  }
}

/// أنواع الانتقالات المتاحة
enum TransitionType {
  slide,
  fade,
  scale,
}

/// فئة مساعدة للتنقل السريع
class NavigationHelper {
  /// التنقل إلى الصفحة الرئيسية
  static void toHome(BuildContext context) {
    AppRoutes.navigateAndRemoveUntil(context, AppRoutes.home);
  }

  /// التنقل إلى مشغل الصوت
  static void toAudioPlayer(BuildContext context, {Object? arguments}) {
    AppRoutes.navigateTo(context, AppRoutes.audioPlayer, arguments: arguments);
  }

  /// التنقل إلى مشغل الفيديو
  static void toVideoPlayer(BuildContext context, {Object? arguments}) {
    AppRoutes.navigateTo(context, AppRoutes.videoPlayer, arguments: arguments);
  }

  /// التنقل إلى الإعدادات
  static void toSettings(BuildContext context) {
    AppRoutes.navigateTo(context, AppRoutes.settings);
  }

  /// التنقل إلى المكتبة
  static void toLibrary(BuildContext context) {
    AppRoutes.navigateTo(context, AppRoutes.library);
  }

  /// التنقل إلى المفضلة
  static void toFavorites(BuildContext context) {
    AppRoutes.navigateTo(context, AppRoutes.favorites);
  }

  /// التنقل إلى قوائم التشغيل
  static void toPlaylists(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('صفحة قوائم التشغيل قيد التطوير')),
    );
  }

  /// التنقل إلى قائمة تشغيل محددة
  static void toPlaylist(BuildContext context, {Object? arguments}) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('صفحة قائمة التشغيل قيد التطوير')),
    );
  }

  /// التنقل إلى المشغل مؤخراً
  static void toRecentPlayed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('صفحة التشغيل الحديث قيد التطوير')),
    );
  }

  /// التنقل إلى التالي في القائمة
  static void toUpNext(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('صفحة التالي في القائمة قيد التطوير')),
    );
  }

  /// التنقل إلى عرض الفنان/الألبوم
  static void toArtistAlbumView(BuildContext context, {Object? arguments}) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('صفحة عرض الفنان/الألبوم قيد التطوير')),
    );
  }

  /// التنقل إلى استكشاف الجهاز
  static void toExploreDevice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('صفحة استكشاف الجهاز قيد التطوير')),
    );
  }

  /// التنقل إلى المعادل الصوتي
  static void toEqualizer(BuildContext context) {
    AppRoutes.navigateTo(context, AppRoutes.equalizer);
  }
}
