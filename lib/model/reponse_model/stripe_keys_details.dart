class StripeKeysDetailsModelClass {
  int? status;
  String? message;
  Data? data;

  StripeKeysDetailsModelClass({this.status, this.message, this.data});

  StripeKeysDetailsModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {

  String? stripeTestKey;
  String? stripeLiveKey;

  Data(
      {
        this.stripeTestKey,
        this.stripeLiveKey,});

  Data.fromJson(Map<String, dynamic> json) {
    stripeTestKey = json['test_public_key'];
    stripeLiveKey = json['live_public_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['test_public_key'] = stripeTestKey;
    data['live_public_key'] = stripeLiveKey;
    return data;
  }
}