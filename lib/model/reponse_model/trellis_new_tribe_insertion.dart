class TrellisNewDataAddRequestModel {
  String? userId;
  String? text;
  String? type;

  TrellisNewDataAddRequestModel({this.userId, this.text,this.type});

  TrellisNewDataAddRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    text = json['text'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['text'] = text;
    data['type'] = type;
    return data;
  }
}