class NotificationsModel {
  Content? content;

  NotificationsModel({this.content});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    return data;
  }
}

class Content {
  int? id;
  String? channelKey;
  String? title;
  String? body;
  String? notificationLayout;
  String? largeIcon;
  String? bigPicture;
  bool? showWhen;
  bool? autoDismissible;
  String? privacy;

  Content(
      {this.id,
        this.channelKey,
        this.title,
        this.body,
        this.notificationLayout,
        this.largeIcon,
        this.bigPicture,
        this.showWhen,
        this.autoDismissible,
        this.privacy});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelKey = json['channelKey'];
    title = json['title'];
    body = json['body'];
    notificationLayout = json['notificationLayout'];
    largeIcon = json['largeIcon'];
    bigPicture = json['bigPicture'];
    showWhen = json['showWhen'];
    autoDismissible = json['autoDismissible'];
    privacy = json['privacy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['channelKey'] = this.channelKey;
    data['title'] = this.title;
    data['body'] = this.body;
    data['notificationLayout'] = this.notificationLayout;
    data['largeIcon'] = this.largeIcon;
    data['bigPicture'] = this.bigPicture;
    data['showWhen'] = this.showWhen;
    data['autoDismissible'] = this.autoDismissible;
    data['privacy'] = this.privacy;
    return data;
  }
}
