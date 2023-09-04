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
    message = json['message'] ?? " ";
    userId = json['user_id'] ?? " ";
    name = json['name'] ?? " ";
    date = json['date'] ?? " ";
    minNaqResponse = json['min_naq_response'] ?? " ";
    maxNaqResponse = json['max_naq_response'] ?? " ";
    level = json['level'] ?? " ";
    delta = json['delta'] ?? " ";
    countPire = json['count_pire'] ?? " ";
    countTrellis = json['count_trellis'] ?? " ";
    countColumn = json['count_column'] ?? " ";
    countLadder = json['count_ladder'] ?? " ";
    totalCount = json['total_count'] ?? " ";
    sumActiveReminders = json['sum_active_reminders'] ?? " ";
    sumYesReminders = json['sum_yes_reminders'] ?? " ";
    sumReminders = json['sum_reminders'] ?? " ";
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