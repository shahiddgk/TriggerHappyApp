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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['old_password'] = currentPassword;
    data['new_password'] = newPassword;
    data['user_id'] = userId;
    data['auth_id'] = authId;
    return data;
  }
}

class ChangeProfileRequestModel {
  String? name;
  String? email;
  String? userId;
  String? timeZone;
  String? deviceToken;

  ChangeProfileRequestModel({this.name,this.email,this.userId,this.timeZone,this.deviceToken});

  ChangeProfileRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    userId = json['user_id'];
    timeZone = json['time_zone'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['user_id'] = userId;
    data['time_zone'] = timeZone;
    data['device_token'] = deviceToken;
    return data;
  }
}