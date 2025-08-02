import 'package:flutter/material.dart';

/// نموذج يمثل تطبيق في الـ sidebar
class AppItem {
  final String id;
  final String name;
  final String nameAr;
  final IconData icon;
  final List<AppPage> pages;
  final Color primaryColor;
  final Color secondaryColor;

  const AppItem({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
    required this.pages,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

/// نموذج يمثل صفحة داخل التطبيق
class AppPage {
  final String id;
  final String name;
  final String nameAr;
  final IconData icon;
  final Widget screen;

  const AppPage({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.icon,
    required this.screen,
  });
}
