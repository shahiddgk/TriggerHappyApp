class HistoryResponseModel {
  int? status;
  List<ResponseHistory>? responseHistory;

  HistoryResponseModel({this.status, this.responseHistory});

  HistoryResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response_history'] != null) {
      responseHistory = <ResponseHistory>[];
      json['response_history'].forEach((v) {
        responseHistory!.add(ResponseHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (responseHistory != null) {
      data['response_history'] =
          responseHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseHistory {
  String? date;
  int? score;

  ResponseHistory({this.date, this.score});

  ResponseHistory.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['score'] = score;
    return data;
  }
}