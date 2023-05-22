class ColumnDeleteRequestModel {
  String? recordId;

  ColumnDeleteRequestModel({this.recordId, });

  ColumnDeleteRequestModel.fromJson(Map<String, dynamic> json) {
    recordId = json['record_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['record_id'] = recordId;
    return data;
  }
}