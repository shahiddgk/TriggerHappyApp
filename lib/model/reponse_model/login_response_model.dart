class LoginResponseModel {
  String? userLogin;
  UserSession? userSession;

  LoginResponseModel({this.userLogin, this.userSession, });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    userLogin = json['user_login'];
    userSession = json['user_session'] != null
        ? new UserSession.fromJson(json['user_session'])
        : null;
    // if (json['user_cookie'] != null) {
    //   userCookie = <Null>[];
    //   json['user_cookie'].forEach((v) {
    //     userCookie!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_login'] = userLogin;
    if (userSession != null) {
      data['user_session'] = userSession!.toJson();
    }
    // if (this.userCookie != null) {
    //   data['user_cookie'] = this.userCookie!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class UserSession {
  int? iCiLastRegenerate;
  bool? userLoggedIn;
  String? usertype;
  String? username;
  String? useremail;
  int? userid;

  UserSession(
      {this.iCiLastRegenerate,
        this.userLoggedIn,
        this.usertype,
        this.username,
        this.useremail,
        this.userid});

  UserSession.fromJson(Map<String, dynamic> json) {
    iCiLastRegenerate = json['__ci_last_regenerate'];
    userLoggedIn = json['user_logged_in'];
    usertype = json['usertype'];
    username = json['username'];
    useremail = json['useremail'];
    userid = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__ci_last_regenerate'] = iCiLastRegenerate;
    data['user_logged_in'] = userLoggedIn;
    data['usertype'] = usertype;
    data['username'] = username;
    data['useremail'] = useremail;
    data['userid'] = userid;
    return data;
  }
}