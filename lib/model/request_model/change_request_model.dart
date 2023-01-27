class ChangePasswordRequestModel {
  String? currentPassword;
  String? newPassword;
  String? userId;
  String? authId;

  ChangePasswordRequestModel({this.newPassword,this.currentPassword,this.userId,this.authId});

  ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) {
    currentPassword = json['old_password'];
    newPassword = json['new_password'];
    userId = json['user_id'];
    authId = json['auth_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_password'] = this.currentPassword;
    data['new_password'] = this.newPassword;
    data['user_id'] = this.userId;
    data['auth_id'] = this.authId;
    return data;
  }
}