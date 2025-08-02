import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../../generated/app_localizations.dart';
import '../../data/models/media_file.dart';

class UpNextScreen extends StatefulWidget {
  const UpNextScreen({super.key});

  @override
  State<UpNextScreen> createState() => _UpNextScreenState();
}

class _UpNextScreenState extends State<UpNextScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // Access ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.upNext),
        backgroundColor:
            themeProvider.primaryBackgroundColor, // Use themeProvider
        foregroundColor: themeProvider.primaryTextColor, // Use themeProvider
      ),
      backgroundColor:
          themeProvider.primaryBackgroundColor, // Use themeProvider
      body: Consumer<MediaProvider>(
        builder: (context, mediaProvider, child) {
          final currentPlaylist = mediaProvider.currentPlaylist;
          final currentMediaFile = mediaProvider.currentMediaFile;

          if (currentPlaylist == null || currentPlaylist.mediaFileIds.isEmpty) {
            return Center(
              child: Text(
                'No items in queue',
                style: TextStyle(color: themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ), // Use themeProvider
            );
          }

          // Filter out files that are not actually in the media library
          final mediaFiles = currentPlaylist.mediaFileIds
              .map((id) => mediaProvider.getMediaFileById(id))
              .where((file) => file != null)
              .cast<MediaFile>()
              .toList();

          if (mediaFiles.isEmpty) {
            return Center(
              child: Text(
                localizations.noMediaFound,
                style: TextStyle(color: themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ), // Use themeProvider
            );
          }

          return ReorderableListView.builder(
            itemCount: mediaFiles.length,
            itemBuilder: (context, index) {
              final file = mediaFiles[index];
              final isPlaying = file == currentMediaFile;
              return Card(
                key: ValueKey(file.id),
                color: isPlaying
                    ? themeProvider.currentTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                    : themeProvider.currentTheme.cardColor, // Use themeProvider
                child: ListTile(
                  leading: Icon(
                    file.type == 'audio' ? Icons.music_note : Icons.movie,
                    color: isPlaying
                        ? themeProvider.currentTheme.colorScheme.primary
                        : themeProvider.currentTheme.iconTheme.color, // Use themeProvider
                  ),
                  title: Text(
                    file.name,
                    style: TextStyle(
                      color: isPlaying
                          ? themeProvider.currentTheme.colorScheme.primary
                          : themeProvider.currentTheme.colorScheme.onSurface,
                    ), // Use themeProvider
                  ),
                  subtitle: Text(
                    file.formattedDuration,
                    style: TextStyle(
                      color: isPlaying
                          ? themeProvider.currentTheme.colorScheme.primary
                                .withValues(alpha: 0.7)
                          : themeProvider.currentTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ), // Use themeProvider
                  ),
                  onTap: () {
                    mediaProvider.setCurrentMediaFile(file);
                  },
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              mediaProvider.reorderPlaylist(
                currentPlaylist,
                oldIndex,
                newIndex,
              );
            },
          );
        },
      ),
    );
  }
}
