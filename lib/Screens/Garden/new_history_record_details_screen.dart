// ignore_for_file: avoid_print, depend_on_referenced_packages, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_quiz_app/Screens/Ladder/Ladder_Screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/logo_widget_for_all_screens.dart';
import '../../Widgets/option_mcq_widget.dart';
import '../../model/reponse_model/column_read_data_model.dart';
import '../../model/reponse_model/new_history_garden_details_response.dart';
import '../../model/reponse_model/skipped_list_response_model.dart';
import '../../model/reponse_model/trellis_data_history_response.dart';
import '../../model/reponse_model/trellis_ladder_data_response.dart';
import '../../model/request_model/garden_history_details_request.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../network/http_manager.dart';
import '../Column/Widgets/column_details_widget.dart';
import '../Ladder/widgets/ladder_details_widget.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../PireScreens/widgets/pire_naq_details_widget.dart';
import '../Widgets/show_notification_pop_up.dart';
import '../utill/userConstants.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AnswerDetailsScreen extends StatefulWidget {
   AnswerDetailsScreen(this.answerRecordId,this.isTrellisColumnLadder,this.dateHistory,{Key? key}) : super(key: key);
  String answerRecordId;
   String isTrellisColumnLadder;
   String dateHistory;

  @override
  State<AnswerDetailsScreen> createState() => _AnswerDetailsScreenState();
}

class _AnswerDetailsScreenState extends State<AnswerDetailsScreen> {
  String name = "";
  String id = "";
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String email = "";
  String timeZone = "";
  String userType = "";
  bool _isLoading = true;
  bool _isUserDataLoading = true;

  late NewGardenHistoryResponseDetailsModel newGardenHistoryResponseDetailsModel;
  late TrellisLadderDataModel trellisLadderDataModel;
  late TrellisDataHistoryResponse trellisDataHistoryResponse;
  late ColumnReadDataModel columnReadDataModel;

  late bool isPhone;
  String errorMessage = "";
  int badgeCount1 = 0;
  int badgeCountShared = 0;

  bool otherUserLoggedIn = false;

  @override
  void initState() {
    _getUserData();
    if(widget.isTrellisColumnLadder == "PIRE" || widget.isTrellisColumnLadder == "NAQ") {
      getNewResponseHistoryDetails();
    } else {
        getNewResponseHistoryDetailsForTrellisLadderColumn(widget.answerRecordId,widget.isTrellisColumnLadder);
    }
    // TODO: implement initState
    super.initState();
  }

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;
    if(otherUserLoggedIn) {

      id = sharedPreferences.getString(UserConstants().otherUserId)!;
      name = sharedPreferences.getString(UserConstants().otherUserName)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

    } else {
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

      // getNewResponseHistoryDetails();
      _getSkippedReminderList();
    }
    setState(() {
      _isUserDataLoading = false;
    });
  }

  String? formattedDate;
  String? formattedTime;
  late SkippedReminderNotification skippedReminderNotification;

  _getSkippedReminderList() {
    setState(() {
      // sharedPreferences.setString("Score", "");
      // _isLoading = true;
    });
    HTTPManager().getSkippedReminderListData(LogoutRequestModel(userId: id)).then((value) {
      setState(() {
        skippedReminderNotification = value;
        // sharedPreferences.setString("Score", "");
        // _isLoading = false;
      });
      print("SKIPPED REMINDER LIST");
      print(value);

      for(int i = 0; i<skippedReminderNotification.result!.length; i++) {
        String title = "Hi $name. Did you....";
        DateTime date = DateTime.parse(skippedReminderNotification.result![i].dateTime.toString());
        formattedDate = DateFormat('MM-dd-yy').format(DateTime.parse(skippedReminderNotification.result![i].createdAt.toString()));
        formattedTime = DateFormat("hh:mm a").format(date);
        showPopupDialogueForReminderGeneral(context,skippedReminderNotification.result![i].entityId.toString(),skippedReminderNotification.result![i].id.toString(),title,skippedReminderNotification.result![i].text.toString(),formattedDate!,formattedTime!);
      }

    }).catchError((e) {
      print(e);
      setState(() {
        // sharedPreferences.setString("Score", "");
        // _isLoading = false;
      });
    });
  }

  getScreenDetails() {
    // setState(() {
    //   _isLoading = true;
    // });
    if(MediaQuery.of(context).size.width<= 500) {
      isPhone = true;
    } else {
      isPhone = false;
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  getNewResponseHistoryDetails() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getNewGardenDataHistoryDetails(GardenHistoryDetailsRequestModel(responseId: widget.answerRecordId)).then((value) {

      setState(() {
        newGardenHistoryResponseDetailsModel = value;
        errorMessage = "";
        _isLoading = false;
      });
      // newGardenResponseModel.responseData!.sort((a,b) => b.date!.compareTo(a.date!));

      print("History List Model Details");
      print(newGardenHistoryResponseDetailsModel.data![0].options);
    }).catchError((e) {
      //print(e);
      setState(() {
        _isLoading = false;
        errorMessage = e.toString();
      });
    });
  }

  getNewResponseHistoryDetailsForTrellisLadderColumn(String responseId,String type) {
    setState(() {
      _isLoading = true;
    });
    if(type == "trellis") {

      HTTPManager().getNewLevelTrellisDataHistoryDetails(LevelHistoryDetailsRequestModel(responseId: widget.answerRecordId,tableName: type)).then((value) {

        setState(() {
          trellisDataHistoryResponse = value;
          errorMessage = "";
          _isLoading = false;
        });
        // newGardenResponseModel.responseData!.sort((a,b) => b.date!.compareTo(a.date!));
      }).catchError((e) {
        //print(e);
        setState(() {
          _isLoading = false;
          errorMessage = e.toString();
        });
      });

    }  else if(type == "column") {

      HTTPManager().getNewLevelColumnDataHistoryDetails(LevelHistoryDetailsRequestModel(responseId: widget.answerRecordId,tableName: type)).then((value) {

        setState(() {
          columnReadDataModel = value;
          errorMessage = "";
          _isLoading = false;
        });
        // newGardenResponseModel.responseData!.sort((a,b) => b.date!.compareTo(a.date!));
      }).catchError((e) {
        //print(e);
        setState(() {
          _isLoading = false;
          errorMessage = e.toString();
        });
      });

    } else {

      HTTPManager().getNewLevelLadderDataHistoryDetails(LevelHistoryDetailsRequestModel(responseId: widget.answerRecordId,tableName: type)).then((value) {

        setState(() {
          trellisLadderDataModel = value;
          errorMessage = "";
          _isLoading = false;
        });
        // newGardenResponseModel.responseData!.sort((a,b) => b.date!.compareTo(a.date!));
      }).catchError((e) {
        //print(e);
        setState(() {
          _isLoading = false;
          errorMessage = e.toString();
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    getScreenDetails();
    return Scaffold(
      appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
          context,
              () {
            Navigator.of(context).pop();
          }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.isTrellisColumnLadder == "PIRE" ? LogoScreen("PIRE")
                  : widget.isTrellisColumnLadder == "NAQ" ? LogoScreen("NAQ")
                  : widget.isTrellisColumnLadder == "column" ?LogoScreen("Column")
                  : widget.isTrellisColumnLadder == "trellis" ? LogoScreen("Trellis")
                  : LogoScreen("Ladder"),
              Text(widget.dateHistory,style:const TextStyle(fontSize: AppConstants.headingFontSize),),
             const SizedBox(height: 10,),
              _isLoading ? const Center(
                child: CircularProgressIndicator(),
              ) : errorMessage != "" ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage,style:const TextStyle(fontSize: 25),),
                    const SizedBox(height: 5,),
                    GestureDetector(
                      onTap: () {
                        if(widget.isTrellisColumnLadder == "PIRE" || widget.isTrellisColumnLadder == "NAQ"){
                          getNewResponseHistoryDetails();
                        } else {
                          getNewResponseHistoryDetailsForTrellisLadderColumn(widget.answerRecordId,widget.isTrellisColumnLadder);
                        }

                      },
                      child: OptionMcqAnswer(
                          TextButton(onPressed: () {
                            getNewResponseHistoryDetails();
                          }, child: const Text("Reload",style: TextStyle(fontSize:25,color: AppColors.redColor)),)
                      ),
                    )
                  ],
                ),
              ) : Container(
                margin:const EdgeInsets.only(bottom: 20,right: 5,left: 5),
                child: OptionMcqAnswer(widget.isTrellisColumnLadder == "column" ? ColumnDetailsWidget(
                  typeText: columnReadDataModel.entryType!,
                  titleText: columnReadDataModel.entryTitle!,
                  takeAwayText: columnReadDataModel.entryTakeaway!,
                  noteText: columnReadDataModel.entryDecs!,
                  dateText: columnReadDataModel.entryDate!,
                )

                      //  Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Container(
                      //       margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                      //       child: Column(
                      //         children: [
                      //           Row(
                      //             children: [
                      //               const Text("Type: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                      //               Container(
                      //                   padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      //                   alignment: Alignment.centerLeft,
                      //                   margin:const EdgeInsets.symmetric(horizontal: 5),
                      //                   child: Text(columnReadDataModel.entryType!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
                      //
                      //             ],
                      //           ),
                      //
                      //           Row(
                      //             children: [
                      //               const Text("Title: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                      //               Expanded(
                      //                 child: Container(
                      //                     padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      //                     alignment: Alignment.centerLeft,
                      //                     margin:const EdgeInsets.symmetric(horizontal: 5),
                      //                     child: Text(columnReadDataModel.entryTitle!,textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize,),)),
                      //               ),
                      //
                      //
                      //             ],
                      //           ),
                      //
                      //           Row(
                      //             children: [
                      //               const Text("Date: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                      //               Container(
                      //                   padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      //                   alignment: Alignment.centerLeft,
                      //                   margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      //                   child: Text(" ${DateFormat('MM-dd-yy').format(DateTime.parse(columnReadDataModel.entryDate!.toString()))}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),)),
                      //
                      //             ],
                      //           ),
                      //
                      //           Row(
                      //             children: [
                      //               const Text("Note: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                      //               Expanded(
                      //                 child: Container(
                      //                   padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      //                   alignment: Alignment.centerLeft,
                      //                   margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      //                   child: Text(" ${columnReadDataModel.entryDecs!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
                      //               ),
                      //
                      //             ],
                      //           ),
                      //
                      //           Row(
                      //             children: [
                      //               const Text("Take Away: ",style: TextStyle(color: AppColors.primaryColor,fontSize: AppConstants.headingFontSizeForEntriesAndSession,fontWeight: FontWeight.bold),),
                      //               Expanded(
                      //                 child: Container(
                      //                   padding:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      //                   alignment: Alignment.centerLeft,
                      //                   margin:const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                      //                   child: Text(" ${columnReadDataModel.entryTakeaway!}",textAlign:TextAlign.start,style: const TextStyle(fontSize: AppConstants.columnDetailsScreenFontSize),),),
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // )
                      : widget.isTrellisColumnLadder == "trellis" ?
                  Padding(
                    padding:const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text("Name : ",style: TextStyle(color: AppColors.primaryColor),),
                            Expanded(child: Text(trellisDataHistoryResponse.data!.name!)),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text("Name Description: ",style: TextStyle(color: AppColors.primaryColor),),
                            Expanded(child: Text(trellisDataHistoryResponse.data!.nameDesc!)),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text("Purpose : ",style: TextStyle(color: AppColors.primaryColor),),
                            Expanded(child: Text(trellisDataHistoryResponse.data!.purpose!)),
                          ],
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  )
                      : widget.isTrellisColumnLadder == "ladder" ? LadderDetailsWidgets(
                  titleText: trellisLadderDataModel.text!,
                  typeText: trellisLadderDataModel.option2!,
                  favourite: trellisLadderDataModel.favourite!,
                  category: trellisLadderDataModel.option1!,
                  descriptionText: trellisLadderDataModel.description!,
                )
                  // Padding(
                  //   padding:const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const SizedBox(height: 10,),
                  //       Row(
                  //         children: [
                  //          const Text("Type : ",style: TextStyle(color: AppColors.primaryColor),),
                  //           Text(),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 10,),
                  //       Row(
                  //         children: [
                  //           const Text("Favourite : ",style: TextStyle(color: AppColors.primaryColor),),
                  //           Text(),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 10,),
                  //       Row(
                  //         children: [
                  //           const Text("Category : ",style: TextStyle(color: AppColors.primaryColor),),
                  //           Text(),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 10,),
                  //       Row(
                  //         children: [
                  //           const Text("Title : ",style: TextStyle(color: AppColors.primaryColor),),
                  //           Expanded(child: Text()),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 10,),
                  //       Row(
                  //         children: [
                  //           const Text("Description : ",style: TextStyle(color: AppColors.primaryColor),),
                  //           Expanded(child: Text()),
                  //         ],
                  //       ),
                  //      const SizedBox(height: 10,),
                  //     ],
                  //   ),
                  // )
                      : Column(
                        children: [
                          if(widget.isTrellisColumnLadder == "NAQ")
                            Text("Your NAQ Score is ${newGardenHistoryResponseDetailsModel.score}/100",style: const TextStyle(fontWeight: FontWeight.bold),),
                          if(widget.isTrellisColumnLadder == "NAQ")
                            const Divider(color: AppColors.primaryColor,),
                          ListView.builder(
                          padding:const EdgeInsets.symmetric(vertical: 10),
                          shrinkWrap: true,
                          itemCount:  newGardenHistoryResponseDetailsModel.data!.length,
                          physics:const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return PireNaqDetailsWidget(
                              listIndex: index,
                              answerText: newGardenHistoryResponseDetailsModel.data![index].text!,
                              optionText: newGardenHistoryResponseDetailsModel.data![index].options!,
                              questionText: newGardenHistoryResponseDetailsModel.data![index].question!,
                            );
                            //   Column(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Row(
                            //       children: [
                            //         Text(" Question ${index + 1} : "),
                            //         Expanded(
                            //           child: Html(data: newGardenHistoryResponseDetailsModel.data![index].question?.replaceAll("Q${index + 1}:", ""),style: {
                            //             "#" : Style(
                            //               color: AppColors.textWhiteColor,
                            //               fontSize: FontSize(AppConstants.defaultFontSize),
                            //               textAlign: TextAlign.start,
                            //
                            //             ),
                            //           },),
                            //         ),
                            //       ],
                            //     ),
                            //     if(newGardenHistoryResponseDetailsModel.data![index].options!="")
                            //     Row(
                            //       children: [
                            //       const Text("   Answer: ",style:  TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                            //         Expanded(
                            //           child: Html(data: newGardenHistoryResponseDetailsModel.data![index].options!.capitalize().replaceAll("Never", "1 - Never").replaceAll("Rarely", "2 - Rarely").replaceAll("Often", "3 - Often").replaceAll("Always", "4 - Always"),style: {
                            //             "#" : Style(
                            //               color: AppColors.textWhiteColor,
                            //               fontSize: FontSize(AppConstants.defaultFontSize),
                            //               textAlign: TextAlign.start,
                            //
                            //             ),
                            //           },),
                            //         ),
                            //     ],),
                            //     if(newGardenHistoryResponseDetailsModel.data![index].text!="")
                            //       Row(
                            //         children: [
                            //           Text(newGardenHistoryResponseDetailsModel.data![index].type == "naq" && newGardenHistoryResponseDetailsModel.data![index].options! == "yes" ? "  Why Yes:" : "   Answer: ",style:  const TextStyle(fontSize: AppConstants.defaultFontSize,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                            //           Expanded(
                            //             child: Html(data: newGardenHistoryResponseDetailsModel.data![index].text!,style: {
                            //               "#" : Style(
                            //                 color: AppColors.textWhiteColor,
                            //                 fontSize: FontSize(AppConstants.defaultFontSize),
                            //                 textAlign: TextAlign.start,
                            //
                            //               ),
                            //             },),
                            //           ),
                            //         ],),
                            //       const Divider(color: AppColors.primaryColor,height: 2,)
                            //   ],
                            // );
                          }),
                        ],
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
