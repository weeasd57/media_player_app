import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/navigation/app_layout.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediaPlayerApp());
}

class MediaPlayerApp extends StatelessWidget {
  const MediaPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Media Player UI Kit',
            theme: themeProvider.currentTheme,
            home: const AppLayout(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

