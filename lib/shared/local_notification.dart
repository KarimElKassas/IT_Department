import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:it_department/shared/constants.dart';

class LocalNotification {
  static showNotification(RemoteMessage message) {
    Map<String, dynamic> dataMap = message.data;
    Map<String, String> payloadMap = {};
    dataMap.forEach((key, value) {
      if(key == "payload"){
        Map valueMap = jsonDecode(value);
        payloadMap["senderID"] = valueMap["senderID"].toString();
        payloadMap["channelKey"] = valueMap["channelKey"].toString();
        payloadMap["chatID"] = valueMap["chatID"].toString();
      }

    });
    var notificationType = NotificationLayout.Default;

    notificationType = dataMap["type"] == "Image"
        ? NotificationLayout.BigPicture
        : NotificationLayout.BigText;

    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'image_test',
          channelKey: "image",
          channelName: 'image notifications',
          channelDescription: 'Notification channel for image tests',
          defaultColor: Colors.redAccent,
          ledColor: Colors.yellow,
          channelShowBadge: true,
          importance: NotificationImportance.High,
          enableLights: true,
          defaultPrivacy: NotificationPrivacy.Public,

          //icon: '@mipmap/ic_launcher'
        ),
      ],
    );
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          //with asset image
          id: 1234,
          channelKey: 'image',
          title: dataMap["title"],
          body: dataMap["body"],
          bigPicture: dataMap["image"],
          notificationLayout: notificationType,
          displayOnForeground: true,
          wakeUpScreen: true,
          displayOnBackground: true,
          ticker: "اصحى معانا متنامشى",
          //icon: '@mipmap/ic_launcher'
          payload: payloadMap,
          backgroundColor: lightGreen,

        ),
        actionButtons: [
          NotificationActionButton(
            key: "REPLY_BUTTON",
            label: "رد",
            color: Colors.white,
            isDangerousOption: false,
            buttonType: ActionButtonType.InputField,
          ),
          NotificationActionButton(
            key: "SEEN_BUTTON",
            label: "تمييز كمقروء",
            color: Colors.white,
            isDangerousOption: false,
            buttonType: ActionButtonType.KeepOnTop,
          ),
        ],
    );
  }
}
