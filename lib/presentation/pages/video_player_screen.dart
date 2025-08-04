import 'package:flutter/material.dart';

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
  bool _showBottomSheet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullscreen
          ? null
          : AppBar(
              title: const Text('مشغل الفيديو'),
              centerTitle: true,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: () {
                    _showFilePicker();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    _showVideoSettings();
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
                            'لم يتم تحديد فيديو',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اضغط على أيقونة المجلد لاختيار فيديو',
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
              child: _buildBottomControls(),
            ),
        ],
      ),
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

  Widget _buildBottomControls() {
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
          const ListTile(
            leading: Icon(Icons.video_file),
            title: Text('اسم الفيديو'),
            subtitle: Text('لم يتم تحديد فيديو'),
            trailing: Icon(Icons.info_outline),
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _showFilePicker,
                icon: const Icon(Icons.folder_open),
                label: const Text('اختيار فيديو'),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.playlist_add),
                label: const Text('إضافة لقائمة'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختيار مصدر الفيديو',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('من الملفات'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('من الكاميرا'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('من رابط'),
              onTap: () {
                Navigator.pop(context);
                _showUrlDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUrlDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إدخال رابط الفيديو'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'أدخل رابط الفيديو هنا...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
              );
            },
            child: const Text('تحميل'),
          ),
        ],
      ),
    );
  }

  void _showVideoSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildVideoSettingsSheet(),
    );
  }

  Widget _buildVideoSettingsSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.settings, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'إعدادات الفيديو',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Playback Settings
                  _buildSettingsSection(
                    'إعدادات التشغيل',
                    [
                      _buildSettingTile(
                        'سرعة التشغيل',
                        '1.0x',
                        Icons.speed,
                        () => _showSpeedDialog(),
                      ),
                      _buildSettingTile(
                        'جودة الفيديو',
                        'تلقائي',
                        Icons.high_quality,
                        () => _showQualityDialog(),
                      ),
                      _buildSettingTile(
                        'التشغيل التلقائي',
                        _isPlaying ? 'مفعل' : 'معطل',
                        Icons.play_circle_outline,
                        () => _toggleAutoPlay(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Audio Settings
                  _buildSettingsSection(
                    'إعدادات الصوت',
                    [
                      _buildSliderTile(
                        'مستوى الصوت',
                        _volume,
                        Icons.volume_up,
                        (value) => _updateVolume(value),
                      ),
                      _buildSettingTile(
                        'معادل الصوت',
                        'عادي',
                        Icons.equalizer,
                        () => _showEqualizer(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Display Settings
                  _buildSettingsSection(
                    'إعدادات العرض',
                    [
                      _buildSettingTile(
                        'الوضع الكامل',
                        _isFullscreen ? 'مفعل' : 'معطل',
                        Icons.fullscreen,
                        () => _toggleFullscreen(),
                      ),
                      _buildSettingTile(
                        'السطوع',
                        'متوسط',
                        Icons.brightness_6,
                        () => _showBrightnessDialog(),
                      ),
                      _buildSettingTile(
                        'التباين',
                        'عادي',
                        Icons.contrast,
                        () => _showContrastDialog(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Advanced Settings
                  _buildSettingsSection(
                    'إعدادات متقدمة',
                    [
                      _buildSettingTile(
                        'التخزين المؤقت',
                        '1GB',
                        Icons.storage,
                        () => _showCacheSettings(),
                      ),
                      _buildSettingTile(
                        'تنسيق الفيديو',
                        'MP4',
                        Icons.video_file,
                        () => _showFormatSettings(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(String title, String value, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSliderTile(String title, double value, IconData icon, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 12),
              Text(title),
              const Spacer(),
              Text('${(value * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سرعة التشغيل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSpeedOption('0.5x'),
            _buildSpeedOption('0.75x'),
            _buildSpeedOption('1.0x', isSelected: true),
            _buildSpeedOption('1.25x'),
            _buildSpeedOption('1.5x'),
            _buildSpeedOption('2.0x'),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedOption(String speed, {bool isSelected = false}) {
    return ListTile(
      title: Text(speed),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        Navigator.pop(context);
        // Apply speed
      },
    );
  }

  void _showQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('جودة الفيديو'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQualityOption('تلقائي', isSelected: true),
            _buildQualityOption('1080p'),
            _buildQualityOption('720p'),
            _buildQualityOption('480p'),
            _buildQualityOption('360p'),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityOption(String quality, {bool isSelected = false}) {
    return ListTile(
      title: Text(quality),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        Navigator.pop(context);
        // Apply quality
      },
    );
  }

  void _toggleAutoPlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _updateVolume(double value) {
    setState(() {
      _volume = value;
    });
  }

  void _showEqualizer() {
    // Show equalizer
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
    });
    Navigator.pop(context);
  }

  void _showBrightnessDialog() {
    // Show brightness dialog
  }

  void _showContrastDialog() {
    // Show contrast dialog
  }

  void _showCacheSettings() {
    // Show cache settings
  }

  void _showFormatSettings() {
    // Show format settings
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
