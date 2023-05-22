class TrellisRequestModel {
  String? userId;

  dynamic name;
  dynamic nameDescription;

  TrellisRequestModel({this.userId,this.name,this.nameDescription});

  TrellisRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    return data;
  }
}