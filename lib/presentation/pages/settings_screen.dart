import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../generated/app_localizations.dart';
import '../providers/media_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer2<ThemeProvider, MediaProvider>(
      builder: (context, themeProvider, mediaProvider, child) {

        return Scaffold(
          backgroundColor: themeProvider.primaryBackgroundColor,
          appBar: AppBar(
            title: Text(
              l10n.settings,
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
                  // قسم التشغيل
                  _buildSectionHeader(
                    l10n.playback,
                    themeProvider,
                  ),
                  _buildSettingsCard(themeProvider, [
                    _buildSwitchTile(
                      icon: Icons.repeat_rounded,
                      title: l10n.autoRepeat,
                      subtitle: l10n.autoRepeatDesc,
                      value: mediaProvider.autoRepeat,
                      onChanged: (value) => mediaProvider.setAutoRepeat(value),
                      themeProvider: themeProvider,
                    ),
                    _buildSwitchTile(
                      icon: Icons.shuffle_rounded,
                      title: l10n.shuffleMode,
                      subtitle: l10n.shuffleModeDesc,
                      value: mediaProvider.shuffleMode,
                      onChanged: (value) => mediaProvider.setShuffleMode(value),
                      themeProvider: themeProvider,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // قسم المكتبة
                  _buildSectionHeader(l10n.library, themeProvider),
                  _buildSettingsCard(themeProvider, [
                    _buildSettingsTile(
                      icon: Icons.refresh_rounded,
                      title: l10n.scanMediaFiles,
                      subtitle: l10n.scanMediaFilesDesc,
                      onTap: () => _scanForFiles(
                        mediaProvider,
                        themeProvider,
                      ),
                      themeProvider: themeProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.cleaning_services_rounded,
                      title: l10n.cleanLibrary,
                      subtitle: l10n.cleanLibraryDesc,
                      onTap: () => _cleanLibrary(
                        mediaProvider,
                        themeProvider,
                      ),
                      themeProvider: themeProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.folder_rounded,
                      title: l10n.storageInfo,
                      subtitle: l10n.storageInfoDesc,
                      onTap: () => _showStorageInfo(
                        mediaProvider,
                        themeProvider,
                      ),
                      themeProvider: themeProvider,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // قسم إدارة البيانات
                  _buildSectionHeader(
                    l10n.dataManagement,
                    themeProvider,
                  ),
                  _buildSettingsCard(themeProvider, [
                    _buildSettingsTile(
                      icon: Icons.delete_forever_rounded,
                      title: l10n.clearAllData,
                      subtitle: l10n.clearAllDataDesc,
                      onTap: () => _clearAllData(
                        mediaProvider,
                        themeProvider,
                      ),
                      textColor: Colors.red,
                      themeProvider: themeProvider,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // قسم حول التطبيق
                  _buildSectionHeader(
                    l10n.about,
                    themeProvider,
                  ),
                  _buildSettingsCard(themeProvider, [
                    _buildSettingsTile(
                      icon: Icons.info_rounded,
                      title: l10n.appVersion,
                      subtitle: l10n.version,
                      onTap: () => _showAppInfo(themeProvider),
                      themeProvider: themeProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.star_rounded,
                      title: l10n.rateApp,
                      subtitle: l10n.rateAppDesc,
                      onTap: () => _rateApp(),
                      themeProvider: themeProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.bug_report_rounded,
                      title: l10n.reportBug,
                      subtitle: l10n.reportBugDesc,
                      onTap: () => _reportBug(),
                      themeProvider: themeProvider,
                    ),
                    _buildSettingsTile(
                      icon: Icons.privacy_tip_rounded,
                      title: l10n.privacyPolicy,
                      subtitle: l10n.privacyPolicyDesc,
                      onTap: () => _showPrivacyPolicy(themeProvider),
                      themeProvider: themeProvider,
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
        activeTrackColor: Colors.blue.withValues(alpha: 0.3),
        inactiveThumbColor: themeProvider.isDarkMode 
            ? Colors.grey[600] 
            : Colors.grey[400],
        inactiveTrackColor: themeProvider.isDarkMode 
            ? Colors.grey[800] 
            : Colors.grey[300],
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return themeProvider.isDarkMode 
                ? Colors.grey[400]! 
                : Colors.white;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.blue.withValues(alpha: 0.5);
            }
            return themeProvider.isDarkMode 
                ? Colors.grey[700]! 
                : Colors.grey[300]!;
          },
        ),
      ),
    );
  }

  void _scanForFiles(
    MediaProvider mediaProvider,
    ThemeProvider themeProvider,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    
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
                  l10n.scanningFiles,
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
                      : l10n.loadingLibrary,
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
            l10n.scanComplete,
            style: TextStyle(color: themeProvider.primaryTextColor),
          ),
          content: Text(
            l10n.scanComplete,
            style: TextStyle(color: themeProvider.secondaryTextColor),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.ok),
            ),
          ],
        ),
      );
    }
  }

  void _cleanLibrary(
    MediaProvider mediaProvider,
    ThemeProvider themeProvider,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.cleanLibrary,
          style: TextStyle(color: themeProvider.primaryTextColor),
        ),
        content: Text(
          l10n.cleanLibraryConfirm,
          style: TextStyle(color: themeProvider.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(l10n.clean),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await mediaProvider.cleanupMissingFiles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.cleanLibrary),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _showStorageInfo(
    MediaProvider mediaProvider,
    ThemeProvider themeProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    
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
                  l10n.storageInformation,
                  style: TextStyle(color: themeProvider.primaryTextColor),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow(
                  l10n.totalFiles,
                  '${(stats['audio'] ?? 0) + (stats['video'] ?? 0)}',
                  themeProvider,
                ),
                _buildStatRow(
                  l10n.audioFiles,
                  '${stats['audio'] ?? 0}',
                  themeProvider,
                ),
                _buildStatRow(
                  l10n.videoFiles,
                  '${stats['video'] ?? 0}',
                  themeProvider,
                ),
                _buildStatRow(
                  l10n.favorites,
                  '${stats['favorites'] ?? 0}',
                  themeProvider,
                ),
                _buildStatRow(
                  l10n.playlists,
                  '${stats['playlists'] ?? 0}',
                  themeProvider,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.ok),
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
    ThemeProvider themeProvider,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.clearAllData, style: TextStyle(color: Colors.red)),
        content: Text(
          l10n.clearAllDataConfirm,
          style: TextStyle(color: themeProvider.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await mediaProvider.clearAllData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.allDataCleared),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAppInfo(ThemeProvider themeProvider) {
    final l10n = AppLocalizations.of(context)!;
    
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
              l10n.appInformation,
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.version,
              style: TextStyle(color: themeProvider.secondaryTextColor),
            ),
            Text(
              l10n.build,
              style: TextStyle(color: themeProvider.secondaryTextColor),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.appDescription,
              style: TextStyle(color: themeProvider.secondaryTextColor),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.ratingFeatureComingSoon),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _reportBug() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.bugReportingComingSoon),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showPrivacyPolicy(ThemeProvider themeProvider) {
    final l10n = AppLocalizations.of(context)!;
    
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
              l10n.privacyPolicyTitle,
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 300,
          child: SingleChildScrollView(
            child: Text(
              l10n.privacyPolicyContent,
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
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
