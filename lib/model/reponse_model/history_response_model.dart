// ignore_for_file: non_constant_identifier_names

class HistoryResponseModel {
  String? date;
  int? score;

  HistoryResponseModel({this.date, this.score});

  HistoryResponseModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['date'] = date;
    data['score'] = score;
    return data;
  }
}

class HistoryResponseListModel {
  List<HistoryResponseModel> values = [];
  NaqResponseListModel() {
    values = [];
  }
  HistoryResponseListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      HistoryResponseModel model = HistoryResponseModel.fromJson(area);
      values.add(model);
    }
  }
}