import 'package:flutter/material.dart';
import '../../data/models/media_item.dart';
import '../../core/enums/media_enums.dart';

class MediaListItem extends StatelessWidget {
  final MediaItem mediaItem;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool isPlaying;

  const MediaListItem({
    super.key,
    required this.mediaItem,
    required this.onTap,
    this.onDelete,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Hero(
          tag: 'media_list_item_${mediaItem.id}',
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: mediaItem.type == MediaType.audio
                  ? Colors.purple.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              mediaItem.type == MediaType.audio
                  ? Icons.music_note_rounded
                  : Icons.video_library_rounded,
              color: mediaItem.type == MediaType.audio
                  ? Colors.purple
                  : Colors.orange,
              size: 32,
            ),
          ),
        ),
        title: Text(
          mediaItem.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          mediaItem.formattedDuration,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: Icon(
            mediaItem.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: mediaItem.isFavorite ? Colors.red : Colors.grey[400],
          ),
          onPressed: () {
            // Provider.of<MediaProvider>(context, listen: false).toggleFavorite(mediaFile); // Fixed: Pass object
          },
        ),
        onTap: onTap,
      ),
    );
  }

}
