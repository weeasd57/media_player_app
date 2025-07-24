import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/media_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
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
              _buildSectionHeader('Library'),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.refresh_rounded,
                  title: 'Scan Media Files',
                  subtitle: 'Search for new media files on your device',
                  onTap: _scanForFiles,
                ),
                _buildSettingsTile(
                  icon: Icons.cleaning_services_rounded,
                  title: 'Clean Library',
                  subtitle: 'Remove missing files from library',
                  onTap: _cleanLibrary,
                ),
                _buildSettingsTile(
                  icon: Icons.folder_rounded,
                  title: 'Storage Info',
                  subtitle: 'View storage usage and file statistics',
                  onTap: _showStorageInfo,
                ),
              ]),
              
              const SizedBox(height: 24),
              
              _buildSectionHeader('Playback'),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: Icons.repeat_rounded,
                  title: 'Auto Repeat',
                  subtitle: 'Automatically repeat playlists',
                  value: true,
                  onChanged: (value) {},
                ),
                _buildSwitchTile(
                  icon: Icons.shuffle_rounded,
                  title: 'Shuffle Mode',
                  subtitle: 'Randomize playback order',
                  value: false,
                  onChanged: (value) {},
                ),
                _buildSettingsTile(
                  icon: Icons.equalizer_rounded,
                  title: 'Audio Equalizer',
                  subtitle: 'Adjust audio settings',
                  onTap: () {},
                ),
              ]),
              
              const SizedBox(height: 24),
              
              _buildSectionHeader('Data & Privacy'),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.backup_rounded,
                  title: 'Backup Playlists',
                  subtitle: 'Export your playlists',
                  onTap: _backupPlaylists,
                ),
                _buildSettingsTile(
                  icon: Icons.restore_rounded,
                  title: 'Restore Playlists',
                  subtitle: 'Import playlists from backup',
                  onTap: _restorePlaylists,
                ),
                _buildSettingsTile(
                  icon: Icons.delete_forever_rounded,
                  title: 'Clear All Data',
                  subtitle: 'Remove all playlists and preferences',
                  onTap: _clearAllData,
                  textColor: Colors.red,
                ),
              ]),
              
              const SizedBox(height: 24),
              
              _buildSectionHeader('About'),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.info_rounded,
                  title: 'App Version',
                  subtitle: '1.0.0',
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.star_rounded,
                  title: 'Rate App',
                  subtitle: 'Rate us on the app store',
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.bug_report_rounded,
                  title: 'Report Bug',
                  subtitle: 'Help us improve the app',
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {},
                ),
              ]),
              
              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (textColor ?? Colors.blue).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: textColor ?? Colors.blue,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.grey[400],
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
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.blue,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  void _scanForFiles() async {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<MediaProvider>(
        builder: (context, provider, child) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.refresh_rounded, color: Colors.blue),
                SizedBox(width: 12),
                Text('Scanning Files'),
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
                      : 'Preparing to scan...',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    final result = await mediaProvider.scanForMediaFiles();
    
    if (mounted) {
      Navigator.of(context).pop();
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(result.hasError ? 'Scan Failed' : 'Scan Complete'),
          content: Text(
            result.hasError
                ? 'Error: ${result.error}'
                : 'Found ${result.totalFilesFound} files\nAdded ${result.filesAdded} new files',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _cleanLibrary() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Clean Library'),
        content: const Text(
          'This will remove all missing files from your library. This action cannot be undone.\n\nContinue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
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
      final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      final removedCount = await mediaProvider.cleanupMissingFiles();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed $removedCount missing files'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _showStorageInfo() {
    showDialog(
      context: context,
      builder: (context) => Consumer<MediaProvider>(
        builder: (context, mediaProvider, child) {
          final stats = mediaProvider.statistics;
          
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.storage_rounded, color: Colors.blue),
                SizedBox(width: 12),
                Text('Storage Information'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow('Total Files', '${(stats['audio'] ?? 0) + (stats['video'] ?? 0)}'),
                _buildStatRow('Audio Files', '${stats['audio'] ?? 0}'),
                _buildStatRow('Video Files', '${stats['video'] ?? 0}'),
                _buildStatRow('Favorites', '${stats['favorites'] ?? 0}'),
                _buildStatRow('Playlists', '${stats['playlists'] ?? 0}'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _backupPlaylists() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup feature coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _restorePlaylists() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Restore feature coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Clear All Data',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'This will permanently delete all your playlists, favorites, and app data. This action cannot be undone.\n\nAre you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
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
      final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
      await mediaProvider.clearAllData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared successfully'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}