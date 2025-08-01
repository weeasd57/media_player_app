import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:file_picker/file_picker.dart';
import '../../generated/app_localizations.dart';
import 'package:provider/provider.dart'; // Added for ThemeProvider
import '../providers/theme_provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  String? _currentSongPath;
  String? _currentSongName;
  String? _artistName;
  String? _albumName;
  bool _isLoading = false;
  bool _isShuffleOn = false;
  int _repeatMode = 0; // 0 = off, 1 = one, 2 = all

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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

        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(AppLocalizations.of(context)!.scanError(e.toString()));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // Access ThemeProvider

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle), centerTitle: true),
      backgroundColor:
          themeProvider.primaryBackgroundColor, // Use themeProvider
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeProvider.currentTheme.colorScheme.primary.withValues(alpha: 0.1),
              themeProvider.currentTheme.colorScheme.primary.withValues(alpha: 0.2),
            ], // Use themeProvider
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // منطقة عرض الملف الحالي
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: themeProvider.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.shadowColor,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
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
                        _currentSongName ?? l10n.noMediaFound,
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

                          String statusText = l10n.ready;
                          if (processingState == ProcessingState.loading) {
                            statusText = l10n.loadingLibrary;
                          } else if (processingState ==
                              ProcessingState.buffering) {
                            statusText = l10n.buffering;
                          } else if (playerState?.playing == true) {
                            statusText = l10n.playing;
                          } else if (processingState ==
                              ProcessingState.completed) {
                            statusText = l10n.done;
                          } else {
                            statusText = l10n.paused;
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
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
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

                      // منطقة دعم التحكم عبر الكورة
                      GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.velocity.pixelsPerSecond.dx > 0) {
                            // Swipe right ➜ Previous
                          } else if (details.velocity.pixelsPerSecond.dx < 0) {
                            // Swipe left ➜ Next
                          }
                        },
                        child: Row(
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

                            // زر الترجيع
                            IconButton(
                              onPressed: () {
                                final currentPosition = _audioPlayer.position;
                                final newPosition =
                                    currentPosition -
                                    const Duration(seconds: 10);
                                _audioPlayer.seek(
                                  newPosition < Duration.zero
                                      ? Duration.zero
                                      : newPosition,
                                );
                              },
                              icon: const Icon(Icons.replay_10),
                              iconSize: 30,
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

                            // زر التقديم
                            IconButton(
                              onPressed: () {
                                final currentPosition = _audioPlayer.position;
                                final duration =
                                    _audioPlayer.duration ?? Duration.zero;
                                final newPosition =
                                    currentPosition +
                                    const Duration(seconds: 10);
                                _audioPlayer.seek(
                                  newPosition > duration
                                      ? duration
                                      : newPosition,
                                );
                              },
                              icon: const Icon(Icons.forward_10),
                              iconSize: 30,
                              color: themeProvider
                                  .currentTheme
                                  .colorScheme
                                  .primary,
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
                    _isLoading ? l10n.loadingLibrary : l10n.selectAudioFile,
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
  }
}
