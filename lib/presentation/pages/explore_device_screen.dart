import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../../generated/app_localizations.dart';
import '../../data/models/media_file.dart';
import 'audio_player_screen.dart';
import 'video_player_screen.dart';

class ExploreDeviceScreen extends StatefulWidget {
  const ExploreDeviceScreen({super.key});

  @override
  State<ExploreDeviceScreen> createState() => _ExploreDeviceScreenState();
}

class _ExploreDeviceScreenState extends State<ExploreDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer2<MediaProvider, ThemeProvider>(
      builder: (context, mediaProvider, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryBackgroundColor,
          appBar: AppBar(
            title: Text(
              localizations.exploreDevice,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: themeProvider.primaryBackgroundColor,
            foregroundColor: themeProvider.primaryTextColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _refreshFiles(mediaProvider),
                tooltip: localizations.refresh,
              ),
            ],
          ),
          body: _buildBody(mediaProvider, themeProvider, localizations),
        );
      },
    );
  }

  Widget _buildBody(
    MediaProvider mediaProvider,
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    if (mediaProvider.isScanning) {
      return _buildLoadingState(themeProvider, localizations);
    }

    final allFiles = [...mediaProvider.audioFiles, ...mediaProvider.videoFiles];
    
    if (allFiles.isEmpty) {
      return _buildEmptyState(themeProvider, localizations);
    }

    return _buildFilesList(allFiles, mediaProvider, themeProvider, localizations);
  }

  Widget _buildLoadingState(
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            localizations.scanningFiles,
            style: TextStyle(
              color: themeProvider.primaryTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: themeProvider.iconColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            localizations.noFilesFound,
            style: TextStyle(
              color: themeProvider.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.scanFiles,
            style: TextStyle(
              color: themeProvider.secondaryTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _refreshFiles(Provider.of<MediaProvider>(context, listen: false)),
            icon: const Icon(Icons.refresh),
            label: Text(localizations.scanFiles),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeProvider.currentTheme.colorScheme.primary,
              foregroundColor: themeProvider.currentTheme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilesList(
    List<MediaFile> files,
    MediaProvider mediaProvider,
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return _buildFileCard(file, mediaProvider, themeProvider, localizations);
      },
    );
  }

  Widget _buildFileCard(
    MediaFile file,
    MediaProvider mediaProvider,
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    final isFavorite = mediaProvider.favoriteFiles.contains(file);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      color: themeProvider.cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: file.type == 'audio' 
                ? Colors.purple.withValues(alpha: 0.2)
                : Colors.orange.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            file.type == 'audio' ? Icons.music_note : Icons.video_file,
            color: file.type == 'audio' ? Colors.purple : Colors.orange,
          ),
        ),
        title: Text(
          file.name,
          style: TextStyle(
            color: themeProvider.primaryTextColor,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              file.formattedDuration,
              style: TextStyle(
                color: themeProvider.secondaryTextColor,
                fontSize: 12,
              ),
            ),
            Text(
              file.path,
              style: TextStyle(
                color: themeProvider.secondaryTextColor.withValues(alpha: 0.7),
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : themeProvider.iconColor,
              ),
              onPressed: () => _toggleFavorite(file, mediaProvider, localizations),
            ),
            IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: themeProvider.iconColor,
              ),
              onPressed: () => _playFile(file, mediaProvider),
            ),
          ],
        ),
        onTap: () => _playFile(file, mediaProvider),
      ),
    );
  }

  void _refreshFiles(MediaProvider mediaProvider) async {
    await mediaProvider.scanForMediaFiles();
  }

  void _toggleFavorite(
    MediaFile file,
    MediaProvider mediaProvider,
    AppLocalizations localizations,
  ) async {
    await mediaProvider.toggleFavorite(file);
    
    final isFavorite = mediaProvider.favoriteFiles.contains(file);
    final message = isFavorite 
        ? localizations.addedToFavorites
        : localizations.removedFromFavorites;
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isFavorite ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _playFile(MediaFile file, MediaProvider mediaProvider) {
    mediaProvider.setCurrentMediaFile(file);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => file.type == 'audio'
            ? const AudioPlayerScreen()
            : const VideoPlayerScreen(),
      ),
    );
  }
}

