class PireNaqListRequestModel {
  String? userId;
  String? type;

  PireNaqListRequestModel({this.userId,this.type,});

  PireNaqListRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['type'] = type;
    return data;
  }
}

class PireNaqSingleItemRequestModel {
  String? responseId;

  PireNaqSingleItemRequestModel({this.responseId});

  PireNaqSingleItemRequestModel.fromJson(Map<String, dynamic> json) {
    responseId = json['response_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_id'] = responseId;
    return data;
  }
}