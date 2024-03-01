class SageFeedbackAddRequest {
  String? senderId;
  String? recieverId;
  String? shareId;
  String? message;

  SageFeedbackAddRequest({this.senderId,this.recieverId,this.message,this.shareId});

  SageFeedbackAddRequest.fromJson(Map<String, dynamic> json) {
    senderId = json['requester_id'];
    recieverId = json['approver_id'];
    shareId = json['shared_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['requester_id'] = senderId;
    data['approver_id'] = recieverId;
    data['shared_id'] = shareId;
    data['message'] = message;

    return data;
  }
}