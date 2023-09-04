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
  String? userId;
  String? text;
  String? dayList;
  String? dateTime;
  String? status;
  String? snooze;
  String? reminderType;
  String? reminderStop;
  String? endDate;
  String? createdAt;
  String? updatedAt;

  ReminderNotification(
      {this.id,
        this.userId,
        this.text,
        this.dayList,
        this.dateTime,
        this.status,
        this.snooze,
        this.reminderType,
        this.reminderStop,
        this.endDate,
        this.createdAt,
        this.updatedAt});

  ReminderNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    text = json['text'];
    dayList = json['day_list'];
    dateTime = json['date_time'];
    status = json['status'];
    snooze = json['snooze'];
    reminderType = json['reminder_type'];
    reminderStop = json['reminder_stop'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['text'] = text;
    data['day_list'] = dayList;
    data['date_time'] = dateTime;
    data['status'] = status;
    data['snooze'] = snooze;
    data['reminder_type'] = reminderType;
    data['reminder_stop'] = reminderStop;
    data['end_date'] = endDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}