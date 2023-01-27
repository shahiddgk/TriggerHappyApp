
import 'package:flutter/cupertino.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/change_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/login_request.dart';
import 'package:flutter_quiz_app/model/request_model/register_create_request.dart';
import 'package:flutter_quiz_app/model/reponse_model/login_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/social_login_request_model.dart';
import 'package:flutter_quiz_app/network/response_handler.dart';

import '../model/request_model/answer_reques_model.dart';
import 'api_urls.dart';

class HTTPManager {
  final ResponseHandler _handler = ResponseHandler();

  Future<dynamic> registerUser(RegisterRequestModel registerRequestModel) async {
    const url = ApplicationURLs.API_REGISTER_USER;
    print(url);

    final response =
        await _handler.post(Uri.parse(url),registerRequestModel.toJson());
    return response;
  }

  Future<dynamic> registerUserWithGoogle(SocialRegisterRequestModel socialRegisterRequestModel) async {
    const url = ApplicationURLs.API_REGISTER_USER_WITH_GOOGLE;
    print(url);

    final response =
    await _handler.post(Uri.parse(url),socialRegisterRequestModel.toJson());
    return response;
  }

  Future<dynamic> loginUser(LoginRequestModel loginRequestModel) async {

    const url = ApplicationURLs.API_LOGIN;
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
    print(url);

    final response =
    await _handler.post(Uri.parse(url),changePasswordRequestModel.toJson());
    return response;
  }

  Future<QuestionListModel> getQuestions() async {

    const url = ApplicationURLs.API_QUESTIONS;
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
    QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    print(response.toString());
    return questionAnswerResponseModel;
  }

  Future<dynamic> userAnswer(AnswerRequestModel answerRequestModel) async {

    const url = ApplicationURLs.API_ANSWER;
    print(url);
    print(answerRequestModel.options??"");
    print(answerRequestModel.text??"");

    final response =
    await _handler.post(Uri.parse(url), answerRequestModel.toJson());

    return response;

  }

  Future<dynamic> deleteUser(String userId) async {

    String url = "${ApplicationURLs.API_DELETE}?user_id=$userId";
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
   // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    print(response.toString());
    return response;
  }
}
