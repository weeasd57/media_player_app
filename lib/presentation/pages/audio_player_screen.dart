import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../../generated/app_localizations.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../../widgets/neumorphic_components.dart' as neumorphic;
import 'explore_device_screen.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _albumAnimationController;
  late AnimationController _controlsAnimationController;
  late Animation<double> _albumAnimation;
  late Animation<double> _controlsAnimation;
  
  String? _currentSongPath;
  String? _currentSongName;
  String? _artistName;
  String? _albumName;
  bool _isLoading = false;
  bool _isShuffleOn = false;
  bool _isFavorite = false;
  int _repeatMode = 0; // 0 = off, 1 = one, 2 = all
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _albumAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _albumAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _albumAnimationController, curve: Curves.elasticOut),
    );
    _controlsAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controlsAnimationController, curve: Curves.easeInOut),
    );
    
    _loadFavorites();
    _albumAnimationController.forward();
    _controlsAnimationController.forward();
    
    // Automatically open file picker if no file is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentSongPath == null) {
        _pickAudioFile();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _albumAnimationController.dispose();
    _controlsAnimationController.dispose();
    super.dispose();
  }
  
  // دالة تحميل المفضلة
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('audio_favorites') ?? [];
    setState(() {
      _favorites = favoritesJson;
      _checkIfCurrentSongIsFavorite();
    });
  }
  
  // دالة حفظ المفضلة
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('audio_favorites', _favorites);
  }
  
  // دالة التحقق إذا كانت الأغنية الحالية في المفضلة
  void _checkIfCurrentSongIsFavorite() {
    if (_currentSongPath != null) {
      _isFavorite = _favorites.contains(_currentSongPath!);
    }
  }
  
  // دالة إضافة/إزالة من المفضلة
  Future<void> _toggleFavorite() async {
    if (_currentSongPath == null) return;
    
    setState(() {
      if (_isFavorite) {
        _favorites.remove(_currentSongPath!);
        _isFavorite = false;
      } else {
        _favorites.add(_currentSongPath!);
        _isFavorite = true;
      }
    });
    
    await _saveFavorites();
    
    // إظهار رسالة تأكيد
    if (mounted) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite 
                ? localizations.addedToFavorites
                : localizations.removedFromFavorites,
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _pickAudioFile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        _currentSongPath = result.files.single.path!;
        _currentSongName = result.files.single.name;
        // Simulated metadata
        _artistName = 'Unknown Artist';
        _albumName = 'Unknown Album';

        await _audioPlayer.setFilePath(_currentSongPath!);
        _checkIfCurrentSongIsFavorite();

        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;
      final localizations = AppLocalizations.of(context)!;
      _showErrorDialog(localizations.error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.ok),
          ),
        ],
      ),
    );
  }

  // نافذة البحث
  void _showSearchDialog(BuildContext context, ThemeProvider themeProvider) {
    final localizations = AppLocalizations.of(context)!;
    final TextEditingController searchController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.primaryBackgroundColor,
        title: Text(
          localizations.search,
          style: TextStyle(color: themeProvider.primaryTextColor),
        ),
        content: TextField(
          controller: searchController,
          style: TextStyle(color: themeProvider.primaryTextColor),
          decoration: InputDecoration(
            hintText: localizations.searchHint,
            hintStyle: TextStyle(color: themeProvider.secondaryTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: themeProvider.iconColor,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.cancel,
              style: TextStyle(color: themeProvider.secondaryTextColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ البحث هنا
              _performSearch(searchController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.currentTheme.colorScheme.primary,
              foregroundColor: themeProvider.currentTheme.colorScheme.onPrimary,
            ),
            child: Text(localizations.search),
          ),
        ],
      ),
    );
  }

  // تنفيذ البحث
  void _performSearch(String query) {
    // هنا يمكن إضافة منطق البحث في المكتبة
    if (query.isNotEmpty) {
      // مؤقتاً سنفتح منتقي الملفات
      _pickAudioFile();
    }
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // If no song is selected, show loading or go back
        if (_currentSongPath == null && !_isLoading) {
          // Go back to previous screen if no file was selected
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
          return Scaffold(
            backgroundColor: themeProvider.primaryBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: themeProvider.currentTheme.colorScheme.primary,
              ),
            ),
          );
        }
        
        return Scaffold(
            appBar: AppBar(
              title: Text(localizations.nowPlaying),
              centerTitle: true,
              backgroundColor: themeProvider.primaryBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                // زر البحث
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: themeProvider.currentTheme.colorScheme.primary,
                  ),
                  onPressed: () {
                    _showSearchDialog(context, themeProvider);
                  },
                  tooltip: localizations.search,
                ),
                // زر المفضلة
                if (_currentSongPath != null)
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : themeProvider.currentTheme.colorScheme.primary,
                    ),
                    onPressed: _toggleFavorite,
                    tooltip: _isFavorite ? localizations.removeFromFavorites : localizations.addToFavorites,
                  ),
                // زر استكشاف مجلد الجهاز
                IconButton(
                  icon: Icon(
                    Icons.folder_open,
                    color: themeProvider.currentTheme.colorScheme.primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExploreDeviceScreen(),
                      ),
                    );
                  },
                  tooltip: localizations.exploreDevice,
                ),
              ],
            ),
          backgroundColor: themeProvider.primaryBackgroundColor,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeProvider.currentTheme.colorScheme.primary.withValues(alpha: 0.1),
                  themeProvider.currentTheme.colorScheme.primary.withValues(alpha: 0.2),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // منطقة عرض الملف الحالي
                  Expanded(
                    flex: 2,
                    child: neumorphic.NeumorphicCard(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // صورة الألبوم
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: themeProvider.currentTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Icon(
                              Icons.music_note,
                              size: 60,
                              color: themeProvider.currentTheme.colorScheme.primary,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // اسم الأغنية
                          Text(
                            _currentSongName ?? localizations.noFilesFound,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.primaryTextColor,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // اسم الفنان
                          if (_artistName != null)
                            Text(
                              _artistName!,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeProvider.secondaryTextColor,
                              ),
                              textAlign: TextAlign.center,
                            ),

                          // اسم الألبوم
                          if (_albumName != null)
                            Text(
                              _albumName!,
                              style: TextStyle(
                                fontSize: 12,
                                color: themeProvider.secondaryTextColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),

                          const SizedBox(height: 10),

                          // حالة التشغيل
                          StreamBuilder<PlayerState>(
                            stream: _audioPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              final playerState = snapshot.data;
                              final processingState = playerState?.processingState;

                              String statusText = localizations.ready;
                              if (processingState == ProcessingState.loading) {
                                statusText = localizations.loadingLibrary;
                              } else if (processingState ==
                                  ProcessingState.buffering) {
                                statusText = localizations.buffering;
                              } else if (playerState?.playing == true) {
                                statusText = localizations.playing;
                              } else if (processingState ==
                                  ProcessingState.completed) {
                                statusText = localizations.success;
                              } else {
                                statusText = localizations.paused;
                              }

                              return Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeProvider
                                      .currentTheme
                                      .colorScheme
                                      .primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // شريط التقدم والتحكم
                  Expanded(
                    flex: 1,
                    child: neumorphic.NeumorphicCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // شريط التقدم
                          StreamBuilder<Duration>(
                            stream: _audioPlayer.positionStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data ?? Duration.zero;
                              final duration =
                                  _audioPlayer.duration ?? Duration.zero;

                              return Column(
                                children: [
                                  ProgressBar(
                                    progress: position,
                                    total: duration,
                                    onSeek: (duration) {
                                      _audioPlayer.seek(duration);
                                    },
                                    barHeight: 4,
                                    baseBarColor: themeProvider.dividerColor,
                                    progressBarColor: themeProvider
                                        .currentTheme
                                        .colorScheme
                                        .primary,
                                    thumbColor: themeProvider
                                        .currentTheme
                                        .colorScheme
                                        .primary,
                                    timeLabelTextStyle: TextStyle(
                                      color: themeProvider.primaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // أزرار التحكم
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // زر Shuffle
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isShuffleOn = !_isShuffleOn;
                                  });
                                },
                                icon: Icon(
                                  _isShuffleOn ? Icons.shuffle_on : Icons.shuffle,
                                  color: _isShuffleOn
                                      ? themeProvider
                                            .currentTheme
                                            .colorScheme
                                            .primary
                                      : themeProvider.iconColor,
                                ),
                                iconSize: 30,
                              ),

                              // زر السابق
                              IconButton(
                                onPressed: () {
                                  // سيتم تنفيذ في مستقبل بإضافة قائمة تشغيل
                                },
                                icon: const Icon(Icons.skip_previous),
                                iconSize: 40,
                                color: themeProvider
                                    .currentTheme
                                    .colorScheme
                                    .primary,
                              ),

                              // زر التشغيل/الإيقاف
                              StreamBuilder<PlayerState>(
                                stream: _audioPlayer.playerStateStream,
                                builder: (context, snapshot) {
                                  final playerState = snapshot.data;
                                  final processingState =
                                      playerState?.processingState;
                                  final playing = playerState?.playing;

                                  if (processingState ==
                                          ProcessingState.loading ||
                                      processingState ==
                                          ProcessingState.buffering) {
                                    return Container(
                                      margin: const EdgeInsets.all(8.0),
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        color: themeProvider
                                            .currentTheme
                                            .colorScheme
                                            .primary,
                                      ),
                                    );
                                  } else if (playing != true) {
                                    return IconButton(
                                      onPressed: _currentSongPath != null
                                          ? _audioPlayer.play
                                          : null,
                                      icon: const Icon(Icons.play_arrow),
                                      iconSize: 50,
                                      color: themeProvider
                                          .currentTheme
                                          .colorScheme
                                          .primary,
                                    );
                                  } else {
                                    return IconButton(
                                      onPressed: _audioPlayer.pause,
                                      icon: const Icon(Icons.pause),
                                      iconSize: 50,
                                      color: themeProvider
                                          .currentTheme
                                          .colorScheme
                                          .primary,
                                    );
                                  }
                                },
                              ),

                              // زر التالي
                              IconButton(
                                onPressed: () {
                                  // سيتم تنفيذ في مستقبل بإضافة قائمة تشغيل
                                },
                                icon: const Icon(Icons.skip_next),
                                iconSize: 40,
                                color: themeProvider
                                    .currentTheme
                                    .colorScheme
                                    .primary,
                              ),

                              // زر Repeat
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _repeatMode = (_repeatMode + 1) % 3;
                                  });
                                },
                                icon: Icon(
                                  _repeatMode == 0
                                      ? Icons.repeat
                                      : _repeatMode == 1
                                      ? Icons.repeat_one
                                      : Icons.repeat_on,
                                  color: _repeatMode > 0
                                      ? themeProvider
                                            .currentTheme
                                            .colorScheme
                                            .primary
                                      : themeProvider.iconColor,
                                ),
                                iconSize: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // زر اختيار ملف
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _pickAudioFile,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.folder_open),
                      label: Text(
                        _isLoading ? localizations.loading : localizations.search,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            themeProvider.currentTheme.colorScheme.primary,
                        foregroundColor:
                            themeProvider.currentTheme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
