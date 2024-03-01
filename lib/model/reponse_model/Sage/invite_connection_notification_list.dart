class InvitedNotificationConnectionListResponse {
  int? status;
  List<Data>? data;

  InvitedNotificationConnectionListResponse({this.status, this.data});

  InvitedNotificationConnectionListResponse.fromJson(
      Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? id;
  String? senderId;
  String? receiverId;
  String? role;
  String? message;
  String? image;
  String? senderName;
  String? receiverName;

  Data(
      {this.id,
        this.senderId,
        this.receiverId,
        this.role,
        this.message,
        this.image,
        this.senderName,
        this.receiverName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    role = json['role'];
    message = json['message'];
    image = json['image'];
    senderName = json['sender_name'];
    receiverName = json['receiver_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['role'] = role;
    data['message'] = message;
    data['image'] = image;
    data['sender_name'] = senderName;
    data['receiver_name'] = receiverName;
    return data;
  }
}