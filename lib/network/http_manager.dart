

// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:io';

import 'package:flutter_quiz_app/model/reponse_model/Tribe/module_tribe_list_detail.dart';
import 'package:flutter_quiz_app/model/reponse_model/garden_response_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/leaving_reason_response_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/naq_response_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/question_answer_response_model.dart';
import 'package:flutter_quiz_app/model/reponse_model/stripe_keys_details.dart';
import 'package:flutter_quiz_app/model/reponse_model/trellis_ladder_data_response.dart';
import 'package:flutter_quiz_app/model/reponse_model/tribe_new_read_data_response.dart';
import 'package:flutter_quiz_app/model/reponse_model/user_activity_response_model.dart';
import 'package:flutter_quiz_app/model/request_model/change_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/forgot_password_request.dart';
import 'package:flutter_quiz_app/model/request_model/identity_add_favourite_request.dart';
import 'package:flutter_quiz_app/model/request_model/login_request.dart';
import 'package:flutter_quiz_app/model/request_model/organizing_principles_add_favourite_request.dart';
import 'package:flutter_quiz_app/model/request_model/register_create_request.dart';
import 'package:flutter_quiz_app/model/request_model/response_email_request.dart';
import 'package:flutter_quiz_app/model/request_model/rhythms_add_favourite_request.dart';
import 'package:flutter_quiz_app/model/request_model/social_login_request_model.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_data_saving_request.dart';
import 'package:flutter_quiz_app/model/request_model/trellis_vision_request_model.dart';
import 'package:flutter_quiz_app/network/response_handler.dart';

import '../model/reponse_model/Sage/accepted_connections_list_response.dart';
import '../model/reponse_model/Sage/chat_list_response.dart';
import '../model/reponse_model/Sage/invite_connection_notification_list.dart';
import '../model/reponse_model/Sage/sage_feedback_list_model.dart';
import '../model/reponse_model/Sage/sage_list_response_model.dart';
import '../model/reponse_model/Sage/shared_item_list_details.dart';
import '../model/reponse_model/Sage/shared_list_response.dart';
import '../model/reponse_model/Sage/user_search_list_response.dart';
import '../model/reponse_model/Tribe/trellis_share_response_model_all.dart';
import '../model/reponse_model/Tribe/tribe_shared_items_lists_response_model.dart';
import '../model/reponse_model/Tribe/tribe_single_item_shared_list.dart';
import '../model/reponse_model/column_read_data_model.dart';
import '../model/reponse_model/garden_level_response.dart';
import '../model/reponse_model/garden_seed_response_model.dart';
import '../model/reponse_model/growth_tree_response_count.dart';
import '../model/reponse_model/history_response_model.dart';
import '../model/reponse_model/level_response_model.dart';
import '../model/reponse_model/naq__response_model.dart';
import '../model/reponse_model/new_history_garden_details_response.dart';
import '../model/reponse_model/pire_naq_list_response_model.dart';
import '../model/reponse_model/post_reminder_list_response_model.dart';
import '../model/reponse_model/pro_user_response_model.dart';
import '../model/reponse_model/skipped_list_response_model.dart';
import '../model/reponse_model/trellis_data_history_response.dart';
import '../model/reponse_model/trellis_new_tribe_insertion.dart';
import '../model/request_model/Sage Request/add_shared_item_to_shared_list.dart';
import '../model/request_model/Sage Request/chat_list_request.dart';
import '../model/request_model/Sage Request/invite_connection_request.dart';
import '../model/request_model/Sage Request/sage_coaches_payment_request.dart';
import '../model/request_model/Sage Request/sage_feedback_add_request.dart';
import '../model/request_model/Sage Request/sage_feedback_list_request.dart';
import '../model/request_model/Sage Request/search_request_model.dart';
import '../model/request_model/Sage Request/shared_item_details_request.dart';
import '../model/request_model/Tribe/all_single_item_shared_request.dart';
import '../model/request_model/Tribe/pending_permission_request_model.dart';
import '../model/request_model/Tribe/pending_permission_sent_request.dart';
import '../model/request_model/Tribe/tribe_shared_item_request.dart';
import '../model/request_model/Tribe/tribe_shared_module_list_item_request.dart';
import '../model/request_model/admin_access_request_model.dart';
import '../model/request_model/answer_reques_model.dart';
import '../model/request_model/chnage_tree_growth_type_request.dart';
import '../model/request_model/column_delete_request.dart';
import '../model/request_model/column_read_list_request.dart';
import '../model/request_model/garden_history_details_request.dart';
import '../model/request_model/garden_seed_request_model.dart';
import '../model/request_model/ladder_add_favourite_response.dart';
import '../model/request_model/logout_user_request.dart';
import '../model/request_model/pire_naq_request_model.dart';
import '../model/request_model/post_request_model.dart';
import '../model/request_model/read_trellis_model.dart';
import '../model/request_model/session_entry_request.dart';
import '../model/request_model/stripe_request_payment_model.dart';
import '../model/request_model/trellis_delete_request_model.dart';
import '../model/request_model/trellis_identity_request_model.dart';
import '../model/request_model/trellis_ladder_request_model.dart';
import '../model/request_model/trellis_principles_request_model.dart';
import '../model/request_model/trellis_share_request.dart';
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

  Future<ProUserResponse> proUsersList() async {
    const url = ApplicationURLs.API_PRO_USERS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.postWithOutParams(Uri.parse(url));
    ProUserResponse proUserResponse = ProUserResponse.fromJson(response);
    return proUserResponse;
  }

  Future<dynamic> registerUser(RegisterRequestModel registerRequestModel) async {
    const url = ApplicationURLs.API_REGISTER_USER;
    // ignore: avoid_print
    print(url);

    final response =
        await _handler.post(Uri.parse(url),registerRequestModel.toJson());
    return response;
  }

  Future<dynamic> adminAccess(AdminAccessRequestModel adminAccessRequestModel) async {
    const url = ApplicationURLs.API_ADMIN_ACCESS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),adminAccessRequestModel.toJson());
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

  Future<dynamic> getUserProfileDetails(LogoutRequestModel logoutRequestModel) async {
    const url = ApplicationURLs.API_USER_DETAILS;
    // ignore: avoid_print
    print(url);
    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    return response;

  }

  Future<dynamic> changeProfileWithImage(ChangeProfileRequestModel changeProfileRequestModel,File profileImage) async {
    const url = ApplicationURLs.API_CHANGE_PROFILE;
    // ignore: avoid_print
    print(url);
      final response =
      await _handler.postImage(Uri.parse(url),changeProfileRequestModel.toJson(),profileImage);
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

  //PIRE NAQ LIST API CALL
  Future<PireNaqListResponseModel> pireNaqListResponse(PireNaqListRequestModel pireNaqListRequestModel) async {

    String url = ApplicationURLs.API_PIRE_NAQ_LIST;
    //// ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),pireNaqListRequestModel.toJson());
    PireNaqListResponseModel pireNaqListResponseModel = PireNaqListResponseModel.fromJson(response);

    return pireNaqListResponseModel;
  }

  //PIRE sinel Item API CALL
  Future<PireNaqSingleItemResponseModel> pireSingleItemResponse(PireNaqSingleItemRequestModel pireNaqSingleItemRequestModel) async {

    String url = ApplicationURLs.API_PIRE_SINGLE_ITEM_DETAILS;
    //// ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),pireNaqSingleItemRequestModel.toJson());
    PireNaqSingleItemResponseModel pireNaqSingleItemResponseModel = PireNaqSingleItemResponseModel.fromJson(response);

    return pireNaqSingleItemResponseModel;
  }

  //Naq sinel Item API CALL
  Future<PireNaqSingleItemResponseModel> naqSingleItemResponse(PireNaqSingleItemRequestModel pireNaqSingleItemRequestModel) async {

    String url = ApplicationURLs.API_NAQ_SINGLE_ITEM_DETAILS;
    //// ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),pireNaqSingleItemRequestModel.toJson());
    PireNaqSingleItemResponseModel pireNaqSingleItemResponseModel = PireNaqSingleItemResponseModel.fromJson(response);

    return pireNaqSingleItemResponseModel;
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

  Future<dynamic> trellisShareScreen(TrellisShareRequest trellisShareRequest) async {

    String url = ApplicationURLs.API_TRELLIS_SHARE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisShareRequest.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // print(response.toString());
    return response;
  }


  Future<SingleShredItemsForTribeResponse> tribeAllSingleItemsSharedRead(TribeAllSingleSharedRequestModel tribeAllSingleSharedRequestModel) async {

    String url = ApplicationURLs.API_ALL_SINGLE_SHARED_ITEM;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeAllSingleSharedRequestModel.toJson());
    SingleShredItemsForTribeResponse singleShredItemsForTribeResponse = SingleShredItemsForTribeResponse.fromJson(response);
    // print(response.toString());
    return singleShredItemsForTribeResponse;
  }

  Future<dynamic> tribeSingleItemsSharedDelete(TribeSingleSharedDeleteRequestModel tribeSingleSharedDeleteRequestModel) async {

    String url = ApplicationURLs.API_SINGLE_SHARED_ITEM_DELETE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSingleSharedDeleteRequestModel.toJson());
    // SingleShredItemsForTribeResponse singleShredItemsForTribeResponse = SingleShredItemsForTribeResponse.fromJson(response);
    // print(response.toString());
    return response;
  }

  //All App Share

  Future<dynamic> allAppShareScreen(TrellisShareRequest trellisShareRequest) async {

    String url = ApplicationURLs.API_ALL_APP_SHARE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisShareRequest.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // print(response.toString());
    return response;
  }

  Future<TrellisShareResponseModel> trellisShareScreenRead(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SHARE_READ;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    TrellisShareResponseModel trellisShareResponseModel = TrellisShareResponseModel.fromJson(response);
    // print(response.toString());
    return trellisShareResponseModel;
  }

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

  Future<dynamic> trellisVision(TrellisVisionRequestModel trellisVisionRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_VISION;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisVisionRequestModel.toJson());
    // QuestionListModel questionAnswerResponseModel = QuestionListModel.fromJson(response["questions"]);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> trellisUpdateIdentity(TrellisUpdateIdentityRequestModel trellisUpdateIdentityRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_UPDATE_IDENTITY;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisUpdateIdentityRequestModel.toJson());
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

  Future<dynamic> trellisUpdatePrinciples(TrellisPrinciplesUpdateRequestModel trellisPrinciplesUpdateRequestModel) async {

    String url = ApplicationURLs.API_TRELLIS_UPDATE_PRINCIPLES;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisPrinciplesUpdateRequestModel.toJson());
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


  Future<dynamic> identityAddFavourite(IdentityAddFavouriteItem identityAddFavouriteItem) async {

    String url = ApplicationURLs.API_IDENTITY_FAVOURITE;

    print(url);

    final response =
    await _handler.post(Uri.parse(url),identityAddFavouriteItem.toJson());
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> organizingPrinciplesAddFavourite(OrganizingPrincipleAddFavouriteItem organizingPrincipleAddFavouriteItem) async {

    String url = ApplicationURLs.API_PRINCIPLE_FAVOURITE;

    print(url);

    final response =
    await _handler.post(Uri.parse(url),organizingPrincipleAddFavouriteItem.toJson());
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  Future<dynamic> rhythmsAddFavourite(RhythmsAddFavouriteItem rhythmsAddFavouriteItem) async {

    String url = ApplicationURLs.API_PRINCIPLE_FAVOURITE;

    print(url);

    final response =
    await _handler.post(Uri.parse(url),rhythmsAddFavouriteItem.toJson());
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

  Future<dynamic> trellisUpdateTribeDataAdd(TrellisUpdateDataAddRequestModel trellisUpdateDataAddRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_EDIT_RESPONSE;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),trellisUpdateDataAddRequestModel.toJson());
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

  Future<dynamic> sessionEntryUpdate(ColumnUpdateRequestModel columnUpdateRequestModel) async {
    const url = ApplicationURLs.API_COLUMN_UPDATE;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),columnUpdateRequestModel.toJson());
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

  Future<ColumnReadDataModel> sessionTaskComplete(ColumnTaskCompleteRequestModel columnTaskCompleteRequestModel) async {
    const url = ApplicationURLs.API_COLUMN_COMPLETE_TASK;
    // print
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),columnTaskCompleteRequestModel.toJson());
    ColumnReadDataModel columnReadDataModel = ColumnReadDataModel.fromJson(response['data']);

    return columnReadDataModel;
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

  Future<LeavingReasonResponseModel> getLeavingReasons(LogoutRequestModel logoutRequestModel) async{
    const url = ApplicationURLs.API_LEAVING_REASONS;
    print(url);
    final response = await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    return LeavingReasonResponseModel.fromJson(response);
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

    print('Request Body ========> ${reminderNotificationForSnoozeRequestModel.toJson()}');

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


  //Sage API Call

  //Sage Feedback List
  Future<SageFeedbackListResponse> getSageFeedbackList(SageFeedbackRequestModel sageFeedbackRequestModel) async {

    String url = ApplicationURLs.API_SAGE_FEEDBACK_LIST_READ;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),sageFeedbackRequestModel.toJson());
    SageFeedbackListResponse sageFeedbackListResponse = SageFeedbackListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return sageFeedbackListResponse;
  }

  //Sage Feedback Insert
  Future<SageFeedback> addSageFeedback(SageFeedbackAddRequest sageFeedbackAddRequest) async {

    String url = ApplicationURLs.API_SAGE_FEEDBACK;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),sageFeedbackAddRequest.toJson());
    SageFeedback sageFeedback = SageFeedback.fromJson(response['data']);
    // ignore: avoid_print
    print(response.toString());
    return sageFeedback;
  }

  //Sage Connection List
  Future<ConnectionListResponse> getConnectionList(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SAGE_CONNECTION_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    ConnectionListResponse connectionListResponse = ConnectionListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return connectionListResponse;
  }

  //Sage Payment For Share with coach
  Future<dynamic> sendSagePaymentForCoach(SageCoachesPayment sageCoachesPayment) async {

    String url = ApplicationURLs.API_SAGE_PAYMENT_FOR_COACH;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),sageCoachesPayment.toJson());

    return response;
  }

  //Sage Accepted Connections List
  Future<AcceptedConnectionsListResponse> getAcceptedConnectionList(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SAGE_ACCEPTED_CONNECTION_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    AcceptedConnectionsListResponse acceptedConnectionsListResponse = AcceptedConnectionsListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return acceptedConnectionsListResponse;
  }

  //Sage Accepted Connections List
  Future<AcceptedConnectionsListResponse> getPendingConnectionList(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SAGE_PENDING_CONNECTION_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    AcceptedConnectionsListResponse acceptedConnectionsListResponse = AcceptedConnectionsListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return acceptedConnectionsListResponse;
  }

  //Tribe Pending permission List
  Future<PendingPermissionSentRequestList> getPendingPermssionList(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_Tribe_PENDING_PERMISSION_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    PendingPermissionSentRequestList pendingPermissionSentRequestList = PendingPermissionSentRequestList.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return pendingPermissionSentRequestList;
  }

  //Tribe Pending permission List
  Future<PendingPermissionSentRequestList> getPendingPermssionRequestList(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_Tribe_PENDING_PERMISSION_REQUEST_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    PendingPermissionSentRequestList pendingPermissionList = PendingPermissionSentRequestList.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return pendingPermissionList;
  }

  //Sage Sent Connections List
  Future<AcceptedConnectionsListResponse> getSentConnectionList(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SAGE_SENT_CONNECTION_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    AcceptedConnectionsListResponse acceptedConnectionsListResponse = AcceptedConnectionsListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return acceptedConnectionsListResponse;
  }


  //Sage Pending Connections count
  Future<dynamic> getPendingConnectionCount(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SAGE_PENDING_CONNECTION_COUNT;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    // AcceptedConnectionsListResponse acceptedConnectionsListResponse = AcceptedConnectionsListResponse.fromJson(response);
    // // ignore: avoid_print
    // print(response.toString());
    return response;
  }

  //Sage Pending Connections count
  Future<dynamic> addShareItemToConnectionList(SharedListItemAddRequest sharedListItemAddRequest) async {

    String url = ApplicationURLs.API_SAGE_CHAT_ROOM_INSERT;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),sharedListItemAddRequest.toJson());
    return response;
  }

  //Sage Shared Item List Item Details
  Future<SharedItemDetailsResponse> getShareItemDetail(SharedItemDetailsRequest sharedItemDetailsRequest) async {

    String url = ApplicationURLs.API_SAGE_SHARED_ITEM_DETAILS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),sharedItemDetailsRequest.toJson());
    SharedItemDetailsResponse sharedItemDetailsResponse = SharedItemDetailsResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return sharedItemDetailsResponse;
  }

  //Tribe Shared Item List
  Future<SharePireResponseModel> getTribeShareItemDetailForPireNaq(TribeSharedRequestModel tribeSharedRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_FULL_MODULE_DETAIL;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSharedRequestModel.toJson());
    SharePireResponseModel sharePireResponseModel = SharePireResponseModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return sharePireResponseModel;
  }

  //Tribe Shared Item List
  Future<ShareColumnResponseModel> getTribeShareItemDetailForColumn(TribeSharedRequestModel tribeSharedRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_FULL_MODULE_DETAIL;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSharedRequestModel.toJson());
    ShareColumnResponseModel shareColumnResponseModel = ShareColumnResponseModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return shareColumnResponseModel;
  }

  //Tribe Shared Item List
  Future<dynamic> getTribeShareItemDetailForTrellis(TribeSharedRequestModel tribeSharedRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_FULL_MODULE_DETAIL;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSharedRequestModel.toJson());
    // ShareColumnResponseModel shareColumnResponseModel = ShareColumnResponseModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  //Tribe Shared Item List
  Future<ShareLadderResponseModel> getTribeShareItemDetailForLadder(TribeSharedRequestModel tribeSharedRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_FULL_MODULE_DETAIL;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSharedRequestModel.toJson());
    ShareLadderResponseModel shareLadderResponseModel = ShareLadderResponseModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return shareLadderResponseModel;
  }

  Future<ColumnSharedItemDetail> getShareItemDetailForColumn(SharedItemDetailsRequest sharedItemDetailsRequest) async {

    String url = ApplicationURLs.API_SAGE_SHARED_ITEM_DETAILS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),sharedItemDetailsRequest.toJson());
    ColumnSharedItemDetail columnSharedItemDetail = ColumnSharedItemDetail.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return columnSharedItemDetail;
  }

  Future<LadderSingleItemDetailsResponseModel> getShareItemDetailForLadder(SharedItemDetailsRequest sharedItemDetailsRequest) async {

    String url = ApplicationURLs.API_SAGE_SHARED_ITEM_DETAILS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),sharedItemDetailsRequest.toJson());
    LadderSingleItemDetailsResponseModel ladderSingleItemDetailsResponseModel = LadderSingleItemDetailsResponseModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return ladderSingleItemDetailsResponseModel;
  }

  //Tribe Shared Single Item List
  Future<SharePireResponseModel> getTribeShareSingleItemDetailForPireNaq(TribeSingleSharedRequestModel tribeSingleSharedRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_SINGLE_TYPE_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSingleSharedRequestModel.toJson());
    SharePireResponseModel sharePireResponseModel = SharePireResponseModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return sharePireResponseModel;
  }

  //Tribe Shared Single Item List
  Future<ShareColumnResponseModel> getTribeShareSingleItemDetailForColumn(TribeSingleSharedRequestModel tribeSingleSharedRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_SINGLE_TYPE_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSingleSharedRequestModel.toJson());
    ShareColumnResponseModel shareColumnResponseModel = ShareColumnResponseModel.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return shareColumnResponseModel;
  }

  //Tribe Shared Single Item List
  Future<dynamic> getTribeShareSingleItemDetailForTrellis(TribeSingleSharedRequestModel tribeSingleSharedRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_SINGLE_TYPE_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSingleSharedRequestModel.toJson());
    // ShareColumnResponseModel shareColumnResponseModel = ShareColumnResponseModel.fromJson(response);
    // ignore: avoid_print
    // print(response.toString());
    return response;
  }

  //Tribe Shared Single Item List
  Future<ShareLadderResponseModel> getTribeShareSingleItemDetailForLadder(TribeSingleSharedRequestModel tribeSingleSharedRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_SINGLE_TYPE_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSingleSharedRequestModel.toJson());
    ShareLadderResponseModel shareLadderResponseModel = ShareLadderResponseModel.fromJson(response);
    // ignore: avoid_print
    // print(response.toString());
    return shareLadderResponseModel;
  }

  // Tribe Edit Connection
  Future<dynamic> editConnectionRequest(EditConnectionRequestModel editConnectionRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_EDIT_MODULE_TYPE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),editConnectionRequestModel.toJson());
    // AcceptedConnectionItem acceptedConnectionItem = AcceptedConnectionItem.fromJson(response['data']);
    return response;
  }

  // Tribe Edit Accept No Connection
  Future<dynamic> editConnectionAcceptNoRequest(EditConnectionAcceptNoRequestModel editConnectionAcceptNoRequestModel) async {

    String url = ApplicationURLs.API_TRIBE_EDIT_MODULE_ACCEPT_NO_TYPE;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),editConnectionAcceptNoRequestModel.toJson());
    // AcceptedConnectionItem acceptedConnectionItem = AcceptedConnectionItem.fromJson(response['data']);
    return response;
  }

  //Sage Shared Item List With me
  Future<TribeModuleTypeListDetails> getShareModuleTypeList(TribeSharedModuleRequestModel tribeSharedModuleRequestModel) async {

    String url = ApplicationURLs.API_SAGE_SHARED_ITEM_DETAILS;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),tribeSharedModuleRequestModel.toJson());
    TribeModuleTypeListDetails tribeModuleTypeListDetails = TribeModuleTypeListDetails.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return tribeModuleTypeListDetails;
  }

  //Sage Shared Item List With me
  Future<SharedListResponseForOther> getShareItemListWithMe(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SAGE_SHARED_WITH_ME;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    SharedListResponseForOther sharedListResponse = SharedListResponseForOther.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return sharedListResponse;
  }

  //Sage Shared Item List With Other
  Future<SharedListResponse> getShareItemListWithOther(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SAGE_SHARED_WITH_OTHER;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    SharedListResponse sharedListResponse = SharedListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return sharedListResponse;
  }

  //Sage Shared Item List With Other
  Future<SharedListResponse> getShareItemListWithCoach(SenderRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SAGE_SHARED_WITH_COACH;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    SharedListResponse sharedListResponse = SharedListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return sharedListResponse;
  }


  //Sage Search User For Connection
  Future<ConnectionUserListResponse1> getSearchConnectionUserList(SearchConnectionUserRequestModel searchConnectionUserRequestModel) async {

    String url = ApplicationURLs.API_SAGE_CONNECTION_SEARCH_USER;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),searchConnectionUserRequestModel.toJson());
    ConnectionUserListResponse1 connectionUserListResponse1 = ConnectionUserListResponse1.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return connectionUserListResponse1;
  }

  //Sage Invite User For Connection
  Future<AcceptedConnectionItem> getInviteConnectionRequest(InviteConnectionRequestModel inviteConnectionRequestModel) async {

    String url = ApplicationURLs.API_SAGE_SEND_CONNECTION;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),inviteConnectionRequestModel.toJson());
    AcceptedConnectionItem acceptedConnectionItem = AcceptedConnectionItem.fromJson(response['data']);
    // ignore: avoid_print
    print(response.toString());
    return acceptedConnectionItem;
  }

  //Sage Invite User For Connection
  Future<dynamic> getInviteConnectionRequestForEmail(InviteConnectionRequestModel inviteConnectionRequestModel) async {

    String url = ApplicationURLs.API_SAGE_SEND_CONNECTION;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),inviteConnectionRequestModel.toJson());
    // AcceptedConnectionItem acceptedConnectionItem = AcceptedConnectionItem.fromJson(response['data']);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  //Sage Invite Notification List For User For Connection
  Future<InvitedNotificationConnectionListResponse> getInviteNotificationConnectionList(LogoutRequestModel logoutRequestModel) async {

    String url = ApplicationURLs.API_SAGE_INVITED_CONNECTION_LIST;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),logoutRequestModel.toJson());
    InvitedNotificationConnectionListResponse invitedNotificationConnectionListResponse = InvitedNotificationConnectionListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return invitedNotificationConnectionListResponse;
  }

  //Accept User For Connection
  Future<dynamic> acceptRejectPendingPermission(PendingPermissionRequestModel pendingPermissionRequestModel) async {

    String url = ApplicationURLs.API_ACCEPT_PENDING_PERMISSION;
    print(url);

    final response =
    await _handler.post(Uri.parse(url),pendingPermissionRequestModel.toJson());
    print(response.toString());
    return response;
  }


  //Accept User For Connection
  Future<dynamic> acceptNotificationInvite(String senderId,String recieverId, String role) async {

    String url = "${ApplicationURLs.API_SAGE_ACCEPT_CONNECTION}?approver_role=$role&requester_id=$senderId&approver_id=$recieverId";
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
    // SearchConnectionListResponse searchConnectionListResponse = SearchConnectionListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  // Reject User For Connection
  Future<dynamic> rejectNotificationInvite(String senderId,String recieverId, String role) async {

    String url = "${ApplicationURLs.API_SAGE_REJECT_CONNECTION}?approver_role=$role&requester_id=$senderId&approver_id=$recieverId";
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.get(Uri.parse(url),false);
    // SearchConnectionListResponse searchConnectionListResponse = SearchConnectionListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return response;
  }

  // Chat Messages List
  Future<ChatMessageListResponse> chatMessagesList(ChatRequestModel chatRequestModel) async {

    String url = ApplicationURLs.API_SAGE_CHAT_ROOM_READ;
    // ignore: avoid_print
    print(url);

    final response =
    await _handler.post(Uri.parse(url),chatRequestModel.toJson());
    ChatMessageListResponse chatMessageListResponse = ChatMessageListResponse.fromJson(response);
    // ignore: avoid_print
    print(response.toString());
    return chatMessageListResponse;
  }

}
