
class AcceptedConnectionsListResponse {
  int? status;
  List<AcceptedConnectionItem>? data;

  AcceptedConnectionsListResponse({this.status, this.data});

  AcceptedConnectionsListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <AcceptedConnectionItem>[];
      json['data'].forEach((v) {
        data!.add(AcceptedConnectionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AcceptedConnectionItem {
  ConnectionInfo? connectionInfo;
  FirstUserDetail? firstUserDetail;
  FirstUserDetail? secondUserDetail;

  AcceptedConnectionItem({this.connectionInfo, this.firstUserDetail, this.secondUserDetail});

  AcceptedConnectionItem.fromJson(Map<String, dynamic> json) {
    connectionInfo = json['connection_info'] != null
        ? ConnectionInfo.fromJson(json['connection_info'])
        : null;
    firstUserDetail = json['first_user_detail'] != null
        ? FirstUserDetail.fromJson(json['first_user_detail'])
        : null;
    secondUserDetail = json['second_user_detail'] != null
        ? FirstUserDetail.fromJson(json['second_user_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (connectionInfo != null) {
      data['connection_info'] = connectionInfo!.toJson();
    }
    if (firstUserDetail != null) {
      data['first_user_detail'] = firstUserDetail!.toJson();
    }
    if (secondUserDetail != null) {
      data['second_user_detail'] = secondUserDetail!.toJson();
    }
    return data;
  }
}

class ConnectionInfo {
  String? id;
  String? accept;
  String? senderId;
  String? receiverId;
  String? sharingModules;
  String? acceptedModules;
  String? role;
  String? message;
  String? senderName;
  String? receiverName;

  ConnectionInfo(
      {this.id,
        this.accept,
        this.senderId,
        this.receiverId,
        this.sharingModules,
        this.acceptedModules,
        this.role,
        this.message,
        this.senderName,
        this.receiverName});

  ConnectionInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accept = json['accept'];
    senderId = json['requester_id'];
    receiverId = json['approver_id'];
    sharingModules = json['sharing_modules'];
    acceptedModules = json['accepted_modules'];
    role = json['role'];
    message = json['message'];
    senderName = json['sender_name'];
    receiverName = json['receiver_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['accept'] = accept;
    data['requester_id'] = senderId;
    data['approver_id'] = receiverId;
    data['sharing_modules'] = sharingModules;
    data['accepted_modules'] = acceptedModules;
    data['role'] = role;
    data['message'] = message;
    data['sender_name'] = senderName;
    data['receiver_name'] = receiverName;
    return data;
  }
}

class FirstUserDetail {
  String? id;
  String? name;
  String? email;
  String? image;

  FirstUserDetail({this.id, this.name, this.email, this.image});

  FirstUserDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    return data;
  }
}