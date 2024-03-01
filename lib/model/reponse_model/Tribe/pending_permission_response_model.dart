class PendingPermissionList {
  int? status;
  List<PendingPermissionListDetails>? data;

  PendingPermissionList({this.status, this.data});

  PendingPermissionList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PendingPermissionListDetails>[];
      json['data'].forEach((v) {
        data!.add(PendingPermissionListDetails.fromJson(v));
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

class PendingPermissionListDetails {
  PendingInfo? pendingInfo;
  FirstUserDetail? firstUserDetail;
  FirstUserDetail? secondUserDetail;

  PendingPermissionListDetails({this.pendingInfo, this.firstUserDetail, this.secondUserDetail});

  PendingPermissionListDetails.fromJson(Map<String, dynamic> json) {
    pendingInfo = json['pending_info'] != null
        ? PendingInfo.fromJson(json['pending_info'])
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
    if (pendingInfo != null) {
      data['pending_info'] = pendingInfo!.toJson();
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

class PendingInfo {
  String? id;
  String? permission;
  String? module;
  String? connectionId;
  String? senderId;
  String? receiverId;
  String? image;
  String? senderName;
  String? receiverName;

  PendingInfo(
      {this.id,
        this.permission,
        this.module,
        this.connectionId,
        this.senderId,
        this.receiverId,
        this.image,
        this.senderName,
        this.receiverName});

  PendingInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    permission = json['permission'];
    module = json['module'];
    connectionId = json['connection_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    image = json['image'];
    senderName = json['sender_name'];
    receiverName = json['receiver_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['permission'] = permission;
    data['module'] = module;
    data['connection_id'] = connectionId;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['image'] = image;
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