import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isPlaying = false;
  bool _showControls = true;
  double _currentPosition = 0.0;
  double _volume = 0.7;
  bool _isFullscreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullscreen ? null : AppBar(
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
                    if (_showControls)
                      _buildControlsOverlay(),
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
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
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
                  color: Colors.black.withValues(alpha: 0.6),
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
                      _formatDuration(Duration(seconds: (_currentPosition * 3600).round())),
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
                        inactiveColor: Colors.white.withValues(alpha: 0.3),
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
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
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
                  const SnackBar(
                    content: Text('سيتم إضافة هذه الميزة قريباً'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('من الكاميرا'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('سيتم إضافة هذه الميزة قريباً'),
                  ),
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
                const SnackBar(
                  content: Text('سيتم إضافة هذه الميزة قريباً'),
                ),
              );
            },
            child: const Text('تحميل'),
          ),
        ],
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
