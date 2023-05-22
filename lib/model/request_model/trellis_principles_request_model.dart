class TrellisPrinciplesRequestModel {
  String? userId;
  String? type;
  String? empTruths;
  String? powerlessBelieve;

  TrellisPrinciplesRequestModel({
    this.userId,
    this.type,
    this.empTruths,
    this.powerlessBelieve
  });

  TrellisPrinciplesRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    type = json['type'];
    empTruths = json['emp_truths'];
    powerlessBelieve = json['powerless_believes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['user_id'] = userId;
    data['type'] = type;
    data['emp_truths'] = empTruths;
    data['powerless_believes'] = powerlessBelieve;
    return data;
  }
}