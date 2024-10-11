class LeavingReasonResponseModel {
  int? status;
  String? message;
  List<Reasons>? reasons;

  LeavingReasonResponseModel({this.status, this.message, this.reasons});

  LeavingReasonResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      reasons = <Reasons>[];
      json['data'].forEach((v) {
        reasons!.add(new Reasons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.reasons != null) {
      data['data'] = this.reasons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reasons {
  String? id;
  String? reason;

  Reasons({this.id, this.reason});

  Reasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reason'] = this.reason;
    return data;
  }
}
