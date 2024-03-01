class SageFeedbackRequestModel {
  String? sharedId;

  SageFeedbackRequestModel({this.sharedId});

  SageFeedbackRequestModel.fromJson(Map<String, dynamic> json) {
    sharedId = json['shared_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shared_id'] = sharedId;
    return data;
  }
}