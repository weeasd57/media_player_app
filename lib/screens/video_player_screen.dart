import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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
        await _initializeVideo(result.files.single.path!, result.files.single.name);
      }
    } catch (e) {
      _showErrorDialog('خطأ في تحميل الملف: $e');
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

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: false,
      looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.orange,
        handleColor: Colors.orange,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.orange.withValues(alpha: 0.3),
      ),
      placeholder: Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      ),
      autoInitialize: true,
    );

    setState(() {});
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشغل الفيديو'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.orange.shade100,
            ],
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
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade300,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _chewieController != null && 
                           _chewieController!.videoPlayerController.value.isInitialized
                        ? Chewie(controller: _chewieController!)
                        : _buildPlaceholder(),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
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
                            color: Colors.orange.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'الفيديو الحالي:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        _currentVideoName!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
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
                              color: Colors.orange.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'المدة: ${_formatDuration(_videoPlayerController!.value.duration)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            
                            const SizedBox(width: 20),
                            
                            Icon(
                              Icons.aspect_ratio,
                              color: Colors.orange.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'الأبعاد: ${_videoPlayerController!.value.size.width.toInt()}x${_videoPlayerController!.value.size.height.toInt()}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
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
                  label: Text(_isLoading ? 'جاري التحميل...' : 'اختيار ملف فيديو'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
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

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange.shade600.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.video_library,
              size: 40,
              color: Colors.orange.shade600,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            'لم يتم اختيار فيديو',
            style: TextStyle(
              fontSize: 18,
              color: Colors.orange.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'اضغط على الزر أدناه لاختيار ملف فيديو',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

