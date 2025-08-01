import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // New import
import '../providers/text_provider.dart';
import '../providers/theme_provider.dart'; // Added import for ThemeProvider

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  double _bassValue = 0.0;
  double _trebleValue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bassValue = prefs.getDouble('bassValue') ?? 0.0;
      _trebleValue = prefs.getDouble('trebleValue') ?? 0.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('bassValue', _bassValue);
    await prefs.setDouble('trebleValue', _trebleValue);
  }

  @override
  Widget build(BuildContext context) {
    final textProvider = Provider.of<TextProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // Access ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: Text(textProvider.getText('equalizer')),
        backgroundColor:
            themeProvider.primaryBackgroundColor, // Use themeProvider
        foregroundColor: themeProvider.primaryTextColor, // Use themeProvider
      ),
      backgroundColor:
          themeProvider.primaryBackgroundColor, // Use themeProvider
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textProvider.getText('bass'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryTextColor, // Use themeProvider
              ),
            ),
            Slider(
              value: _bassValue,
              min: -10.0,
              max: 10.0,
              divisions: 20,
              label: _bassValue.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _bassValue = value;
                });
                _saveSettings();
              },
              activeColor: themeProvider
                  .currentTheme
                  .colorScheme
                  .primary, // Use themeProvider
              inactiveColor: themeProvider.dividerColor, // Use themeProvider
            ),
            const SizedBox(height: 20),
            Text(
              textProvider.getText('treble'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.primaryTextColor, // Use themeProvider
              ),
            ),
            Slider(
              value: _trebleValue,
              min: -10.0,
              max: 10.0,
              divisions: 20,
              label: _trebleValue.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _trebleValue = value;
                });
                _saveSettings();
              },
              activeColor: themeProvider
                  .currentTheme
                  .colorScheme
                  .primary, // Use themeProvider
              inactiveColor: themeProvider.dividerColor, // Use themeProvider
            ),
            // يمكنك إضافة أشرطة تمرير مخصصة هنا
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _bassValue = 0.0;
                  _trebleValue = 0.0;
                });
                _saveSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.currentTheme.colorScheme.primary,
                foregroundColor:
                    themeProvider.currentTheme.colorScheme.onPrimary,
              ),
              child: Text(textProvider.getText('reset')),
            ),
          ],
        ),
      ),
    );
  }
}
