class NewGardenResponseModel {
  int? status;
  List<ResponseData>? responseData;

  NewGardenResponseModel({this.status, this.responseData});

  NewGardenResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['response_data'] != null) {
      responseData = <ResponseData>[];
      json['response_data'].forEach((v) {
        responseData!.add(ResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (responseData != null) {
      data['response_data'] =
          responseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseData {
  String? date;
  String? score;
  String? mobileImageUrl;
  String? ipadImageUrl;
  String? ladderCount;
  String? trellisCount;
  String? columnCount;
  List<PireCount>? pireCount;
  List<PireCount>? naqCount;

  ResponseData({this.date,this.score,this.mobileImageUrl,this.ipadImageUrl,this.ladderCount,this.trellisCount,this.columnCount, this.pireCount, this.naqCount});

  ResponseData.fromJson(Map<String, dynamic> json) {
    date = json['date'].toString();
    score = json['score'].toString();
    mobileImageUrl = json['mobile_image_url'].toString();
    ipadImageUrl = json['ipad_image_url'].toString();
    trellisCount = json['trellis_count'].toString();
    ladderCount = json['ladder_count'].toString();
    columnCount = json['column_count'].toString();
    if (json['pire_count'] != null) {
      pireCount = <PireCount>[];
      json['pire_count'].forEach((v) {
        pireCount!.add(PireCount.fromJson(v));
      });
    }
    if (json['naq_count'] != null) {
      naqCount = <PireCount>[];
      json['naq_count'].forEach((v) {
        naqCount!.add(PireCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['score'] = score;
    data['mobile_image_url'] = mobileImageUrl;
    data['ipad_image_url'] = ipadImageUrl;
    data['trellis_count'] = trellisCount;
    data['ladder_count'] = ladderCount;
    data['column_count'] = columnCount;
    if (pireCount != null) {
      data['pire_count'] = pireCount!.map((v) => v.toJson()).toList();
    }
    if (naqCount != null) {
      data['naq_count'] = naqCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PireCount {
  String? responseId;

  PireCount({this.responseId});

  PireCount.fromJson(Map<String, dynamic> json) {
    responseId = json['response_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_id'] = responseId;
    return data;
  }
}
