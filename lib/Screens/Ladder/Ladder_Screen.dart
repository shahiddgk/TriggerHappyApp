// ignore_for_file: file_names, use_build_context_synchronously, depend_on_referenced_packages, avoid_print, duplicate_ignore, unrelated_type_equality_checks, unused_field


import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/model/request_model/ladder_add_favourite_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/share_custom_alert_dialogue.dart';
import '../../Widgets/video_player_in_pop_up.dart';
import '../../model/reponse_model/skipped_list_response_model.dart';
import '../../model/reponse_model/trellis_ladder_data_response.dart';
import '../../model/request_model/logout_user_request.dart';
import '../../model/request_model/read_trellis_model.dart';
import '../../model/request_model/trellis_data_saving_request.dart';
import '../../model/request_model/trellis_delete_request_model.dart';
import '../../model/request_model/trellis_ladder_request_model.dart';
import '../../network/http_manager.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/AppBar.dart';
import '../Trellis/widgets/bottom_sheet.dart';
import '../Widgets/show_notification_pop_up.dart';
import '../dashboard_tiles.dart';
import '../utill/userConstants.dart';

class LadderTileSection extends StatefulWidget {
  const LadderTileSection({Key? key}) : super(key: key);

  @override
  State<LadderTileSection> createState() => _LadderTileSectionState();
}

class _LadderTileSectionState extends State<LadderTileSection> {

  String name = "";
  String id = "";
  bool _isUserDataLoading = true;
  bool _isLoading = true;
  bool _isDataLoading = false;
  String email = "";
  String timeZone = "";
  String userType = "";
  bool isGoalsValue = true;
  String userPremium = "";
  String userPremiumType = "";
  String userCustomerId = "";
  String userSubscriptionId = "";

  bool otherUserLoggedIn = false;

  int badgeCount1 = 0;

 // bool isGoalsTabActive = true;
  bool isFavourite = false;

  String initialValueForType = "Physical";
  List itemsForType = ["Physical","Emotional","Relational","Work","Financial","Spiritual"];

  String initialValueForLadderType = "Goals";
  List itemsForLadderType = <String>["Goals", "Challenges", "Memories", "Achievements"];

  String initialValueForMType = "Memories";
  List itemsForMType = ["Memories","Achievements"];

  String initialValueForGType = "Goals";
  List itemsForGType = <String>["Goals","Challenges"];

  String ladderUrl = "https://www.youtube.com/watch?v=6g8EcajHQPY";

  List <TrellisLadderDataModel> trellisLadderData = [];
  List <TrellisLadderDataModel> trellisLadderDataForGoals = [];
  List <TrellisLadderDataModel> trellisLadderDataForChallenges = [];
  List <TrellisLadderDataModel> trellisLadderDataForMemoriesAndAchievements = [];

  // List <TrellisLadderDataModel> trellisLadderDataForGoalsAchievements = [];
  List <bool> trellisExpiryDateColor = [];
  // List <TrellisLadderDataModel> trellisLadderDataForGoalsChallenges = [];
  // List <TrellisLadderDataModel> trellisLadderDataForAchievements = [];
  int isLadderGoals = 2;
  int isLadderChallenges = 2;
  int isLadderMemories = 2;
  int isLadderAchievements = 2;
  int badgeCountShared = 0;

  TextEditingController dateForGController = TextEditingController();
  TextEditingController titleForGController = TextEditingController();
  TextEditingController descriptionForGController = TextEditingController();
  TextEditingController dateForMController = TextEditingController();
  TextEditingController titleForMController = TextEditingController();
  TextEditingController descriptionForMController = TextEditingController();

  _getUserData() async {
    setState(() {
      _isUserDataLoading = true;
    });
    // ignore: avoid_print
    print("Data getting called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("IsGoals", true);
    badgeCount1 = sharedPreferences.getInt("BadgeCount")!;
    badgeCountShared = sharedPreferences.getInt("BadgeShareResponseCount")!;

    otherUserLoggedIn = sharedPreferences.getBool(UserConstants().otherUserLoggedIn)!;

    if(otherUserLoggedIn) {

      name = sharedPreferences.getString(UserConstants().otherUserName)!;
      id = sharedPreferences.getString(UserConstants().otherUserId)!;

    } else {
      name = sharedPreferences.getString(UserConstants().userName)!;
      id = sharedPreferences.getString(UserConstants().userId)!;
      email = sharedPreferences.getString(UserConstants().userEmail)!;
      timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
      userType = sharedPreferences.getString(UserConstants().userType)!;

      userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
      userPremiumType = sharedPreferences.getString(UserConstants().userPremiumType)!;
      userCustomerId = sharedPreferences.getString(UserConstants().userCustomerId)!;
      userSubscriptionId = sharedPreferences.getString(UserConstants().userSubscriptionId)!;

      _getSkippedReminderList();
    }

     _getTrellisReadData();

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

  _getTrellisReadData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'ladder')).then((value) {
      print('TrellisRequestModel ===================>');
      // trellisLadderDataForGoalsAchievements.clear();
      // trellisLadderDataForGoalsChallenges.clear();
      // trellisLadderDataForGoals.clear();
      // trellisLadderDataForAchievements.clear();


      TrellisLadderDataListModel trellisLadderDataListModel  = TrellisLadderDataListModel.fromJson(value['data']);
      print('TrellisLadderList ===================> ${trellisLadderDataListModel.length}');

      trellisLadderData = trellisLadderDataListModel.values;

      for(int i=0; i < trellisLadderData.length;i++){
        if(trellisLadderData[i].type.toString() == "goal"){
          trellisLadderDataForGoals.add(trellisLadderData[i]);
        }else if(trellisLadderData[i].type.toString() == "challenges"){
          trellisLadderDataForChallenges.add(trellisLadderData[i]);
        }else {
          trellisLadderDataForMemoriesAndAchievements.add(trellisLadderData[i]);
        }


        trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));
        trellisLadderDataForChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
        trellisLadderDataForMemoriesAndAchievements.sort((a,b)=>b.date!.compareTo(a.date!));



          // trellisLadderDataForGoalsAchievements = trellisLadderDataListModel.values;
          //
          // for(int i=0; i< trellisLadderDataForGoalsAchievements.length;i++) {
          //   if (trellisLadderDataForGoalsAchievements[i].type.toString() == "goal") {
          //     if(trellisLadderDataForGoalsAchievements[i].option2 == "Challenges") {
          //       print("Challenges calling");
          //       trellisLadderDataForGoalsChallenges.add(trellisLadderDataForGoalsAchievements[i]);
          //     } else {
          //
          //       trellisLadderDataForGoals.add(trellisLadderDataForGoalsAchievements[i]);
          //     }
          //   } else {
          //     trellisLadderDataForAchievements.add(trellisLadderDataForGoalsAchievements[i]);
          //          }
          // }
          //
          // //trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
          // trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));
          // trellisLadderDataForAchievements.sort((a,b)=>b.date!.compareTo(a.date!));
          // trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
          setState(() {
            _isLoading = false;
          });
          // ignore: avoid_print
          print("Ladder Data Load");
        }
      // setState(() {
      //   _isLoading = false;
      // });
    }).catchError((e) {

      showToastMessage(context, e.toString(), false);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _getTrellisDetails();
    _getUserData();
    super.initState();
  }

  _getTrellisDetails() {
    setState(() {
      _isLoading = true;
    });

    HTTPManager().getAppVersion().then((value)  async {
      setState(() {
        isLadderGoals = int.parse(value['goals'].toString());
        isLadderChallenges = int.parse(value['challenges'].toString());
        isLadderMemories = int.parse(value['memories'].toString());
        isLadderAchievements = int.parse(value['achievements'].toString());

        _isLoading = false;
      });


    }).catchError((e) {
      // print(e);
      setState(() {
        _isLoading = false;
      });
    });
  }


  showDeletePopup(String type,String recordId,int index1,String goalsOrChallenges) {

    showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title:const Text('Confirm delete?'),
            content:const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text("Are you sure you want to delete!"),
            ),
            actions: [
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // ignore: deprecated_member_use
              TextButton(
                child:const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteRecord(type, recordId, index1,goalsOrChallenges);
                },
              ),
            ],
          );
        });
  }

  Future<bool> _onWillPop() async {
    // if(nameController.text.isNotEmpty || descriptionController.text.isNotEmpty || purposeController.text.isNotEmpty || mentorNameController.text.isNotEmpty || mentorDescriptionController.text.isNotEmpty || peerNameController.text.isNotEmpty || peerDescriptionController.text.isNotEmpty || menteeNameController.text.isNotEmpty || menteeDescriptionController.text.isNotEmpty) {
    //   _setTrellisData();
    // }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBarWidget().appBarGeneralButtonsWithOtherUserLogged(
            context,
                () {
              Navigator.of(context).pop();
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (BuildContext context) =>const Dashboard()),
              //         (Route<dynamic> route) => false
              // );
            }, true, true, true, id, true,true,badgeCount1,false,badgeCountShared,otherUserLoggedIn,name),
        floatingActionButton: Visibility(
          visible: !otherUserLoggedIn,
          child: FloatingActionButton(
            onPressed: () async {
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setBool("IsGoals", true);
              print(userPremium);

              setState(() {
                 initialValueForType = "Physical";
                 initialValueForMType = "Memories";
                 initialValueForLadderType = "Goals";
                 initialValueForGType = "Goals";
                 titleForGController.clear();
                 descriptionForGController.clear();
                 dateForGController.clear();
                 dateForGController.text = "";
                 descriptionForGController.text = "";
                 titleForGController.text = "";
              });

              ladderBottomSheet(false,context,true,true,"Ladder",
                      initialValueForType,itemsForType,
                      initialValueForLadderType, itemsForLadderType,
                      initialValueForMType, itemsForMType,
                      initialValueForGType, itemsForGType,
                      () async {
                            print('Ladder Type ===========> $initialValueForLadderType' );
                            print('Type ===========> $initialValueForType' );
                            if(userPremium == "no" && trellisLadderDataForGoals.length >= isLadderGoals && trellisLadderDataForChallenges.length >= isLadderChallenges && trellisLadderDataForMemoriesAndAchievements.length >= isLadderAchievements){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                            }else{
                              if(initialValueForLadderType != "Challenges"){
                                if(dateForGController.text.isEmpty) {
                                  showToastMessage(context, "Please select a date", false);
                                   return;
                                  }
                              }

                              if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                print(initialValueForLadderType);
                                print(initialValueForType);
                                _setLadderGoalsData();

                              }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                initialValueForType = "";
                                print(initialValueForLadderType);
                                print(initialValueForType);
                                _setLadderMemoriesData();
                              }



                            }




                            // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                            // bool isGoalsValue = sharedPreferences.getBool("IsGoals")!;
                            // if(isGoalsValue) {
                            //   String ladderType = sharedPreferences.getString('ladderType') ?? 'goal';
                            //   if(userPremium == "no" && trellisLadderDataForGoals.length>=isLadderGoals) {
                            //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                            //   } else {
                            //     print("Goals Saving");
                            //     if(initialValueForType == "Memories" || initialValueForType == "Achievements")
                            //     {
                            //       setState(() {
                            //         initialValueForType = "physical";
                            //       });
                            //     }
                            //     if(initialValueForGoals == "Challenges") {
                            //
                            //       _setLadderGoalsData(ladderType);
                            //     } else {
                            //         if(dateForGController.text.isNotEmpty) {
                            //           _setLadderGoalsData(ladderType);
                            //         } else {
                            //           showToastMessage(context, "Please select a date", false);
                            //         }
                            //     }
                            //
                            //   }
                            // } else {
                            //   String ladderType = sharedPreferences.getString('ladderType') ?? 'achievements';
                            //   if(userPremium == "no" && trellisLadderDataForAchievements.length>=isLadderAchievements) {
                            //         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                            //       } else {
                            //     print("Memories saving");
                            //     if(initialValueForType == "physical" || initialValueForType == "Emotional" || initialValueForType =="Relational" || initialValueForType =="Work" || initialValueForType =="Financial" || initialValueForType =="Spiritual")
                            //       {
                            //         setState(() {
                            //           initialValueForType = "Memories";
                            //         });
                            //       }
                            //     _setLadderMemoriesData(ladderType);
                            //   }
                            // }
                      },
                      (value) {
                          print(value);
                          setState(() {
                              initialValueForLadderType = value;
                          });
                      },
                      (value) {
                        print(value);
                        setState(() {
                            initialValueForType = value;
                          });
                      },
                      dateForGController,
                      titleForGController,
                      descriptionForGController
                  );
              },
            child: const Icon(Icons.add,size:40,color: AppColors.backgroundColor,),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LogoScreen("Ladder"),
                      const SizedBox(width: 20,),
                      IconButton(onPressed: (){
                        String? videoId = YoutubePlayer.convertUrlToId(ladderUrl);
                        YoutubePlayerController playerController3 = YoutubePlayerController(
                            initialVideoId: videoId!,
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                              controlsVisibleAtStart: false,
                            )

                        );
                        videoPopupDialog(context,"Introduction to Ladder",playerController3);
                        //bottomSheet(context,"Trellis","Welcome to Trellis, the part of the Brugeon app designed to help you flourish and live life intentionally. Trellis is a light structure that provides structure and focus, and helps propel you towards your desired outcomes. Invest at least five minutes a day in reviewing and meditating on your Trellis. If you don't have any answers yet, spend your time meditating, praying, or journaling on the questions/sections. If you have partial answers, keep taking your time daily to consider the questions and your answers. By consistently returning to your Trellis, you will become more clear and focused on creating the outcomes you desire. Enjoy your Trellis!","");
                      }, icon: const Icon(Icons.ondemand_video,size:30,color: AppColors.infoIconColor,)),
                      const SizedBox(height: 5,),

                    ],
                  ),
                 Visibility(
                   visible: !_isLoading,
                   child: Container(
                     alignment: Alignment.centerLeft,
                       padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                       child: const Text("Future",style: TextStyle(fontSize: AppConstants.headingFontSizeForCreation,color: AppColors.primaryColor,fontWeight: FontWeight.bold),)),
                 ),
                  _isLoading ? const Center(child: CircularProgressIndicator(),) : Container(
                    margin:const EdgeInsets.symmetric(horizontal: 10),
                    child: trellisLadderDataForGoals.isEmpty ? const Text("No data available") : ListView.builder(
                      physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:trellisLadderDataForGoals.length,
                        itemBuilder: (context, index) {
                          final now = DateTime.now();
                          final expirationDate = DateTime.parse(trellisLadderDataForGoals[index].date.toString());
                          final bool isExpired = expirationDate.isBefore(now);
                          trellisLadderDataForGoals[index].isExpired = isExpired;
                          print(isExpired);
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildPopupDialog(context,"Goals",trellisLadderDataForGoals[index],true),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: trellisLadderDataForGoals[index].isExpired! ? AppColors.warningYellowColor : AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${trellisLadderDataForGoals[index].option1?.capitalize()} ${ trellisLadderDataForGoals[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                        if(!otherUserLoggedIn)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                print(isFavourite);
                                                if(trellisLadderDataForGoals[index].favourite != 'no'){
                                                  _setLadderFavouriteItem(index,trellisLadderDataForGoals[index].id.toString(),trellisLadderDataForGoals[index].favourite.toString(),true);
                                                }else {
                                                  final items = trellisLadderDataForGoals.where((e) => e.favourite != 'no');
                                                  if (items.length < 2) {
                                                    _setLadderFavouriteItem(index, trellisLadderDataForGoals[index].id.toString(), trellisLadderDataForGoals[index].favourite.toString(),true);
                                                  }else{
                                                    showToastMessage(context, "You cannot add more than two goals as favorites", false);
                                                  }
                                                }
                                              },
                                              child: trellisLadderDataForGoals[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                            ),
                                            // const SizedBox(width: 2,),
                                            // InkWell(
                                            //   onTap: (){
                                            //     mentorPeerPopUp(context);
                                            //   },
                                            //   child: const Icon(Icons.share,color: AppColors.primaryColor,),
                                            // ),

                                            IconButton(onPressed: () async {
                                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                              sharedPreferences.setBool("IsGoals", true);
                                              setState(() {
                                                titleForGController.clear();
                                                descriptionForGController.clear();
                                                descriptionForGController.text = "";
                                                titleForGController.text = "";
                                              });
                                              setState(() {
                                                initialValueForType = trellisLadderDataForGoals[index].option1!;
                                                initialValueForLadderType = trellisLadderDataForGoals[index].option2!;
                                                dateForGController.text = trellisLadderDataForGoals[index].date!;
                                                titleForGController.text = trellisLadderDataForGoals[index].text!;
                                                descriptionForGController.text = trellisLadderDataForGoals[index].description!;
                                              });

                                              ladderBottomSheet(false,context,true,true,"Ladder",
                                                  initialValueForType,itemsForType,
                                                  initialValueForLadderType, itemsForLadderType,
                                                  initialValueForMType, itemsForMType,
                                                  initialValueForGType, itemsForGType,
                                                      () async {
                                                    print('Ladder Type ===========> $initialValueForLadderType' );
                                                    print('Type ===========> $initialValueForType' );
                                                    if(userPremium == "no" && trellisLadderDataForGoals.length >= isLadderGoals && trellisLadderDataForChallenges.length >= isLadderChallenges && trellisLadderDataForMemoriesAndAchievements.length >= isLadderAchievements){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                    }else{
                                                      if(initialValueForLadderType != "Challenges"){
                                                        if(dateForGController.text.isEmpty) {
                                                          showToastMessage(context, "Please select a date", false);
                                                          return;
                                                        }
                                                      }

                                                      if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                                        print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                                        print(initialValueForLadderType);
                                                        print(initialValueForType);
                                                        _updateLadderGoalsData('goal',trellisLadderDataForGoals[index].id!, index);



                                                      }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                                        print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                                        initialValueForType = "";
                                                        print(initialValueForLadderType);
                                                        print(initialValueForType);
                                                        _updateLadderMemoriesData('goal',trellisLadderDataForGoals[index].id!,index);

                                                      }
                                                    }

                                                  },
                                                      (value) {
                                                    print(value);
                                                    setState(() {
                                                      initialValueForLadderType = value;
                                                    });
                                                  },
                                                      (value) {
                                                    print(value);
                                                    setState(() {
                                                      initialValueForType = value;
                                                    });
                                                  },
                                                  dateForGController,
                                                  titleForGController,
                                                  descriptionForGController
                                              );

                                             // showDeletePopup( "goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
                                            }, icon: const Icon(Icons.edit,color: AppColors.primaryColor,),),
                                            IconButton(
                                                onPressed: () async {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return ShareCustomAlertDialogue(responseId: trellisLadderDataForGoals[index].id.toString(), isModule: false, responseType: "ladder");
                                                      }
                                                  );
                                                  // showThumbsUpDialogue(context, _animationController, id, 'ladder', trellisLadderDataForGoals[index].id.toString(), selectedUserAcceptedConnectionsListResponse, searchAcceptedConnectionsListResponse, acceptedConnectionsListResponse);
                                                },
                                                icon: const Icon(Icons.share,color: AppColors.primaryColor,)),
                                            IconButton(onPressed: () {
                                              showDeletePopup("goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
                                            }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                          ],
                                        )
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("${trellisLadderDataForGoals[index].option2 == "Challenges" ? "" : DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForGoals[index].date.toString()))} ${trellisLadderDataForGoals[index].option2 == "Challenges" ? "" : "|" } ${trellisLadderDataForGoals[index].text}"))
                                  ],
                                )),
                          );
                        }),
                  ),
                  Visibility(
                      visible: !_isLoading,
                      child: const Divider(color: AppColors.primaryColor,thickness: 2,)),
                  Visibility(
                    visible: !_isLoading,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: const Text("Present",style: TextStyle(fontSize: AppConstants.headingFontSizeForCreation,color: AppColors.primaryColor,fontWeight: FontWeight.bold),)),
                  ),
                  _isLoading ? const Center() : Container(
                    margin:const EdgeInsets.symmetric(horizontal: 10),
                    child: trellisLadderDataForChallenges.isEmpty ? const Text("No data available") : ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:trellisLadderDataForChallenges.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildPopupDialog(context,"Challenges",trellisLadderDataForChallenges[index],true),
                              );
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${trellisLadderDataForChallenges[index].option1?.capitalize()} ${ trellisLadderDataForChallenges[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                        if(!otherUserLoggedIn)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print(isFavourite);
                                                if(trellisLadderDataForChallenges[index].favourite != 'no'){
                                                  _setLadderFavouriteItem(index,trellisLadderDataForChallenges[index].id.toString(),trellisLadderDataForChallenges[index].favourite.toString(),true);
                                                }else{
                                                  final items = trellisLadderDataForChallenges.where((e) => e.favourite != 'no');
                                                  if(items.length < 2){
                                                    _setLadderFavouriteItem(index,trellisLadderDataForChallenges[index].id.toString(),trellisLadderDataForChallenges[index].favourite.toString(),true);
                                                  }else{
                                                    showToastMessage(context, "You cannot add more than two challenges as favorites", false);
                                                  }
                                                }
                                              },
                                              child: trellisLadderDataForChallenges[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                            ),
                                            IconButton(onPressed: () async {
                                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                              sharedPreferences.setBool("IsGoals", true);
                                              setState(() {
                                                titleForGController.clear();
                                                descriptionForGController.clear();
                                                descriptionForGController.text = "";
                                                titleForGController.text = "";
                                              });
                                              setState(() {
                                                initialValueForType = trellisLadderDataForChallenges[index].option1!.capitalize();
                                                initialValueForLadderType = trellisLadderDataForChallenges[index].option2!;
                                                // dateForGController.text = trellisLadderDataForGoalsChallenges[index].date!;
                                                titleForGController.text = trellisLadderDataForChallenges[index].text!;
                                                descriptionForGController.text = trellisLadderDataForChallenges[index].description!;
                                              });

                                              ladderBottomSheet(false,context,true,false,"Ladder",
                                                  initialValueForType,itemsForType,
                                                  initialValueForLadderType, itemsForLadderType,
                                                  initialValueForMType, itemsForMType,
                                                  initialValueForGType, itemsForGType,
                                                      () async {
                                                    print('Ladder Type ===========> $initialValueForLadderType' );
                                                    print('Type ===========> $initialValueForType' );
                                                    if(userPremium == "no" && trellisLadderDataForGoals.length >= isLadderGoals && trellisLadderDataForChallenges.length >= isLadderChallenges && trellisLadderDataForMemoriesAndAchievements.length >= isLadderAchievements){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                    }else{
                                                      if(initialValueForLadderType != "Challenges"){
                                                        if(dateForGController.text.isEmpty) {
                                                          showToastMessage(context, "Please select a date", false);
                                                          return;
                                                        }
                                                      }

                                                      if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                                        print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                                        print(initialValueForLadderType);
                                                        print(initialValueForType);
                                                        _updateLadderGoalsData('challenges',trellisLadderDataForChallenges[index].id!, index);



                                                      }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                                        print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                                        initialValueForType = "";
                                                        print(initialValueForLadderType);
                                                        print(initialValueForType);
                                                        _updateLadderMemoriesData('challenges',trellisLadderDataForChallenges[index].id!,index);

                                                      }
                                                    }

                                                  },
                                                      (value) {
                                                    print(value);
                                                    setState(() {
                                                      initialValueForLadderType = value;
                                                    });
                                                  },
                                                      (value) {
                                                    print(value);
                                                    setState(() {
                                                      initialValueForType = value;
                                                    });
                                                  },
                                                  dateForGController,
                                                  titleForGController,
                                                  descriptionForGController
                                              );

                                              // showDeletePopup( "goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
                                            }, icon: const Icon(Icons.edit,color: AppColors.primaryColor,),),
                                            IconButton(
                                                onPressed: () async {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return ShareCustomAlertDialogue(responseId: trellisLadderDataForChallenges[index].id.toString(), isModule: false, responseType: "ladder");
                                                      }
                                                  );
                                                },
                                                icon: const Icon(Icons.share,color: AppColors.primaryColor,)),
                                            IconButton(onPressed: () {
                                              showDeletePopup("challenges",trellisLadderDataForChallenges[index].id.toString(),index,trellisLadderDataForChallenges[index].type!);
                                            }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                          ],
                                        )
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("${trellisLadderDataForChallenges[index].option2 == "Challenges" ? "" : DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForChallenges[index].date.toString()))} ${trellisLadderDataForChallenges[index].option2 == "Challenges" ? "" : "|" } ${trellisLadderDataForChallenges[index].text}"))
                                  ],
                                )),
                          );
                        }),
                  ),
                 Visibility(
                     visible: !_isLoading,
                     child: const Divider(color: AppColors.primaryColor,thickness: 2,)),
                  Visibility(
                    visible: !_isLoading,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: const Text("Past",style: TextStyle(fontSize: AppConstants.headingFontSizeForCreation,color: AppColors.primaryColor,fontWeight: FontWeight.bold),)),
                  ),
                  _isLoading ? const Center() : Container(
                    margin:const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics:const NeverScrollableScrollPhysics(),
                        itemCount:trellisLadderDataForMemoriesAndAchievements.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print('Gesture Clicked =========> ${trellisLadderDataForMemoriesAndAchievements[index]}');

                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements",trellisLadderDataForMemoriesAndAchievements[index],true),
                              );
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                padding:const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${trellisLadderDataForMemoriesAndAchievements[index].option2?.capitalize()}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                        if(!otherUserLoggedIn)
                                          Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print(isFavourite);
                                                if(trellisLadderDataForMemoriesAndAchievements[index].favourite != 'no'){
                                                  _setLadderFavouriteItem(index,trellisLadderDataForMemoriesAndAchievements[index].id.toString(),trellisLadderDataForMemoriesAndAchievements[index].favourite.toString(),false);
                                                }else{
                                                  final items = trellisLadderDataForMemoriesAndAchievements.where((e) => e.favourite != 'no' );
                                                  if(items.length < 2){
                                                    _setLadderFavouriteItem(index,trellisLadderDataForMemoriesAndAchievements[index].id.toString(),trellisLadderDataForMemoriesAndAchievements[index].favourite.toString(),false);
                                                  }else{
                                                    showToastMessage(context, "You cannot add more than two memories or achievements as favorites", false);
                                                  }
                                                }
                                              },
                                              child: trellisLadderDataForMemoriesAndAchievements[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                              sharedPreferences.setBool("IsGoals", false);
                                              setState(() {
                                                titleForGController.clear();
                                                descriptionForGController.clear();
                                                dateForGController.clear();
                                                dateForGController.text = "";
                                                descriptionForGController.text = "";
                                                titleForGController.text = "";
                                              });
                                              setState(() {
                                                initialValueForLadderType = trellisLadderDataForMemoriesAndAchievements[index].option2!.capitalize();
                                                initialValueForType = 'Physical';
                                                dateForGController.text = trellisLadderDataForMemoriesAndAchievements[index].date!;
                                                titleForGController.text = trellisLadderDataForMemoriesAndAchievements[index].text!;
                                                descriptionForGController.text = trellisLadderDataForMemoriesAndAchievements[index].description!;
                                              });

                                              ladderBottomSheet(false,context,false,true,"Ladder",
                                                  initialValueForType,itemsForType,
                                                  initialValueForLadderType, itemsForLadderType,
                                                  initialValueForMType, itemsForMType,
                                                  initialValueForGType, itemsForGType,
                                                      () async {
                                                    print('Ladder Type ===========> $initialValueForLadderType' );
                                                    print('Type ===========> $initialValueForType' );
                                                    if(userPremium == "no" && trellisLadderDataForGoals.length >= isLadderGoals && trellisLadderDataForChallenges.length >= isLadderChallenges && trellisLadderDataForMemoriesAndAchievements.length >= isLadderAchievements){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                    }else{
                                                      if(initialValueForLadderType != "Challenges"){
                                                        if(dateForGController.text.isEmpty) {
                                                          showToastMessage(context, "Please select a date", false);
                                                          return;
                                                        }
                                                      }

                                                      if(initialValueForLadderType == "Goals" || initialValueForLadderType == "Challenges"){
                                                        print('Initial Value For Ladder Type is Goals or Challenges ========> ');
                                                        print(initialValueForLadderType);
                                                        print(initialValueForType);
                                                        _updateLadderGoalsData('',trellisLadderDataForMemoriesAndAchievements[index].id!, index);



                                                      }else if(initialValueForLadderType == "Memories" || initialValueForLadderType == "Achievements"){
                                                        print('Initial Value For Ladder Type is Memories or Achievements ========> ');
                                                        initialValueForType = "";
                                                        print(initialValueForLadderType);
                                                        print(initialValueForType);
                                                        _updateLadderMemoriesData('',trellisLadderDataForMemoriesAndAchievements[index].id!,index);

                                                      }
                                                    }

                                                  },
                                                      (value) {
                                                    print(value);
                                                    setState(() {
                                                      initialValueForLadderType = value;
                                                    });
                                                  },
                                                      (value) {
                                                    print(value);
                                                    setState(() {
                                                      initialValueForType = value;
                                                    });
                                                  },
                                                  dateForGController,
                                                  titleForGController,
                                                  descriptionForGController
                                              );

                                              // showDeletePopup( "goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
                                            }, icon: const Icon(Icons.edit,color: AppColors.primaryColor,),),
                                            IconButton(
                                                onPressed: () async {
                                                  showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return ShareCustomAlertDialogue(responseId: trellisLadderDataForMemoriesAndAchievements[index].id.toString(), isModule: false, responseType: "ladder");
                                                      }
                                                  );
                                                },
                                                icon: const Icon(Icons.share,color: AppColors.primaryColor,)),
                                            IconButton(onPressed: () {
                                              showDeletePopup( trellisLadderDataForMemoriesAndAchievements[index].type ?? 'memories',trellisLadderDataForMemoriesAndAchievements[index].id.toString(),index,"");
                                            }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                          ],
                                        )
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForMemoriesAndAchievements[index].date.toString()))} | ${trellisLadderDataForMemoriesAndAchievements[index].text}"))
                                  ],
                                )),
                          );
                        }),
                  ),
                  if(!otherUserLoggedIn)
                    Align(
                    alignment: Alignment.center,
                    child: Visibility(
                      visible: !_isLoading,
                      child: ElevatedButton(
                        onPressed: (){
                          _saveLadderTriggerResponse();
                        },
                        style:ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: const Text("I Read My Ladder Today",style: TextStyle(color: AppColors.backgroundColor),),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/16,)
                ],
              ),
            ),
            _isDataLoading ?
            const Center(child: CircularProgressIndicator())
                : Container() ,
          ],
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context,String heading,TrellisLadderDataModel trellisLadderDataModel1, bool oneCategory) {
    return  AlertDialog(
      backgroundColor: AppColors.lightGreyColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ladder",style: TextStyle(fontSize: AppConstants.headingFontSize),),
              Text(heading,style: const TextStyle(fontSize: AppConstants.defaultFontSize,color: AppColors.primaryColor),),
            ],
          ),
          IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon:const Icon(Icons.cancel))
        ],),
      content:  Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const  Expanded(
                      flex:1,
                      child: Text("Type: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(trellisLadderDataModel1.type?.capitalize() ?? '')),
                ],
              ),
            ),
            Visibility(
              visible: trellisLadderDataModel1.type == 'goal' || trellisLadderDataModel1.type == 'challenges' ,
              child: Container(
                margin:const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                        flex:1,
                        child: Text("Category: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                    Expanded(
                        flex: 2,
                        child: Text(trellisLadderDataModel1.option1?.capitalize() ?? '')),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: trellisLadderDataModel1.type != 'challenges',
              child: Container(
                  margin:const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                          flex:1,
                          child: Text("Date: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                      Expanded(
                          flex: 2,
                          child: Text(trellisLadderDataModel1.option2! == "Challenges" ? "" :DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataModel1.date.toString())))),
                    ],
                  ),
                ),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      flex:1,
                      child: Text("Title: ",style: TextStyle(fontWeight: FontWeight.bold),)),

                  Expanded(
                      flex: 2,
                      child: Text(trellisLadderDataModel1.text!)),
                ],
              ),
            ),
            Container(
              margin:const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Description: ",style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                      child: Text(trellisLadderDataModel1.description!)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _setLadderFavouriteItem(int indexItem,String responseId,String status,bool isGoals) {
    String? favouriteStatus;
    if(status == "yes") {
      setState(() {
        favouriteStatus = "no";
      });
    } else {
      setState(() {
        favouriteStatus = "yes";
      });
    }
    print(favouriteStatus);
    setState(() {
      _isDataLoading = true;
    });

    HTTPManager().ladderAddFavourite(LadderAddFavouriteItem(responseId:responseId,favStatus: favouriteStatus)).then((value) {

      showToastMessage(context,value['data']['favourite'] == "no" ? "Removed from favorites" : "Added to favorites", true);

      TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['data']['id'],
          userId: value['data']['user_id'],
          type: value['data']['type'],
          favourite: value['data']['favourite'],
          option1: value['data']['option1'],
          option2: value['data']['option2'],
          date: value['data']['date'],
          text: value['data']['text'],
          description: value['data']['description'],
      );

      if(trellisLadderDataModel.type == "goal"){
        trellisLadderDataForGoals[indexItem] = trellisLadderDataModel;
      }else if(trellisLadderDataModel.type == "challenges"){
        trellisLadderDataForChallenges[indexItem] = trellisLadderDataModel;
      }else{
        setState(() {
          trellisLadderDataForMemoriesAndAchievements[indexItem] = trellisLadderDataModel;
        });
      }

      setState(() {
        _isDataLoading = false;
      });
    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      print(e.toString());
      setState(() {
        _isDataLoading = false;
      });
    });
  }


  _setLadderGoalsData() {
    // ignore: avoid_print
    // print("Selected Date:${dateForGController.text}");

    print('Setting Ladder Goals Data  =================> Ladder Type = $initialValueForLadderType');

    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });




      HTTPManager().trellisLadderForGoals(TrellisLadderGoalsRequestModel(userId: id,type: initialValueForLadderType == "Goals" ? "goal" : initialValueForLadderType.toLowerCase(),option1: initialValueForType,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text,insertFrom: "ladder")).then((value) {

        Navigator.of(context).pop();
        setState(() {
          initialValueForLadderType = "Goals";
          initialValueForType = "Physical";
          initialValueForMType = "Memories";
          initialValueForGType = "Goals";
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });
        print('After Setting Ladder Goals Data  =================> Ladder Type = ${value['post_data']['type']}');

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          type: value['post_data']['type'].toString(),
          favourite: "no",
          option1: value['post_data']['option1'].toString(),
          option2: value['post_data']['option2'].toString(),
          date: value['post_data']['date'].toString(),
          text: value['post_data']['text'].toString(),
          description: value['post_data']['description'].toString(),
        );
        if(trellisLadderDataModel.type == "challenges") {
          trellisLadderDataForChallenges.add(trellisLadderDataModel);
          trellisLadderDataForChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
        } else {
          trellisLadderDataForGoals.add(trellisLadderDataModel);
          trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));
        }





        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Goals");
        showToastMessage(context, "Added successfully", true);
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some text to title field please", false);
    }
  }

  _updateLadderGoalsData(String updateType,String ladderGoalsId, int index1) {
    // ignore: avoid_print
    // print("Selected Date:${dateForGController.text}");

    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForGoalsUpdate(TrellisLadderGoalsUpdateRequestModel(ladderId: ladderGoalsId,type: initialValueForLadderType == "Goals" ? 'goal' :  initialValueForLadderType.toLowerCase(),option1: initialValueForType,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text)).then((value) {



        Navigator.of(context).pop();

        if(updateType == "challenges") {
          setState(() {
            trellisLadderDataForChallenges.removeAt(index1);
          });
        } else if(updateType == "goal") {
          setState(() {
            trellisLadderDataForGoals.removeAt(index1);
          });
        }else{
          setState(() {
            trellisLadderDataForMemoriesAndAchievements.removeAt(index1);
          });
        }

        setState(() {
          initialValueForLadderType = "Goals";
          initialValueForType = "Physical";
          initialValueForMType = "Memories";
          initialValueForGType = "Goals";
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        final now = DateTime.now();
        final expirationDate = DateTime.parse(value['updated_data']['date'].toString());
        final bool isExpired = expirationDate.isBefore(now);

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['updated_data']['id'].toString(),
          userId: value['updated_data']['user_id'].toString(),
          type: value['updated_data']['type'].toString(),
          favourite: value['updated_data']['favourite'].toString(),
          option1: value['updated_data']['option1'].toString(),
          option2: value['updated_data']['option2'].toString(),
          date: value['updated_data']['date'].toString(),
          text: value['updated_data']['text'].toString(),
          description: value['updated_data']['description'].toString(),
          isExpired: isExpired
        );
        if(trellisLadderDataModel.type == "challenges") {
          trellisLadderDataForChallenges.add(trellisLadderDataModel);
          trellisLadderDataForChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
        }else{
          trellisLadderDataForGoals.add(trellisLadderDataModel);
          trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));
        }




        // _getTrellisReadData(false);
        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Goals");
        showToastMessage(context, "Updated successfully", true);
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some text to title field please", false);
    }
  }


  _setLadderMemoriesData() {
    print('Setting Ladder Memories Data  =================> Ladder Type = $initialValueForLadderType');

    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForAchievements(TrellisLadderAchievementRequestModel(userId: id,type: initialValueForLadderType.toLowerCase(),option1:initialValueForType,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text,insertFrom: "ladder")).then((value) {

        Navigator.of(context).pop();
        setState(() {
          initialValueForLadderType = "Goals";
          initialValueForType = "Physical";
          initialValueForMType = "Memories";
          initialValueForGType = "Goals";
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });
        print('After Setting Ladder Memories Data  =================> Ladder Type = ${value['post_data']['type']}');

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          type: value['post_data']['type'].toString(),
          favourite: "no",
          option1: value['post_data']['option1'].toString(),
          option2: value['post_data']['option2'].toString(),
          date: value['post_data']['date'].toString(),
          text: value['post_data']['text'].toString(),
          description: value['post_data']['description'].toString(),
        );


        trellisLadderDataForMemoriesAndAchievements.add(trellisLadderDataModel);
        trellisLadderDataForMemoriesAndAchievements.sort((a,b)=>b.date!.compareTo(a.date!));


        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Achievements");
        showToastMessage(context, "Added successfully", true);
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some data please", false);
    }
  }

  _updateLadderMemoriesData(String updateType,String ladderMemoriesId, int index) {
    print("Ladder Memories ID");
    print(ladderMemoriesId);
    print(initialValueForType);
    print(dateForGController.text);
    print(titleForGController.text);
    print(descriptionForGController.text);

    if(initialValueForLadderType != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForAchievementsUpdate(TrellisLadderAchievementUpdateRequestModel(ladderId: ladderMemoriesId,type: initialValueForLadderType.toLowerCase(),option1:initialValueForType ,option2: initialValueForLadderType,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text)).then((value) {

        Navigator.of(context).pop();

        if(updateType == "challenges") {
          setState(() {
            trellisLadderDataForChallenges.removeAt(index);
          });
        } else if(updateType == "goal") {
          setState(() {
            trellisLadderDataForGoals.removeAt(index);
          });
        }else{
          setState(() {
            trellisLadderDataForMemoriesAndAchievements.removeAt(index);
          });
        }




        setState(() {
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['updated_data']['id'].toString(),
          userId: value['updated_data']['user_id'].toString(),
          type: value['updated_data']['type'].toString(),
          favourite: value['updated_data']['favourite'].toString(),
          option1: value['updated_data']['option1'].toString(),
          option2: value['updated_data']['option2'].toString(),
          date: value['updated_data']['date'].toString(),
          text: value['updated_data']['text'].toString(),
          description: value['updated_data']['description'].toString(),
        );
        trellisLadderDataForMemoriesAndAchievements.add(trellisLadderDataModel);
        trellisLadderDataForMemoriesAndAchievements.sort((a,b)=>b.date!.compareTo(a.date!));
        setState(() {
          _isDataLoading = false;
        });
        // print(value);
        // print("Ladder Data For Achievements");
        showToastMessage(context, "Updated successfully", true);
      }).catchError((e) {
        showToastMessage(context, e.toString(), false);
        setState(() {
          _isDataLoading = false;
        });
      });

    } else {
      showToastMessage(context, "Add some data please", false);
    }
  }

  _saveLadderTriggerResponse() {
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().ladderTriggerData(TrellisTriggerRequestModel(userId: id)).then((value) {
      // ignore: avoid_print
      print(value);
      setState(() {
        _isDataLoading = false;
      });
      showToastMessage(context, "Great job growing your Garden!", true);
    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      setState(() {
        _isDataLoading = false;
      });
      print(e);
    });
  }

  _deleteRecord(String type,String recordId,int index,String goalsOrChallenges) {
    print('Request Data =============>');
    print(id);
    print(recordId);
    print(type);
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().trellisDelete(TrellisDeleteRequestModel(userId: id,recordId: recordId,type:type)).then((value) {

      if(type == "challenges") {
          setState(() {
            trellisLadderDataForChallenges.removeAt(index);
          });
      } else if(type == "goal") {
        setState(() {
          trellisLadderDataForGoals.removeAt(index);
        });
      } else if(type == "achievements" || type == "memories" ) {
        setState(() {
          trellisLadderDataForMemoriesAndAchievements.removeAt(index);
        });
      }
      setState(() {
        _isDataLoading = false;
      });
      // print(value);
      // _getTrellisReadData(false);
      showToastMessage(context, "Deleted successfully", true);

    }).catchError((e) {
      showToastMessage(context, e.toString(), false);
      setState(() {
        _isDataLoading = false;
      });
    });
  }
}

extension StringExtensions on String {
  String capitalize() {
    if(isEmpty){
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
