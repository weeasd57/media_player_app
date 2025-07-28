// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Media Player';

  @override
  String get goodMorning => 'Good Morning!';

  @override
  String get goodAfternoon => 'Good Afternoon!';

  @override
  String get goodEvening => 'Good Evening!';

  @override
  String get yourLibrary => 'Your Library';

  @override
  String get audioFiles => 'Audio Files';

  @override
  String get videoFiles => 'Video Files';

  @override
  String get favorites => 'Favorites';

  @override
  String get playlists => 'Playlists';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get scanFiles => 'Scan Files';

  @override
  String get createPlaylist => 'Create Playlist';

  @override
  String get recentlyPlayed => 'Recently Played';

  @override
  String get yourFavorites => 'Your Favorites';

  @override
  String get yourPlaylists => 'Your Playlists';

  @override
  String get loadingLibrary => 'Loading your media library...';

  @override
  String get scanComplete => 'Scan Complete';

  @override
  String get scanFailed => 'Scan Failed';

  @override
  String scanError(Object error) {
    return 'Scan error: $error';
  }

  @override
  String filesFound(Object newFiles, Object totalFiles) {
    return 'Found $totalFiles files\nAdded $newFiles new files';
  }

  @override
  String get playlistCreated => 'Playlist created successfully';

  @override
  String get searchMediaFiles => 'Search media files';

  @override
  String get createNewPlaylist => 'Create New Playlist';

  @override
  String get playlistName => 'Playlist name';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get ok => 'OK';

  @override
  String get done => 'Done';

  @override
  String get reset => 'Reset';

  @override
  String get settings => 'Settings';

  @override
  String get library => 'Library';

  @override
  String get scanMediaFiles => 'Scan Media Files';

  @override
  String get scanMediaFilesDesc => 'Search for new media files on your device';

  @override
  String get cleanLibrary => 'Clean Library';

  @override
  String get cleanLibraryDesc => 'Remove missing files from library';

  @override
  String get storageInfo => 'Storage Info';

  @override
  String get storageInfoDesc => 'View storage usage and file statistics';

  @override
  String get playback => 'Playback';

  @override
  String get autoRepeat => 'Auto Repeat';

  @override
  String get autoRepeatDesc => 'Automatically repeat playlists';

  @override
  String get shuffleMode => 'Shuffle Mode';

  @override
  String get shuffleModeDesc => 'Randomize playback order';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get clearAllData => 'Clear All Data';

  @override
  String get clearAllDataDesc => 'Remove all playlists and preferences';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get rateApp => 'Rate App';

  @override
  String get rateAppDesc => 'Rate us on the app store';

  @override
  String get reportBug => 'Report Bug';

  @override
  String get reportBugDesc => 'Help us improve the app';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyDesc => 'Read our privacy policy';

  @override
  String get scanningFiles => 'Scanning Files';

  @override
  String get preparingToScan => 'Preparing to scan...';

  @override
  String get cleanLibraryConfirm =>
      'This will remove all missing files from your library. This action cannot be undone.\n\nContinue?';

  @override
  String get clean => 'Clean';

  @override
  String removedMissingFiles(Object count) {
    return 'Removed $count missing files';
  }

  @override
  String get storageInformation => 'Storage Information';

  @override
  String get totalFiles => 'Total Files';

  @override
  String get clearAllDataConfirm =>
      'This will permanently delete all your playlists, favorites, and app data. This action cannot be undone.\n\nAre you sure you want to continue?';

  @override
  String get clearAll => 'Clear All';

  @override
  String get allDataCleared => 'All data cleared successfully';

  @override
  String bass(Object value) {
    return 'Bass: $value';
  }

  @override
  String treble(Object value) {
    return 'Treble: $value';
  }

  @override
  String get appInformation => 'App Information';

  @override
  String get version => 'Version: 1.0.0';

  @override
  String get build => 'Build: 1';

  @override
  String get appDescription =>
      'A modern media player for audio and video files with playlist support.';

  @override
  String get ratingFeatureComingSoon => 'Rating feature coming soon!';

  @override
  String get bugReportingComingSoon => 'Bug reporting feature coming soon!';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyContent =>
      'Privacy Policy\n\nThis media player app is designed to respect your privacy. All media files are stored locally on your device and are not transmitted to any external servers.\n\nData Collection:\n• We do not collect any personal information\n• File paths and metadata are stored locally only\n• No data is shared with third parties\n\nPermissions:\n• Storage access: Required to scan and play media files\n• No network permissions are requested\n\nYour media library and playlists remain completely private and under your control.';

  @override
  String filesCount(Object count) {
    return '$count files';
  }

  @override
  String get storagePermissionRequired => 'Storage permission required';

  @override
  String permissionError(Object error) {
    return 'Permission error: $error';
  }

  @override
  String get noMediaFound => 'No media found';

  @override
  String get noPlaylistsYet => 'No playlists yet';

  @override
  String get createFirstPlaylist =>
      'Create your first playlist to organize your favorite media files';

  @override
  String get playAll => 'Play All';

  @override
  String get edit => 'Edit';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get delete => 'Delete';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String get playlistIsEmpty => 'Playlist is Empty';

  @override
  String get addSomeFiles => 'Add some files to get started';

  @override
  String get playlistUpdated => 'Playlist updated successfully';

  @override
  String get playlistDuplicated => 'Playlist duplicated successfully';

  @override
  String get deletePlaylist => 'Delete Playlist';

  @override
  String deletePlaylistConfirmation(Object playlistName) {
    return 'Are you sure you want to delete \'$playlistName\'?';
  }

  @override
  String get playlistDeleted => 'Playlist deleted successfully';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get editPlaylist => 'Edit Playlist';

  @override
  String get save => 'Save';

  @override
  String get removeFromPlaylist => 'Remove from Playlist';

  @override
  String get addToPlaylist => 'Add to Playlist';

  @override
  String get removedFromPlaylist => 'File removed from playlist';

  @override
  String get addedToPlaylist => 'File added to playlist';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removedFromFavorites => 'File removed from favorites';

  @override
  String get addedFromFavorites => 'File added to favorites';

  @override
  String get deleteFile => 'Delete File';

  @override
  String get searchFiles => 'Search Files';

  @override
  String get searchHint => 'Search media files...';
}
