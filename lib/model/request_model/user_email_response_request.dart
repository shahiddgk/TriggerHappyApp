class UserEmailResponseRequestModel {
  String? status;
  String? userId;

  UserEmailResponseRequestModel({this.status, this.userId});

  UserEmailResponseRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_id'] = userId;
    return data;
  }
}