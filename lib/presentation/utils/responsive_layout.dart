import 'package:flutter/material.dart';

class ResponsiveLayout {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Check device type
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  // Get responsive values
  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final size = MediaQuery.of(context).size;
    if (size.width >= desktopBreakpoint && desktop != null) {
      return desktop;
    } else if (size.width >= mobileBreakpoint && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  // Get responsive padding
  static EdgeInsets getPadding(BuildContext context) {
    return getValue(
      context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  // Get responsive grid columns
  static int getGridColumns(BuildContext context) {
    return getValue(context, mobile: 2, tablet: 3, desktop: 4);
  }

  // Get responsive font sizes
  static double getTitleFontSize(BuildContext context) {
    return getValue(context, mobile: 24, tablet: 28, desktop: 32);
  }

  static double getSubtitleFontSize(BuildContext context) {
    return getValue(context, mobile: 16, tablet: 18, desktop: 20);
  }

  static double getBodyFontSize(BuildContext context) {
    return getValue(context, mobile: 14, tablet: 16, desktop: 16);
  }

  // Get responsive icon sizes
  static double getIconSize(BuildContext context) {
    return getValue(context, mobile: 24, tablet: 28, desktop: 32);
  }

  // Get responsive navigation icon sizes
  static double getNavigationIconSize(BuildContext context) {
    return getValue(
      context, 
      mobile: isSmallMobile(context) ? 18 : 20, 
      tablet: 22, 
      desktop: 24
    );
  }

  // Get responsive small icon sizes
  static double getSmallIconSize(BuildContext context) {
    return getValue(
      context, 
      mobile: isSmallMobile(context) ? 16 : 18, 
      tablet: 20, 
      desktop: 22
    );
  }

  // Get responsive sidebar width
  static double getSidebarWidth(BuildContext context) {
    return getValue(
      context,
      mobile: 260.0, // أصغر للموبايل
      tablet: 320.0, // أكبر للتابلت لاستيعاب 3 أعمدة
      desktop: 380.0, // أكبر للديسكتوب لاستيعاب 4 أعمدة
    );
  }

  // Get responsive sidebar grid columns
  static int getSidebarGridColumns(BuildContext context) {
    return getValue(
      context,
      mobile: isSmallMobile(context) ? 1 : 2, // عمود واحد للشاشات الصغيرة جداً
      tablet: 3, // ثلاثة أعمدة للتابلت
      desktop: 4, // أربعة أعمدة للديسكتوب لاستيعاب 20 تطبيق
    );
  }

  // Get responsive card icon size for sidebar
  static double getSidebarCardIconSize(BuildContext context, bool isSelected) {
    final baseSize = getValue(
      context,
      mobile: isSmallMobile(context) ? 28.0 : 32.0,
      tablet: 36.0,
      desktop: 40.0,
    );
    return isSelected ? baseSize + 4 : baseSize;
  }

  // Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    return getValue(
      context,
      mobile: kToolbarHeight,
      tablet: kToolbarHeight + 8,
      desktop: kToolbarHeight + 16,
    );
  }

  // Responsive widget builder
  static Widget responsive(
    BuildContext context, {
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= desktopBreakpoint && desktop != null) {
          return desktop;
        } else if (constraints.maxWidth >= mobileBreakpoint && tablet != null) {
          return tablet;
        }
        return mobile;
      },
    );
  }

  // Check if device is small mobile
  static bool isSmallMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 400;
  }

  // Get safe button size based on screen size
  static double getButtonSize(BuildContext context) {
    return getValue(
      context,
      mobile: isSmallMobile(context) ? 40.0 : 48.0,
      tablet: 56.0,
      desktop: 64.0,
    );
  }


}

// Responsive container widget
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth:
            maxWidth ??
            ResponsiveLayout.getValue(
              context,
              mobile: double.infinity,
              tablet: 800,
              desktop: 1200,
            ),
      ),
      padding: padding ?? ResponsiveLayout.getPadding(context),
      margin: margin,
      child: child,
    );
  }
}

// Responsive grid widget
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? spacing;
  final double? runSpacing;
  final double? childAspectRatio;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing,
    this.runSpacing,
    this.childAspectRatio,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveLayout.getValue(
      context,
      mobile: mobileColumns ?? 2,
      tablet: tabletColumns ?? 3,
      desktop: desktopColumns ?? 4,
    );

    return GridView.count(
      crossAxisCount: columns,
      crossAxisSpacing: spacing ?? 16,
      mainAxisSpacing: runSpacing ?? 16,
      childAspectRatio: childAspectRatio ?? 1.0,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      children: children,
    );
  }
}

// Responsive text widget
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveLayout.getValue(
      context,
      mobile: mobileFontSize ?? 14,
      tablet: tabletFontSize ?? 16,
      desktop: desktopFontSize ?? 16,
    );

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Responsive player controls
class ResponsivePlayerControls extends StatelessWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final bool isPlaying;

  const ResponsivePlayerControls({
    super.key,
    this.onPrevious,
    this.onPlayPause,
    this.onNext,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveLayout.isSmallMobile(context);

    final iconSize = ResponsiveLayout.getValue(
      context,
      mobile: isSmallScreen ? 24.0 : 32.0,
      tablet: 40.0,
      desktop: 48.0,
    );

    final playIconSize = ResponsiveLayout.getValue(
      context,
      mobile: isSmallScreen ? 32.0 : 44.0,
      tablet: 56.0,
      desktop: 64.0,
    );

    final spacing = isSmallScreen ? 8.0 : 16.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: Icon(Icons.skip_previous, size: iconSize),
          padding: isSmallScreen
              ? const EdgeInsets.all(4)
              : const EdgeInsets.all(8),
          constraints: BoxConstraints(minWidth: iconSize, minHeight: iconSize),
        ),
        SizedBox(width: spacing),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: IconButton(
            onPressed: onPlayPause,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: playIconSize,
              color: Colors.white,
            ),
            padding: isSmallScreen
                ? const EdgeInsets.all(4)
                : const EdgeInsets.all(8),
            constraints: BoxConstraints(
              minWidth: playIconSize,
              minHeight: playIconSize,
            ),
          ),
        ),
        SizedBox(width: spacing),
        IconButton(
          onPressed: onNext,
          icon: Icon(Icons.skip_next, size: iconSize),
          padding: isSmallScreen
              ? const EdgeInsets.all(4)
              : const EdgeInsets.all(8),
          constraints: BoxConstraints(minWidth: iconSize, minHeight: iconSize),
        ),
      ],
    );
  }
}

// Responsive list item
class ResponsiveListItem extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ResponsiveListItem({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveLayout.getValue(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 16)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) title!,
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    subtitle!,
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 16), trailing!],
          ],
        ),
      ),
    );
  }
}

// Responsive bottom sheet
class ResponsiveBottomSheet {
  static void show({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    if (ResponsiveLayout.isDesktop(context)) {
      // Show as dialog on desktop
      showDialog(
        context: context,
        barrierDismissible: isDismissible,
        builder: (context) => Dialog(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      );
    } else {
      // Show as bottom sheet on mobile/tablet
      showModalBottomSheet(
        context: context,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        isScrollControlled: true,
        useSafeArea: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        builder: (context) => SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      );
    }
  }
}
