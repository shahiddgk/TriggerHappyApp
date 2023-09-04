class InsertPostReminderRequestModel {
  // String? text;
  String? userId;
  String? text;
  String? date;
  String? endDate;
  String? daysList;
  String? timeType;
  String? time;
  String? status;
  String? reminderType;

  InsertPostReminderRequestModel({this.text, this.userId, this.date,this.endDate, this.daysList,this.timeType,this.time,this.status,this.reminderType});

  InsertPostReminderRequestModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    userId = json['user_id'];
    date = json['date'];
    endDate = json['end_date'];
    daysList = json['day_list'];
    timeType = json['time_type'];
    time = json['time'];
    status = json['status'];
    reminderType = json['reminder_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['user_id'] = userId;
    data['date'] = date;
    data['end_date'] = endDate;
    data['day_list'] = daysList;
    data['time_type'] = timeType;
    data['time'] = time;
    data['status'] = status;
    data['reminder_type'] = reminderType;
    return data;
  }
}

class EditPostReminderRequestModel {
  String? reminderId;
  String? userId;
  String? text;
  String? date;
  String? endDate;
  String? daysList;
  String? timeType;
  String? status;
  String? time;
  String? reminderType;

  EditPostReminderRequestModel({this.reminderId,this.text, this.userId, this.date,this.endDate, this.daysList,this.timeType,this.time,this.status,this.reminderType});

  EditPostReminderRequestModel.fromJson(Map<String, dynamic> json) {
    reminderId = json['id'];
    text = json['text'];
    userId = json['user_id'];
    date = json['date'];
    endDate = json['end_date'];
    daysList = json['day_list'];
    timeType = json['time_type'];
    time = json['time'];
    status = json['status'];
    reminderType = json['reminder_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = reminderId;
    data['text'] = text;
    data['user_id'] = userId;
    data['date'] = date;
    data['end_date'] = endDate;
    data['day_list'] = daysList;
    data['time_type'] = timeType;
    data['time'] = time;
    data['status'] = status;
    data['reminder_type'] = reminderType;
    return data;
  }
}

class DeletePostReminderRequestModel {

  String? reminderId;

  DeletePostReminderRequestModel({ this.reminderId});

  DeletePostReminderRequestModel.fromJson(Map<String, dynamic> json) {
    reminderId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = reminderId;
    return data;
  }
}

class UpdateReminderStatusRequestModel {

  String? reminderId;
  String? status;

  UpdateReminderStatusRequestModel({ this.reminderId,this.status});

  UpdateReminderStatusRequestModel.fromJson(Map<String, dynamic> json) {
    reminderId = json['entity_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entity_id'] = reminderId;
    data['status'] = status;
    return data;
  }
}

class ReminderNotificationForSnoozeRequestModel {

  String? notificationId;
  String? snooze;

  ReminderNotificationForSnoozeRequestModel({ this.notificationId,this.snooze});

  ReminderNotificationForSnoozeRequestModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['entity_id'];
    snooze = json['snooze'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entity_id'] = notificationId;
    data['snooze'] = snooze;
    return data;
  }
}

class ReminderNotificationForStopRequestModel {

  String? notificationId;
  String? reminderStop;

  ReminderNotificationForStopRequestModel({ this.notificationId,this.reminderStop});

  ReminderNotificationForStopRequestModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['entity_id'];
    reminderStop = json['reminder_stop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entity_id'] = notificationId;
    data['reminder_stop'] = reminderStop;
    return data;
  }
}