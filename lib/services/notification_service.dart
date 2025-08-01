import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data'; // For Uint8List

class NotificationService {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications(
    Function onNotificationResponse,
  ) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
            onNotificationResponse(notificationResponse.payload);
          },
      onDidReceiveBackgroundNotificationResponse:
          (NotificationResponse notificationResponse) async {
            onNotificationResponse(notificationResponse.payload);
          },
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? mediaFilePath, // Path to media file (unused for now)
  }) async {
    // TODO: Add album art support when metadata library is compatible
    Uint8List? albumArt;

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'media_playback_channel',
          'Media Playback',
          channelDescription: 'Notifications for media playback controls',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          ongoing: true,
          styleInformation: MediaStyleInformation(),
          // ignore: unnecessary_null_comparison
          largeIcon: albumArt != null ? ByteArrayAndroidBitmap(albumArt) : null,
          actions: [
            AndroidNotificationAction(
              'prev',
              'Previous',
              showsUserInterface: false,
            ),
            AndroidNotificationAction(
              'play_pause',
              'Play/Pause',
              showsUserInterface: false,
            ),
            AndroidNotificationAction(
              'next',
              'Next',
              showsUserInterface: false,
            ),
          ],
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
