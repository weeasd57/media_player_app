// Extension for MediaProvider with additional functionality
import '../models/media_file.dart';
import '../services/database_service.dart';
import 'media_provider.dart';

extension MediaProviderExtension on MediaProvider {
  // Get all media files (public getter)
  Future<List<MediaFile>> getAllMediaFiles() async {
    try {
      final databaseService = DatabaseService();
      return await databaseService.getAllMediaFiles();
    } catch (e) {
      print('Error getting all media files: $e');
      return [];
    }
  }
}