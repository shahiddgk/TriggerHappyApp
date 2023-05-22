class TrellisDeleteRequestModel {
  String? userId;
  String? recordId;
  String? type;

  TrellisDeleteRequestModel({this.userId, this.recordId,this.type});

  TrellisDeleteRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    recordId = json['record_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['record_id'] = recordId;
    data['type'] = type;
    return data;
  }
}