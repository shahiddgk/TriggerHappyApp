// ignore_for_file: file_names, use_build_context_synchronously, depend_on_referenced_packages, avoid_print, duplicate_ignore, unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/Screens/Widgets/toast_message.dart';
import 'package:flutter_quiz_app/Widgets/logo_widget_for_all_screens.dart';
import 'package:flutter_quiz_app/model/request_model/ladder_add_favourite_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../Widgets/colors.dart';
import '../../Widgets/constants.dart';
import '../../model/reponse_model/trellis_ladder_data_response.dart';
import '../../model/request_model/read_trellis_model.dart';
import '../../model/request_model/trellis_data_saving_request.dart';
import '../../model/request_model/trellis_delete_request_model.dart';
import '../../model/request_model/trellis_ladder_request_model.dart';
import '../../network/http_manager.dart';
import '../Payment/payment_screen.dart';
import '../PireScreens/widgets/PopMenuButton.dart';
import '../Trellis/widgets/bottom_sheet.dart';
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

 // bool isGoalsTabActive = true;
  bool isFavourite = false;

  String initialValueForType = "physical";
  List itemsForType = ["physical","Emotional","Relational","Work","Financial","Spiritual"];

  String initialValueForMType = "Memories";
  List itemsForMType = ["Memories","Achievements"];

  String initialValueForGoals = "Goals";
  String initialValueForMGoals = "Goals";
  List itemsForGoals = <String>["Goals","Challenges"];

  List <TrellisLadderDataModel> trellisLadderDataForGoalsAchievements = [];
  List <TrellisLadderDataModel> trellisLadderDataForGoals = [];
  List <bool> trellisExpiryDateColor = [];
 List <TrellisLadderDataModel> trellisLadderDataForGoalsChallenges = [];
  List <TrellisLadderDataModel> trellisLadderDataForAchievements = [];
  int isLadderGoals = 2;
  int isLadderAchievements = 2;

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

    name = sharedPreferences.getString(UserConstants().userName)!;
    id = sharedPreferences.getString(UserConstants().userId)!;
    email = sharedPreferences.getString(UserConstants().userEmail)!;
    timeZone = sharedPreferences.getString(UserConstants().timeZone)!;
    userType = sharedPreferences.getString(UserConstants().userType)!;

    userPremium = sharedPreferences.getString(UserConstants().userPremium)!;
    userPremiumType = sharedPreferences.getString(UserConstants().userPremiumType)!;
    userCustomerId = sharedPreferences.getString(UserConstants().userCustomerId)!;
    userSubscriptionId = sharedPreferences.getString(UserConstants().userSubscriptionId)!;

     _getTrellisReadData();


    setState(() {
      _isUserDataLoading = false;
    });
  }

  _getTrellisReadData() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().trellisRead(TrellisRequestModel(userId: id,table: 'ladder')).then((value) {
      // trellisLadderDataForGoalsAchievements.clear();
      // trellisLadderDataForGoalsChallenges.clear();
      // trellisLadderDataForGoals.clear();
      // trellisLadderDataForAchievements.clear();

      TrellisLadderDataListModel trellisLadderDataListModel  = TrellisLadderDataListModel.fromJson(value['data']);
      trellisLadderDataForGoalsAchievements = trellisLadderDataListModel.values;

      for(int i=0; i<trellisLadderDataForGoalsAchievements.length;i++) {
        if (trellisLadderDataForGoalsAchievements[i].type.toString() == "goal") {

          if(trellisLadderDataForGoalsAchievements[i].option2 == "Challenges") {
            print("Challenges calling");
            trellisLadderDataForGoalsChallenges.add(trellisLadderDataForGoalsAchievements[i]);
          } else {

            trellisLadderDataForGoals.add(trellisLadderDataForGoalsAchievements[i]);
          }
        } else {
          trellisLadderDataForAchievements.add(trellisLadderDataForGoalsAchievements[i]);
               }
      }

      //trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForAchievements.sort((a,b)=>b.date!.compareTo(a.date!));
      trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
      print("Ladder Data Load");
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
        isLadderGoals = int.parse(value['goal'].toString());
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
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Platform.isAndroid ? Icons.arrow_back_rounded : Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const Dashboard()));
            },
          ),
          title: Text(_isUserDataLoading ? "" : name),
          actions:  [
            PopMenuButton(false,false,id)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setBool("IsGoals", true);
            print(userPremium);

            setState(() {
               initialValueForType = "physical";
               initialValueForMType = "Memories";
               initialValueForGoals = "Goals";
               initialValueForMGoals = "Goals";
               titleForGController.clear();
               descriptionForGController.clear();
               dateForGController.clear();
               dateForGController.text = "";
               descriptionForGController.text = "";
               titleForGController.text = "";
            });
            ladderBottomSheet(false,context,true,"Ladder","Goals/Challenges",
                    initialValueForType,itemsForType,
                    initialValueForGoals,itemsForGoals,
                        () async {
                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          bool isGoalsValue = sharedPreferences.getBool("IsGoals")!;

                          if(isGoalsValue) {
                            if(userPremium == "no" && trellisLadderDataForGoals.length>=isLadderGoals) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                            } else {
                              print("Goals Saving");
                              if(initialValueForType == "Memories" || initialValueForType == "Achievements")
                              {
                                setState(() {
                                  initialValueForType = "physical";
                                });
                              }
                              if(initialValueForGoals == "Challenges") {

                                _setLadderGoalsData();
                              } else {
                                  if(dateForGController.text.isNotEmpty) {
                                    _setLadderGoalsData();
                                  } else {
                                    showToastMessage(context, "Please select a date", false);
                                  }
                              }

                            }
                          } else {
                            if(userPremium == "no" && trellisLadderDataForAchievements.length>=isLadderAchievements) {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                } else {
                              print("Memories saving");
                              if(initialValueForType == "physical" || initialValueForType == "Emotional" || initialValueForType =="Relational" || initialValueForType =="Work" || initialValueForType =="Financial" || initialValueForType =="Spiritual")
                                {
                                  setState(() {
                                    initialValueForType = "Memories";
                                  });
                                }
                              _setLadderMemoriesData();
                            }
                          }
                    },
                        (value) {
                          print(value);
                      setState(() {
                        initialValueForGoals = value;
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
                        // String? videoId = YoutubePlayer.convertUrlToId(introUrl);
                        // YoutubePlayerController playerController = YoutubePlayerController(
                        //     initialVideoId: videoId!,
                        //     flags: const YoutubePlayerFlags(
                        //       autoPlay: false,
                        //       controlsVisibleAtStart: false,
                        //     )
                        //
                        // );
                        // videoPopupDialog(context,"Introduction to Trellis",playerController);
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
                                builder: (BuildContext context) => _buildPopupDialog(context,"Goals/Challenges",trellisLadderDataForGoals[index],true),
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print(isFavourite);
                                                  _setLadderFavouriteItem(index,trellisLadderDataForGoals[index].id.toString(),trellisLadderDataForGoals[index].favourite.toString(),true);
                                              },
                                              child: trellisLadderDataForGoals[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
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
                                                initialValueForType = trellisLadderDataForGoals[index].option1!.capitalize();
                                                initialValueForGoals = trellisLadderDataForGoals[index].option2!;
                                                dateForGController.text = trellisLadderDataForGoals[index].date!;
                                                titleForGController.text = trellisLadderDataForGoals[index].text!;
                                                descriptionForGController.text = trellisLadderDataForGoals[index].description!;
                                              });

                                              ladderBottomSheet(true,context,true,"Ladder","Goals/Challenges",
                                                  initialValueForType,itemsForType,
                                                  initialValueForGoals,itemsForGoals,
                                                      () async {

                                                      if(userPremium == "no" && trellisLadderDataForGoals.length>=isLadderGoals) {
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                      } else {
                                                        print("Goals Saving");
                                                        if(initialValueForType == "Memories" || initialValueForType == "Achievements")
                                                        {
                                                          setState(() {
                                                            initialValueForType = "physical";
                                                          });
                                                        }
                                                        if(initialValueForGoals == "Challenges") {

                                                          _updateLadderGoalsData("Goals",trellisLadderDataForGoals[index].id.toString(),index);
                                                        } else {
                                                          if(dateForGController.text.isNotEmpty) {
                                                            _updateLadderGoalsData("Goals",trellisLadderDataForGoals[index].id.toString(),index);
                                                          } else {
                                                            showToastMessage(context, "Please select a date", false);
                                                          }
                                                        }

                                                      }
                                                  },
                                                      (value) {
                                                    print(value);
                                                    setState(() {
                                                      initialValueForGoals = value;
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
                                            IconButton(onPressed: () {
                                              showDeletePopup( "goal",trellisLadderDataForGoals[index].id.toString(),index,trellisLadderDataForGoals[index].option2!);
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
                    child: trellisLadderDataForGoalsChallenges.isEmpty ? const Text("No data available") : ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:trellisLadderDataForGoalsChallenges.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildPopupDialog(context,"Goals/Challenges",trellisLadderDataForGoalsChallenges[index],true),
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
                                        Text("${trellisLadderDataForGoalsChallenges[index].option1?.capitalize()} ${ trellisLadderDataForGoalsChallenges[index].option2}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print(isFavourite);
                                                _setLadderFavouriteItem(index,trellisLadderDataForGoalsChallenges[index].id.toString(),trellisLadderDataForGoalsChallenges[index].favourite.toString(),true);
                                              },
                                              child: trellisLadderDataForGoalsChallenges[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
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
                                                initialValueForType = trellisLadderDataForGoalsChallenges[index].option1!.capitalize();
                                                initialValueForGoals = trellisLadderDataForGoalsChallenges[index].option2!;
                                                // dateForGController.text = trellisLadderDataForGoalsChallenges[index].date!;
                                                titleForGController.text = trellisLadderDataForGoalsChallenges[index].text!;
                                                descriptionForGController.text = trellisLadderDataForGoalsChallenges[index].description!;
                                              });

                                              ladderBottomSheet(true,context,true,"Ladder","Goals/Challenges",
                                                  initialValueForType,itemsForType,
                                                  initialValueForGoals,itemsForGoals,
                                                      () async {

                                                      if(userPremium == "no" && trellisLadderDataForGoalsChallenges.length>=isLadderGoals) {
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                      } else {
                                                        print("Goals Saving");
                                                        if(initialValueForType == "Memories" || initialValueForType == "Achievements")
                                                        {
                                                          setState(() {
                                                            initialValueForType = "physical";
                                                          });
                                                        }
                                                        if(initialValueForGoals == "Challenges") {

                                                          _updateLadderGoalsData("Challenges",trellisLadderDataForGoalsChallenges[index].id.toString(),index);
                                                        } else {
                                                          if(dateForGController.text.isNotEmpty) {
                                                            _updateLadderGoalsData("Challenges",trellisLadderDataForGoalsChallenges[index].id.toString(),index);
                                                          } else {
                                                            showToastMessage(context, "Please select a date", false);
                                                          }
                                                        }

                                                      }
                                                  },
                                                      (value) {
                                                    print(value);
                                                    setState(() {
                                                      initialValueForGoals = value;
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
                                            IconButton(onPressed: () {
                                              showDeletePopup( "goal",trellisLadderDataForGoalsChallenges[index].id.toString(),index,trellisLadderDataForGoalsChallenges[index].option2!);
                                            }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                          ],
                                        )
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("${trellisLadderDataForGoalsChallenges[index].option2 == "Challenges" ? "" : DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForGoalsChallenges[index].date.toString()))} ${trellisLadderDataForGoalsChallenges[index].option2 == "Challenges" ? "" : "|" } ${trellisLadderDataForGoalsChallenges[index].text}"))
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
                        itemCount:trellisLadderDataForAchievements.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildPopupDialog(context,"Memories/Achievements",trellisLadderDataForAchievements[index],true),
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
                                        Text("${trellisLadderDataForAchievements[index].option1?.capitalize()}",style:const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print(isFavourite);
                                                  _setLadderFavouriteItem(index,trellisLadderDataForAchievements[index].id.toString(),trellisLadderDataForAchievements[index].favourite.toString(),false);
                                              },
                                              child: trellisLadderDataForAchievements[index].favourite != 'no' ? Image.asset( "assets/like_full.png") : Image.asset( "assets/like_empty.png"),
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
                                                DateTime date1 = DateTime.parse(trellisLadderDataForAchievements[index].date!);
                                                initialValueForMType = trellisLadderDataForAchievements[index].option1!.capitalize();
                                                dateForGController.text = DateFormat('MM-dd-yy').format(date1);
                                                titleForGController.text = trellisLadderDataForAchievements[index].text!;
                                                descriptionForGController.text = trellisLadderDataForAchievements[index].description!;
                                              });

                                              ladderBottomSheet(true,context,false,"Ladder","Goals/Challenges",
                                                  initialValueForMType,itemsForType,
                                                  initialValueForGoals,itemsForGoals,
                                                      () async {


                                                      if(userPremium == "no" && trellisLadderDataForAchievements.length>=isLadderAchievements) {
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StripePayment(true)));
                                                      } else {
                                                        print("Memories saving");
                                                        if(initialValueForType == "physical" || initialValueForType == "Emotional" || initialValueForType =="Relational" || initialValueForType =="Work" || initialValueForType =="Financial" || initialValueForType =="Spiritual")
                                                        {
                                                          setState(() {
                                                            initialValueForType = "Memories";
                                                          });
                                                        }
                                                        _updateLadderMemoriesData(trellisLadderDataForAchievements[index].id.toString(),index);
                                                      }
                                                  },
                                                      (value) {
                                                    print(value);
                                                    setState(() {
                                                      initialValueForGoals = value;
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
                                            IconButton(onPressed: () {
                                              showDeletePopup( "achievements",trellisLadderDataForAchievements[index].id.toString(),index,"");
                                            }, icon: const Icon(Icons.delete,color: AppColors.redColor,),),
                                          ],
                                        )
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("${DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataForAchievements[index].date.toString()))} | ${trellisLadderDataForAchievements[index].text}"))
                                  ],
                                )),
                          );
                        }),
                  ),
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
                      child: Text(trellisLadderDataModel1.type!)),
                ],
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
                      child: Text("Category: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(trellisLadderDataModel1.option1!.capitalize())),
                ],
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
                      child: Text("Date: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
                      child: Text(trellisLadderDataModel1.option2! == "Challenges" ? "" :DateFormat('MM-dd-yy').format(DateTime.parse(trellisLadderDataModel1.date.toString())))),
                ],
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
                  const Expanded(
                      flex:1,
                      child:  Text("Description: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                  Expanded(
                      flex: 2,
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
      if(isGoals) {
        if(value['data']['option2'] == "Challenges") {
          setState(() {
            trellisLadderDataForGoalsChallenges[indexItem] = trellisLadderDataModel;
          });
        }else {
          setState(() {
            trellisLadderDataForGoals[indexItem] = trellisLadderDataModel;
          });
        }
      } else {
        setState(() {
          trellisLadderDataForAchievements[indexItem] = trellisLadderDataModel;
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

    if(initialValueForGoals != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForGoals(TrellisLadderGoalsRequestModel(userId: id,type: "goal",option1: initialValueForType,option2: initialValueForGoals,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text)).then((value) {

        Navigator.of(context).pop();
        setState(() {
          initialValueForType = "physical";
          initialValueForMType = "Memories";
          initialValueForGoals = "Goals";
          initialValueForMGoals = "Goals";
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          type: value['post_data']['type'].toString(),
          favourite: value['post_data']['favourite'].toString(),
          option1: value['post_data']['option1'].toString(),
          option2: value['post_data']['option2'].toString(),
          date: value['post_data']['date'].toString(),
          text: value['post_data']['text'].toString(),
          description: value['post_data']['description'].toString(),
        );
        if(trellisLadderDataModel.option2 == "Challenges") {
          trellisLadderDataForGoalsChallenges.add(trellisLadderDataModel);
        } else {
          trellisLadderDataForGoals.add(trellisLadderDataModel);
        }

        trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));

        trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));

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

  _updateLadderGoalsData(String updateType, String ladderGoalsId, int index1) {
    print("Ladder Goals ID");
    print(updateType);
    // ignore: avoid_print
    // print("Selected Date:${dateForGController.text}");

    if(initialValueForGoals != "" && titleForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForGoalsUpdate(TrellisLadderGoalsUpdateRequestModel(ladderId: ladderGoalsId,type: "goal",option1: initialValueForType,option2: initialValueForGoals,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text)).then((value) {
        if(updateType == "Challenges") {
          setState(() {
            trellisLadderDataForGoalsChallenges.removeAt(index1);
          });

        } else {
          setState(() {
            trellisLadderDataForGoals.removeAt(index1);
          });
        }
        Navigator.of(context).pop();
        setState(() {
          initialValueForType = "physical";
          initialValueForMType = "Memories";
          initialValueForGoals = "Goals";
          initialValueForMGoals = "Goals";
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
        if(trellisLadderDataModel.option2 == "Challenges") {

          trellisLadderDataForGoalsChallenges.add(trellisLadderDataModel);
        } else {
          trellisLadderDataForGoals.add(trellisLadderDataModel);
        }

        trellisLadderDataForGoals.sort((a,b)=>b.date!.compareTo(a.date!));

        trellisLadderDataForGoalsChallenges.sort((a,b)=>b.date!.compareTo(a.date!));
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
    if(initialValueForGoals != "" && titleForGController.text.isNotEmpty && dateForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForAchievements(TrellisLadderAchievementRequestModel(userId: id,type: "achievements",option1:initialValueForType ,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text)).then((value) {

        Navigator.of(context).pop();
        setState(() {
          dateForGController.text = "";
          titleForGController.text = "";
          descriptionForGController.text = "";
        });

        TrellisLadderDataModel trellisLadderDataModel = TrellisLadderDataModel(
          id: value['post_data']['id'].toString(),
          userId: value['post_data']['user_id'].toString(),
          type: value['post_data']['type'].toString(),
          favourite: value['post_data']['favourite'].toString(),
          option1: value['post_data']['option1'].toString(),
          option2: value['post_data']['option2'].toString(),
          date: value['post_data']['date'].toString(),
          text: value['post_data']['text'].toString(),
          description: value['post_data']['description'].toString(),
        );
        trellisLadderDataForAchievements.add(trellisLadderDataModel);
        trellisLadderDataForAchievements.sort((a,b)=>b.date!.compareTo(a.date!));
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

  _updateLadderMemoriesData(String ladderMemoriesId, int index) {
    print("Ladder Memories ID");
    print(ladderMemoriesId);
    print(initialValueForType);
    print(dateForGController.text);
    print(titleForGController.text);
    print(descriptionForGController.text);

    if(initialValueForGoals != "" && titleForGController.text.isNotEmpty && dateForGController.text.isNotEmpty) {
      setState(() {
        _isDataLoading = true;
      });
      HTTPManager().trellisLadderForAchievementsUpdate(TrellisLadderAchievementUpdateRequestModel(ladderId: ladderMemoriesId,type: "achievements",option1:initialValueForType ,date: dateForGController.text,title: titleForGController.text,description: descriptionForGController.text)).then((value) {

        Navigator.of(context).pop();
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
        trellisLadderDataForAchievements[index] = trellisLadderDataModel;
        trellisLadderDataForAchievements.sort((a,b)=>b.date!.compareTo(a.date!));
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
    // print(type);
    // print(index);
    setState(() {
      _isDataLoading = true;
    });
    HTTPManager().trellisDelete(TrellisDeleteRequestModel(userId: id,recordId: recordId,type:type,)).then((value) {

      if(type == "goal") {
        if(goalsOrChallenges == "Challenges") {
          setState(() {
            trellisLadderDataForGoalsChallenges.removeAt(index);
          });
        }else {
          setState(() {
            trellisLadderDataForGoals.removeAt(index);
          });
        }

      } else if(type == "achievements") {
        setState(() {
          trellisLadderDataForAchievements.removeAt(index);
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
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
