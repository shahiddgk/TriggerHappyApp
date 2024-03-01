class SkippedReminderNotification {
  int? status;
  String? message;
  List<ReminderNotification>? result;

  SkippedReminderNotification({this.status, this.message, this.result});

  SkippedReminderNotification.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <ReminderNotification>[];
      json['result'].forEach((v) {
        result!.add(ReminderNotification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReminderNotification {
  String? id;
  String? entityId;
  String? userId;
  String? reminderStop;
  String? createdAt;
  String? text;
  String? dateTime;

  ReminderNotification(
      {this.id,
        this.entityId,
        this.userId,
        this.reminderStop,
        this.createdAt,
        this.text,
        this.dateTime});

  ReminderNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entityId = json['entity_id'];
    userId = json['user_id'];
    reminderStop = json['reminder_stop'];
    createdAt = json['created_date'];
    text = json['text'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['entity_id'] = entityId;
    data['user_id'] = userId;
    data['reminder_stop'] = reminderStop;
    data['created_date'] = createdAt;
    data['text'] = text;
    data['date_time'] = dateTime;
    return data;
  }
}

// class SkippedReminderNotification {
//   int? status;
//   String? message;
//   List<ReminderNotification>? result;
//
//   SkippedReminderNotification({this.status, this.message, this.result});
//
//   SkippedReminderNotification.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['result'] != null) {
//       result = <ReminderNotification>[];
//       json['result'].forEach((v) {
//         result!.add(ReminderNotification.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (result != null) {
//       data['result'] = result!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ReminderNotification {
//   String? id;
//   String? userId;
//   String? entityId;
//   String? text;
//   String? dateTime;
//   String? reminderStop;
//   String? createdAt;
//
//   ReminderNotification(
//       {this.id,
//         this.userId,
//         this.entityId,
//         this.text,
//         this.dateTime,
//         this.reminderStop,
//         this.createdAt,});
//
//   ReminderNotification.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     entityId = json['entity_id'];
//     text = json['text'];
//     dateTime = json['date_time'];
//     reminderStop = json['reminder_stop'];
//     createdAt = json['created_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_id'] = userId;
//     data['entity_id'] = entityId;
//     data['text'] = text;
//     data['date_time'] = dateTime;
//     data['reminder_stop'] = reminderStop;
//     data['created_at'] = createdAt;
//     return data;
//   }
// }