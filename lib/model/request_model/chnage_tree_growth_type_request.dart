class SetTreeGrowthTypeRequestModel {
  String? userId;
  String? levelId;
  String? seedId;

  SetTreeGrowthTypeRequestModel({this.userId,this.levelId,this.seedId});

  SetTreeGrowthTypeRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    levelId = json['level'];
    seedId = json['seed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['level'] = levelId;
    data['seed'] = seedId;
    return data;
  }
}