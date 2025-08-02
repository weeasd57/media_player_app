import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/home_screen.dart';
import '../pages/library_screen.dart';
import '../pages/audio_player_screen.dart';
import '../pages/video_player_screen.dart';
import '../pages/settings_screen.dart';
import '../pages/equalizer_screen.dart';
import '../providers/theme_provider.dart';
import '../../generated/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
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
            unselectedItemColor: themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.6),
            backgroundColor: themeProvider.primaryBackgroundColor,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: l10n.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.library_music),
                label: l10n.yourLibrary,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.music_note),
                label: l10n.audioFiles,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.video_library),
                label: l10n.videoFiles,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.equalizer),
                label: l10n.equalizer,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: l10n.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
