import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart'; // Corrected path

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isPlaying = false;
  final bool _showControls = true;
  double _currentPosition = 0.0;
  double _volume = 0.7;
  bool _isFullscreen = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: _isFullscreen
              ? null
              : AppBar(
                  title: Text(
                    localeProvider.getLocalizedText(
                      'مشغل الفيديو',
                      'Video Player',
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.folder_open),
                      onPressed: () {
                        _showFilePicker(localeProvider);
                      },
                    ),
                  ],
                ),
          body: Stack(
            children: [
              // Video Player Area
              Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: _isFullscreen
                          ? BorderRadius.zero
                          : BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Video placeholder
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.video_library,
                                size: 80,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                localeProvider.getLocalizedText(
                                  'لم يتم تحديد فيديو',
                                  'No video selected',
                                ),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                localeProvider.getLocalizedText(
                                  'اضغط على أيقونة المجلد لاختيار فيديو',
                                  'Tap folder icon to select a video',
                                ),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Controls overlay
                        if (_showControls) _buildControlsOverlay(),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom controls (when not fullscreen)
              if (!_isFullscreen)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomControls(localeProvider),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withAlpha((0.7 * 255).round()),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withAlpha((0.7 * 255).round()),
          ],
        ),
        borderRadius: _isFullscreen
            ? BorderRadius.zero
            : BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Play/Pause button in center
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withAlpha((0.6 * 255).round()),
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Top controls
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFullscreen = !_isFullscreen;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Progress bar at bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      _formatDuration(
                        Duration(seconds: (_currentPosition * 3600).round()),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Expanded(
                      child: Slider(
                        value: _currentPosition,
                        onChanged: (value) {
                          setState(() {
                            _currentPosition = value;
                          });
                        },
                        activeColor: Colors.red,
                        inactiveColor: Colors.white.withAlpha(
                          (0.3 * 255).round(),
                        ),
                      ),
                    ),
                    const Text(
                      '1:00:00',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay_10, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(LocaleProvider localeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Volume control
          Row(
            children: [
              const Icon(Icons.volume_up),
              Expanded(
                child: Slider(
                  value: _volume,
                  onChanged: (value) {
                    setState(() {
                      _volume = value;
                    });
                  },
                ),
              ),
              Text('${(_volume * 100).round()}%'),
            ],
          ),

          const SizedBox(height: 16),

          // Video info
          ListTile(
            leading: const Icon(Icons.video_file),
            title: Text(
              localeProvider.getLocalizedText('اسم الفيديو', 'Video Title'),
            ),
            subtitle: Text(
              localeProvider.getLocalizedText(
                'لم يتم تحديد فيديو',
                'No video selected',
              ),
            ),
            trailing: const Icon(Icons.info_outline),
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showFilePicker(localeProvider),
                icon: const Icon(Icons.folder_open),
                label: Text(
                  localeProvider.getLocalizedText(
                    'اختيار فيديو',
                    'Choose Video',
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.playlist_add),
                label: Text(
                  localeProvider.getLocalizedText(
                    'إضافة لقائمة',
                    'Add to Playlist',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilePicker(LocaleProvider localeProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localeProvider.getLocalizedText(
                  'اختيار مصدر الفيديو',
                  'Choose Video Source',
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.folder),
                title: Text(
                  localeProvider.getLocalizedText('من الملفات', 'From Files'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localeProvider.getLocalizedText(
                          'سيتم إضافة هذه الميزة قريباً',
                          'This feature will be added soon',
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: Text(
                  localeProvider.getLocalizedText('من الكاميرا', 'From Camera'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localeProvider.getLocalizedText(
                          'سيتم إضافة هذه الميزة قريباً',
                          'This feature will be added soon',
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: Text(
                  localeProvider.getLocalizedText('من رابط', 'From URL'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showUrlDialog(localeProvider);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUrlDialog(LocaleProvider localeProvider) {
    showDialog(
      context: context,
      builder: (context) => Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) => AlertDialog(
          title: Text(
            localeProvider.getLocalizedText(
              'إدخال رابط الفيديو',
              'Enter Video URL',
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              hintText: localeProvider.getLocalizedText(
                'أدخل رابط الفيديو هنا...',
                'Enter video URL here...',
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localeProvider.getLocalizedText('إلغاء', 'Cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      localeProvider.getLocalizedText(
                        'سيتم إضافة هذه الميزة قريباً',
                        'This feature will be added soon',
                      ),
                    ),
                  ),
                );
              },
              child: Text(localeProvider.getLocalizedText('تحميل', 'Download')),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    }
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
