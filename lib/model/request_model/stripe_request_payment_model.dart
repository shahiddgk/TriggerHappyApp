// ignore_for_file: unnecessary_new, prefer_collection_literals

class StripePaymentRequestModel {
  String? userId;
  String? token;
  String? packageText;
  String? packageAmount;
  String? packageInterval;

  StripePaymentRequestModel({this.userId, this.token, this.packageText,this.packageAmount,this.packageInterval});

  StripePaymentRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] ;
    token = json['token'] ;
    packageText = json['pkg_text'];
    packageAmount = json['pkg_amount'];
    packageInterval = json['pkg_interval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user_id'] = userId;
    data['token'] = token;
    data['pkg_text'] = packageText;
    data['pkg_amount'] = packageAmount;
    data['pkg_interval'] = packageInterval;

    return data;
  }
}

class StripeCancelRequestModel {
  String? subscriptionId;

  StripeCancelRequestModel({this.subscriptionId});

  StripeCancelRequestModel.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscription_id'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['subscription_id'] = subscriptionId;

    return data;
  }
}

class User {
  int? userid;
  String? useremail;
  String? username;

  User({this.userid, this.useremail, this.username});

  User.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    useremail = json['useremail'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['useremail'] = useremail;
    data['username'] = username;
    return data;
  }
}

class Token {
  String? id;
  String? object;
  Card? card;
  String? clientIp;
  int? created;
  bool? livemode;
  String? type;
  bool? used;

  Token(
      {this.id,
        this.object,
        this.card,
        this.clientIp,
        this.created,
        this.livemode,
        this.type,
        this.used});

  Token.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
    clientIp = json['client_ip'];
    created = json['created'];
    livemode = json['livemode'];
    type = json['type'];
    used = json['used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['object'] = object;
    if (card != null) {
      data['card'] = card!.toJson();
    }
    data['client_ip'] = clientIp;
    data['created'] = created;
    data['livemode'] = livemode;
    data['type'] = type;
    data['used'] = used;
    return data;
  }
}

class Card {
  String? id;
  String? object;
  dynamic addressCity;
  dynamic addressCountry;
  dynamic addressLine1;
  dynamic addressLine1Check;
  dynamic addressLine2;
  dynamic addressState;
  dynamic addressZip;
  dynamic addressZipCheck;
  String? brand;
  String? country;
  String? cvcCheck;
  dynamic dynamicLast4;
  int? expMonth;
  int? expYear;
  String? funding;
  String? last4;
  dynamic name;
  dynamic tokenizationMethod;
  dynamic wallet;

  Card(
      {this.id,
        this.object,
        this.addressCity,
        this.addressCountry,
        this.addressLine1,
        this.addressLine1Check,
        this.addressLine2,
        this.addressState,
        this.addressZip,
        this.addressZipCheck,
        this.brand,
        this.country,
        this.cvcCheck,
        this.dynamicLast4,
        this.expMonth,
        this.expYear,
        this.funding,
        this.last4,
        this.name,
        this.tokenizationMethod,
        this.wallet});

  Card.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    object = json['object'];
    addressCity = json['address_city'];
    addressCountry = json['address_country'];
    addressLine1 = json['address_line1'];
    addressLine1Check = json['address_line1_check'];
    addressLine2 = json['address_line2'];
    addressState = json['address_state'];
    addressZip = json['address_zip'];
    addressZipCheck = json['address_zip_check'];
    brand = json['brand'];
    country = json['country'];
    cvcCheck = json['cvc_check'];
    dynamicLast4 = json['dynamic_last4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    funding = json['funding'];
    last4 = json['last4'];
    name = json['name'];
    tokenizationMethod = json['tokenization_method'];
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['object'] = object;
    data['address_city'] = addressCity;
    data['address_country'] = addressCountry;
    data['address_line1'] = addressLine1;
    data['address_line1_check'] = addressLine1Check;
    data['address_line2'] = addressLine2;
    data['address_state'] = addressState;
    data['address_zip'] = addressZip;
    data['address_zip_check'] = addressZipCheck;
    data['brand'] = brand;
    data['country'] = country;
    data['cvc_check'] = cvcCheck;
    data['dynamic_last4'] = dynamicLast4;
    data['exp_month'] = expMonth;
    data['exp_year'] = expYear;
    data['funding'] = funding;
    data['last4'] = last4;
    data['name'] = name;
    data['tokenization_method'] = tokenizationMethod;
    data['wallet'] = wallet;
    return data;
  }
}

class Package {
  String? text;
  int? amount;
  String? interval;

  Package({this.text, this.amount, this.interval});

  Package.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    amount = json['amount'];
    interval = json['interval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = text;
    data['amount'] = amount;
    data['interval'] = interval;
    return data;
  }
}

