import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/theme_provider.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final double borderRadius;
  final double depth;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.onTap,
    this.borderRadius = 12.0,
    this.depth = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFE6E6E6);

    return Container(
      margin: margin,
      height: height,
      width: width,
      child: ClayContainer(
        color: backgroundColor,
        height: height,
        width: width,
        borderRadius: borderRadius,
        depth: depth.toInt(),
        spread: 1,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              padding: padding ?? const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class NeumorphicButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double borderRadius;
  final double depth;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.height,
    this.width,
    this.borderRadius = 12.0,
    this.depth = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFE6E6E6);

    return ClayContainer(
      color: backgroundColor,
      height: height,
      width: width,
      borderRadius: borderRadius,
      depth: depth.toInt(),
      spread: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class NeumorphicIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double borderRadius;
  final double depth;
  final Color? iconColor;

  const NeumorphicIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48.0,
    this.borderRadius = 24.0,
    this.depth = 15.0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFE6E6E6);

    final effectiveIconColor =
        iconColor ?? (themeProvider.isDarkMode ? Colors.white : Colors.black);

    return ClayContainer(
      color: backgroundColor,
      height: size,
      width: size,
      borderRadius: borderRadius,
      depth: depth.toInt(),
      spread: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Icon(icon, color: effectiveIconColor, size: size * 0.5),
        ),
      ),
    );
  }
}

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double borderRadius;
  final double depth;
  final Color? backgroundColor;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.borderRadius = 12.0,
    this.depth = 20.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final effectiveBackgroundColor =
        backgroundColor ??
        (themeProvider.isDarkMode
            ? const Color(0xFF2D2D2D)
            : const Color(0xFFE6E6E6));

    return Container(
      margin: margin,
      child: ClayContainer(
        color: effectiveBackgroundColor,
        height: height,
        width: width,
        borderRadius: borderRadius,
        depth: depth.toInt(),
        spread: 2,
        child: Container(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}

class NeumorphicSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final double height;
  final double borderRadius;

  const NeumorphicSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
    this.height = 8.0,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode
        ? const Color(0xFF2D2D2D)
        : const Color(0xFFE6E6E6);

    final trackColor = themeProvider.isDarkMode
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFD0D0D0);

    return ClayContainer(
      color: backgroundColor,
      height: height + 8,
      borderRadius: borderRadius,
      depth: -5,
      spread: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: height,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: height + 2),
            overlayShape: RoundSliderOverlayShape(overlayRadius: height + 6),
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor: trackColor,
            thumbColor: backgroundColor,
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
      ),
    );
  }
}
