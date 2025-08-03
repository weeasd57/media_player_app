import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/home_screen.dart';
import '../pages/library_screen.dart';
import '../pages/audio_player_screen.dart';
import '../pages/video_player_screen.dart';
import '../pages/settings_screen.dart';
import '../pages/equalizer_screen.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToTab(int index) {
    _onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              HomeScreen(onNavigateToTab: _navigateToTab),
              const LibraryScreen(),
              const AudioPlayerScreen(),
              const VideoPlayerScreen(),
              const EqualizerScreen(),
              const SettingsScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: themeProvider.currentTheme.colorScheme.primary,
            unselectedItemColor: themeProvider
                .currentTheme
                .colorScheme
                .onSurface
                .withAlpha((0.6 * 255).round()),
            backgroundColor: themeProvider.primaryBackgroundColor,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: localeProvider.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.library_music),
                label: localeProvider.getLocalizedText(
                  'مكتبتك',
                  'Your Library',
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.music_note),
                label: localeProvider.getLocalizedText(
                  'ملفات صوتية',
                  'Audio Files',
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.video_library),
                label: localeProvider.getLocalizedText(
                  'ملفات فيديو',
                  'Video Files',
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.equalizer),
                label: localeProvider.getLocalizedText(
                  'معادل الصوت',
                  'Equalizer',
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: localeProvider.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
