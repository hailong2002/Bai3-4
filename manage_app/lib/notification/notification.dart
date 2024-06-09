import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

class Noti{
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    var androidInitialize = const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationsSettings = InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification({var id =0, required String title,
    required String body, var payload, required FlutterLocalNotificationsPlugin fln}) async{
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            'channel id 1',
            'MyChannel',
             playSound: true,
             importance: Importance.max,
             priority: Priority.high
        );

    var notiDetails = NotificationDetails(android: androidNotificationDetails);
    await fln.show(0, title, body, notiDetails);
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id 1', 'MyChannel',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future scheduleNotification({int id = 0, String? title, String? body,
        required DateTime scheduledNotificationDateTime}) async {
    final scheduledTime = tz.TZDateTime.from(scheduledNotificationDateTime, tz.getLocation('Asia/Ho_Chi_Minh'));
    return await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        await notificationDetails(),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );
  }

}