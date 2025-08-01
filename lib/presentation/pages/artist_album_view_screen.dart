import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/text_provider.dart';
import '../../data/models/media_file.dart';

class ArtistAlbumViewScreen extends StatelessWidget {
  const ArtistAlbumViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<MediaProvider, ThemeProvider, TextProvider>(
      builder: (context, mediaProvider, themeProvider, textProvider, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                textProvider.getText('artistAlbum'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Artists'),
                  Tab(text: 'Albums'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildArtistsTab(mediaProvider, themeProvider, textProvider),
                _buildAlbumsTab(mediaProvider, themeProvider, textProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtistsTab(MediaProvider mediaProvider, ThemeProvider themeProvider, TextProvider textProvider) {
    final artistGroups = mediaProvider.getGroupedMediaFilesByArtist();

    return ListView.builder(
      itemCount: artistGroups.keys.length,
      itemBuilder: (context, index) {
        final artist = artistGroups.keys.elementAt(index);
        final files = artistGroups[artist]!;

        return ExpansionTile(
          title: Text(artist),
          children: files.map((file) => _buildMediaItem(file)).toList(),
        );
      },
    );
  }

  Widget _buildAlbumsTab(MediaProvider mediaProvider, ThemeProvider themeProvider, TextProvider textProvider) {
    final albumGroups = mediaProvider.getGroupedMediaFilesByAlbum();

    return ListView.builder(
      itemCount: albumGroups.keys.length,
      itemBuilder: (context, index) {
        final album = albumGroups.keys.elementAt(index);
        final files = albumGroups[album]!;

        return ExpansionTile(
          title: Text(album),
          children: files.map((file) => _buildMediaItem(file)).toList(),
        );
      },
    );
  }

  Widget _buildMediaItem(MediaFile file) {
    return ListTile(
      leading: Icon(file.type == 'audio' ? Icons.music_note : Icons.video_label),
      title: Text(file.name),
      subtitle: Text('${file.artist} • ${file.album} • ${file.formattedDuration}'),
    );
  }
}

