class TrellisDataHistoryResponse {
  int? status;
  String? message;
  Data? data;

  TrellisDataHistoryResponse({this.status, this.message, this.data});

  TrellisDataHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? responseId;
  String? name;
  String? nameDesc;
  String? purpose;
  String? createdAt;

  Data(
      {this.id,
        this.userId,
        this.responseId,
        this.name,
        this.nameDesc,
        this.purpose,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    responseId = json['response_id'];
    name = json['name'];
    nameDesc = json['name_desc'];
    purpose = json['purpose'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['response_id'] = responseId;
    data['name'] = name;
    data['name_desc'] = nameDesc;
    data['purpose'] = purpose;
    data['created_at'] = createdAt;
    return data;
  }
}