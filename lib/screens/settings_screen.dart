import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/text_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<ThemeProvider, TextProvider, MediaProvider>(
      builder: (context, themeProvider, textProvider, mediaProvider, child) {

        return Scaffold(
          backgroundColor: themeProvider.primaryBackgroundColor,
          appBar: AppBar(
            title: Text(
              textProvider.getText('settings'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: AnimationLimiter(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  // قسم إعدادات المظهر
                  _buildSectionHeader(
                    textProvider.getText('theme'),
                    themeProvider,
                    textProvider,
                  ),
                  _buildSettingsCard(themeProvider, [
                    _buildSwitchTile(
                      icon: themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      title: textProvider.getText('dark_mode'),
                      subtitle: themeProvider.isDarkMode
                          ? textProvider.getText('light_mode')
                          : textProvider.getText('dark_mode'),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) => themeProvider.toggleTheme(value),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // قسم إعدادات اللغة
                  _buildSectionHeader(
                    textProvider.getText('language'),
                    themeProvider,
                    textProvider,
                  ),
                  _buildSettingsCard(themeProvider, [
                    _buildSettingsTile(
                      icon: Icons.language,
                      title: textProvider.getText('language'),
                      subtitle: textProvider.currentLanguage == 'ar'
                          ? textProvider.getText('arabic')
                          : textProvider.getText('english'),
                      onTap: () =>
                          _showLanguageDialog(textProvider, themeProvider),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // قسم التشغيل
                  _buildSectionHeader(
                    textProvider.getText('playback'),
                    themeProvider,
                    textProvider,
                  ),
                  _buildSettingsCard(themeProvider, [
                    _buildSwitchTile(
                      icon: Icons.repeat_rounded,
                      title: textProvider.getText('repeat'),
                      subtitle: 'Automatically repeat playlists',
                      value: mediaProvider.autoRepeat,
                      onChanged: (value) => mediaProvider.setAutoRepeat(value),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                    _buildSwitchTile(
                      icon: Icons.shuffle_rounded,
                      title: textProvider.getText('shuffle'),
                      subtitle: 'Randomize playback order',
                      value: mediaProvider.shuffleMode,
                      onChanged: (value) => mediaProvider.setShuffleMode(value),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // قسم المكتبة
                  _buildSectionHeader('Library', themeProvider, textProvider),
                  _buildSettingsCard(themeProvider, [
                    _buildSettingsTile(
                      icon: Icons.refresh_rounded,
                      title: textProvider.getText('scan_files'),
                      subtitle: 'Search for new media files on your device',
                      onTap: () => _scanForFiles(
                        mediaProvider,
                        textProvider,
                        themeProvider,
                      ),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.cleaning_services_rounded,
                      title: 'Clean Library',
                      subtitle: 'Remove missing files from library',
                      onTap: () => _cleanLibrary(
                        mediaProvider,
                        textProvider,
                        themeProvider,
                      ),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.folder_rounded,
                      title: 'Storage Info',
                      subtitle: 'View storage usage and file statistics',
                      onTap: () => _showStorageInfo(
                        mediaProvider,
                        textProvider,
                        themeProvider,
                      ),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // قسم إدارة البيانات
                  _buildSectionHeader(
                    'Data Management',
                    themeProvider,
                    textProvider,
                  ),
                  _buildSettingsCard(themeProvider, [
                    _buildSettingsTile(
                      icon: Icons.delete_forever_rounded,
                      title: 'Clear All Data',
                      subtitle: 'Remove all playlists and preferences',
                      onTap: () => _clearAllData(
                        mediaProvider,
                        textProvider,
                        themeProvider,
                      ),
                      textColor: Colors.red,
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // قسم حول التطبيق
                  _buildSectionHeader(
                    textProvider.getText('about'),
                    themeProvider,
                    textProvider,
                  ),
                  _buildSettingsCard(themeProvider, [
                    _buildSettingsTile(
                      icon: Icons.info_rounded,
                      title: textProvider.getText('version'),
                      subtitle: '1.0.0',
                      onTap: () => _showAppInfo(textProvider, themeProvider),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.star_rounded,
                      title: 'Rate App',
                      subtitle: 'Rate us on the app store',
                      onTap: () => _rateApp(textProvider),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.bug_report_rounded,
                      title: 'Report Bug',
                      subtitle: 'Help us improve the app',
                      onTap: () => _reportBug(textProvider),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.privacy_tip_rounded,
                      title: textProvider.getText('privacy_policy'),
                      subtitle: 'Read our privacy policy',
                      onTap: () =>
                          _showPrivacyPolicy(textProvider, themeProvider),
                      themeProvider: themeProvider,
                      textProvider: textProvider,
                    ),
                  ]),

                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    String title,
    ThemeProvider themeProvider,
    TextProvider textProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: themeProvider.secondaryTextColor,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    ThemeProvider themeProvider,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      color: themeProvider.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeProvider themeProvider,
    required TextProvider textProvider,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? Colors.blue).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: textColor ?? Colors.blue, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor ?? themeProvider.primaryTextColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: themeProvider.secondaryTextColor, fontSize: 14),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: themeProvider.iconColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeProvider themeProvider,
    required TextProvider textProvider,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: themeProvider.primaryTextColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: themeProvider.secondaryTextColor, fontSize: 14),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  void _showLanguageDialog(
    TextProvider textProvider,
    ThemeProvider themeProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.language, color: Colors.blue),
            const SizedBox(width: 12),
            Text(
              textProvider.getText('language'),
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: textProvider.availableLanguages.map((lang) {
            return ListTile(
              leading: Radio<String>(
                value: lang['code']!,
                groupValue: textProvider.currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    textProvider.changeLanguage(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: Text(
                lang['name']!,
                style: TextStyle(color: themeProvider.primaryTextColor),
              ),
              onTap: () {
                textProvider.changeLanguage(lang['code']!);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(textProvider.getText('cancel')),
          ),
        ],
      ),
    );
  }

  void _scanForFiles(
    MediaProvider mediaProvider,
    TextProvider textProvider,
    ThemeProvider themeProvider,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<MediaProvider>(
        builder: (context, provider, child) {
          return AlertDialog(
            backgroundColor: themeProvider.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.refresh_rounded, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  textProvider.getText('scanning_files'),
                  style: TextStyle(color: themeProvider.primaryTextColor),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  provider.scanningStatus.isNotEmpty
                      ? provider.scanningStatus
                      : textProvider.getText('loading'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: themeProvider.secondaryTextColor),
                ),
              ],
            ),
          );
        },
      ),
    );

    await mediaProvider.scanForMediaFiles();

    if (mounted) {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: themeProvider.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Scan Complete',
            style: TextStyle(color: themeProvider.primaryTextColor),
          ),
          content: Text(
            'Media scan has been completed successfully.',
            style: TextStyle(color: themeProvider.secondaryTextColor),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(textProvider.getText('ok')),
            ),
          ],
        ),
      );
    }
  }

  void _cleanLibrary(
    MediaProvider mediaProvider,
    TextProvider textProvider,
    ThemeProvider themeProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Clean Library',
          style: TextStyle(color: themeProvider.primaryTextColor),
        ),
        content: Text(
          'This will remove all missing files from your library. This action cannot be undone.\n\nContinue?',
          style: TextStyle(color: themeProvider.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(textProvider.getText('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Clean'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await mediaProvider.cleanupMissingFiles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Library cleaned successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _showStorageInfo(
    MediaProvider mediaProvider,
    TextProvider textProvider,
    ThemeProvider themeProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => Consumer<MediaProvider>(
        builder: (context, mediaProvider, child) {
          final stats = mediaProvider.statistics;

          return AlertDialog(
            backgroundColor: themeProvider.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.storage_rounded, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  'Storage Information',
                  style: TextStyle(color: themeProvider.primaryTextColor),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow(
                  'Total Files',
                  '${(stats['audio'] ?? 0) + (stats['video'] ?? 0)}',
                  themeProvider,
                ),
                _buildStatRow(
                  textProvider.getText('audio_files'),
                  '${stats['audio'] ?? 0}',
                  themeProvider,
                ),
                _buildStatRow(
                  textProvider.getText('video_files'),
                  '${stats['video'] ?? 0}',
                  themeProvider,
                ),
                _buildStatRow(
                  'Favorites',
                  '${stats['favorites'] ?? 0}',
                  themeProvider,
                ),
                _buildStatRow(
                  textProvider.getText('playlists'),
                  '${stats['playlists'] ?? 0}',
                  themeProvider,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(textProvider.getText('ok')),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value,
    ThemeProvider themeProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: themeProvider.secondaryTextColor),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeProvider.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllData(
    MediaProvider mediaProvider,
    TextProvider textProvider,
    ThemeProvider themeProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear All Data', style: TextStyle(color: Colors.red)),
        content: Text(
          'This will permanently delete all your playlists, favorites, and app data. This action cannot be undone.\n\nAre you sure you want to continue?',
          style: TextStyle(color: themeProvider.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(textProvider.getText('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await mediaProvider.clearAllData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All data cleared successfully'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAppInfo(TextProvider textProvider, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info_rounded, color: Colors.blue),
            const SizedBox(width: 12),
            Text(
              textProvider.getText('about'),
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              textProvider.getText('app_name'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${textProvider.getText('version')}: 1.0.0',
              style: TextStyle(color: themeProvider.secondaryTextColor),
            ),
            Text(
              'Build: 1',
              style: TextStyle(color: themeProvider.secondaryTextColor),
            ),
            const SizedBox(height: 12),
            Text(
              'A modern media player for audio and video files with playlist support.',
              style: TextStyle(color: themeProvider.secondaryTextColor),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(textProvider.getText('ok')),
          ),
        ],
      ),
    );
  }

  void _rateApp(TextProvider textProvider) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rating feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _reportBug(TextProvider textProvider) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bug reporting feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showPrivacyPolicy(
    TextProvider textProvider,
    ThemeProvider themeProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.privacy_tip_rounded, color: Colors.blue),
            const SizedBox(width: 12),
            Text(
              textProvider.getText('privacy_policy'),
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 300,
          child: SingleChildScrollView(
            child: Text(
              'Privacy Policy\n\n'
              'This media player app is designed to respect your privacy. '
              'All media files are stored locally on your device and are not '
              'transmitted to any external servers.\n\n'
              'Data Collection:\n'
              '• We do not collect any personal information\n'
              '• File paths and metadata are stored locally only\n'
              '• No data is shared with third parties\n\n'
              'Permissions:\n'
              '• Storage access: Required to scan and play media files\n'
              '• No network permissions are requested\n\n'
              'Your media library and playlists remain completely private '
              'and under your control.',
              style: TextStyle(
                fontSize: 14,
                color: themeProvider.secondaryTextColor,
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(textProvider.getText('ok')),
          ),
        ],
      ),
    );
  }
}
