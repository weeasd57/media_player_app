import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:media_player_app/data/models/media_file.dart';
import 'dart:io'; // For File
import 'package:flutter/material.dart'; // For debugPrint
import 'package:media_player_app/services/notification_service.dart'; // Added import for NotificationService

class MediaPlaybackService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  VideoPlayerController? _videoPlayerController;
  int? _currentMediaIndex;
  List<MediaFile> _currentPlaylist = [];

  AudioPlayer get audioPlayer => _audioPlayer;
  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  MediaFile? get currentMediaFile =>
      _currentPlaylist.isNotEmpty && _currentMediaIndex != null
      ? _currentPlaylist[_currentMediaIndex!]
      : null;

  MediaPlaybackService() {
    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        // Auto play next song if enabled (implement shuffle/repeat logic here)
        // For now, just stop
        if (_currentMediaIndex != null &&
            _currentMediaIndex! < _currentPlaylist.length - 1) {
          playMedia(_currentPlaylist[_currentMediaIndex! + 1]);
        } else {
          // Playlist ended, stop notification
        }
      }
    });
  }

  Future<void> playMedia(MediaFile mediaFile) async {
    if (mediaFile.type == 'audio') {
      if (_videoPlayerController != null) {
        await _videoPlayerController!.dispose();
        _videoPlayerController = null;
      }
      await _audioPlayer.setFilePath(mediaFile.path);
      await _audioPlayer.play();
    } else if (mediaFile.type == 'video') {
      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }
      _videoPlayerController = VideoPlayerController.file(File(mediaFile.path));
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.play();
    }
    // Update current media and index logic
    final index = _currentPlaylist.indexOf(mediaFile);
    if (index != -1) {
      _currentMediaIndex = index;
    } else {
      _currentPlaylist = [mediaFile];
      _currentMediaIndex = 0;
    }
    notifyListeners();

    // Show notification
    NotificationService.showNotification(
      id: 0, // A unique ID for your media notification
      title: mediaFile.name,
      body: mediaFile.type == 'audio' ? 'Now Playing' : 'Now Watching',
      payload: 'play_pause', // A default payload for the notification tap
      mediaFilePath: mediaFile.path,
    );
  }

  Future<void> pause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else if (_videoPlayerController != null &&
        _videoPlayerController!.value.isPlaying) {
      await _videoPlayerController!.pause();
    }
    notifyListeners();
  }

  Future<void> resume() async {
    if (_audioPlayer.playerState.playing == false) {
      await _audioPlayer.play();
    } else if (_videoPlayerController != null &&
        !_videoPlayerController!.value.isPlaying) {
      await _videoPlayerController!.play();
    }
    notifyListeners();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }
    _currentMediaIndex = null;
    _currentPlaylist = [];
    notifyListeners();
  }

  Future<void> next() async {
    if (_currentMediaIndex != null && _currentPlaylist.isNotEmpty) {
      if (_currentMediaIndex! < _currentPlaylist.length - 1) {
        await playMedia(_currentPlaylist[_currentMediaIndex! + 1]);
      } else {
        // End of playlist, stop or loop
        await stop();
      }
    }
  }

  Future<void> previous() async {
    if (_currentMediaIndex != null && _currentPlaylist.isNotEmpty) {
      if (_currentMediaIndex! > 0) {
        await playMedia(_currentPlaylist[_currentMediaIndex! - 1]);
      } else {
        // Start of playlist, do nothing or loop to end
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }
}
