import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isPressed;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neumorphicColors = theme.neumorphicColors;
    final radius = borderRadius ?? BorderRadius.circular(20);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: neumorphicColors.bgColor,
          borderRadius: radius,
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: neumorphicColors.shadowDark,
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: neumorphicColors.shadowLight,
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                    spreadRadius: -2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: neumorphicColors.shadowDark,
                    offset: const Offset(6, 6),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: neumorphicColors.shadowLight,
                    offset: const Offset(-6, -6),
                    blurRadius: 12,
                  ),
                ],
        ),
        child: child,
      ),
    );
  }
}

class NeumorphicButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isLarge;
  final bool isSelected;
  final Color? iconColor;
  final double? size;

  const NeumorphicButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isLarge = false,
    this.isSelected = false,
    this.iconColor,
    this.size,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neumorphicColors = theme.neumorphicColors;
    final buttonSize = widget.size ?? (widget.isLarge ? 60.0 : 45.0);
    final iconSize = widget.isLarge ? 30.0 : 20.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: neumorphicColors.bgColor,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          boxShadow: _isPressed || widget.isSelected
              ? [
                  BoxShadow(
                    color: neumorphicColors.shadowDark,
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: neumorphicColors.shadowLight,
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                    spreadRadius: -2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: neumorphicColors.shadowDark,
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: neumorphicColors.shadowLight,
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Icon(
          widget.icon,
          color:
              widget.iconColor ??
              (widget.isSelected
                  ? neumorphicColors.accentColor
                  : neumorphicColors.textColor),
          size: iconSize,
        ),
      ),
    );
  }
}

class NeumorphicIcon extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final double? size;

  const NeumorphicIcon({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.size,
  });

  @override
  State<NeumorphicIcon> createState() => _NeumorphicIconState();
}

class _NeumorphicIconState extends State<NeumorphicIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neumorphicColors = theme.neumorphicColors;
    final containerSize = widget.size ?? 52.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: neumorphicColors.bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isPressed || widget.isSelected
              ? [
                  BoxShadow(
                    color: neumorphicColors.shadowDark,
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: neumorphicColors.shadowLight,
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                    spreadRadius: -2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: neumorphicColors.shadowDark,
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: neumorphicColors.shadowLight,
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Icon(
          widget.icon,
          color: widget.isSelected
              ? neumorphicColors.accentColor
              : neumorphicColors.textColor,
          size: 24,
        ),
      ),
    );
  }
}

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isInset;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.isInset = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neumorphicColors = theme.neumorphicColors;
    final radius = borderRadius ?? BorderRadius.circular(16);

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: neumorphicColors.bgColor,
        borderRadius: radius,
        boxShadow: isInset
            ? [
                BoxShadow(
                  color: neumorphicColors.shadowDark,
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: neumorphicColors.shadowLight,
                  offset: const Offset(-2, -2),
                  blurRadius: 4,
                  spreadRadius: -2,
                ),
              ]
            : [
                BoxShadow(
                  color: neumorphicColors.shadowDark,
                  offset: const Offset(6, 6),
                  blurRadius: 12,
                ),
                BoxShadow(
                  color: neumorphicColors.shadowLight,
                  offset: const Offset(-6, -6),
                  blurRadius: 12,
                ),
              ],
      ),
      child: child,
    );
  }
}

class NeumorphicBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NeumorphicBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: NeumorphicContainer(
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == currentIndex;

            return NeumorphicIcon(
              icon: item.icon as IconData,
              isSelected: isSelected,
              onTap: () => onTap(index),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class NeumorphicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const NeumorphicAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neumorphicColors = theme.neumorphicColors;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: neumorphicColors.highlightColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: neumorphicColors.bgColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading:
          leading ??
          (Navigator.canPop(context)
              ? NeumorphicButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                )
              : null),
      actions: actions,
    );
  }
}

class NeumorphicListTile extends StatefulWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;

  const NeumorphicListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.borderRadius,
  });

  @override
  State<NeumorphicListTile> createState() => _NeumorphicListTileState();
}

class _NeumorphicListTileState extends State<NeumorphicListTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      isPressed: _isPressed,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
      onTap: widget.onTap,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: ListTile(
          leading: widget.leading,
          title: widget.title,
          subtitle: widget.subtitle,
          trailing: widget.trailing,
          contentPadding: widget.contentPadding ?? const EdgeInsets.all(16),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

class NeumorphicCustomButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const NeumorphicCustomButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  });

  @override
  State<NeumorphicCustomButton> createState() => _NeumorphicCustomButtonState();
}

class _NeumorphicCustomButtonState extends State<NeumorphicCustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neumorphicColors = theme.neumorphicColors;
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    return GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onPressed != null
          ? (_) => setState(() => _isPressed = false)
          : null,
      onTapCancel: widget.onPressed != null
          ? () => setState(() => _isPressed = false)
          : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        padding: widget.padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: neumorphicColors.bgColor,
          borderRadius: radius,
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: neumorphicColors.shadowDark,
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: neumorphicColors.shadowLight,
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                    spreadRadius: -2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: neumorphicColors.shadowDark,
                    offset: const Offset(6, 6),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: neumorphicColors.shadowLight,
                    offset: const Offset(-6, -6),
                    blurRadius: 12,
                  ),
                ],
        ),
        child: widget.child,
      ),
    );
  }
}

class NeumorphicSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final int? divisions;

  const NeumorphicSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
  });

  @override
  State<NeumorphicSlider> createState() => _NeumorphicSliderState();
}

class _NeumorphicSliderState extends State<NeumorphicSlider> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neumorphicColors = theme.neumorphicColors;

    return NeumorphicContainer(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: BorderRadius.circular(25),
      isInset: true,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: neumorphicColors.accentColor,
          inactiveTrackColor: neumorphicColors.textColor.withAlpha(
            (0.3 * 255).round(),
          ),
          thumbColor: neumorphicColors.accentColor,
          overlayColor: neumorphicColors.accentColor.withAlpha(
            (0.2 * 255).round(),
          ),
          trackHeight: 6,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        ),
        child: Slider(
          value: widget.value,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
