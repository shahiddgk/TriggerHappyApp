class GardenHistoryDetailsRequestModel {
  String? responseId;

  GardenHistoryDetailsRequestModel({this.responseId});

  GardenHistoryDetailsRequestModel.fromJson(Map<String, dynamic> json) {
    responseId = json['response_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_id'] = responseId;
    return data;
  }
}

class LevelHistoryDetailsRequestModel {
  String? responseId;
  String? tableName;

  LevelHistoryDetailsRequestModel({this.responseId,this.tableName});

  LevelHistoryDetailsRequestModel.fromJson(Map<String, dynamic> json) {
    responseId = json['response_id'];
    tableName = json['table_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_id'] = responseId;
    data['table_name'] = tableName;
    return data;
  }
}