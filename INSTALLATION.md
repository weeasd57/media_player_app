# دليل التثبيت والتشغيل - Installation Guide

هذا الدليل يوضح كيفية تثبيت وتشغيل تطبيق مشغل الوسائط على أنظمة مختلفة.

## المتطلبات الأساسية

### 1. تثبيت Flutter SDK

#### على Windows:
1. تحميل Flutter SDK من [الموقع الرسمي](https://docs.flutter.dev/get-started/install/windows)
2. فك الضغط في مجلد مثل `C:\flutter`
3. إضافة `C:\flutter\bin` إلى متغير PATH
4. تشغيل `flutter doctor` للتحقق من التثبيت

#### على macOS:
```bash
# باستخدام Homebrew
brew install flutter

# أو تحميل مباشر
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.x.x-stable.zip
unzip flutter_macos_3.x.x-stable.zip
export PATH="$PATH:`pwd`/flutter/bin"
```

#### على Linux:
```bash
# تحميل Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.x.x-stable.tar.xz
tar xf flutter_linux_3.x.x-stable.tar.xz

# إضافة إلى PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# التحقق من التثبيت
flutter doctor
```

### 2. تثبيت Android SDK

#### الطريقة الأولى: عبر Android Studio
1. تحميل وتثبيت [Android Studio](https://developer.android.com/studio)
2. تشغيل Android Studio وتثبيت Android SDK
3. تكوين متغيرات البيئة:
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   ```

#### الطريقة الثانية: أدوات سطر الأوامر فقط
```bash
# تحميل أدوات سطر الأوامر
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
unzip commandlinetools-linux-11076708_latest.zip -d cmdline-tools
mkdir -p cmdline-tools/latest
mv cmdline-tools/cmdline-tools/* cmdline-tools/latest/

# تكوين متغيرات البيئة
export ANDROID_HOME=$HOME/cmdline-tools
export PATH=$PATH:$ANDROID_HOME/latest/bin

# قبول التراخيص
sdkmanager --licenses
```

### 3. تثبيت Java Development Kit (JDK)

```bash
# على Ubuntu/Debian
sudo apt update
sudo apt install openjdk-17-jdk

# على macOS
brew install openjdk@17

# على Windows
# تحميل من موقع Oracle أو OpenJDK
```

## تحضير المشروع

### 1. استنساخ المشروع
```bash
git clone [repository-url]
cd media_player_app
```

### 2. تحديث التبعيات
```bash
flutter pub get
```

### 3. التحقق من الإعداد
```bash
flutter doctor
```

يجب أن تظهر علامات ✓ خضراء للعناصر التالية:
- Flutter SDK
- Android toolchain
- Connected device (إذا كان هناك جهاز متصل)

## تشغيل التطبيق

### 1. على المحاكي

#### إنشاء محاكي Android:
```bash
# عرض المحاكيات المتاحة
flutter emulators

# إنشاء محاكي جديد
flutter emulators --create --name test_emulator

# تشغيل المحاكي
flutter emulators --launch test_emulator
```

#### تشغيل التطبيق:
```bash
flutter run
```

### 2. على جهاز حقيقي

#### تفعيل وضع المطور:
1. الذهاب إلى الإعدادات > حول الهاتف
2. النقر على "رقم الإصدار" 7 مرات
3. العودة للإعدادات > خيارات المطور
4. تفعيل "تصحيح أخطاء USB"

#### توصيل الجهاز:
```bash
# التحقق من اتصال الجهاز
adb devices

# تشغيل التطبيق
flutter run
```

## بناء التطبيق للإنتاج

### 1. بناء APK
```bash
# بناء APK للإصدار
flutter build apk --release

# بناء APK منفصل لكل معمارية
flutter build apk --split-per-abi
```

### 2. بناء App Bundle (موصى به لـ Google Play)
```bash
flutter build appbundle --release
```

### 3. مواقع الملفات المبنية
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`

## إعداد التوقيع (للنشر)

### 1. إنشاء مفتاح التوقيع
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. إنشاء ملف key.properties
```properties
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<location-of-the-key-store-file>
```

### 3. تحديث build.gradle
إضافة إعدادات التوقيع في `android/app/build.gradle`

## استكشاف الأخطاء

### مشاكل شائعة:

#### 1. خطأ "Flutter SDK not found"
```bash
# التحقق من مسار Flutter
which flutter
echo $PATH

# إعادة تعيين المسار
export PATH="$PATH:/path/to/flutter/bin"
```

#### 2. خطأ "Android SDK not found"
```bash
# التحقق من ANDROID_HOME
echo $ANDROID_HOME

# تعيين المسار الصحيح
export ANDROID_HOME=/path/to/android/sdk
flutter config --android-sdk $ANDROID_HOME
```

#### 3. خطأ "Gradle build failed"
```bash
# تنظيف المشروع
flutter clean
flutter pub get

# إعادة البناء
flutter build apk
```

#### 4. مشاكل الأذونات
```bash
# منح أذونات التنفيذ
chmod +x android/gradlew

# تحديث Gradle Wrapper
cd android
./gradlew wrapper --gradle-version 7.5
```

## تحسين الأداء

### 1. تقليل حجم APK
```bash
# تفعيل ProGuard/R8
flutter build apk --release --shrink

# بناء منفصل لكل معمارية
flutter build apk --split-per-abi
```

### 2. تحسين وقت البناء
```bash
# استخدام Gradle Daemon
echo "org.gradle.daemon=true" >> android/gradle.properties

# زيادة ذاكرة Gradle
echo "org.gradle.jvmargs=-Xmx4g" >> android/gradle.properties
```

## الدعم والمساعدة

### موارد مفيدة:
- [وثائق Flutter الرسمية](https://docs.flutter.dev/)
- [دليل Android للمطورين](https://developer.android.com/docs)
- [مجتمع Flutter](https://flutter.dev/community)

### للحصول على المساعدة:
1. تحقق من ملف README.md
2. ابحث في Issues على GitHub
3. اطرح سؤالاً في مجتمع Flutter

---

**ملاحظة:** تأكد من تحديث Flutter SDK بانتظام للحصول على أحدث الميزات وإصلاحات الأمان:
```bash
flutter upgrade
```

