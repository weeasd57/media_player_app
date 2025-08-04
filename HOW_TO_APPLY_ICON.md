# كيفية تطبيق أيقونة التطبيق 🎵

## الخطوات:

### 1. تحويل SVG إلى PNG
- افتح الملف `assets/icons/app_icon_simple.svg` في متصفح أو محرر صور
- احفظه كـ PNG بحجم 512x512 بكسل
- استبدل الملف `assets/icons/app_icon.png` بالملف الجديد

### 2. تطبيق الأيقونة
```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
```

### 3. إعادة البناء
```bash
flutter clean
flutter build apk
```

## النتيجة:
ستظهر أيقونة مشغل الوسائط الجميلة بدلاً من أيقونة Flutter الافتراضية! 🎉