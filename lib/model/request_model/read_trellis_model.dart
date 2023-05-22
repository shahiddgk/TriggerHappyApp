class TrellisRequestModel {
  String? userId;
  String? table;

  TrellisRequestModel({this.userId, this.table});

  TrellisRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    table = json['table'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['user_id'] = userId;
    data['table'] = table;
    return data;
  }
}