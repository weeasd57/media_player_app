import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../../generated/app_localizations.dart';
import '../pages/home_screen.dart';
import '../pages/library_screen.dart';
import '../pages/playlists_screen.dart';
import '../pages/settings_screen.dart';
import '../pages/explore_device_screen.dart';
import '../pages/video_player_screen.dart';
import '../../widgets/neumorphic_components.dart' as neumorphic;

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

  void _onHomeNavigateToTab(int homeIndex) {
    // Map home screen indices to main navigation indices
    int navigationIndex;
    switch (homeIndex) {
      case 0: // Audio Files -> Library
        navigationIndex = 1;
        break;
      case 1: // Video Files -> Library
        navigationIndex = 1;
        break;
      case 2: // Favorites -> Library (for now, could be a separate tab)
        navigationIndex = 1;
        break;
      case 3: // Playlists -> Playlists
        navigationIndex = 2;
        break;
      default:
        navigationIndex = 1;
    }

    _onItemTapped(navigationIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              HomeScreen(onNavigateToTab: _onHomeNavigateToTab),
              LibraryScreen(),
              PlaylistsScreen(),
              SettingsScreen(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(
            themeProvider,
            l10n,
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // تحديد ارتفاع الشريط بناءً على حجم الشاشة
    final navigationHeight = screenWidth < 360 ? 70.0 :
                           screenWidth < 600 ? 80.0 :
                           screenWidth < 1024 ? 85.0 : 90.0;
    
    return Container(
      height: navigationHeight,
      decoration: BoxDecoration(
        color: themeProvider.currentTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode 
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: themeProvider.isDarkMode 
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.7),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildResponsiveNavItem(0, Icons.home, l10n.home, themeProvider),
          ),
          Expanded(
            child: _buildResponsiveNavItem(1, Icons.library_music, l10n.library, themeProvider),
          ),
          // Center Play Button
          _buildCenterPlayButton(themeProvider),
          Expanded(
            child: _buildResponsiveNavItem(2, Icons.playlist_play, l10n.playlists, themeProvider),
          ),
          Expanded(
            child: _buildResponsiveNavItem(3, Icons.settings, l10n.settings, themeProvider),
          ),
        ]
      ),
    );
  }

  Widget _buildSimpleNavItem(int index, IconData icon, String label, ThemeProvider themeProvider) {
    final isActive = _currentIndex == index;
    final color = isActive ? Colors.blue : Colors.grey;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleFAB(ThemeProvider themeProvider) {
    return Expanded(
      child: Container(
        height: 60,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExploreDeviceScreen()),
                  );
                },
                child: const Icon(Icons.add),
                mini: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernNavItem(
    int index,
    ThemeProvider themeProvider,
    AppLocalizations l10n,
  ) {
    final item = _navigationItems[index];
    final isActive = _currentIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Ultra compact sizing to prevent overflow
    final iconSize = screenWidth < 360 ? 16.0 : 20.0;
    final containerSize = screenWidth < 360 ? 24.0 : 28.0;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          height: 50, // Fixed height to prevent overflow
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Simplified icon container
              Container(
                width: containerSize,
                height: containerSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isActive 
                      ? item.color.withValues(alpha: 0.2)
                      : Colors.transparent,
                ),
                child: Icon(
                  isActive ? item.activeIcon : item.icon,
                  color: isActive 
                      ? item.color
                      : themeProvider.currentTheme.iconTheme.color?.withValues(alpha: 0.7) ?? Colors.grey,
                  size: iconSize,
                ),
              ),
              const SizedBox(height: 2),
              // Only show label for active item on very small screens
              if (screenWidth >= 360 || isActive)
                Flexible(
                  child: Text(
                    _getShortLabel(index, l10n),
                    style: TextStyle(
                      fontSize: screenWidth < 360 ? 7.0 : 8.0,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive 
                          ? item.color
                          : themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  String _getShortLabel(int index, AppLocalizations l10n) {
    final labels = [
      l10n.home,
      l10n.library,
      l10n.playlists,
      l10n.settings,
    ];
    return labels[index];
  }

  // دالة جديدة لبناء عناصر التنقل المتجاوبة
  Widget _buildResponsiveNavItem(int index, IconData icon, String label, ThemeProvider themeProvider) {
    final isActive = _currentIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // تحديد أحجام متجاوبة بناءً على حجم الشاشة
    final iconSize = screenWidth < 360 ? 18.0 :
                    screenWidth < 600 ? 22.0 :
                    screenWidth < 1024 ? 24.0 : 26.0;
    
    final fontSize = screenWidth < 360 ? 8.0 :
                    screenWidth < 600 ? 9.0 :
                    screenWidth < 1024 ? 10.0 : 11.0;
    
    final containerPadding = screenWidth < 360 ? 4.0 :
                            screenWidth < 600 ? 6.0 :
                            screenWidth < 1024 ? 8.0 : 10.0;
    
    final verticalMargin = screenWidth < 360 ? 12.0 :
                          screenWidth < 600 ? 14.0 :
                          screenWidth < 1024 ? 16.0 : 18.0;
    
    final horizontalMargin = screenWidth < 360 ? 4.0 :
                            screenWidth < 600 ? 6.0 :
                            screenWidth < 1024 ? 8.0 : 10.0;
    
    final color = isActive ? _navigationItems[index].color : themeProvider.currentTheme.iconTheme.color?.withValues(alpha: 0.6) ?? Colors.grey;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: neumorphic.NeumorphicContainer(
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
        padding: EdgeInsets.symmetric(vertical: containerPadding),
        borderRadius: BorderRadius.circular(12),
        isInset: isActive,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? _navigationItems[index].activeIcon : icon,
              color: color,
              size: iconSize,
            ),
            SizedBox(height: screenWidth < 360 ? 2 : 4),
            // إخفاء النص في الشاشات الصغيرة جداً إلا للعنصر النشط
            if (screenWidth >= 360 || isActive)
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeumorphicNavItem(int index, IconData icon, String label, ThemeProvider themeProvider) {
    final isActive = _currentIndex == index;
    final color = isActive ? _navigationItems[index].color : themeProvider.currentTheme.iconTheme.color?.withValues(alpha: 0.6) ?? Colors.grey;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: neumorphic.NeumorphicContainer(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          padding: const EdgeInsets.symmetric(vertical: 8),
          borderRadius: BorderRadius.circular(12),
          isInset: isActive,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? _navigationItems[index].activeIcon : icon, 
                color: color, 
                size: 24
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNeumorphicFAB(ThemeProvider themeProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // تحديد حجم الزر بناءً على حجم الشاشة
    final fabSize = screenWidth < 360 ? 40.0 :
                   screenWidth < 600 ? 48.0 :
                   screenWidth < 1024 ? 52.0 : 56.0;
    
    final paddingSize = screenWidth < 360 ? 6.0 :
                       screenWidth < 600 ? 8.0 :
                       screenWidth < 1024 ? 10.0 : 12.0;
    
    return Container(
      padding: EdgeInsets.all(paddingSize),
      child: Center(
        child: Consumer<MediaProvider>(
          builder: (context, mediaProvider, child) {
            return ScaleTransition(
              scale: _fabAnimation,
              child: neumorphic.NeumorphicButton(
                icon: mediaProvider.isScanning
                    ? Icons.refresh
                    : mediaProvider.currentMediaFile != null
                        ? Icons.play_arrow_rounded
                        : Icons.add_rounded,
                onTap: () {
                  if (mediaProvider.currentMediaFile != null) {
                    // Navigate to current playing media
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoPlayerScreen(),
                      ),
                    );
                  } else {
                    // Show scan dialog or explore device
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExploreDeviceScreen(),
                      ),
                    );
                  }
                },
                size: fabSize,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNeumorphicFAB(ThemeProvider themeProvider) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        return ScaleTransition(
          scale: _fabAnimation,
          child: neumorphic.NeumorphicButton(
            icon: mediaProvider.isScanning
                ? Icons.refresh
                : mediaProvider.currentMediaFile != null
                    ? Icons.play_arrow_rounded
                    : Icons.add_rounded,
            onTap: () {
              if (mediaProvider.currentMediaFile != null) {
                // Navigate to current playing media
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoPlayerScreen(),
                  ),
                );
              } else {
                // Show scan dialog or explore device
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExploreDeviceScreen(),
                  ),
                );
              }
            },
            size: 56,
          ),
        );
      },
    );
  }

  Widget _buildCenterFAB(ThemeProvider themeProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive FAB sizing
    final isVerySmallScreen = screenWidth < 360;
    final isSmallScreen = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    
    final fabSize = isVerySmallScreen ? 40.0 :
                   isSmallScreen ? 48.0 :
                   isTablet ? 52.0 : 56.0;
    
    final fabBorderRadius = fabSize / 2;
    
    final fabDepth = isVerySmallScreen ? 12.0 :
                    isSmallScreen ? 16.0 :
                    isTablet ? 18.0 : 20.0;
    
    
    return Container(
      width: fabSize,
      height: fabSize,
      child: Consumer<MediaProvider>(
        builder: (context, mediaProvider, child) {
          return ScaleTransition(
            scale: _fabAnimation,
            child: neumorphic.NeumorphicButton(
              icon: mediaProvider.isScanning
                  ? Icons.refresh
                  : mediaProvider.currentMediaFile != null
                      ? Icons.play_arrow_rounded
                      : Icons.add_rounded,
              onTap: () {
                if (mediaProvider.currentMediaFile != null) {
                  // Navigate to current playing media
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VideoPlayerScreen(),
                    ),
                  );
                } else {
                  // Show scan dialog or explore device
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExploreDeviceScreen(),
                    ),
                  );
                }
              },
              size: fabSize,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCenterPlayButton(ThemeProvider themeProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // تحديد حجم الزر بناءً على حجم الشاشة
    final fabSize = screenWidth < 360 ? 40.0 :
                   screenWidth < 600 ? 48.0 :
                   screenWidth < 1024 ? 52.0 : 56.0;
    
    final paddingSize = screenWidth < 360 ? 6.0 :
                       screenWidth < 600 ? 8.0 :
                       screenWidth < 1024 ? 10.0 : 12.0;
    
    return Container(
      padding: EdgeInsets.all(paddingSize),
      child: Center(
        child: Consumer<MediaProvider>(
          builder: (context, mediaProvider, child) {
            final currentMedia = mediaProvider.currentMediaFile;
            final isPlaying = currentMedia != null;
            
            return ScaleTransition(
              scale: _fabAnimation,
              child: neumorphic.NeumorphicButton(
                icon: Icons.play_arrow_rounded,
                onTap: () {
                  if (isPlaying) {
                    // Navigate to video player for media
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoPlayerScreen(),
                      ),
                    );
                  } else {
                    // Navigate to library screen to choose media
                    _onItemTapped(1); // Go to library
                  }
                },
                size: fabSize,
              ),
            );
          },
        ),
      ),
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
