class UserActivityResponse {
  int? status;
  String? message;
  String? userId;
  String? name;
  String? date;
  String? minNaqResponse;
  String? maxNaqResponse;
  String? level;
  String? delta;
  String? countPire;
  String? countTrellis;
  String? countColumn;
  String? countLadder;
  String? totalCount;
  String? sumActiveReminders;
  String? sumYesReminders;
  String? sumReminders;

  UserActivityResponse(
      {this.status,
        this.message,
        this.userId,
        this.name,
        this.date,
        this.minNaqResponse,
        this.maxNaqResponse,
        this.level,
        this.delta,
        this.countPire,
        this.countTrellis,
        this.countColumn,
        this.countLadder,
        this.totalCount,
        this.sumActiveReminders,
        this.sumYesReminders,
        this.sumReminders});

  UserActivityResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'].toString();
    userId = json['user_id'].toString();
    name = json['name'].toString();
    date = json['date'].toString();
    minNaqResponse = json['min_naq_response'].toString();
    maxNaqResponse = json['max_naq_response'].toString();
    level = json['level'].toString();
    delta = json['delta'].toString();
    countPire = json['count_pire'].toString();
    countTrellis = json['count_trellis'].toString();
    countColumn = json['count_column'].toString();
    countLadder = json['count_ladder'].toString();
    totalCount = json['total_count'].toString();
    sumActiveReminders = json['sum_active_reminders'].toString();
    sumYesReminders = json['sum_yes_reminders'].toString();
    sumReminders = json['sum_reminders'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['user_id'] = userId;
    data['name'] = name;
    data['date'] = date;
    data['min_naq_response'] = minNaqResponse;
    data['max_naq_response'] = maxNaqResponse;
    data['level'] = level;
    data['delta'] = delta;
    data['count_pire'] = countPire;
    data['count_trellis'] = countTrellis;
    data['count_column'] = countColumn;
    data['count_ladder'] = countLadder;
    data['total_count'] = totalCount;
    data['sum_active_reminders'] = sumActiveReminders;
    data['sum_yes_reminders'] = sumYesReminders;
    data['sum_reminders'] = sumReminders;
    return data;
  }
}