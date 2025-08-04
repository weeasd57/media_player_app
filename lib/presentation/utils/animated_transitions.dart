import 'package:flutter/material.dart';

// Fade transition animation
class FadeRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadeRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
}

// Slide transition animation
class SlideRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  SlideRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}

// Scale transition animation
class ScaleRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  ScaleRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: child,
          );
        },
      );
}

// Sidebar slide animation
class SidebarTransition extends StatelessWidget {
  final Widget child;
  final bool isCollapsed;
  final bool isRtl;
  final Duration duration;
  final Curve curve;

  const SidebarTransition({
    super.key,
    required this.child,
    required this.isCollapsed,
    this.isRtl = false,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(isCollapsed ? (isRtl ? 1.0 : -1.0) * 0.2 : 0.0, 0.0),
      duration: duration,
      curve: curve,
      child: AnimatedOpacity(
        opacity: isCollapsed ? 0.0 : 1.0,
        duration: duration,
        curve: curve,
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          width: isCollapsed ? 0.0 : null,
          child: child,
        ),
      ),
    );
  }
}

// Content slide animation that adjusts based on sidebar state
class ContentTransition extends StatelessWidget {
  final Widget child;
  final bool isSidebarCollapsed;
  final bool isRtl;
  final Duration duration;
  final Curve curve;

  const ContentTransition({
    super.key,
    required this.child,
    required this.isSidebarCollapsed,
    this.isRtl = false,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      padding: EdgeInsets.only(
        left: isRtl ? 0 : (isSidebarCollapsed ? 70 : 280),
        right: isRtl ? (isSidebarCollapsed ? 70 : 280) : 0,
      ),
      child: child,
    );
  }
}
