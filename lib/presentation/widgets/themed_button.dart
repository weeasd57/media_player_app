import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';

class ThemedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;
  final double? width;

  const ThemedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, ThemeProvider>(
      builder: (context, appProvider, themeProvider, child) {
        final uiKitType = appProvider.currentApp.uiKitType;
        
        switch (uiKitType) {
          case 'modern':
            return _buildModernButton(context, appProvider, themeProvider);
          case 'glassmorphic':
            return _buildGlassmorphicButton(context, appProvider, themeProvider);
          case 'neomorphic':
            return _buildNeomorphicButton(context, appProvider, themeProvider);
          case 'gradient':
            return _buildGradientButton(context, appProvider, themeProvider);
          case 'minimal':
            return _buildMinimalButton(context, appProvider, themeProvider);
          case 'cyber':
            return _buildCyberButton(context, appProvider, themeProvider);
          case 'nature':
            return _buildNatureButton(context, appProvider, themeProvider);
          case 'retro':
            return _buildRetroButton(context, appProvider, themeProvider);
          case 'ocean':
            return _buildOceanButton(context, appProvider, themeProvider);
          case 'sunset':
            return _buildSunsetButton(context, appProvider, themeProvider);
          default:
            return _buildModernButton(context, appProvider, themeProvider);
        }
      },
    );
  }

  Widget _buildModernButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined 
            ? Colors.transparent 
            : appProvider.currentApp.primaryColor,
          foregroundColor: isOutlined 
            ? appProvider.currentApp.primaryColor 
            : Colors.white,
          elevation: isOutlined ? 0 : 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isOutlined 
              ? BorderSide(color: appProvider.currentApp.primaryColor, width: 2)
              : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassmorphicButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(themeProvider.isDarkMode ? 0.1 : 0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeomorphicButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.currentTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode ? Colors.black54 : Colors.grey.shade400,
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.white,
              offset: const Offset(-4, -4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: appProvider.currentApp.primaryColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: appProvider.currentApp.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              appProvider.currentApp.primaryColor,
              appProvider.currentApp.secondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: appProvider.currentApp.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : Colors.black,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: isOutlined ? Colors.black : Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isOutlined ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCyberButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: appProvider.currentApp.primaryColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: appProvider.currentApp.primaryColor.withOpacity(0.5),
              blurRadius: 15,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: appProvider.currentApp.primaryColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: appProvider.currentApp.primaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNatureButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: appProvider.currentApp.primaryColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: appProvider.currentApp.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetroButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: appProvider.currentApp.primaryColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: appProvider.currentApp.primaryColor,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOceanButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: appProvider.currentApp.primaryColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: appProvider.currentApp.primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSunsetButton(BuildContext context, AppProvider appProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              appProvider.currentApp.primaryColor,
              appProvider.currentApp.secondaryColor,
              const Color(0xFFFFD23F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: appProvider.currentApp.primaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}