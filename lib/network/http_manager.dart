
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_quiz_app/model/reponse_model/column_read_data_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/response_history_model.dart';
import 'package:flutter_quiz_app/model/request_model/change_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/forgot_password_request.dart';
import 'package:flutter_quiz_app/model/request_model/login_request.dart';
import 'package:flutter_quiz_app/model/request_model/register_create_request.dart';
import 'package:flutter_quiz_app/model/reponse_model/login_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/response_email_request.dart';
import 'package:flutter_quiz_app/model/request_model/social_login_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_data_saving_request.dart';
import 'package:flutter_quiz_app/network/response_handler.dart';

import '../model/request_model/answer_reques_model.dart';
import '../model/request_model/column_delete_request.dart';
import '../model/request_model/column_read_list_request.dart';
import '../model/request_model/logout_user_request.dart';
import '../model/request_model/read_trellis_model.dart';
import '../model/request_model/session_entry_request.dart';
import '../model/request_model/trellis_delete_request_model.dart';
import '../model/request_model/trellis_identity_request_model.dart';
import '../model/request_model/trellis_ladder_request_model.dart';
import '../model/request_model/trellis_principles_request_model.dart';
import '../model/request_model/tribe_data_saving_request.dart';
import '../model/request_model/user_email_response_request.dart';
import 'api_urls.dart';

class HTTPManager {
  final ResponseHandler _handler = ResponseHandler();

  Future<dynamic> registerUser(RegisterRequestModel registerRequestModel) async {
    const url = ApplicationURLs.API_REGISTER_USER;
    // ignore: avoid_print
    print(url);

    final response =
        await _handler.post(Uri.parse(url),registerRequestModel.toJson());
    return response;
  }


  Future<dynamic> treeGrowth(LogoutRequestModel logoutRequestModel) async {
    const url = ApplicationURLs.API_TREE_GROWTH;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    return response;
  }

  Future<dynamic> registerUserWithGoogle(SocialRegisterRequestModel socialRegisterRequestModel) async {
    const url = ApplicationURLs.API_REGISTER_USER_WITH_GOOGLE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),socialRegisterRequestModel.toJson());
    return response;
  }

  Future<dynamic> loginUser(LoginRequestModel loginRequestModel) async {

    const url = ApplicationURLs.API_LOGIN;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url), loginRequestModel.toJson());
    //LoginResponseModel loginResponseModel = LoginResponseModel.fromJson(response);
    // if(loginResponseModel.message != null || loginResponseModel.message != '') {
    //   return loginResponseModel;
    // } else {
     return response;
   // }
  }

  Future<dynamic> changePassword(ChangePasswordRequestModel changePasswordRequestModel) async {
    const url = ApplicationURLs.API_CHANGE_PASSWORD;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),changePasswordRequestModel.toJson());
    return response;
  }

  Future<dynamic> changeProfile(ChangeProfileRequestModel changeProfileRequestModel) async {
    const url = ApplicationURLs.API_CHANGE_PROFILE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),changeProfileRequestModel.toJson());
    return response;
  }

  Future<QuestionListModel> getQuestions() async {

    const url = ApplicationURLs.API_QUESTIONS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
    QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return questionAnswerResponseModel;
  }

  Future<dynamic> userAnswer(AnswerRequestModel answerRequestModel) async {

    const url = ApplicationURLs.API_ANSWER;
    // ignore: avoid_print
    print(url);
    // ignore: avoid_print
    print(answerRequestModel.options??"");
    // ignore: avoid_print
    print(answerRequestModel.text??"");

    final response =
    await _handler.post(Uri.parse(url), answerRequestModel.toJson());

    return response;

  }

  Future<dynamic> forgotPassword(ForgotPasswordRequestModel forgotPasswordRequestModel) async {

    const url = ApplicationURLs.API_FORGOT_PASSWORD;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url), forgotPasswordRequestModel.toJson());

    return response;

  }

  Future<dynamic> userResponseEmail(UserResponseRequestModel userResponseRequestModel) async {

    const url = ApplicationURLs.API_RESPONSE_EMAIL;
    // ignore: avoid_print
    print(url);
    // ignore: avoid_print
    print(userResponseRequestModel.answerMap);

    final response =
    await _handler.post(Uri.parse(url), userResponseRequestModel.toJson());

    return response;

  }

  Future<dynamic> deleteUser(String userId) async {

    String url = "${ApplicationURLs.API_DELETE}?user_id=$userId";
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
   // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> userEmailResponse(UserEmailResponseRequestModel userEmailResponseRequestModel) async {

    String url = ApplicationURLs.API_EMAIL_RESPONSE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),userEmailResponseRequestModel.toJson());
    return response;
  }

  Future<dynamic> responseHistory(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_RESPONSE_HISTORY;
    //// ignore: avoid_print
    // print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    //// ignore: avoid_print
    // print(response.toString());
    return response;
  }

  Future<dynamic> logoutUser(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_LOGOUT;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

//Trellis Api's Manager
  Future<dynamic> trellisScreen(TrellisDataRequestModel trellisDataRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisDataRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // print(response.toString());
    return response;
  }

  Future<dynamic> trellisTribeScreen(TribeDataRequestModel tribeDataRequestModel) async {

    String url = ApplicationURLs.API_TRIBE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeDataRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    //// ignore: avoid_print
    // print(response.toString());
    return response;
  }

  Future<dynamic> trellisLadderForGoals(TrellisLadderGoalsRequestModel trellisLadderGoalsRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_LADDER;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisLadderGoalsRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> trellisLadderForAchievements(TrellisLadderAchievementRequestModel trellisLadderAchievementRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_LADDER;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisLadderAchievementRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> trellisIdentity(TrellisIdentityRequestModel trellisIdentityRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_IDENTITY;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisIdentityRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> trellisPrinciples(TrellisPrinciplesRequestModel trellisPrinciplesRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_PRINCIPLES;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisPrinciplesRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> trellisRead(TrellisRequestModel trellisRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_READ;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> trellisDelete(TrellisDeleteRequestModel trellisDeleteRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_DELETE;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisDeleteRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  //Column/Session Api's
  Future<dynamic> sessionEntry(ColumnAddRequestModel columnAddRequestModel) async {
    const url = ApplicationURLs.API_COLUMN_ADD;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),columnAddRequestModel.toJson());
    return response;
  }

  Future<dynamic> sessionRead(ColumnReadRequestModel columnReadRequestModel) async {
    const url = ApplicationURLs.API_COLUMN_READ;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),columnReadRequestModel.toJson());
    return response;
  }

  Future<dynamic> sessionDelete(ColumnDeleteRequestModel columnDeleteRequestModel) async {
    const url = ApplicationURLs.API_COLUMN_DELETE;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),columnDeleteRequestModel.toJson());
    return response;
  }

  Future<dynamic> getAppVersion() async {
    const url = ApplicationURLs.API_APP_VERSION;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
    return response;
  }


}
