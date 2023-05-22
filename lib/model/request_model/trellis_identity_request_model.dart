class TrellisIdentityRequestModel {
  String? userId;
  String? type;
  String? text;

  TrellisIdentityRequestModel({
    this.userId,
    this.type,
    this.text,

  });

  TrellisIdentityRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    type = json['type'];
    text = json['text'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['user_id'] = userId;
    data['type'] = type;
    data['text'] = text;
    return data;
  }
}