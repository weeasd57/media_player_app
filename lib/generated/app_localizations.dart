import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Media Player'**
  String get appTitle;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning!'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon!'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening!'**
  String get goodEvening;

  /// No description provided for @yourLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your Library'**
  String get yourLibrary;

  /// No description provided for @audioFiles.
  ///
  /// In en, this message translates to:
  /// **'Audio Files'**
  String get audioFiles;

  /// No description provided for @videoFiles.
  ///
  /// In en, this message translates to:
  /// **'Video Files'**
  String get videoFiles;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @scanFiles.
  ///
  /// In en, this message translates to:
  /// **'Scan Files'**
  String get scanFiles;

  /// No description provided for @createPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create Playlist'**
  String get createPlaylist;

  /// No description provided for @recentlyPlayed.
  ///
  /// In en, this message translates to:
  /// **'Recently Played'**
  String get recentlyPlayed;

  /// No description provided for @yourFavorites.
  ///
  /// In en, this message translates to:
  /// **'Your Favorites'**
  String get yourFavorites;

  /// No description provided for @yourPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Your Playlists'**
  String get yourPlaylists;

  /// No description provided for @loadingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Loading library...'**
  String get loadingLibrary;

  /// No description provided for @scanComplete.
  ///
  /// In en, this message translates to:
  /// **'Scan Complete'**
  String get scanComplete;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan Failed'**
  String get scanFailed;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error: {error}'**
  String scanError(Object error);

  /// No description provided for @filesFound.
  ///
  /// In en, this message translates to:
  /// **'Found {totalFiles} files\\nAdded {newFiles} new files'**
  String filesFound(Object newFiles, Object totalFiles);

  /// No description provided for @playlistCreated.
  ///
  /// In en, this message translates to:
  /// **'Playlist created successfully'**
  String get playlistCreated;

  /// No description provided for @searchMediaFiles.
  ///
  /// In en, this message translates to:
  /// **'Search media files'**
  String get searchMediaFiles;

  /// No description provided for @createNewPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create New Playlist'**
  String get createNewPlaylist;

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Playlist name'**
  String get playlistName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @scanMediaFiles.
  ///
  /// In en, this message translates to:
  /// **'Scan Media Files'**
  String get scanMediaFiles;

  /// No description provided for @scanMediaFilesDesc.
  ///
  /// In en, this message translates to:
  /// **'Search for new media files on your device'**
  String get scanMediaFilesDesc;

  /// No description provided for @cleanLibrary.
  ///
  /// In en, this message translates to:
  /// **'Clean Library'**
  String get cleanLibrary;

  /// No description provided for @cleanLibraryDesc.
  ///
  /// In en, this message translates to:
  /// **'Remove missing files from library'**
  String get cleanLibraryDesc;

  /// No description provided for @storageInfo.
  ///
  /// In en, this message translates to:
  /// **'Storage Info'**
  String get storageInfo;

  /// No description provided for @storageInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'View storage usage and file statistics'**
  String get storageInfoDesc;

  /// No description provided for @playback.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get playback;

  /// No description provided for @autoRepeat.
  ///
  /// In en, this message translates to:
  /// **'Auto Repeat'**
  String get autoRepeat;

  /// No description provided for @autoRepeatDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically repeat playlists'**
  String get autoRepeatDesc;

  /// No description provided for @shuffleMode.
  ///
  /// In en, this message translates to:
  /// **'Shuffle Mode'**
  String get shuffleMode;

  /// No description provided for @shuffleModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Randomize playback order'**
  String get shuffleModeDesc;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// No description provided for @clearAllDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Remove all playlists and preferences'**
  String get clearAllDataDesc;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @rateAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Rate us on the app store'**
  String get rateAppDesc;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reportBug;

  /// No description provided for @reportBugDesc.
  ///
  /// In en, this message translates to:
  /// **'Help us improve the app'**
  String get reportBugDesc;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get privacyPolicyDesc;

  /// No description provided for @scanningFiles.
  ///
  /// In en, this message translates to:
  /// **'Scanning Files'**
  String get scanningFiles;

  /// No description provided for @preparingToScan.
  ///
  /// In en, this message translates to:
  /// **'Preparing to scan...'**
  String get preparingToScan;

  /// No description provided for @cleanLibraryConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will remove all missing files from your library. This action cannot be undone.\\n\\nContinue?'**
  String get cleanLibraryConfirm;

  /// No description provided for @clean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get clean;

  /// No description provided for @removedMissingFiles.
  ///
  /// In en, this message translates to:
  /// **'Removed {count} missing files'**
  String removedMissingFiles(Object count);

  /// No description provided for @storageInformation.
  ///
  /// In en, this message translates to:
  /// **'Storage Information'**
  String get storageInformation;

  /// No description provided for @totalFiles.
  ///
  /// In en, this message translates to:
  /// **'Total Files'**
  String get totalFiles;

  /// No description provided for @clearAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete all your playlists, favorites, and app data. This action cannot be undone.\\n\\nAre you sure you want to continue?'**
  String get clearAllDataConfirm;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @allDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All data cleared successfully'**
  String get allDataCleared;

  /// No description provided for @bass.
  ///
  /// In en, this message translates to:
  /// **'Bass: {value}'**
  String bass(Object value);

  /// No description provided for @treble.
  ///
  /// In en, this message translates to:
  /// **'Treble'**
  String get treble;

  /// No description provided for @appInformation.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get appInformation;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version: 1.0.0'**
  String get version;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'Build: 1'**
  String get build;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A modern media player for audio and video files with playlist support.'**
  String get appDescription;

  /// No description provided for @ratingFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Rating feature coming soon!'**
  String get ratingFeatureComingSoon;

  /// No description provided for @bugReportingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Bug reporting feature coming soon!'**
  String get bugReportingComingSoon;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy\\n\\nThis media player app is designed to respect your privacy. All media files are stored locally on your device and are not transmitted to any external servers.\\n\\nData Collection:\\n• We do not collect any personal information\\n• File paths and metadata are stored locally only\\n• No data is shared with third parties\\n\\nPermissions:\\n• Storage access: Required to scan and play media files\\n• No network permissions are requested\\n\\nYour media library and playlists remain completely private and under your control.'**
  String get privacyPolicyContent;

  /// No description provided for @filesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} files'**
  String filesCount(Object count);

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage permission required'**
  String get storagePermissionRequired;

  /// No description provided for @permissionError.
  ///
  /// In en, this message translates to:
  /// **'Permission error: {error}'**
  String permissionError(Object error);

  /// No description provided for @noMediaFound.
  ///
  /// In en, this message translates to:
  /// **'No media found'**
  String get noMediaFound;

  /// No description provided for @noPlaylistsYet.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet'**
  String get noPlaylistsYet;

  /// No description provided for @createFirstPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create your first playlist to organize your favorite media files'**
  String get createFirstPlaylist;

  /// No description provided for @playAll.
  ///
  /// In en, this message translates to:
  /// **'Play All'**
  String get playAll;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(Object days);

  /// No description provided for @playlistIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Playlist is Empty'**
  String get playlistIsEmpty;

  /// No description provided for @addSomeFiles.
  ///
  /// In en, this message translates to:
  /// **'Add some files to get started'**
  String get addSomeFiles;

  /// No description provided for @playlistUpdated.
  ///
  /// In en, this message translates to:
  /// **'Playlist updated successfully'**
  String get playlistUpdated;

  /// No description provided for @playlistDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Playlist duplicated successfully'**
  String get playlistDuplicated;

  /// No description provided for @deletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist'**
  String get deletePlaylist;

  /// No description provided for @deletePlaylistConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \'{playlistName}\'?'**
  String deletePlaylistConfirmation(Object playlistName);

  /// No description provided for @playlistDeleted.
  ///
  /// In en, this message translates to:
  /// **'Playlist deleted successfully'**
  String get playlistDeleted;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @editPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Edit Playlist'**
  String get editPlaylist;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @removeFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Playlist'**
  String get removeFromPlaylist;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get addToPlaylist;

  /// No description provided for @removedFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'File removed from playlist'**
  String get removedFromPlaylist;

  /// No description provided for @addedToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Added to {name}'**
  String addedToPlaylist(Object name);

  /// No description provided for @noFilePlaying.
  ///
  /// In en, this message translates to:
  /// **'No file playing'**
  String get noFilePlaying;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No search results'**
  String get noSearchResults;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'File removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'File added to favorites'**
  String get addedToFavorites;

  /// No description provided for @deleteFile.
  ///
  /// In en, this message translates to:
  /// **'Delete File'**
  String get deleteFile;

  /// No description provided for @searchFiles.
  ///
  /// In en, this message translates to:
  /// **'Search Files'**
  String get searchFiles;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search media files...'**
  String get searchHint;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @buffering.
  ///
  /// In en, this message translates to:
  /// **'Buffering...'**
  String get buffering;

  /// No description provided for @playing.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get playing;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @selectAudioFile.
  ///
  /// In en, this message translates to:
  /// **'Select Audio File'**
  String get selectAudioFile;

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get upNext;

  /// No description provided for @currentVideo.
  ///
  /// In en, this message translates to:
  /// **'Current Video'**
  String get currentVideo;

  /// No description provided for @dimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get dimensions;

  /// No description provided for @selectVideoFile.
  ///
  /// In en, this message translates to:
  /// **'Select Video File'**
  String get selectVideoFile;

  /// No description provided for @playedXTimes.
  ///
  /// In en, this message translates to:
  /// **'Played {count} times'**
  String playedXTimes(Object count);

  /// No description provided for @addFilesToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add Files to {playlistName}'**
  String addFilesToPlaylist(Object playlistName);

  /// No description provided for @filesSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} files selected'**
  String filesSelected(Object count);

  /// No description provided for @noFilesAvailableToAdd.
  ///
  /// In en, this message translates to:
  /// **'No files available to add'**
  String get noFilesAvailableToAdd;

  /// No description provided for @addWithCount.
  ///
  /// In en, this message translates to:
  /// **'Add ({count})'**
  String addWithCount(Object count);

  /// No description provided for @addedFilesToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Added {count} files to playlist'**
  String addedFilesToPlaylist(Object count);

  /// No description provided for @confirmRemoveFromFile.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{fileName}\" from this playlist?'**
  String confirmRemoveFromFile(Object fileName);

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// No description provided for @noMusicPlaying.
  ///
  /// In en, this message translates to:
  /// **'No music playing'**
  String get noMusicPlaying;

  /// No description provided for @tapToPlay.
  ///
  /// In en, this message translates to:
  /// **'Tap to play a song'**
  String get tapToPlay;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Media Player'**
  String get appName;

  /// No description provided for @settingUpLibrary.
  ///
  /// In en, this message translates to:
  /// **'Setting up your library...'**
  String get settingUpLibrary;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noFilesFound.
  ///
  /// In en, this message translates to:
  /// **'No files found'**
  String get noFilesFound;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get sortByName;

  /// No description provided for @sortBySize.
  ///
  /// In en, this message translates to:
  /// **'Sort by Size'**
  String get sortBySize;

  /// No description provided for @allFiles.
  ///
  /// In en, this message translates to:
  /// **'All Files'**
  String get allFiles;

  /// No description provided for @folders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders;

  /// No description provided for @parentDirectory.
  ///
  /// In en, this message translates to:
  /// **'Parent Directory'**
  String get parentDirectory;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found: {fileName}'**
  String fileNotFound(Object fileName);

  /// No description provided for @playedTimes.
  ///
  /// In en, this message translates to:
  /// **'Played {count} times'**
  String playedTimes(Object count);

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @exploreDevice.
  ///
  /// In en, this message translates to:
  /// **'Explore Device'**
  String get exploreDevice;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// No description provided for @equalizer.
  ///
  /// In en, this message translates to:
  /// **'Equalizer'**
  String get equalizer;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Loading playlist...'**
  String get loadingPlaylist;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @addFiles.
  ///
  /// In en, this message translates to:
  /// **'Add Files'**
  String get addFiles;

  /// No description provided for @shufflePlay.
  ///
  /// In en, this message translates to:
  /// **'Shuffle Play'**
  String get shufflePlay;

  /// No description provided for @removeFromHistory.
  ///
  /// In en, this message translates to:
  /// **'Remove from History'**
  String get removeFromHistory;

  /// No description provided for @noRecentFiles.
  ///
  /// In en, this message translates to:
  /// **'No Recent Files'**
  String get noRecentFiles;

  /// No description provided for @noRecentFilesDescription.
  ///
  /// In en, this message translates to:
  /// **'Files you play will appear here'**
  String get noRecentFilesDescription;

  /// No description provided for @removeFromHistoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove {fileName} from history?'**
  String removeFromHistoryConfirmation(Object fileName);

  /// No description provided for @removedFromHistory.
  ///
  /// In en, this message translates to:
  /// **'Removed from history'**
  String get removedFromHistory;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Clear all recent files history?'**
  String get clearHistoryConfirmation;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @scanCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Media scan completed successfully.'**
  String get scanCompleteMessage;

  /// No description provided for @emptyPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Empty Playlist'**
  String get emptyPlaylist;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
