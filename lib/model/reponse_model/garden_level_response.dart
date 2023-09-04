class GardenLevelResponse {
  int? status;
  String? message;
  List<GardenLevelListResponseData>? gardenLevelListResponseData;

  GardenLevelResponse({this.status, this.message, this.gardenLevelListResponseData});

  GardenLevelResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      gardenLevelListResponseData = <GardenLevelListResponseData>[];
      json['result'].forEach((v) {
        gardenLevelListResponseData!.add(GardenLevelListResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (gardenLevelListResponseData != null) {
      data['result'] = gardenLevelListResponseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GardenLevelListResponseData {
  String? id;
  String? slug;
  String? name;
  String? status;
  String? createdAt;

  GardenLevelListResponseData({this.id, this.slug, this.name, this.status, this.createdAt});

  GardenLevelListResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slug'] = slug;
    data['name'] = name;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}