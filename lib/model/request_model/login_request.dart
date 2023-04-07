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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['device_token'] = this.token;
    return data;
  }
}