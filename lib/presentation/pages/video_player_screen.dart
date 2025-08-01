import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../generated/app_localizations.dart';
import 'package:provider/provider.dart'; // Added for ThemeProvider
import '../providers/theme_provider.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  String? _currentVideoName;
  bool _isLoading = false;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideoFile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        await _initializeVideo(
          result.files.single.path!,
          result.files.single.name,
        );
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

  Future<void> _initializeVideo(String path, String name) async {
    // التخلص من المشغل السابق
    await _videoPlayerController?.dispose();
    _chewieController?.dispose();

    _currentVideoName = name;

    // إنشاء مشغل فيديو جديد
    _videoPlayerController = VideoPlayerController.file(File(path));

    await _videoPlayerController!.initialize();

    if (!mounted) return;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: false,
      looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: themeProvider.currentTheme.colorScheme.secondary,
        handleColor: themeProvider.currentTheme.colorScheme.secondary,
        backgroundColor: themeProvider.dividerColor,
        bufferedColor: themeProvider.currentTheme.colorScheme.secondary
            .withValues(alpha: 0.3),
      ),
      placeholder: Container(
        color: themeProvider.primaryBackgroundColor,
        child: Center(
          child: CircularProgressIndicator(
            color: themeProvider.currentTheme.colorScheme.secondary,
          ),
        ),
      ),
      autoInitialize: true,
    );

    setState(() {});
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
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
              themeProvider.currentTheme.colorScheme.secondary.withValues(alpha: 0.1),
              themeProvider.currentTheme.colorScheme.secondary.withValues(alpha: 0.2),
            ], // Use themeProvider
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // منطقة عرض الفيديو
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: themeProvider.primaryBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.shadowColor,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        _chewieController != null &&
                            _chewieController!
                                .videoPlayerController
                                .value
                                .isInitialized
                        ? Chewie(controller: _chewieController!)
                        : _buildPlaceholder(themeProvider),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // معلومات الفيديو
              if (_currentVideoName != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: themeProvider.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: themeProvider.shadowColor,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.video_file,
                            color: themeProvider
                                .currentTheme
                                .colorScheme
                                .secondary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.currentVideo,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.primaryTextColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        _currentVideoName!,
                        style: TextStyle(
                          fontSize: 14,
                          color: themeProvider.secondaryTextColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (_videoPlayerController != null &&
                          _videoPlayerController!.value.isInitialized) ...[
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: themeProvider
                                  .currentTheme
                                  .colorScheme
                                  .secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'المدة: ${_formatDuration(_videoPlayerController!.value.duration)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: themeProvider.secondaryTextColor,
                              ),
                            ),

                            const SizedBox(width: 20),

                            Icon(
                              Icons.aspect_ratio,
                              color: themeProvider
                                  .currentTheme
                                  .colorScheme
                                  .secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'الأبعاد: ${_videoPlayerController!.value.size.width.toInt()}x${_videoPlayerController!.value.size.height.toInt()}',
                              style: TextStyle(
                                fontSize: 12,
                                color: themeProvider.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],

              // زر اختيار ملف
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _pickVideoFile,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.video_library),
                  label: Text(
                    _isLoading ? l10n.loadingLibrary : l10n.selectVideoFile,
                  ), // Keep Arabic for file picker
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themeProvider.currentTheme.colorScheme.secondary,
                    foregroundColor:
                        themeProvider.currentTheme.colorScheme.onSecondary,
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

  Widget _buildPlaceholder(ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: themeProvider.primaryBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: themeProvider.currentTheme.colorScheme.secondary
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.video_library,
              size: 40,
              color: themeProvider.currentTheme.colorScheme.secondary,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            AppLocalizations.of(context)!.noMediaFound,
            style: TextStyle(
              fontSize: 18,
              color: themeProvider.primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            AppLocalizations.of(context)!.selectVideoFile,
            style: TextStyle(
              fontSize: 14,
              color: themeProvider.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
