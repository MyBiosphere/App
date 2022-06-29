import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future notificationDefaultSound(flutterNotificationPlugin, title, desc) async{

  var androidPlatformChannelSpecifics =
  const AndroidNotificationDetails(
    'Notification Channel ID',
    'Channel Name',
    // 'Description',
    importance: Importance.max,
    priority: Priority.high,
  );

  var iOSPlatformChannelSpecifics =
  IOSNotificationDetails();

  var platformChannelSpecifics =
  NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
  );

  flutterNotificationPlugin.show(
      0,
      title,
      desc,
      platformChannelSpecifics,
      payload: 'Default Sound'
  );
}