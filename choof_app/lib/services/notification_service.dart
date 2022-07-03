import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
          playSound: true,
          icon: '@mipmap/ic_noti',
        ),
        iOS: IOSNotificationDetails(
          presentAlert:
              true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
          presentBadge:
              true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
          presentSound:
              true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
          // sound: String?,  // Specifics the file path to play (only from iOS 10 onwards)
          // badgeNumber: int?, // The application's icon badge number
          // attachments: List<IOSNotificationAttachment>?, (only from iOS 10 onwards)
          // subtitle: String?, //Secondary description  (only from iOS 10 onwards)
          // threadIdentifier: String? (only from iOS 10 onwards)
        ));
  }

  static Future init({bool initSchedule = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_noti');
    const ios = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });
  }

  /// Show Noti on Click
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> cancelNotifications(int id) async {
    await _notifications.cancel(id);
  }
}
