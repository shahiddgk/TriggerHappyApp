class PostReminderResponseListModel {
  int? status;
  String? message;
  List<SingleAnswer>? singleAnswer;

  PostReminderResponseListModel({this.status, this.message, this.singleAnswer});

  PostReminderResponseListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['single_answer'] != null) {
      singleAnswer = <SingleAnswer>[];
      json['single_answer'].forEach((v) {
        singleAnswer!.add(SingleAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (singleAnswer != null) {
      data['single_answer'] =
          singleAnswer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SingleAnswer {
  String? id;
  String? userId;
  String? text;
  String? dayList;
  String? date;
  String? endDate;
  String? time;
  String? timeType;
  String? status;
  String? reminderType;

  SingleAnswer(
      {this.id,
        this.userId,
        this.text,
        this.dayList,
        this.date,
        this.endDate,
        this.time,
        this.timeType,
        this.status,
        this.reminderType});

  SingleAnswer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    text = json['text'];
    dayList = json['day_list'].toString();
    date = json['date'];
    endDate = json['end_date'] ?? "";
    time = json['time'];
    status = json['status'];
    timeType = json['time_type'];
    reminderType = json['reminder_type'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['text'] = text;
    data['day_list'] = dayList;
    data['date'] = date;
    data['end_date'] = endDate;
    data['time'] = time;
    data['status'] = status;
    data['time_type'] = timeType;
    data['reminder_type'] = reminderType;
    return data;
  }
}