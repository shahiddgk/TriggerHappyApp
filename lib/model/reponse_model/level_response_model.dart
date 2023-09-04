class LevelHistoryResponse {
  int? status;
  List<ResponseData>? responseData;

  LevelHistoryResponse({this.status, this.responseData});

  LevelHistoryResponse.fromJson(Map<String, dynamic> json) {
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
  int? score;
  String? mobileImageUrl;
  String? ipadImageUrl;
  List<TrellisCount>? trellisCount;
  List<TrellisCount>? ladderCount;
  List<TrellisCount>? columnCount;
  List<TrellisCount>? pireCount;
  List<TrellisCount>? naqCount;

  ResponseData(
      {this.date,
        this.score,
        this.mobileImageUrl,
        this.ipadImageUrl,
        this.trellisCount,
        this.ladderCount,
        this.columnCount,
        this.pireCount,
        this.naqCount});

  ResponseData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    score = json['score'];
    mobileImageUrl = json['mobile_image_url'];
    ipadImageUrl = json['ipad_image_url'];
    if (json['trellis_count'] != null) {
      trellisCount = <TrellisCount>[];
      json['trellis_count'].forEach((v) {
        trellisCount!.add(TrellisCount.fromJson(v));
      });
    }
    if (json['ladder_count'] != null) {
      ladderCount = <TrellisCount>[];
      json['ladder_count'].forEach((v) {
        ladderCount!.add(TrellisCount.fromJson(v));
      });
    }
    if (json['column_count'] != null) {
      columnCount = <TrellisCount>[];
      json['column_count'].forEach((v) {
        columnCount!.add(TrellisCount.fromJson(v));
      });
    }
    if (json['pire_count'] != null) {
      pireCount = <TrellisCount>[];
      json['pire_count'].forEach((v) {
        pireCount!.add(TrellisCount.fromJson(v));
      });
    }
    if (json['naq_count'] != null) {
      naqCount = <TrellisCount>[];
      json['naq_count'].forEach((v) {
        naqCount!.add(TrellisCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['score'] = score;
    data['mobile_image_url'] = mobileImageUrl;
    data['ipad_image_url'] = ipadImageUrl;
    if (trellisCount != null) {
      data['trellis_count'] =
          trellisCount!.map((v) => v.toJson()).toList();
    }
    if (ladderCount != null) {
      data['ladder_count'] = ladderCount!.map((v) => v.toJson()).toList();
    }
    if (columnCount != null) {
      data['column_count'] = columnCount!.map((v) => v.toJson()).toList();
    }
    if (pireCount != null) {
      data['pire_count'] = pireCount!.map((v) => v.toJson()).toList();
    }
    if (naqCount != null) {
      data['naq_count'] = naqCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrellisCount {
  String? responseId;

  TrellisCount({this.responseId});

  TrellisCount.fromJson(Map<String, dynamic> json) {
    responseId = json['response_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_id'] = responseId;
    return data;
  }
}