

// ignore_for_file: avoid_print, duplicate_ignore

import 'package:flutter_quiz_app/model/reponse_model/garden_response_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/naq_response_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/stripe_keys_details.dart';
import 'package:flutter_quiz_app/model/reponse_model/trellis_ladder_data_response.dart';
import 'package:flutter_quiz_app/model/reponse_model/tribe_new_read_data_response.dart';
import 'package:flutter_quiz_app/model/reponse_model/user_activity_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/change_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/forgot_password_request.dart';
import 'package:flutter_quiz_app/model/request_model/login_request.dart';
import 'package:flutter_quiz_app/model/request_model/register_create_request.dart';
import 'package:flutter_quiz_app/model/request_model/response_email_request.dart';
import 'package:flutter_quiz_app/model/request_model/social_login_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_data_saving_request.dart';
import 'package:flutter_quiz_app/network/response_handler.dart';

import '../model/reponse_model/column_read_data_model.dart';
import '../model/reponse_model/garden_level_response.dart';
import '../model/reponse_model/garden_seed_response_model.dart';
import '../model/reponse_model/growth_tree_response_count.dart';
import '../model/reponse_model/history_response_model.dart';
import '../model/reponse_model/level_response_model.dart';
import '../model/reponse_model/naq__response_model.dart';
import '../model/reponse_model/new_history_garden_details_response.dart';
import '../model/reponse_model/post_reminder_list_response_model.dart';
import '../model/reponse_model/skipped_list_response_model.dart';
import '../model/reponse_model/trellis_data_history_response.dart';
import '../model/reponse_model/trellis_new_tribe_insertion.dart';
import '../model/request_model/answer_reques_model.dart';
import '../model/request_model/chnage_tree_growth_type_request.dart';
import '../model/request_model/column_delete_request.dart';
import '../model/request_model/column_read_list_request.dart';
import '../model/request_model/garden_history_details_request.dart';
import '../model/request_model/garden_seed_request_model.dart';
import '../model/request_model/ladder_add_favourite_response.dart';
import '../model/request_model/logout_user_request.dart';
import '../model/request_model/post_request_model.dart';
import '../model/request_model/read_trellis_model.dart';
import '../model/request_model/session_entry_request.dart';
import '../model/request_model/stripe_request_payment_model.dart';
import '../model/request_model/trellis_delete_request_model.dart';
import '../model/request_model/trellis_identity_request_model.dart';
import '../model/request_model/trellis_ladder_request_model.dart';
import '../model/request_model/trellis_principles_request_model.dart';
import '../model/request_model/tribe_data_saving_request.dart';
import '../model/request_model/user_email_response_request.dart';
import 'api_urls.dart';

class HTTPManager {
  final ResponseHandler _handler = ResponseHandler();

  Future<StripeKeysDetailsModelClass> getStripeKeysDetails(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_STRIPE_KEY_DETAILS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    StripeKeysDetailsModelClass stripeKeysDetailsModelClass = StripeKeysDetailsModelClass.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return stripeKeysDetailsModelClass;
  }

  Future<dynamic> registerUser(RegisterRequestModel registerRequestModel) async {
    const url = ApplicationURLs.API_REGISTER_USER;
    // ignore: avoid_print
    print(url);

    final response =
        await _handler.post(Uri.parse(url),registerRequestModel.toJson());
    return response;
  }


  Future<TreeGrowthResponse> treeGrowth(LogoutRequestModel logoutRequestModel) async {
    const url = ApplicationURLs.API_TREE_GROWTH;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    TreeGrowthResponse treeGrowthResponse = TreeGrowthResponse.fromJson(response);
    return treeGrowthResponse;
  }

  Future<dynamic> treeGrowthSimple(LogoutRequestModel logoutRequestModel) async {
    const url = ApplicationURLs.API_TREE_GROWTH;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
     // TreeGrowthResponse treeGrowthResponse = TreeGrowthResponse.fromJson(response);
    return response;
  }

  Future<dynamic> setTreeGrowthType(SetTreeGrowthTypeRequestModel setTreeGrowthTypeRequestModel) async {
    const url = ApplicationURLs.API_SET_LEVE_SWITCH;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),setTreeGrowthTypeRequestModel.toJson());
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

  Future<QuestionListModel> getQuestions(String questionListType) async {

    String url = "${ApplicationURLs.API_QUESTIONS}?type=$questionListType";
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
    QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return questionAnswerResponseModel;
  }

  Future<NaqModelClassResponse> getNaqQuestions(String questionListType) async {

    String url = "${ApplicationURLs.API_QUESTIONS}?type=$questionListType";
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
    NaqModelClassResponse naqModelClassResponse = NaqModelClassResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return naqModelClassResponse;
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

    const url = ApplicationURLs.API_RESPONSE_PIRE;
    // ignore: avoid_print
    print(url);
    // ignore: avoid_print
    print(userResponseRequestModel.answerMap);

    final response =
    await _handler.post(Uri.parse(url), userResponseRequestModel.toJson());

    return response;

  }

  Future<dynamic> userNaqResponseEmail(UserResponseRequestModel userResponseRequestModel) async {

    const url = ApplicationURLs.API_RESPONSE_NAQ;
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

  Future<HistoryResponseListModel> responseHistory(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_RESPONSE_HISTORY;
    //// ignore: avoid_print
    // print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    //// ignore: avoid_print
    // print(response.toString());
    HistoryResponseListModel responseListModel = HistoryResponseListModel.fromJson(response["response_history"]);
    return responseListModel;
  }
  //NAQ API CALL
  Future<NaqResponseListModel> naqResponseList(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_NAQ_RESPONSE;
    //// ignore: avoid_print
     print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    NaqResponseListModel naqResponseListModel = NaqResponseListModel.fromJson(response["single_answer"]);
    //// ignore: avoid_print
    // print(response.toString());
    return naqResponseListModel;
  }

  Future<dynamic> naqResponseExistingList(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_NAQ_DATA_EXIST_RESPONSE;
    //// ignore: avoid_print
    print(url);

    final response = await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    //NaqResponseListModel naqResponseListModel = NaqResponseListModel.fromJson(response["single_answer"]);
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

  Future<dynamic> trellisTriggerData(TrellisTriggerRequestModel trellisTriggerRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_RESPONSE_TRIGGER;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisTriggerRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // print(response.toString());
    return response;
  }

  Future<GardenLevelResponse> gardenLevelList() async {

    String url = ApplicationURLs.API_GARDEN_LEVELS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
    GardenLevelResponse gardenLevelResponse = GardenLevelResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return gardenLevelResponse;
  }

  Future<dynamic> ladderTriggerData(TrellisTriggerRequestModel trellisTriggerRequestModel) async {

    String url = ApplicationURLs.API_LADDER_RESPONSE_TRIGGER;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisTriggerRequestModel.toJson());
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

  Future<dynamic> trellisLadderForGoalsUpdate(TrellisLadderGoalsUpdateRequestModel trellisLadderGoalsUpdateRequestModel) async {

    String url = ApplicationURLs.API_LADDER_EDIT_RESPONSE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisLadderGoalsUpdateRequestModel.toJson());
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

  Future<dynamic> trellisLadderForAchievementsUpdate(TrellisLadderAchievementUpdateRequestModel trellisLadderAchievementUpdateRequestModel) async {

    String url = ApplicationURLs.API_LADDER_EDIT_RESPONSE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisLadderAchievementUpdateRequestModel.toJson());
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

  Future<TribeDataListModel> trellisNewDataRead(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_NEW_DATA_READ;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    TribeDataListModel tribeDataListModel = TribeDataListModel.fromJson(response["data"]["tribe"]);
    // ignore: avoid_print
    print(response.toString());
    return tribeDataListModel;
  }


  Future<dynamic> ladderAddFavourite(LadderAddFavouriteItem ladderAddFavouriteItem) async {

    String url = ApplicationURLs.API_LADDER_FAVOURITE;

    print(url);

    final response =
    await _handler.post(Uri.parse(url),ladderAddFavouriteItem.toJson());
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> trellisNewTribeDataAdd(TrellisNewDataAddRequestModel trellisNewDataAddRequestModel) async {

    String url = ApplicationURLs.API_NEW_TRELLIS_TRIBE_INSERTION;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisNewDataAddRequestModel.toJson());
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

  Future<dynamic> trellisNewTribeDelete(TribeNewDataTrellisDeleteRequestModel tribeNewDataTrellisDeleteRequestModel) async {

    String url = ApplicationURLs.API_NEW_TRELLIS_TRIBE_DELETE;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeNewDataTrellisDeleteRequestModel.toJson());
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


  Future<dynamic> stripeTokenApi(String? cardNumber, int? expMonth, int? expYear, String? cvc, String? publishableKey,) async {
    const url = ApplicationURLs.stripeTokenUrl;
    final body = {
      'card[number]': cardNumber,
      'card[exp_month]': expMonth.toString(),
      'card[exp_year]': expYear.toString(),
      'card[cvc]': cvc,
    };

    // ignore: avoid_print
    print(url);

    final response = await _handler.stripePost(Uri.parse(url), body, publishableKey!);
    //TokenObject tokenObject = TokenObject.fromJson(response);
    return response;
  }

  Future<dynamic> stripePayment(StripePaymentRequestModel stripePaymentRequestModel) async {
    const url = ApplicationURLs.API_STRIPE_PAYMENT_URL;
    // print(stripePaymentRequestModel.user);
    // print(stripePaymentRequestModel.package);

    // ignore: avoid_print
    print(url);
    final response =
    await _handler.post(Uri.parse(url),stripePaymentRequestModel.toJson());
    return response;
  }

  Future<dynamic> cancelSubscription(StripeCancelRequestModel stripeCancelRequestModel) async {
    const url = ApplicationURLs.API_STRIPE_CANCEL_SUBSCRIPTION_URL;
    // print(stripePaymentRequestModel.user);
    // print(stripePaymentRequestModel.package);

    // ignore: avoid_print
    print(url);
    final response =
    await _handler.post(Uri.parse(url),stripeCancelRequestModel.toJson());
    return response;
  }


  Future<dynamic> subscriptionDetailsRead(ColumnReadRequestModel columnReadRequestModel) async {
    const url = ApplicationURLs.API_SUBSCRIPTION_DETAILS_READ;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),columnReadRequestModel.toJson());
    return response;
  }

  Future<NewGardenResponseModel> getNewGardenData(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_GARDEN_NEW_HISTORY;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    NewGardenResponseModel newGardenResponseModel = NewGardenResponseModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return newGardenResponseModel;
  }

  Future<LevelHistoryResponse> getLevelHistoryData(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_LEVEL_HISTORY;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    LevelHistoryResponse levelHistoryResponse = LevelHistoryResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return levelHistoryResponse;
  }

  Future<NewGardenHistoryResponseDetailsModel> getNewGardenDataHistoryDetails(GardenHistoryDetailsRequestModel gardenHistoryDetailsRequestModel) async {

    String url = ApplicationURLs.API_GARDEN_HISTORY_DETAILS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),gardenHistoryDetailsRequestModel.toJson());
    NewGardenHistoryResponseDetailsModel newGardenHistoryResponseDetailsModel = NewGardenHistoryResponseDetailsModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return newGardenHistoryResponseDetailsModel;
  }

  Future<TrellisLadderDataModel> getNewLevelLadderDataHistoryDetails(LevelHistoryDetailsRequestModel levelHistoryDetailsRequestModel) async {

    String url = ApplicationURLs.API_LEVEL_HISTORY_DETAILS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),levelHistoryDetailsRequestModel.toJson());
    TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel.fromJson(response['data']);
    // ignore: avoid_print
    print(response.toString());
    return trellisLadderDataModel;
  }

  Future<TrellisDataHistoryResponse> getNewLevelTrellisDataHistoryDetails(LevelHistoryDetailsRequestModel levelHistoryDetailsRequestModel) async {

    String url = ApplicationURLs.API_LEVEL_HISTORY_DETAILS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),levelHistoryDetailsRequestModel.toJson());
    TrellisDataHistoryResponse trellisDataHistoryResponse = TrellisDataHistoryResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return trellisDataHistoryResponse;
  }

  Future<ColumnReadDataModel> getNewLevelColumnDataHistoryDetails(LevelHistoryDetailsRequestModel levelHistoryDetailsRequestModel) async {

    String url = ApplicationURLs.API_LEVEL_HISTORY_DETAILS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),levelHistoryDetailsRequestModel.toJson());
    ColumnReadDataModel columnReadDataModel = ColumnReadDataModel.fromJson(response['data']);
    // ignore: avoid_print
    print(response.toString());
    return columnReadDataModel;
  }

  //POST REMINDER API CALL
  Future<PostReminderResponseListModel> getPostReminderData(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_POST_READ;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    PostReminderResponseListModel postReminderResponseListModel = PostReminderResponseListModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return postReminderResponseListModel;
  }

  Future<SkippedReminderNotification> getSkippedReminderListData(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SKIP_REMINDERS_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    SkippedReminderNotification skippedReminderNotification = SkippedReminderNotification.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return skippedReminderNotification;
  }

  Future<dynamic> postReminderInsertData(InsertPostReminderRequestModel insertPostReminderRequestModel) async {

    String url = ApplicationURLs.API_POST_INSERT;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),insertPostReminderRequestModel.toJson());
    // PostReminderResponseListModel postReminderResponseListModel = PostReminderResponseListModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> postReminderEditData(EditPostReminderRequestModel editPostReminderRequestModel) async {

    String url = ApplicationURLs.API_POST_EDIT;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),editPostReminderRequestModel.toJson());
    // PostReminderResponseListModel postReminderResponseListModel = PostReminderResponseListModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> postReminderDeleteData(DeletePostReminderRequestModel deletePostReminderRequestModel) async {

    String url = ApplicationURLs.API_POST_DELETE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),deletePostReminderRequestModel.toJson());
    // PostReminderResponseListModel postReminderResponseListModel = PostReminderResponseListModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> postReminderUpdateStatus(UpdateReminderStatusRequestModel updateReminderStatusRequestModel) async {

    String url = ApplicationURLs.API_POST_UPDATE_STATUS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),updateReminderStatusRequestModel.toJson());
    // PostReminderResponseListModel postReminderResponseListModel = PostReminderResponseListModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> postReminderSnoozeData(ReminderNotificationForSnoozeRequestModel reminderNotificationForSnoozeRequestModel) async {

    String url = ApplicationURLs.API_POST_SNOOZE_REMINDER;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),reminderNotificationForSnoozeRequestModel.toJson());
    // PostReminderResponseListModel postReminderResponseListModel = PostReminderResponseListModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> postReminderStopData(ReminderNotificationForStopRequestModel reminderNotificationForStopRequestModel) async {

    String url = ApplicationURLs.API_POST_STOP_REMINDER;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),reminderNotificationForStopRequestModel.toJson());
    // PostReminderResponseListModel postReminderResponseListModel = PostReminderResponseListModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }


  Future<GardenSeedResponseModel> getGardenSeeds(GardenSeedRequestModel gardenSeedRequestModel) async {

    String url = ApplicationURLs.API_GARDEN_SEED;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),gardenSeedRequestModel.toJson());
    GardenSeedResponseModel gardenSeedResponseModel = GardenSeedResponseModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return gardenSeedResponseModel;
  }

  // User Activity Call
  Future<UserActivityResponse> getUserActivityData(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_USER_ACTIVITY_DETAIL;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    UserActivityResponse userActivityResponse = UserActivityResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return userActivityResponse;
  }

}
