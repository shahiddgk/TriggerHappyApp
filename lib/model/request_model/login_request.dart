class LoginRequestModel {
  String? email;
  String? rememberme;
  String? password;

  LoginRequestModel({this.email, this.rememberme, this.password});

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    rememberme = json['rememberme'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['rememberme'] = this.rememberme;
    data['password'] = this.password;
    return data;
  }
}