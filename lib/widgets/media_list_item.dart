import 'package:flutter/material.dart';
import '../models/media_item.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isPlaying ? 8 : 2,
      color: isPlaying ? Colors.blue.shade50 : null,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getTypeColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTypeIcon(),
            color: _getTypeColor(),
            size: 24,
          ),
        ),
        title: Text(
          mediaItem.displayName,
          style: TextStyle(
            fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
            color: isPlaying ? Colors.blue.shade700 : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${mediaItem.fileExtension} • ${mediaItem.formattedFileSize}',
              style: const TextStyle(fontSize: 12),
            ),
            if (mediaItem.duration != null)
              Text(
                'المدة: ${mediaItem.formattedDuration}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPlaying)
              Icon(
                Icons.volume_up,
                color: Colors.blue.shade600,
                size: 20,
              ),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.red.shade400,
                onPressed: onDelete,
                iconSize: 20,
              ),
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (mediaItem.type) {
      case MediaType.audio:
        return Icons.music_note;
      case MediaType.video:
        return Icons.video_file;
    }
  }

  Color _getTypeColor() {
    switch (mediaItem.type) {
      case MediaType.audio:
        return Colors.purple;
      case MediaType.video:
        return Colors.orange;
    }
  }
}

