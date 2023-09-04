class TribeDataResponse {
  String? id;
  String? userId;
  String? type;
  String? text;
  String? createdAt;

  TribeDataResponse({this.id, this.userId, this.type, this.text, this.createdAt});

  TribeDataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    text = json['text'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['text'] = text;
    data['created_at'] = createdAt;
    return data;
  }
}

class TribeDataListModel {
  List<TribeDataResponse> values = [];
  TribeDataListModel() {
    values = [];
  }
  TribeDataListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      TribeDataResponse model = TribeDataResponse.fromJson(area);
      values.add(model);
    }
  }
}