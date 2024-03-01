class ProUserResponse {
  int? status;
  List<ProUserListItem>? responses;

  ProUserResponse({this.status, this.responses});

  ProUserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['responses'] != null) {
      responses = <ProUserListItem>[];
      json['responses'].forEach((v) {
        responses!.add(ProUserListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (responses != null) {
      data['responses'] = responses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProUserListItem {
  String? id;
  String? name;
  String? email;
  String? timeZone;
  String? image;

  ProUserListItem({this.id, this.name, this.email, this.timeZone, this.image});

  ProUserListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    timeZone = json['time_zone'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['time_zone'] = timeZone;
    data['image'] = image;
    return data;
  }
}