class PendingPermissionSentRequestList {
  int? status;
  List<PendingPermissionSentItem>? data;

  PendingPermissionSentRequestList({this.status, this.data});

  PendingPermissionSentRequestList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PendingPermissionSentItem>[];
      json['data'].forEach((v) {
        data!.add(PendingPermissionSentItem.fromJson(v));
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

class PendingPermissionSentItem {
  List<PendingInfo>? pendingInfo;
  FirstUserDetail? firstUserDetail;
  FirstUserDetail? secondUserDetail;
  List<String>? module;

  PendingPermissionSentItem(
      {this.pendingInfo,
        this.firstUserDetail,
        this.secondUserDetail,
        this.module});

  PendingPermissionSentItem.fromJson(Map<String, dynamic> json) {
    if (json['pending_info'] != null) {
      pendingInfo = <PendingInfo>[];
      json['pending_info'].forEach((v) {
        pendingInfo!.add(PendingInfo.fromJson(v));
      });
    }
    firstUserDetail = json['first_user_detail'] != null
        ? FirstUserDetail.fromJson(json['first_user_detail'])
        : null;
    secondUserDetail = json['second_user_detail'] != null
        ? FirstUserDetail.fromJson(json['second_user_detail'])
        : null;
    module = json['module'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pendingInfo != null) {
      data['pending_info'] = pendingInfo!.map((v) => v.toJson()).toList();
    }
    if (firstUserDetail != null) {
      data['first_user_detail'] = firstUserDetail!.toJson();
    }
    if (secondUserDetail != null) {
      data['second_user_detail'] = secondUserDetail!.toJson();
    }
    data['module'] = module;
    return data;
  }
}

class PendingInfo {
  String? id;
  String? permission;
  String? senderId;
  String? receiverId;
  String? connectionId;
  String? image;
  String? senderName;
  String? receiverName;

  PendingInfo(
      {this.id,
        this.permission,
        this.senderId,
        this.receiverId,
        this.connectionId,
        this.image,
        this.senderName,
        this.receiverName});

  PendingInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    permission = json['permission'];
    senderId = json['requester_id'];
    receiverId = json['approver_id'];
    connectionId = json['connection_id'];
    image = json['image'];
    senderName = json['sender_name'];
    receiverName = json['receiver_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['permission'] = permission;
    data['requester_id'] = senderId;
    data['approver_id'] = receiverId;
    data['connection_id'] = connectionId;
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