class SocialRegisterRequestModel {
  String? email;
  String? name;
  String? authId;
  String? token;
  String? timeZone;

  SocialRegisterRequestModel({this.email, this.name, this.authId,this.token,this.timeZone});

  SocialRegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    authId = json['auth_id'];
    token = json['device_token'];
    timeZone = json['time_zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['auth_id'] = this.authId;
    data['device_token'] = this.token;
    data['time_zone'] = this.timeZone;
    return data;
  }
}