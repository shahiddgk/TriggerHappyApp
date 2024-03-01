class SageFeedbackListResponse {
  int? status;
  List<SageFeedback>? sageFeedback;

  SageFeedbackListResponse({this.status, this.sageFeedback});

  SageFeedbackListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      sageFeedback = <SageFeedback>[];
      json['data'].forEach((v) {
        sageFeedback!.add(SageFeedback.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (sageFeedback != null) {
      data['data'] = sageFeedback!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SageFeedback {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  String? sharedId;
  String? createdAt;

  SageFeedback(
      {this.id,
        this.senderId,
        this.receiverId,
        this.message,
        this.sharedId,
        this.createdAt});

  SageFeedback.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    senderId = json['requester_id'].toString();
    receiverId = json['approver_id'].toString();
    message = json['message'].toString();
    sharedId = json['shared_id'].toString();
    createdAt = json['created_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['requester_id'] = senderId;
    data['approver_id'] = receiverId;
    data['message'] = message;
    data['shared_id'] = sharedId;
    data['created_at'] = createdAt;
    return data;
  }
}