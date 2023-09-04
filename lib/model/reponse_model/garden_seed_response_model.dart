class GardenSeedResponseModel {
  int? status;
  String? message;
  List<Result>? result;

  GardenSeedResponseModel({this.status, this.message, this.result});

  GardenSeedResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add( Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? id;
  String? level;
  String? seedName;
  String? count;
  String? status;
  String? image;
  String? createdAt;
  String? seedUsed;

  Result(
      {this.id,
        this.level,
        this.seedName,
        this.count,
        this.status,
        this.image,
        this.createdAt,
      this.seedUsed});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    seedName = json['seed_name'];
    count = json['count'];
    status = json['status'];
    image = json['image'];
    createdAt = json['created_at'];
    seedUsed = json['seed_used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['level'] = level;
    data['seed_name'] = seedName;
    data['count'] = count;
    data['status'] = status;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['seed_used'] = seedUsed;
    return data;
  }
}