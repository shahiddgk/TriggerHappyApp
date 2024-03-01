class SingleShredItemsForTribeResponse {
  int? status;
  String? message;
  List<AllSingleShareItemsList>? data;

  SingleShredItemsForTribeResponse({this.status, this.message, this.data});

  SingleShredItemsForTribeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllSingleShareItemsList>[];
      json['data'].forEach((v) {
        data!.add(AllSingleShareItemsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllSingleShareItemsList {
  String? connectionId;
  List<ShareSingleItemDetails>? shareList;

  AllSingleShareItemsList({this.connectionId, this.shareList});

  AllSingleShareItemsList.fromJson(Map<String, dynamic> json) {
    connectionId = json['connection_id'];
    if (json['share_list'] != null) {
      shareList = <ShareSingleItemDetails>[];
      json['share_list'].forEach((v) {
        shareList!.add(ShareSingleItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['connection_id'] = connectionId;
    if (shareList != null) {
      data['share_list'] = shareList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShareSingleItemDetails {
  String? id;
  String? requesterId;
  String? approverId;
  String? type;
  String? paid;
  String? connectionId;
  String? entityId;
  String? status;
  String? createdAt;

  ShareSingleItemDetails(
      {this.id,
        this.requesterId,
        this.approverId,
        this.type,
        this.paid,
        this.connectionId,
        this.entityId,
        this.status,
        this.createdAt});

  ShareSingleItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requesterId = json['requester_id'];
    approverId = json['approver_id'];
    type = json['type'];
    paid = json['paid'];
    connectionId = json['connection_id'];
    entityId = json['entity_id'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['requester_id'] = requesterId;
    data['approver_id'] = approverId;
    data['type'] = type;
    data['paid'] = paid;
    data['connection_id'] = connectionId;
    data['entity_id'] = entityId;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}