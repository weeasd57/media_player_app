import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(localeProvider.settings),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Theme Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localeProvider.getLocalizedText('المظهر', 'Appearance'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(localeProvider.darkMode),
                        subtitle: Text(
                          localeProvider.getLocalizedText(
                            'تبديل بين الوضع الفاتح والداكن',
                            'Toggle between light and dark mode',
                          ),
                        ),
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.setDarkMode(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // App Info Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localeProvider.getLocalizedText(
                          'معلومات التطبيق',
                          'App Information',
                        ),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: Text(
                          localeProvider.getLocalizedText('الإصدار', 'Version'),
                        ),
                        subtitle: const Text('1.0.0'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.developer_mode),
                        title: Text(
                          localeProvider.getLocalizedText(
                            'مطور UI Kit',
                            'UI Kit Developer',
                          ),
                        ),
                        subtitle: Text(
                          localeProvider.getLocalizedText(
                            'تطبيق نموذجي لعرض واجهات المستخدم',
                            'Sample app for showcasing UI components',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // UI Demo Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localeProvider.getLocalizedText(
                          'تجربة الواجهة',
                          'UI Demo',
                        ),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localeProvider.getLocalizedText(
                          'هذا التطبيق هو نموذج لعرض مكونات واجهة المستخدم',
                          'This app is a sample for showcasing UI components',
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                localeProvider.getLocalizedText(
                                  'تم اختبار الواجهة بنجاح!',
                                  'UI tested successfully!',
                                ),
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          localeProvider.getLocalizedText(
                            'اختبار الواجهة',
                            'Test UI',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
