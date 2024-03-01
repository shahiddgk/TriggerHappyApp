class SearchConnectionListResponse {
  int? status;
  String? message;
  List<UsersData>? usersData;

  SearchConnectionListResponse({this.status, this.message, this.usersData});

  SearchConnectionListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['users_data'] != null) {
      usersData = <UsersData>[];
      json['users_data'].forEach((v) {
        usersData!.add(UsersData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (usersData != null) {
      data['users_data'] = usersData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UsersData {
  String? id;
  String? name;
  String? email;
  String? timeZone;
  String? image;
  String? imageUrl;
  String? connectionExist;

  UsersData(
      {this.id,
        this.name,
        this.email,
        this.timeZone,
        this.image,
        this.imageUrl,
        this.connectionExist});

  UsersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    timeZone = json['time_zone'];
    image = json['image'];
    imageUrl = json['image_url'];
    connectionExist = json['connection_exist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['time_zone'] = timeZone;
    data['image'] = image;
    data['image_url'] = imageUrl;
    data['connection_exist'] = connectionExist;
    return data;
  }
}