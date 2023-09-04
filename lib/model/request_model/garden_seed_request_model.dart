class GardenSeedRequestModel {

  String? seedLevel;
  String? userId;

  GardenSeedRequestModel({ this.seedLevel,this.userId});

  GardenSeedRequestModel.fromJson(Map<String, dynamic> json) {
    seedLevel = json['level'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = seedLevel;
    data['user_id'] = userId;
    return data;
  }
}