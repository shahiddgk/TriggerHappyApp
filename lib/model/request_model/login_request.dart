class LoginRequestModel {
  String? email;
  String? password;
  String? token;

  LoginRequestModel({this.email, this.password,this.token});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    token = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['device_token'] = token;
    return data;
  }
}