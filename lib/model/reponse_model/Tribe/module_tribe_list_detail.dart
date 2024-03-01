class TribeModuleTypeListDetails {
  int? status;
  List<ModuleTypeListItem>? data;

  TribeModuleTypeListDetails({this.status, this.data});

  TribeModuleTypeListDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ModuleTypeListItem>[];
      json['data'].forEach((v) {
        data!.add(ModuleTypeListItem.fromJson(v));
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

class ModuleTypeListItem {
  String? id;
  String? senderId;
  String? receiverId;
  String? connectionId;
  String? module;
  String? permission;
  String? createdAt;

  ModuleTypeListItem(
      {this.id,
        this.senderId,
        this.receiverId,
        this.connectionId,
        this.module,
        this.permission,
        this.createdAt});

  ModuleTypeListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    connectionId = json['connection_id'];
    module = json['module'];
    permission = json['permission'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['connection_id'] = connectionId;
    data['module'] = module;
    data['permission'] = permission;
    data['created_at'] = createdAt;
    return data;
  }
}