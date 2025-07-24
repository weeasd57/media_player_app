import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:file_picker/file_picker.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  String? _currentSongPath;
  String? _currentSongName;
  bool _isLoading = false;

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
        
        await _audioPlayer.setFilePath(_currentSongPath!);
        
        setState(() {});
      }
    } catch (e) {
      _showErrorDialog('خطأ في تحميل الملف: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشغل الصوت'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.purple.shade100,
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
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.shade200,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // أيقونة الموسيقى
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          Icons.music_note,
                          size: 60,
                          color: Colors.purple.shade600,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // اسم الملف
                      Text(
                        _currentSongName ?? 'لم يتم اختيار ملف',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // حالة التشغيل
                      StreamBuilder<PlayerState>(
                        stream: _audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          
                          String statusText = 'جاهز';
                          if (processingState == ProcessingState.loading) {
                            statusText = 'جاري التحميل...';
                          } else if (processingState == ProcessingState.buffering) {
                            statusText = 'جاري التخزين المؤقت...';
                          } else if (playerState?.playing == true) {
                            statusText = 'قيد التشغيل';
                          } else if (processingState == ProcessingState.completed) {
                            statusText = 'انتهى التشغيل';
                          } else {
                            statusText = 'متوقف';
                          }
                          
                          return Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.purple.shade600,
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
                          final duration = _audioPlayer.duration ?? Duration.zero;
                          
                          return Column(
                            children: [
                              ProgressBar(
                                progress: position,
                                total: duration,
                                onSeek: (duration) {
                                  _audioPlayer.seek(duration);
                                },
                                barHeight: 4,
                                baseBarColor: Colors.grey.shade300,
                                progressBarColor: Colors.purple.shade600,
                                thumbColor: Colors.purple.shade600,
                                timeLabelTextStyle: TextStyle(
                                  color: Colors.purple.shade600,
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
                          // زر الترجيع
                          IconButton(
                            onPressed: () {
                              final currentPosition = _audioPlayer.position;
                              final newPosition = currentPosition - const Duration(seconds: 10);
                              _audioPlayer.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
                            },
                            icon: const Icon(Icons.replay_10),
                            iconSize: 30,
                            color: Colors.purple.shade600,
                          ),
                          
                          // زر التشغيل/الإيقاف
                          StreamBuilder<PlayerState>(
                            stream: _audioPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              final playerState = snapshot.data;
                              final processingState = playerState?.processingState;
                              final playing = playerState?.playing;
                              
                              if (processingState == ProcessingState.loading ||
                                  processingState == ProcessingState.buffering) {
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 50,
                                  height: 50,
                                  child: const CircularProgressIndicator(),
                                );
                              } else if (playing != true) {
                                return IconButton(
                                  onPressed: _currentSongPath != null ? _audioPlayer.play : null,
                                  icon: const Icon(Icons.play_arrow),
                                  iconSize: 50,
                                  color: Colors.purple.shade600,
                                );
                              } else {
                                return IconButton(
                                  onPressed: _audioPlayer.pause,
                                  icon: const Icon(Icons.pause),
                                  iconSize: 50,
                                  color: Colors.purple.shade600,
                                );
                              }
                            },
                          ),
                          
                          // زر التقديم
                          IconButton(
                            onPressed: () {
                              final currentPosition = _audioPlayer.position;
                              final duration = _audioPlayer.duration ?? Duration.zero;
                              final newPosition = currentPosition + const Duration(seconds: 10);
                              _audioPlayer.seek(newPosition > duration ? duration : newPosition);
                            },
                            icon: const Icon(Icons.forward_10),
                            iconSize: 30,
                            color: Colors.purple.shade600,
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
                  label: Text(_isLoading ? 'جاري التحميل...' : 'اختيار ملف صوتي'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
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
}

