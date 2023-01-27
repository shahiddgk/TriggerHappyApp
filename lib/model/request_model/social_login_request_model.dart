class SocialRegisterRequestModel {
  String? email;
  String? name;
  String? authId;

  SocialRegisterRequestModel({this.email, this.name, this.authId});

  SocialRegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    authId = json['auth_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['auth_id'] = this.authId;
    return data;
  }
}