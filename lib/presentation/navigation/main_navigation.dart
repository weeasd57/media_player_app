import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/text_provider.dart';
import '../pages/home_screen.dart';
import '../pages/library_screen.dart';
import '../pages/playlists_screen.dart';
import '../pages/settings_screen.dart';
import '../pages/explore_device_screen.dart'; // Import for device exploration

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home,
      label: 'Home',
      color: Colors.blue,
    ),
    NavigationItem(
      icon: Icons.library_music_outlined,
      activeIcon: Icons.library_music,
      label: 'Library',
      color: Colors.purple,
    ),
    NavigationItem(
      icon: Icons.playlist_play_outlined,
      activeIcon: Icons.playlist_play,
      label: 'Playlists',
      color: Colors.indigo,
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
      color: Colors.orange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, TextProvider>(
      builder: (context, themeProvider, textProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryBackgroundColor,
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              HomeScreen(),
              LibraryScreen(),
              PlaylistsScreen(),
              SettingsScreen(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(
            themeProvider,
            textProvider,
          ),
          floatingActionButton: _buildFloatingActionButton(
            themeProvider,
            textProvider,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked, // Moved to a new line
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final navHeight = isSmallScreen ? 65.0 : 70.0;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final fabSpaceWidth = isSmallScreen ? 50.0 : 60.0;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 0,
          color: themeProvider.secondaryBackgroundColor,
          child: Container(
            height: navHeight,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, themeProvider, textProvider), // Home
                _buildNavItem(1, themeProvider, textProvider), // Library
                SizedBox(width: fabSpaceWidth), // Space for FAB
                _buildNavItem(2, themeProvider, textProvider), // Playlists
                _buildNavItem(3, themeProvider, textProvider), // Settings
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    final item = _navigationItems[index];
    final isActive = _currentIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    final iconSize = isSmallScreen ? 22.0 : 24.0;
    final fontSize = isSmallScreen ? 11.0 : 12.0;
    final verticalPadding = isSmallScreen ? 6.0 : 8.0;
    final horizontalPadding = isSmallScreen ? 8.0 : 12.0;

    // النصوص المترجمة
    final List<String> translatedLabels = [
      textProvider.getText('home'),
      textProvider.getText('library'),
      textProvider.getText('playlists'),
      textProvider.getText('settings'),
    ];

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive
              ? item.color.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey(isActive),
                color: isActive ? item.color : themeProvider.iconColor,
                size: iconSize,
              ),
            ),
            SizedBox(height: isSmallScreen ? 3 : 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? item.color : themeProvider.secondaryTextColor,
              ),
              child: Text(translatedLabels[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        return ScaleTransition(
          scale: _fabAnimation,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExploreDeviceScreen(), // Assume this screen allows file exploration and adding to favorites
                ),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 8,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: mediaProvider.isScanning
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : mediaProvider.currentMediaFile != null
                  ? Icon(
                      Icons.play_arrow_rounded,
                      key: const ValueKey('play_icon'),
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 28,
                    )
                  : Icon(
                      Icons.music_off,
                      key: const ValueKey('no_file_icon'),
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 28,
                    ),
            ),
          ),
        );
      },
    );
  }

  // Removed showScanDialog as it's no longer used with the FloatingActionButton
  // If scanning functionality is still needed, it should be moved to a different widget or screen.
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}
