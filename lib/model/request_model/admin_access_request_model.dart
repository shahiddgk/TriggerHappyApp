class AdminAccessRequestModel {
  String? userId;
  String? adminAccess;

  AdminAccessRequestModel({this.userId,this.adminAccess,});

  AdminAccessRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    adminAccess = json['admin_access'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['admin_access'] = adminAccess;
    return data;
  }
}